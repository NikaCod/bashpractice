#!/bin/bash

# Цвета
YELLOW='\033[1;33m'
GREEN='033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

# Проверка: есть ли curl
if ! command -v curl $> /dev/null; then
	echo "Ошибка: curl не установлен"
	exit 1
fi

# Проверка: есть ли jq
if ! command -v jq &> /dev/null; then
	echo "Ошибка: jq не установлен"
	exit 1
fi

# Проверка: передан ли аргумент
if [ -z "$1" ]; then
	echo "Использование: $0 <owner/repo>"
	echo "Пример: $0 tensorflow/tensorflow"
	exit 1
fi

REPO="$1"

# Запрос к GitHub API
response=$(curl -s "https://api.github.com/repos/$REPO")

# Проверка: не отдал ли GitHub ошибку
if echo "$response" | jq -e ".message" &> /dev/null; then
	echo -e "${RED}Ошибка: репозиторий '$REPO' не найден${NC}"
	exit 1
fi

# Извлекаем данные
name=$(echo"$response" | jq -r '.full_name')
stars=$(echo "$response" | jq -r '.stargazers_count')
forks=$(echo "$response" | jq -r '.open_issues_count')

# Цвет для issues
if [ "$issues" -gt 100 ]; then
	ISSUE_COLOR="$RED"
else
	ISSUE_COLOR="$YELLOW"
fi

# Вывод
echo -e "Репозиторий: $stars${NC}"
echo -e "${YELLOW}Звёзды: $stars${NC}"
echo -e "${GREEN}Форки: $forks${NC}"
echo -e "${ISSUE_COLOR}Issues: $issues${NC}"
