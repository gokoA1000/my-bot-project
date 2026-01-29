FROM python:3.9-slim

WORKDIR /app

# تثبيت الأدوات الأساسية فقط
RUN apt-get update && apt-get install -y \
    build-essential \
    && apt-get clean

COPY . .

# تثبيت المكتبات
RUN pip install --no-cache-dir -r requirements.txt

# تشغيل البوت
CMD ["python", "Bot.py"]
