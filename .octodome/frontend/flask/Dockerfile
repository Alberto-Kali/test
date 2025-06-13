
# Используем официальный образ Python
FROM python:3.9-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем зависимости и устанавливаем их
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь проект
COPY ./app .

# Открываем порт, на котором работает Flask
EXPOSE 3000

# Запускаем приложение
CMD ["python", "main.py"]
