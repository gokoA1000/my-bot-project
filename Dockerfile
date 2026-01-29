FROM python:3.9

# تحديث النظام وتثبيت المحرك الأساسي للـ PDF
RUN apt-get update && apt-get install -y \
    wkhtmltopdf \
    xvfb \
    && apt-get clean

WORKDIR /app
COPY . .

# تثبيت مكتبات البايثون
RUN pip install --no-cache-dir -r requirements.txt

# أمر تشغيل البوت
CMD ["python", "Bot.py"]
