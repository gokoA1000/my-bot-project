# هذه النسخة تحتوي على wkhtmltopdf جاهزاً ومثبتاً
FROM surgit/python3.9-wkhtmltopdf:latest

WORKDIR /app

# نسخ ملفات البوت
COPY . .

# تثبيت مكتبات البايثون
RUN pip install --no-cache-dir -r requirements.txt

# تشغيل البوت
CMD ["python", "Bot.py"]
