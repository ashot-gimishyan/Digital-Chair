#! /usr/bin/bash

# Напишите скрипт, который по переданной директории будет проходить по всем файлам логов и выводить uid самого активного пользователя за день (по количеству запросов).

log_dir="path/to/logs"  # путь к директории с файлами логов
declare -A uid_counts  # ассоциативный массив для хранения количества запросов для каждого uid

# Проходим по всем файлам в директории
for file in "$log_dir"/*.log; do
    # Подсчитываем количество запросов для каждого uid
    while read -r line; do
        uid=$(echo "$line" | grep -o '"uid":[0-9]*' | grep -o '[0-9]*')
        if [[ -n $uid ]]; then
            ((uid_counts[$uid]++))
        fi
    done < "$file"
done

# Находим uid с максимальным количеством запросов
max_requests=0
active_user=""
for uid in "${!uid_counts[@]}"; do
    requests=${uid_counts[$uid]}
    if (( requests > max_requests )); then
        max_requests=$requests
        active_user=$uid
    fi
done

echo "Самый активный пользователь: $active_user"
