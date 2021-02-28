# Author: Darpan (whole file)

# Import smtplib for the actual sending function
import smtplib
import ssl

# Import the email modules we'll need
from email.message import EmailMessage

# Import for attachments
from email.mime.multipart import MIMEMultipart 
from email.mime.application import MIMEApplication as ma
from email.mime.text import MIMEText

import uploadDOI
import uploadAuthor
import uploadUni
import os

## For SMTP Info -> https://support.google.com/mail/answer/7126229?hl=en


def emailResults(zipPath, recipient, type): #add csv, json parameter
    zipPath = zipPath

    SMTP_SERVER = 'smtp.gmail.com'
    SMTP_PORT = 465
    SMTP_USERNAME = 'openaltteam@gmail.com'
    SMTP_PASSWORD = 'bowmanwsu'

    msg = MIMEMultipart()
    msg['From'] = 'OpenAlt v2.0' #SMTP_USERNAME
    msg['To'] = recipient

    if type == 'doi':
        #if csv else use json functions
        metadataStats = uploadDOI.getMetadataStats()
        eventStats = uploadDOI.getEventStats()
        msg['Subject'] = 'OpenAlt v2.0: Your DOI Results Are Ready!'
        body = 'Thank You for using OpenAlt! You will find your results attached to this email.\n\n\nRESULTS:\n' + metadataStats + '\n' + eventStats
              
    if type == 'author':
        authorStats = uploadAuthor.getStats()
        msg['Subject'] = 'OpenAlt v2.0: Your Author Results Are Ready!'
        body = 'Thank You for using OpenAlt! You will find your results attached to this email.\n\n\n\n' + authorStats
    
    if type == 'uni':
        uniStats = uploadUni.getStats()
        msg['Subject'] = 'OpenAlt v2.0: Your University Results Are Ready!'
        body = 'Thank You for using OpenAlt! You will find your results attached to this email.\n\n\n\n' + uniStats


    body_part = MIMEText(body, 'plain')
    msg.attach (body_part)

    with open(zipPath, 'rb') as file:
        msg.attach(ma(file.read(), Name = os.path.basename(zipPath)))


    # Create SMTP object
    smtp_obj = smtplib.SMTP_SSL(SMTP_SERVER, SMTP_PORT)

    # Login to the server
    print("Logging in...")
    smtp_obj.login(SMTP_USERNAME, SMTP_PASSWORD)

    # Convert the message to a string and send it
    print("Email sending...")
    smtp_obj.sendmail(msg['From'], msg['To'], msg.as_string())
    smtp_obj.quit()

    print("Email sent!")

    #os.remove(zipPath)