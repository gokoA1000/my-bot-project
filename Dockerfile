# استخدام نسخة كاملة ومستقرة من بايثون
FROM python:3.9

# تحديث بسيط وتثبيت المحرك الأساسي
RUN apt-get update && apt-get install -y \
    wkhtmltopdf \
    && apt-get clean

WORKDIR /app
COPY . .

# تثبيت المكتبات من الملف الجديد الذي أنشأته
RUN pip install --no-cache-dir -r requirements.txt

# أمر تشغيل الملف الأساسي
CMD ["python", "Bot.py"]
