# Этап 1: Сборка фронтенда
FROM node:18-alpine as frontend-build

WORKDIR /app/frontend
COPY rental-frontend/package*.json ./
RUN npm ci
COPY rental-frontend/ ./
RUN npm run build

# Этап 2: Настройка бэкенда и объединение с фронтендом
FROM python:3.11-slim

WORKDIR /app

# Установка зависимостей
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn

# Копирование бэкенда
COPY RentalService/ ./RentalService/

# Создание директории для статических файлов
RUN mkdir -p /app/RentalService/staticfiles

# Копирование собранного фронтенда в директорию статических файлов
COPY --from=frontend-build /app/frontend/build /app/RentalService/staticfiles/

# Настройка переменных окружения
ENV PYTHONUNBUFFERED=1
ENV DEBUG=False

# Рабочая директория для Django
WORKDIR /app/RentalService

# Выполнение миграций и сбор статических файлов
RUN python manage.py collectstatic --noinput

# Открытие порта
EXPOSE 8000

# Создание скрипта запуска
RUN echo '#!/bin/bash\n\
python manage.py migrate --noinput\n\
gunicorn --bind 0.0.0.0:8000 RentalService.wsgi:application' > /app/entrypoint.sh \
&& chmod +x /app/entrypoint.sh

# Запуск сервера
CMD ["/app/entrypoint.sh"]
