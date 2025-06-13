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
