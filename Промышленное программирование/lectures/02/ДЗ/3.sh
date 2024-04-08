#! /usr/bin/bash

# С помощью `find` и `grep` напишите команду, которая выведет на экран все записи с кодом ответа 200 (содержащие `"status-code:"200`).

for file in data/*.log; do
    if [ -f "$file" ]; then
        cat "$file" | grep '"status-code":200'
    fi
done

