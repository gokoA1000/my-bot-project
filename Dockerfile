FROM python:3.9
RUN apt-get update && apt-get install -y wkhtmltopdf
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "Bot.py"]
