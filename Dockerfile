FROM python:3.10-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

RUN apk add --no-cache libpq-dev gcc musl-dev

COPY requirements.txt ./

RUN pip install --no-cache -r requirements.txt

COPY . .

RUN mkdir -p /app/staticfiles && chown -R appuser:appgroup /app/staticfiles

EXPOSE 8000

USER appuser

CMD ["sh", "-c", "python manage.py migrate && \
         python manage.py shell -c 'from django.contrib.auth import get_user_model; \
         User = get_user_model(); \
         User.objects.filter(username=\"admin\").exists() or \
         User.objects.create_superuser(\"admin\", \"admin@example.com\", \"admin\")' && \
         python manage.py collectstatic --noinput && \
         python manage.py runserver 0.0.0.0:8000"]





