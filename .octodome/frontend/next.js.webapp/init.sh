#!/bin/bash

# Шаг 1: Создание Next.js проекта с pnpm
echo "Создание Next.js проекта с pnpm..."
pnpm create next-app --example https://github.com/mauriciobraz/next.js-telegram-webapp my-telegram-webapp

# Шаг 2: Переход в директорию проекта
project_dir="my-telegram-webapp"
cd "$project_dir" || exit

# Шаг 4: Создание Dockerfile
echo "Создание Dockerfile..."
cat > ../Dockerfile << 'EOF'
# Используем официальный образ Node.js с pnpm
FROM node:20-alpine

# Устанавливаем pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и pnpm-lock.yaml
COPY */package.json ./
COPY */pnpm-lock.yaml ./

# Устанавливаем зависимости
RUN pnpm install

# Копируем все файлы проекта
COPY */ .

# Собираем проект
RUN pnpm run build

# Запускаем приложение
CMD ["pnpm", "start"]

# Открываем порт 3000
EXPOSE 3000
EOF

echo "Dockerfile создан успешно."
echo "Структура проекта:"
echo "frontend/"
echo "    $project_dir/"
echo "    Dockerfile"
echo "    init.sh"
