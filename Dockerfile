FROM surgit/python3.9-wkhtmltopdf:latest

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "Bot.py"]
