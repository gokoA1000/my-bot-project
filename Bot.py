import logging
import os
import pdfkit
import pandas as pd
import requests
import cloudscraper
from bs4 import BeautifulSoup
from docx import Document
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import Application, CommandHandler, MessageHandler, CallbackQueryHandler, filters, ContextTypes

# إعداد السجلات لمتابعة أداء البوت
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO)

# سحب التوكن من إعدادات البيئة (Environment Variable) للأمان
TOKEN = os.getenv('BOT_TOKEN')

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "🚀 مرحباً بك في بوت تحويل الروابط!\n\n"
        "أرسل لي أي رابط (حتى لو كان من Scribd) وسأحاول تحويله لك."
    )

async def handle_url(update: Update, context: ContextTypes.DEFAULT_TYPE):
    url = update.message.text
    if not url.startswith('http'):
        await update.message.reply_text("❌ يرجى إرسال رابط صحيح.")
        return

    context.user_data['url'] = url
    
    keyboard = [
        [InlineKeyboardButton("PDF 📄", callback_data='pdf'), InlineKeyboardButton("Word 📝", callback_data='word')],
        [InlineKeyboardButton("Excel 📊", callback_data='excel'), InlineKeyboardButton("Text 📖", callback_data='text')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.message.reply_text('اختر الصيغة المطلوبة للتحويل:', reply_markup=reply_markup)

async def button_callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    query = update.callback_query
    await query.answer()
    
    choice = query.data
    url = context.user_data.get('url')
    
    await query.edit_message_text(f"⏳ جاري معالجة الرابط وتحويله إلى {choice.upper()}...")
    
    try:
        file_path = await process_conversion(url, choice)
        if file_path and os.path.exists(file_path):
            with open(file_path, 'rb') as document:
                await query.message.reply_document(document=document, caption=f"✅ تم التحويل إلى {choice}")
            os.remove(file_path)
        else:
            await query.message.reply_text("⚠️ عذراً، لم أستطع استخراج محتوى مناسب لهذا النوع.")
            
    except Exception as e:
        await query.message.reply_text(f"❌ حدث خطأ: {str(e)}")

async def process_conversion(url, format_type):
    # استخدام cloudscraper لتجاوز حماية المواقع مثل Scribd
    scraper = cloudscraper.create_scraper()
    response = scraper.get(url)
    response.encoding = 'utf-8'
    soup = BeautifulSoup(response.content, 'html.parser')
    
    filename = f"converted_file.{format_type}"

    if format_type == 'pdf':
        # إعدادات خاصة لعمل pdfkit على السيرفرات
        options = {'quiet': '', 'encoding': "UTF-8"}
        pdfkit.from_url(url, filename, options=options)
        return filename

    elif format_type == 'word':
        doc = Document()
        doc.add_heading(soup.title.string if soup.title else "Web Content", 0)
        for p in soup.find_all(['p', 'h1', 'h2']):
            doc.add_paragraph(p.get_text())
        doc.save(filename)
        return filename

    elif format_type == 'excel':
        tables = pd.read_html(url)
        if not tables: return None
        tables[0].to_excel(filename)
        return filename

    elif format_type == 'text':
        with open(filename, "w", encoding="utf-8") as f:
            f.write(soup.get_text(separator='\n'))
        return filename

    return None

def main():
    if not TOKEN:
        print("❌ خطأ: لم يتم العثور على BOT_TOKEN في إعدادات السيرفر!")
        return

    app = Application.builder().token(TOKEN).build()
    app.add_handler(CommandHandler("start", start))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_url))
    app.add_handler(CallbackQueryHandler(button_callback))
    
    print("🚀 البوت يعمل الآن على Render...")
    app.run_polling()

if __name__ == '__main__':
    main()
