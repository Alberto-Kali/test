#!/bin/bash

# Функция для вывода цветного текста
print_color() {
    local color=$1
    local text=$2
    case $color in
        "red") echo -e "\033[31m$text\033[0m" ;;
        "green") echo -e "\033[32m$text\033[0m" ;;
        "yellow") echo -e "\033[33m$text\033[0m" ;;
        "blue") echo -e "\033[34m$text\033[0m" ;;
        *) echo "$text" ;;
    esac
}

# Шаг 1: Приветствие
print_color "green" "Добро пожаловать в мастер настройки проекта!"
echo ""

# Шаг 2: Запрос информации о проекте
read -p "Введите название проекта: " PROJECT_NAME
read -p "Введите URL проекта: " PROJECT_URL
read -p "Введите токен доступа: " ACCESS_TOKEN

# Шаг 3: Выбор шаблонов
print_color "blue" "\nВыберите шаблоны для инициализации:"

# Frontend выбор (только один)
print_color "yellow" "\nFrontend (выберите один):"
select FRONTEND_TEMPLATE in "flask" "next.js" "expo.js" "next.js (webapp)" "next + expo" "none"; do
    case $FRONTEND_TEMPLATE in
        "none") FRONTEND_TEMPLATE=""; break ;;
        *) break ;;
    esac
done

# Backend выбор (только один)
print_color "yellow" "\nBackend (выберите один):"
select BACKEND_TEMPLATE in "fastapi" "flask" "artix (rust)" "none"; do
    case $BACKEND_TEMPLATE in
        "none") BACKEND_TEMPLATE=""; break ;;
        *) break ;;
    esac
done

# DB выбор (множественный)
print_color "yellow" "\nБазы данных:"
echo "0) Продолжить без изменений"
PS3="Выберите номера (0 по окончании): "
options=("neo4j" "redis" "postgresql" "mongodb")
selected_dbs=()
select opt in "${options[@]}"; do
    case $REPLY in
        0) break ;;
        *) 
            if [[ " ${options[@]} " =~ " ${opt} " ]]; then
                if [[ ! " ${selected_dbs[@]} " =~ " ${opt} " ]]; then
                    selected_dbs+=("$opt")
                    print_color "green" "Добавлено: $opt"
                else
                    print_color "red" "Уже выбрано: $opt"
                fi
            else
                print_color "red" "Неверный выбор. Попробуйте снова."
            fi
            ;;
    esac
done

# Дополнительные сервисы (множественный)
print_color "yellow" "\nДополнительные сервисы:"
echo "0) Продолжить без изменений"
PS3="Выберите номера (0 по окончании): "
options=("telegram bot" "searchxNG*" "ellasticsearch*" "webchatllm*")
selected_adds=()
select opt in "${options[@]}"; do
    case $REPLY in
        0) break ;;
        *) 
            if [[ " ${options[@]} " =~ " ${opt} " ]]; then
                if [[ ! " ${selected_adds[@]} " =~ " ${opt} " ]]; then
                    selected_adds+=("$opt")
                    print_color "green" "Добавлено: $opt"
                else
                    print_color "red" "Уже выбрано: $opt"
                fi
            else
                print_color "red" "Неверный выбор. Попробуйте снова."
            fi
            ;;
    esac
done

# Шаг 4: Создание структуры проекта
print_color "blue" "\nСоздание структуры проекта..."

# Создаем папки если их нет
mkdir -p frontend backend

# Массив для хранения директорий, в которые были скопированы файлы
COPIED_DIRS=()

# Копируем frontend шаблон если выбран
if [ -n "$FRONTEND_TEMPLATE" ]; then
    case $FRONTEND_TEMPLATE in
        "flask") cp -r ./.octodome/frontend/flask/* ./frontend/ ;;
        "next.js") cp -r ./.octodome/frontend/next.js/* ./frontend/ ;;
        "expo.js") cp -r ./.octodome/frontend/expo.js/* ./frontend/ ;;
        "next.js (webapp)") cp -r ./.octodome/frontend/next.js.webapp/* ./frontend/ ;;
        "next + expo") cp -r ./.octodome/frontend/solito/* ./frontend/ ;;
    esac
    print_color "green" "Frontend шаблон $FRONTEND_TEMPLATE скопирован"
    COPIED_DIRS+=("./frontend")
fi

# Копируем backend шаблон если выбран
if [ -n "$BACKEND_TEMPLATE" ]; then
    case $BACKEND_TEMPLATE in
        "fastapi") cp -r ./.octodome/backend/fastapi/* ./backend/ ;;
        "flask") cp -r ./.octodome/backend/flask/* ./backend/ ;;
        "artix (rust)") cp -r ./.octodome/backend/artix/* ./backend/ ;;
    esac
    print_color "green" "Backend шаблон $BACKEND_TEMPLATE скопирован"
    COPIED_DIRS+=("./backend")
fi

# Шаг 5: Обновление docker-compose.yml
print_color "blue" "\nОбновление docker-compose.yml..."

# Создаем временный файл
TMP_FILE=$(mktemp)

# Функция для добавления сервисов в compose
add_service() {
    local service=$1
    local config=$2
    
    # Ищем место для вставки (после backend service)
    awk -v service="$service" -v config="$config" '
    /^  backend:/ {print; found=1; next}
    found && /^    depends_on:/ {print; print "      - " service; next}
    found && /^    # Dependencies/ {print "      - " service; next}
    /^#....Other containers/ {print config; print; next}
    {print}
    ' docker-compose.yml > "$TMP_FILE" && mv "$TMP_FILE" docker-compose.yml
}

# Добавляем выбранные базы данных
for db in "${selected_dbs[@]}"; do
    case $db in
        "neo4j")
            NEO4J_CONFIG="
  neo4j:
    image: neo4j:latest
    ports:
      - \"7474:7474\"
      - \"7687:7687\"
    volumes:
      - neo4j_data:/data
    environment:
      NEO4J_AUTH: none
    networks:
      - main_network
"
            add_service "neo4j" "$NEO4J_CONFIG"
            ;;
        "redis")
            REDIS_CONFIG="
  redis:
    image: redis:latest
    ports:
      - \"6379:6379\"
    volumes:
      - redis_data:/data
    networks:
      - main_network
"
            add_service "redis" "$REDIS_CONFIG"
            ;;
        "postgresql")
            POSTGRES_CONFIG="
  postgres:
    image: postgres:latest
    env_file:
      - .env
    ports:
      - \"5432:5432\"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - main_network
"
            add_service "postgres" "$POSTGRES_CONFIG"
            ;;
        "mongodb")
            MONGO_CONFIG="
  mongodb:
    image: mongo:latest
    ports:
      - \"27017:27017\"
    volumes:
      - mongo_data:/data/db
    networks:
      - main_network
"
            add_service "mongodb" "$MONGO_CONFIG"
            ;;
    esac
done

# Добавляем дополнительные сервисы
for add in "${selected_adds[@]}"; do
    case $add in
        "telegram bot")
            TELEGRAM_CONFIG="
  telegram_bot:
    build: ./telegram_bot
    depends_on:
      - backend
    networks:
      - main_network
"
            add_service "telegram_bot" "$TELEGRAM_CONFIG"
            mkdir -p ./telegram_bot
            cp -r ./.octodome/additionals/telegram_bot/* ./telegram_bot/
            COPIED_DIRS+=("./telegram_bot")
            ;;
        "searchxNG*")
            SEARCHX_CONFIG="
  searchx:
    image: searchxng/searchxng:latest
    ports:
      - \"8080:8080\"
    networks:
      - main_network
"
            add_service "searchx" "$SEARCHX_CONFIG"
            ;;
        "ellasticsearch*")
            ELASTIC_CONFIG="
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.6.2
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - \"9200:9200\"
    networks:
      - main_network
"
            add_service "elasticsearch" "$ELASTIC_CONFIG"
            ;;
        "webchatllm*")
            WEBCHAT_CONFIG="
  webchatllm:
    image: ghcr.io/webchatllm/webchatllm:latest
    ports:
      - \"3000:3000\"
    networks:
      - main_network
"
            add_service "webchatllm" "$WEBCHAT_CONFIG"
            ;;
    esac
done

# Добавляем volumes если есть базы данных
if [ ${#selected_dbs[@]} -gt 0 ]; then
    echo "" >> docker-compose.yml
    echo "volumes:" >> docker-compose.yml
    for db in "${selected_dbs[@]}"; do
        case $db in
            "neo4j") echo "  neo4j_data:" >> docker-compose.yml ;;
            "redis") echo "  redis_data:" >> docker-compose.yml ;;
            "postgresql") echo "  postgres_data:" >> docker-compose.yml ;;
            "mongodb") echo "  mongo_data:" >> docker-compose.yml ;;
        esac
    done
fi

# Шаг 6: Обновление .env файла
print_color "blue" "\nОбновление .env файла..."

echo "# Project Configuration" > .env
echo "NAME=$PROJECT_NAME" >> .env
echo "URL=$PROJECT_URL" >> .env
echo "TOKEN=$ACCESS_TOKEN" >> .env

# Добавляем настройки для выбранных сервисов
for db in "${selected_dbs[@]}"; do
    case $db in
        "postgresql")
            echo "" >> .env
            echo "# PostgreSQL Configuration" >> .env
            echo "POSTGRES_USER=admin" >> .env
            echo "POSTGRES_PASSWORD=password" >> .env
            echo "POSTGRES_DB=${PROJECT_NAME}_db" >> .env
            ;;
        "mongodb")
            echo "" >> .env
            echo "# MongoDB Configuration" >> .env
            echo "MONGO_INITDB_ROOT_USERNAME=admin" >> .env
            echo "MONGO_INITDB_ROOT_PASSWORD=password" >> .env
            ;;
    esac
done

# Шаг 7: Запуск init.sh в скопированных директориях
print_color "blue" "\nЗапуск init.sh в скопированных директориях..."

for dir in "${COPIED_DIRS[@]}"; do
    if [ -f "$dir/init.sh" ]; then
        print_color "yellow" "Запуск init.sh в $dir..."
        cd "$dir" || continue
        chmod +x init.sh
        ./init.sh
        cd - > /dev/null || continue
        print_color "green" "init.sh в $dir выполнен успешно"
    else
        print_color "red" "Файл init.sh не найден в $dir"
    fi
done

print_color "green" "\nНастройка проекта завершена успешно!"
