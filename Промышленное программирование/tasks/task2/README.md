По адресу http://localhost:8080 досупен некоторый сервис с двумя обработчиками: /auth и /secret.
* /auth принимает логин-пароль и в ответ отдает JSON Web Token (JWT) в заголовке Authorization (с `can_read_secret=false` в Payload)
* /secret принимает Authorization заголовок с JWT и в случае, если `can_read_secret=true` в Payload, отдает секрет

Примеры:
* `curl -X POST -v http://localhost:8080/auth --data 'username=student00&password=***' 2>&1`
* `curl http://localhost:8080/secret -H "Authorization: Bearer TOKEN_FROM_AUTH"`

Известно, что в обработчике /secret при валидации токена была допущена ошибка, и "none" в алгоритме подписи является валидным (см. JWT none signature). Вам необходимо собрать валидный (с точки зрения /secret) токен с `can_read_secret=true` в Payload, и получить доступ к секрету.

Варианты решения:
1. Руками собрать такой токен, рассказать, как его получить, с помощью каких инструментов. (2б)
2. Написать скрипт на Python, который будет принимать логин-пароль и отдавать секретное значение (3б)
3. Написать скрипт на Bash, который будет принимать логин-пароль и отдавать секретное значение (4б)
