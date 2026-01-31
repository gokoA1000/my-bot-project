# استخدام نسخة مستقرة من بايثون
FROM python:3.9-slim-bullseye

# تثبيت أدوات النظام الضرورية ومحول PDF
RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y --no-install-recommends \
    wkhtmltopdf \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# نسخ الملفات
COPY . .

# تثبيت مكتبات بايثون
RUN pip install --no-cache-dir -r requirements.txt

# تشغيل البوت
CMD ["python", "Bot.py"]
