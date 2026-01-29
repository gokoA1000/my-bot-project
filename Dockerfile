FROM python:3.9-slim

# تثبيت المحركات اللازمة مع حل مشكلة التحديث
RUN apt-get update --fix-missing && apt-get install -y \
    wkhtmltopdf \
    && apt-get clean

WORKDIR /app
COPY . .

# تثبيت المكتبات
RUN pip install --no-cache-dir -r requirements.txt

# أمر التشغيل
CMD ["python", "Bot.py"]

