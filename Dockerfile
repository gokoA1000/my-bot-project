FROM python:3.9

# تثبيت محرك الـ PDF
RUN apt-get update && apt-get install -y \
    wkhtmltopdf \
    && apt-get clean

WORKDIR /app
COPY . .

# تثبيت المكتبات
RUN pip install --no-cache-dir -r requirements.txt

# تشغيل البوت
CMD ["python", "Bot.py"]
