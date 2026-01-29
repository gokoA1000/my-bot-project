# استخدام نسخة جاهزة تحتوي على كل شيء (بايثون + محرك PDF)
FROM surgit/python3.9-wkhtmltopdf:latest

WORKDIR /app

# نسخ الملفات
COPY . .

# تثبيت مكتبات البايثون فقط
RUN pip install --no-cache-dir -r requirements.txt

# تشغيل البوت
CMD ["python", "Bot.py"]
