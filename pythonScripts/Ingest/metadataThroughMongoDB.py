# Tabish's work
import pymongo
import os
import pandas
import json
import requests
import mysql.connector
from ingestCrossrefMetadata import crossrefMetadataIngest

def hashmap():
    listofnames = {}
    # Connect to MySQL database
    mysql_username = "root"
    mysql_password = "pass"
    try:
        db = mysql.connector.connect(host = "localhost", user = mysql_username, passwd = mysql_password, database = "doidata")
    except:
        print("Could not connect to MySQL")
        return
    myCursor=db.cursor(buffered=True)
    myCursor.execute("SELECT name FROM author")
    # Fetch all rows of column name from the author table
    nms = myCursor.fetchall()
    # Store all names in a dictionary
    for i in nms:
        listofnames[i[0]]=None
    # Return dictionary
    return listofnames

def storeMetaDatainMongoDB(listofnames, DOI):
    # retrieve metadata from api
    r = requests.get('https://api.crossref.org/works/'+ DOI)
    # connect to localhost MongoDB
    try:
        client = pymongo.MongoClient('mongodb://localhost:27017/')
    except:
        print("Could not connect to MongoDB")
        return
    # cursor to spcified database; create if it doesn't exist
    dbs=client["MetadataDatabase"]
    # cursor to specified collection; create if it doesn't exist
    coll=dbs["MetaData"]
    try:
         data=r.json()
    except:
        print("Invalid data")
        return
    if data.get("message-type")=="work":
        coll.insert_one(data.get("message"))
    else:
        print("Invalid data")
        return
    storeinmysql(listofnames, DOI, coll)
    return

def storeinmysql(listofnames, DOI, coll):
    # Calls function from ingestCrossrefMetadata.py
    # and stores metadata in MySQL
    mysql_username = "root"
    mysql_password = "pass"
    try:
        db = mysql.connector.connect(host = "localhost", user = mysql_username, passwd = mysql_password, database = "doidata")
    except:
        print("Could not connect to MySQL")
        return
    myCursor=db.cursor(buffered=True)
    myCursor.execute("SELECT * FROM author")
    for data in coll.find({},{"author":1}):
        if "author" in data:
            crossrefMetadataIngest(data["author"], myCursor, db, listofnames)
    # End the connection to the MySQL database
    myCursor.close()
    db.close()
    print("Data stored")
    # Delete all contents of collection; delete_many used just to be safe
    coll.delete_many({})
    return

if __name__=='__main__':
    # This main block is only for testing; implementation instructions below
    # First call hashmap() to create first argument for the storeMetaDatainMongoDB() function
    # Next call storeMetaDatainMongoDB() function with the dictionary from hashmap() and the DOI as arguments
    mysql_username = "root"
    mysql_password = "pass"
    db = mysql.connector.connect(host = "localhost", user = mysql_username, passwd = mysql_password, database = "doidata")
    myCursor=db.cursor(buffered=True)
    myCursor.execute("SELECT DOI FROM _main_")
    listofnames = hashmap()
    for i in myCursor:
        storeMetaDatainMongoDB(listofnames, str(i[0]))