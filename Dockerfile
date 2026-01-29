# نستخدم نسخة رسمية وخفيفة ومستقرة
FROM python:3.9-slim-bullseye

# أمر التثبيت القوي (يتجاوز أخطاء الشبكة)
RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y --fix-missing wkhtmltopdf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# تثبيت المكتبات
RUN pip install --no-cache-dir -r requirements.txt

# تشغيل البوت
CMD ["python", "Bot.py"]
