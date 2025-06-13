#!/bin/bash

# Шаг 1: Запуск инициализации shadcn
npx shadcn@latest init

# Шаг 2: Поиск папки проекта (единственной папки в текущей директории)
project_dir=$(find . -maxdepth 1 -type d ! -name '.' ! -name 'init.sh' ! -name 'Dockerfile' | head -n 1 | sed 's|^./||')

# Проверка, что папка проекта найдена
if [ -z "$project_dir" ]; then
    echo "Ошибка: Не удалось найти папку проекта."
    exit 1
fi

# Шаг 3: Создание Dockerfile
cat > Dockerfile << 'EOF'
# Используем официальный образ Node.js
FROM node:20-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY */package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем все файлы проекта
COPY */ .

# Собираем проект
RUN npm run build

# Запускаем приложение
CMD ["npm", "start"]

# Открываем порт 3000
EXPOSE 3000
EOF

echo "Dockerfile создан успешно."
echo "Структура проекта:"
echo "frontend/"
echo "    $project_dir/"
echo "    Dockerfile"
echo "    init.sh"
