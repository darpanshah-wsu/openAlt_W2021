# Tabish Shaikh's work

import zipfile
import zlib
import json
import os
import pandas

# directories
dir_file = str(os.path.dirname(os.path.realpath(__file__)))
dir_results = dir_file + '\\Results\\'

def downloadResultsAsJSON(csvDir,zipName,jsonName):
    # Check for any zip file with the same name
    if os.path.exists(zipName):
        # If necessary, delete it to prevent any errors
        os.remove(zipName)
    # Folder where zip file will be stored
    zipPath = dir_results + str(zipName)
    # Convert file to json
    tempFile = pandas.read_csv(csvDir)
    tempFile.to_json(jsonName)
    # Zip downloaded json file
    zipfile.ZipFile(zipPath, mode = 'w', compression = zipfile.ZIP_DEFLATED).write(jsonName)
    # Delete the copy of the downloaded file that was not zipped
    if os.path.exists('tempFile.json'):
        os.remove('tempFile.json')

if __name__ == '__main__':
    # Top level code if file is run independently
    downloadResultsAsJSON('uploadDOI_Results.json','uploadDOI_ResultsJSON.zip','uploadDOI_Results.json')
