import dateutil.parser
import datetime
import pytz


def hypothesisIngest(uniqueEvent, cursor, connection):

    # These are all temporary objects used to store the values of the fields in the JSON files.
    # Some fields may not always exist. We were getting errors when we didn't have some fields initialized so we decided to initialize all the fields.
    # The layout here is based upon the JSON file layout and is different from the crossrefeventdatamain database's table layout.

    t_license = None
    t_obj_id = None
    t_source_token = None
    t_occurred_at = None
    t_subj_id = None
    t_id = None
    t_evidence_record = None
    t_terms = None
    t_action = None
    t_pid = None
    t_json_url = None
    t_url = None
    t_type = None
    t_title = None
    t_issued = None
    t_source_id = None
    t_obj_pid = None
    t_obj_url = None
    t_timestamp = None
    t_relation_type_id = None

    for key, value in uniqueEvent.items():
        # for key in uniqueEvent.keys():
        if key == "license":
            t_license = value
        elif (key == "obj_id"):
            t_obj_id = value
        elif (key == "source_token"):
            t_source_token = value
        elif (key == "occurred_at"):
            t_occurred_at = value
        elif (key == "subj_id"):
            t_subj_id = value
        elif (key == "id"):
            t_id = value
        elif (key == "evidence_record"):
            t_evidence_record = value
        elif key == "terms":
            t_terms = value
        elif (key == "action"):
            t_action = value
        elif (key == "subj"):
            subjField = uniqueEvent.get("subj")
            for key, value in subjField.items():  # value of subj is a dict:
                if (key == 'pid'):
                    t_pid = value  # pid
                elif (key == 'json-url'):
                    t_json_url = value  # title
                elif (key == 'url'):
                    t_url = value  # issued
                elif key == "type":
                    t_type = value
                elif key == "title":
                    t_title = value
                elif key == "issued":
                    t_issued = value
        elif (key == "source_id"):
            t_source_id = value
        elif (key == "obj"):
            obj_field = uniqueEvent.get("obj")
            for key, value in obj_field.items():  # Value of obj is a dict:
                if(key == 'pid'):
                    t_obj_pid = value  # pid
                elif(key == 'url'):
                    t_obj_url = value  # url
        elif (key == "timestamp"):
            t_timestamp = value
        elif (key == "relation_type_id"):
            t_relation_type_id = value


    # author: Rihat Rahman
    #--------------------------------------------------------------------------------------------------------------------------------------------

    table = 'hypothesisevent'
    
    # checks if duplicate event exists, returns [(1,)] if true
    cursor.execute ("SELECT 1 FROM crossrefeventdatamain." + table + " WHERE subjectID = '" + t_subj_id + "' AND objectID = '" + t_obj_id + "'")
    exists = cursor.fetchall()

    # return to the main program if
    if exists == [(1,)]:
        return

    #--------------------------------------------------------------------------------------------------------------------------------------------

    try:
        if(len(t_obj_id) < 100 or t_obj_id is None):
            # Insert t_obj_id from the event of the JSON file into the main table
            objectIDInsertionQuery = "INSERT IGNORE INTO main (objectID) VALUES(\'" + \
                t_obj_id + "\');"
            cursor.execute(objectIDInsertionQuery)
            connection.commit()

            # Fetch all records from the 4 columns in the main table from t_obj_id and is placed into a list of tuples.
            # (firstHypothesisEvent, lastHypothesisevent, totalEvents, totalHypothesisEvents)
            listOfDictQuery = "SELECT firsthypothesisEvent, lasthypothesisEvent, totalEvents, totalHypothesisEvents FROM main WHERE objectID = \'" + t_obj_id + "\';"
            cursor.execute(listOfDictQuery)
            row = cursor.fetchone()

            firstEvent = ""
            lastEvent = ""
            totalEvents = 0
            totalHypothesisEvents = 0

            if (type(row) == dict):
                # Initialize objects to dictionary key values
                firstEvent = row['firstHypothesisEvent']
                lastEvent = row['lastHypothesisEvent']
                if row['totalEvents'] is not None:
                    totalEvents = row['totalEvents']
                if row['totalHypothesisEvents'] is not None:
                    totalHypothesisEvents = row['totalHypothesisEvents']
            elif (type(row) == tuple):
                # Initialize objects to tuple values
                firstEvent = row[0]
                lastEvent = row[1]

                if row[2] is not None:
                    totalEvents = row[2]
                if row[3] is not None:
                    totalHypothesisEvents = row[3]

        # If we enter this except block, most likely the DOI was long gibberish and was unable to be entered into the main table which is VARCHAR(100)
        elif (len(t_obj_id) >= 100):
            return  # just return to main.py, this event will not be ingested
    except:
        return  # just return to main.py, this event will not be ingested

    # Convert t_timestamp(timestamp) into a localized time
    t_dateTime = dateutil.parser.isoparse(t_timestamp)
    t_dateTime = t_dateTime.astimezone(pytz.timezone("US/Michigan"))
    t_dateTime = t_dateTime.strftime("%Y-%m-%d %H:%M:%S")

    # If t_dateTime is less than firstEvent or if firstEvent is NULL, update firsthypothesisEvent with t_dateTime in the same row in the main table.
    if ((t_dateTime < str(firstEvent)) or (firstEvent == None)):
        updateFirstEventQuery = "UPDATE main SET firsthypothesisEvent = \'" + \
            t_dateTime + "\' WHERE objectID = \'" + t_obj_id + "\';"
        cursor.execute(updateFirstEventQuery)
        connection.commit()

    # If t_dateTime is greater than lastEvent or if lastEvent is NULL, update lasthypothesisEvent with t_dateTime in the same row in the main table.
    if ((t_dateTime > str(lastEvent)) or (lastEvent == None)):
        updateLastEventQuery = "UPDATE main SET lasthypothesisEvent = \'" + \
            t_dateTime + "\' WHERE objectID = \'" + t_obj_id + "\';"
        cursor.execute(updateLastEventQuery)
        connection.commit()

    # Increment event count
    totalEvents += 1
    totalHypothesisEvents += 1

    # Update totalEvents and totalHypothesisEvents in the main table
    updateTotalEventsQuery = "UPDATE main SET totalEvents = " + str(totalEvents) + \
        ", totalHypothesisEvents = " + str(totalHypothesisEvents) + \
        " WHERE objectID = \'" + t_obj_id + "\';"

    cursor.execute(updateTotalEventsQuery)
    connection.commit()

    # These statements are used to insert data into Hypothesis Event's Table
    # SQL which inserts into event table
    # This was a previous layout of columns in the Hypothesis event table before we remodeled the database
    add_event = ("INSERT IGNORE INTO hypothesisevent " "(eventID, objectID, occurredAt, license, sourceToken, subjectID, evidenceRecord, termsOfUse, eventAction, subjectPID, subj_json_url, subjectURL, subjectType, subjectTitle, subjectIssued, sourceID, objectPID, objectURL, timeObserved, relationType ) " "VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s, %s)")

    # Values to insert into Hypothesis event table
    data_event = (t_id, t_obj_id, t_occurred_at, t_license, t_source_token, t_subj_id, t_evidence_record, t_terms, t_action,
                  t_pid, t_json_url, t_url, t_type, t_title, t_issued, t_source_id, t_obj_pid, t_obj_url, t_dateTime, t_relation_type_id)

    # Execute query to add information to Hypothesis event table
    cursor.execute(add_event, data_event)
    connection.commit()
