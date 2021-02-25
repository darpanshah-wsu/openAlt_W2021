###### Darpan Start ######
import os
import csv
import pandas
import logging
import flask
import platform
import mysql
import shutil
import time
import datetime as dt
import dbQuery
from flask import redirect

# importing download function to download zip folder containing results CSV file
from downloadResultsCSV import downloadResultsAsCSV

# Setter for zip directory
def setZipEvents(path):
    global zipEvents
    zipEvents = path
    print("RESULTS DIRECTORY:", zipEvents)

# Getter for zip directory, used to retrieve directory in front end
def getZipEvents():
    return zipEvents

# Setter for stats
def setStats(x,y):
    global stats
    stats = 'RESULTS: ' + str(x) + '/' + str(y) + ' FOUND'
    print(stats)

# Getter for stats
def getStats():
    return stats

def downloadDOI(mysql, dir_csv):

    # time execution of script
    start_time = time.time()

    # path of this file
    dir_file = str(os.path.dirname(os.path.realpath(__file__)))

    # path of uploaded file
    dir_template = dir_csv

    # path of config file
    dir_config = dir_file + '\\uploadDOI_config.txt'

    # path of file to print results to
    dir_results = dir_file  + '\\Results\\doiEvents_' + str(dt.datetime.now().strftime("%Y-%m-%d_%H-%M-%S"))

    # Create folder to hold results
    if not os.path.exists(dir_results):
        os.mkdir(dir_results)

    # Set the logging parameters
    logging.basicConfig(filename= dir_file + '\\Logs\\uploadDOI.log', filemode='a', level=logging.INFO,
        format='%(asctime)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S')

    doi_arr = []

    # pandas library reads doi list
    doi_list = pandas.read_csv(dir_template, header=None)


    # adds doi values into array and prints the array
    for x in range(len(doi_list)):
        if x not in doi_arr:
            doi_arr.append(doi_list.values[x][0])


    # Reading config file to parse doi input to only include number
    config_arr = []
    config_file = open(dir_config,'r')

    # Reading config file line by line
    # Without the r strip, '\n' is added on to the value -> Ex. 'doi:\n'
    for line in config_file:
        config_arr.append(line.rstrip('\n'))

    # Parse out doi formatting
    for config in config_arr:
        doi_arr = [doi.replace(config,'') for doi in doi_arr]

    # Remove duplicates from the doi array
    doi_arr = list(dict.fromkeys(doi_arr))

   
    # Cursor makes connection with the db
    cursor = mysql.connection.cursor()

    # Creating text file with API instructions
    f = open(dir_results + '\\API_Instructions.txt','w+')
    f.write("Thank you for using OpenAlt v2.0!\n" \
            "We do not provide the complete information listed from the APIs. For more complete and raw information, consider using the CrossRef API with the instructions listed below\n\n" \
            "1) Download Postman from https://www.postman.com/downloads/\n" \
            "2) Run a GET Request on Postman, enter a link listed below and hit send\n"
            "3) You will see the output in the body section on the lower third half of the window. Make sure that the *Body* setting is set to *Pretty* and the dropdown to *JSON*\n\n" \
            "You may also use any other API retrieval method, Postman happens to be the method the developers here at OpenAlt use to test APIs\n\n" \
            "For more information about the CrossRef API, checkout the links listed below:\n" \
            "https://www.crossref.org/education/retrieve-metadata/rest-api/\n" \
            "https://github.com/CrossRef/rest-api-doc\n\n\n" \
            "YOUR API QUERIES: \n")


    # Array containing table names found in crossrefeventdatamain (except main)
    event_tables = ['cambiaevent','crossrefevent','dataciteevent', 'f1000event','hypothesisevent','newsfeedevent','redditevent','redditlinksevent','stackexchangeevent','twitterevent','webevent','wikipediaevent','wordpressevent']

    # Count of DOIs found in database
    count = 0
    progress = 0

    # Execution of query and output of result + log
    for doi in doi_arr:
        progress = progress + 1
        print("PROGRESS: " + str(progress) + "/" + str(len(doi_arr)))
        
        resultSet = dbQuery.getDOIEventCounts(doi, cursor)
        logging.info(resultSet)

        

        # Writing API query to API_Instructions.txt
        f.write("https://api.crossref.org/works/" + doi + "\n")


        # If query outputs no results, add to not found csv, else write
        if len(resultSet) == 0:
            # CSV containing list of results not found
            emptyResultPath = dir_results + '\\NotFound.csv'

            with open(emptyResultPath,'a',newline='') as emptyCSV:
                writer = csv.writer(emptyCSV)
                writer.writerow([doi])

            print("DOI NOT FOUND:", doi)
            logging.info("DOI NOT FOUND: " + doi)

        else:
            # Write result to file.
            df = pandas.DataFrame(resultSet)

            # Replace invalid chars for file name
            file_id = doi.replace('/','-')
            file_id = file_id.replace('.','-')
            #print('FILE ID:', file_id)

            # Create folder to hold results
            dir_doi = dir_results + '\\' + str(file_id)
            if not os.path.exists(dir_doi):
                os.mkdir(dir_doi)

            resultPath = dir_doi + '\\eventCounts_' + str(file_id) + '.csv'
            df.columns = [i[0] for i in cursor.description]  ###### CAUSED ISSUE ON SALSBILS MACHINE #######
            #print("DF COLUMNS",[i[0] for i in cursor.description])
            df.to_csv(resultPath,index=False)

            # DOI Info Query
            resultSet = dbQuery.getDOIMetadata(doi, cursor)
            
            logging.info(resultSet)
            
            
            # if results not empty
            if len(resultSet) > 0:

                # Write associated DOI info to file.
                df = pandas.DataFrame(resultSet)
                df.columns = [i[0] for i in cursor.description]

                # Writing CSV containing DOI metadata
                resultPath = dir_doi + '\\doiInfo_' + str(file_id) + '.csv'
                df.to_csv(resultPath,index=False)

                logging.info(resultSet)

                resultSet, headers = dbQuery.getDOIEvents(doi,cursor)
                
                for table in event_tables:
                # Getting specific event data
                    if len(resultSet[table]) > 0:
                        # Write associated DOI info to file.
                        df = pandas.DataFrame(resultSet[table])
                        df.columns = headers[table]

                        # Writing CSV containing DOI metadata
                        resultPath = dir_doi + '\\' + table + '_' + str(file_id) + '.csv'
                        df.to_csv(resultPath,index=False)

            else:
                # CSV containing list of results not found
                emptyResult = open(dir_doi + '\\doiInfo_NotFound.txt','w+')
                emptyResult.write("DOI: " + doi + "\nDOI Information Not Found\n")
                emptyResult.close()


            count = count + 1

    # Close API_Instructions.txt
    f.close()

    # Stats of query
    print('\n')
    setStats(count, len(doi_arr))

    # Time taken to execute script
    print("--- %s seconds ---" % (time.time() - start_time))

    # Zip folder containing the CSV files=
    shutil.make_archive(str(dir_results),'zip',dir_results)

    # Delete unzipped folder
    if os.path.exists(dir_results):
        shutil.rmtree(dir_results)

    # Path of zip folder
    zipEvents = str(dir_results + '.zip')
    setZipEvents(zipEvents)


    return zipEvents

###### Darpan End ######

def searchByDOI(mysql, fileName):

    # Directory of uploaded file
    dir = '../web/uploadFiles/' + fileName

    downloadDOI(mysql, dir)

    # Delete uploaded file
    if os.path.exists(dir):
        os.remove(dir)

    return flask.render_template('download.html', results = getStats())
