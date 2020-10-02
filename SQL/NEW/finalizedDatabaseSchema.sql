--   ##########     WORK IN PROGRESS     ##########     
CREATE DATABASE crossRefEventData;
USE crossRefEventData;

CREATE TABLE Main(
    -- A link that contains the Document Object Identifier(DOI) or the scholary content that was registered at CrossRef.
    objectID               VARCHAR(70),
    -- Unique ID of each event.
    autoArticleID          INTEGER AUTO_INCREMENT UNIQUE,   
    articleTitle           VARCHAR(120),
    journalName            VARCHAR(40),
    articleDate            DATE,
    PRIMARY KEY(objectID)
);
-- Journal Table has been removed and merged with Main Table
-- We can use Python to parse the JSON author lists into Given_Name and Family_Name over time'
-- Are ORCIDs worth considering?'
CREATE TABLE Author(
    -- Given by us, increments automatically
    authorID               INTEGER AUTO_INCREMENT, 
    givenName              VARCHAR(30),
    familyName             VARCHAR(30),
    PRIMARY KEY (authorID)
);

CREATE TABLE Article_to_Author(
    articleAuthorID        INTEGER AUTO_INCREMENT,
    articleID              INTEGER,
    authorID               INTEGER,
    PRIMARY KEY(articleAuthorID),
    FOREIGN KEY (articleID) REFERENCES Main(autoArticleID),
    FOREIGN KEY (authorID) REFERENCES Author(authorID)
);

CREATE TABLE CrossRefEvent
(

    -- Auto increment for easy primary keys
    crossRefIncrement       INTEGER AUTO_INCREMENT PRIMARY KEY,

    --  Foreign key to reference the doi
    FOREIGN KEY (objectID) REFERENCES Main(objectID) ON DELETE CASCADE,

    --  --  -############################--  --  -COLUMNS--  ###############################--  --  -
    
    --  Author. crossrefAuthor
    -- DOIAuthor               VARCHAR(36),

    --  License provided by each service (CrossRef, DataCite, etc). Could be null(?)
    license         VARCHAR(60),

    --  Link to the scholarly writing.
    objectID                VARCHAR(100),

    --  The source token identifies the Agent that processed the data to produce an Event.
    sourceToken             VARCHAR(36),

    --  The date and time the event was "REPORTED" to have been published by users. CONFORMS TO ISO8601.
    occurredAt              TIMESTAMP,

    --  Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event.
    subjectID               VARCHAR(100),

    --  Every event is assigned a unique ID. Used for reference.
    eventID                 VARCHAR(36),

    --  Terms of use for the CROSSREF EVENT DATA QUERY API.
    crossrefTermsOfUse      VARCHAR(45),

    --  The status of the message containing a list of events (message created, updated, deleted, etc.).
    messageAction           VARCHAR(15),

    --  The original source of the input data. Source could be any of the 12 sources listed in CrossRef's guide.
    sourceID                VARCHAR(20),

    --  Timestamp shortly after the event was observed, CONFORMS TO ISO8601.
    timeObserved            TIMESTAMP,

    --  Type of relationship between the subject and the object. String (varchar).
    relationType            VARCHAR (20)

);

CREATE TABLE IF NOT EXISTS RedditEvent(   

    --  Auto increment for easy primary keys.
    redditIncrement         INTEGER AUTO_INCREMENT PRIMARY KEY,

    --  Foreign key to reference the doi.
    FOREIGN KEY(objectID) REFERENCES Main(objectID) ON DELETE CASCADE,

    --  --  -############################--  --  -COLUMNS--  ###############################--  --  -
    --  Author. redditAuthor
    -- DOIAuthor               VARCHAR(36),

    --  License provided by service.
    license                 VARCHAR(70),

    --  Terms of use for the CROSSREF EVENT DATA QUERY API.
    termsOfUse              VARCHAR (50),

    --  Reason for updating an event. Optional, may point to an announcement page explaining the edit
    updatedReason           VARCHAR (100),

    --  Updated (Kind of boolean) states whether the event was edited or deleted. 
    updated                 VARCHAR(10),

    --  Updated date.
    updatedDate             TIMESTAMP,

    --  ID of the scholarly writing.
    objectID                VARCHAR(100),

    --  PID of the object (DOI being discussed).
    objectPID               VARCHAR(200),

    --  URL of the scholarly writing.
    objectURL               VARCHAR (200),

    --  The source token identifies the Agent that processed the data to produce an Event.
    sourceToken             VARCHAR(36),

    --  The date and time the event was "REPORTED" to have been published by users. CONFORMS TO ISO8601.
    occurredAt              TIMESTAMP,

    --  Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event
    subjectID               VARCHAR(100),

    --  Every event is assigned a unique ID. Used for reference.
    eventID                 VARCHAR(36),

    --  Evidence record contains all of the information used to create an event.
    evidenceRecord          VARCHAR(100),

    --  Action is the nature of the event, such as adding a comment, in which case the action is "add".
    eventAction             VARCHAR(15),

     --  The original source of the input data. Source could be any of the 12 sources listed in CrossRef's guide.
    sourceID                VARCHAR(20),

    --  The ID of the entity mentioning the DOI.
    subjectPID              VARCHAR(100),

    -- Type of discussion about DOI
    subjectType             VARCHAR(10),

    --  The title of the subject.
    subjectTitle            VARCHAR(200),

    --  Date the subject issued the mention.
    subjectIssuedDate       TIMESTAMP,

    --  Timestamp shortly after the event was observed, CONFORMS TO ISO8601.
    timeObserved            TIMESTAMP,

    --  Type of relationship between the subject and the object. String (varchar).
    relationType            VARCHAR (20)
    
    );



    CREATE TABLE IF NOT EXISTS StackexchangeEvent(

    --  Auto increment for easy primary keys.
    stackExchangeIncrement  INTEGER AUTO_INCREMENT PRIMARY KEY,

    --  Foreign key to reference the doi.
    FOREIGN KEY(objectID) REFERENCES Main(objectID) ON DELETE CASCADE,



    --  --  -############################--  --  -COLUMNS--  ###############################--  --  -
    
    --  Author. stackexchangeAuthor
    -- DOIAuthor               VARCHAR(36),

    --  License provided by each service (CrossRef, DataCite, etc). Could be null(?)
    license                 VARCHAR(60),

    --  Terms of use for the CROSSREF EVENT DATA QUERY API.
    termsOfUse              VARCHAR (45),

    --  Link to the scholarly writing.
    objectID                VARCHAR(100),

    --  The source token identifies the Agent that processed the data to produce an Event.
    sourceToken             VARCHAR(36),

    --  The date and time the event was "REPORTED" to have been published by users. CONFORMS TO ISO8601.
    occurredAt              TIMESTAMP,

    --  Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event.
    subjectID               VARCHAR(100),

    --  Every event is assigned a unique ID. Used for reference.
    eventID                 VARCHAR(36) ,

    --  Evidence record contains all of the information used to create an event.
    evidenceRecord          VARCHAR(150),

    --  The ID of the entity mentioning the DOI.
    subjectPID              VARCHAR (80),

    --  The title of the subject.
    subjectTitle            VARCHAR(60),

    --  Date the subject issued the mention.
    subjectIssuedDate       TIMESTAMP,

    --  Type of the subject (post, comment, etc.).
    subjectType             VARCHAR(20),

    --  Subject author's URL.
    subjectAuthorURL        VARCHAR(50),

    --  Subject author's name.
    subjectAuthorName       VARCHAR(30),

    --  Subject author's ID.
    subjectAuthorID         INTEGER,

    --  The original source of the input data. Source could be any of the 12 sources listed in CrossRef's guide.
    sourceID                VARCHAR (20),

    --  PID of the object (DOI being discussed).
    objectPID               VARCHAR(80),

    --  URL of the doi being discussed.
    objectURL               VARCHAR(80),

    --  Timestamp shortly after the event was spotted.
    timeObserved            TIMESTAMP,

    --  Nature of the discussion on the doi (discusses, mentions, etc.).
    relationType            VARCHAR(20)

    );

    CREATE TABLE IF NOT EXISTS WikipediaEvent(

    --  Auto increment for easy primary keys
    wikipediaIncrement      INTEGER AUTO_INCREMENT PRIMARY KEY,

    --  Foreign key to reference the doi
    FOREIGN KEY (objectID) REFERENCES Main(objectID) ON DELETE CASCADE,

    --  --  -############################--  --  -COLUMNS--  ###############################--  --  -
    
    --  Author. wikipediaAuthor
    -- DOIAuthor               VARCHAR(36),

    --  License provided by each service (CrossRef, DataCite, etc). Could be null(?)
    license                 VARCHAR(60),

    --  Terms of use for the CROSSREF EVENT DATA QUERY API.
    termsOfUse              VARCHAR(45),

    --  Updated date.
    updatedDate             TIMESTAMP,

    --  Reason for updating an event. Optional, may point to an announcement page explaining the edit.
    updatedReason           VARCHAR(100),

    --  Link to the scholarly writing.
    objectID                VARCHAR(100),

    --  The source token identifies the Agent that processed the data to produce an Event.
    sourceToken             VARCHAR(36),

    --  The date and time the event was "REPORTED" to have been published by users. CONFORMS TO ISO8601.
    occurredAt              TIMESTAMP,

    --  Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event.
    subjectID               VARCHAR(100),

    --  Every event is assigned a unique ID. Used for reference.
    eventID                 VARCHAR(36) ,

    --  Evidence record contains all of the information used to create an event.
    evidenceRecord          VARCHAR(150),

    --  Action is the nature of the event, such as adding a comment, in which case the action is "add".
    eventAction             VARCHAR(15),

    --  The ID of the entity mentioning the DOI.
    subjectPID              VARCHAR (80),

    --  The title of the subject.
    subjectTitle            VARCHAR(60),

    --  Author of the event.
    subjectURL              VARCHAR(100),

    --  Type of the subject (post, comment, etc.).
    subjectAPIURL           VARCHAR(70),

    --  The original source of the input data. Source could be any of the 12 sources listed in CrossRef's guide.
    sourceID                VARCHAR(20),

    --  PID of the object (DOI being discussed).
    objectPID               VARCHAR(80),

    --  URL of the doi being discussed.
    objectURL               VARCHAR(80),

    --  Timestamp shortly after the event was spotted.
    timeObserved            TIMESTAMP,

    --  Nature of the discussion on the doi (discusses, mentions, etc.).
    relationType            VARCHAR(20)

    );

    CREATE TABLE IF NOT EXISTS WordPressEvent(

    --  Auto increment for easy primary keys.
    wordPressIncrement      INTEGER AUTO_INCREMENT PRIMARY KEY,

    --  Foreign key to reference the doi.
    FOREIGN KEY(objectID) REFERENCES Main(objectID) ON DELETE CASCADE,

    --  --  -############################--  --  -COLUMNS--  ###############################--  --  -
    
    --  Author. wordPressAuthor
    -- DOIAuthor               VARCHAR(36),

    --  License provided by each service (CrossRef, DataCite, etc). Could be null(?)
    license                 VARCHAR(60),

    --  Terms of use for the CROSSREF EVENT DATA QUERY API.
    termsOfUse              VARCHAR (45),

    --  Updated date.
    updatedDate             TIMESTAMP,

    --  Reason for updating an event. Optional, may point to an announcement page explaining the edit.
    updatedReason           VARCHAR(100),

    --  Link to the scholarly writing.
    objectID                VARCHAR(100),

    --  The source token identifies the Agent that processed the data to produce an Event.
    sourceToken             VARCHAR(36),

    --  The date and time the event was "REPORTED" to have been published by users. CONFORMS TO ISO8601.
    occurredAt              TIMESTAMP,

    --  Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event.
    subjectID               VARCHAR(100),

    --  Every event is assigned a unique ID. Used for reference.
    eventID                 VARCHAR(36) ,

    --  Evidence record contains all of the information used to create an event.
    evidenceRecord          VARCHAR(150),

    --  Action is the nature of the event, such as adding a comment, in which case the action is "add".
    eventAction             VARCHAR(15),

    --  The ID of the entity mentioning the DOI.
    subjectPID              VARCHAR(80),

    --  The title of the subject.
    subjectTitle            VARCHAR(60),

    --  Author of the event.
    subjectType             VARCHAR(100),

    --  The original source of the input data. Source could be any of the 12 sources listed in CrossRef's guide.
    sourceID                VARCHAR(20),

    --  PID of the object (DOI being discussed).
    objectPID               VARCHAR(80),

    --  URL of the doi being discussed.
    objectURL               VARCHAR(80),

    --  Timestamp shortly after the event was spotted.
    timeObserved            TIMESTAMP,

    --  Nature of the discussion on the doi (discusses, mentions, etc.).
    relationType            VARCHAR(20)

    );

    CREATE TABLE IF NOT EXISTS DataCiteEvent(

    --   Auto increment for easy primary keys.
    dataCiteIncrement       INTEGER AUTO_INCREMENT PRIMARY KEY,

    --   Foreign key to reference the doi.
    FOREIGN KEY(objectID) REFERENCES Main(objectID) ON DELETE CASCADE,

    --  --  -############################--  --  -COLUMNS--  ###############################--  --  -
    
    --  Author. dataCiteAuthor
    -- DOIAuthor               VARCHAR(36),

    --  License provided by each service (CrossRef, DataCite, etc). Could be null(?)
    license                 VARCHAR(60),

    --  Link to the scholarly writing.
    objectID                VARCHAR(100),

    --  The date and time the event was "REPORTED" to have been published by users. CONFORMS TO ISO8601.
    occurredAt              TIMESTAMP,

    --  Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event.
    subjectID               VARCHAR(100),

    --  Every event is assigned a unique ID. Used for reference.
    eventID                 VARCHAR(36) ,

    --  Terms of use for the CROSSREF EVENT DATA QUERY API.
    termsOfUse              VARCHAR (45),

    --  The status of the message containing a list of events (message created, updated, deleted, etc.).
    messageAction           VARCHAR(15),

    --  The original source of the input data. Source could be any of the 12 sources listed in CrossRef's guide.
    sourceID                VARCHAR (20),

    --  Timestamp shortly after the event was spotted.
    timeObserved            TIMESTAMP,

    --  Nature of the discussion on the doi (discusses, mentions, etc.).
    relationType            VARCHAR(20)

    );

CREATE TABLE TwitterEvent(
    -- Uniquely identify each row.
    twitterIncrement        INTEGER AUTO_INCREMENT,

    -- Unique ID of each event.
    eventID                 VARCHAR(36) ,

    -- A link that contains the Document Object Identifier(DOI) or the scholarly content that was registered at CrossRef.
    objectID                VARCHAR(50),

    -- Author. At least for this table, this may be unnecessary because we already have a tweetAuthor and originalTweetAuthor
    -- twitterAuthor        VARCHAR(36),

    -- Retweet author. If there isn't a retweet, this becomes the tweet author. Can be null.
    tweetAuthor             VARCHAR(75),

    -- If not null, the tweet author is tweetAuthor. Can be null.
    originalTweetAuthor     VARCHAR(75),

    -- Timestamp of when the Event was reported to have occurred.
    occurredAt              TIMESTAMP ,

    -- A license under which the Event is made available.
    license                 VARCHAR(70) ,

    -- Terms of using the API at the point that you acquire the Event.
    termsOfUse              VARCHAR(70) ,

    -- Link to URL to changes made to the data.
    updatedReason           VARCHAR(100) ,

    -- If an Event is updated, it will have the value of deleted or edited.
    updated                 VARCHAR(10) ,

    -- An id that identifies the Agent that made the Event.
    sourceToken             VARCHAR(40) ,

    -- Includes a link to an Evidence Record for this Event. This is used to generate an Event and contains all of the information used to create the Event. 
    evidenceRecord          VARCHAR(100) ,

    -- Action is the nature of the event, such as adding a comment, in which case the action is "add".
    eventAction             VARCHAR(10) ,

    -- Captures URL of retweet. If there is no retweet, captures URL of tweet. If value is just 'http://twitter.com', everything within subject is NULL.
    subjectID               VARCHAR(80) ,

    -- Same value as subjectID. If no tweet or retweet exists, turns into NULL. Can be NULL. This field is within subject.
    subjectPID              VARCHAR(80),

    -- Original Tweet URL. If tweet doesn't exist but retweet does, stores retweet URL.  Can be NULL. This field is within subject.
    originalTweetURL        VARCHAR(80),

    -- id given to each tweet or retweet by Twitter. Can be NULL. This field is within subject.
    alternativeID           VARCHAR(20),

    -- Contains the value "tweet" and an alternative_id. Can be NULL. This field is within subject. 
    title                   VARCHAR(25),

    -- Same value as time_occurred. Can be NULL. This field is within subject.
    issued                  TIMESTAMP,

    -- Name of source that event came from.
    sourceID                VARCHAR(25) ,

    -- Same value as the DOI.
    objectPID               VARCHAR(50) ,

    -- URL of the doi being discussed.
    objectURL               VARCHAR(50) ,

    -- Timestamp of when the Event was created. This field was originally called timestamp.
    timeObserved            TIMESTAMP ,

    -- Date and time of when the Event was updated. **DATE AND TIME different from updated_reason for some reason?**
    updatedDate             DATETIME ,

    -- Type of relation between subject and object.
    relationType            VARCHAR(10) ,

    PRIMARY KEY(twitterIncrement),
    FOREIGN KEY (objectID) REFERENCES Main(objectID) ON DELETE CASCADE
);

CREATE TABLE RedditLinksEvent(
    -- To uniquely identify each row.
    redditLinksIncrement    INTEGER AUTO_INCREMENT,

    -- Unique ID of each event.
    eventID                 VARCHAR(36) ,

    -- A link that contains the Document Object Identifier(DOI) or the scholary content that was registered at CrossRef.
    objectID                VARCHAR(50),

    -- Author. redditLinksAuthor
    -- DOIAuthor               VARCHAR(36),

    -- Timestamp of when the Event was reported to have occurred.
    occurredAt              TIMESTAMP ,

    -- A license under which the Event is made available.
    license                 VARCHAR(60) ,

    -- Terms of using the API at the point that you acquire the Event.
    termsOfUse              VARCHAR(50) ,

    -- Link to URL to changes made to the data.
    updatedReason           VARCHAR(100) ,

    -- If an Event is updated, it will have the value of deleted or edited.
    updated                 VARCHAR(10) ,

    -- An id that identifies the Agent that made the Event.
    sourceToken             VARCHAR(40) ,

    -- Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event. As for the type of URL, it's usually the Canonical URL of a webpage, if one is available. If not, then it's a URL of a webpage.
    subjectID               VARCHAR(200) ,

    -- Includes a link to an Evidence Record for this Event. This is used to generate an Event and contains all of the information used to create the Event.
    evidenceRecord          VARCHAR(110) ,

    -- Action is the nature of the event, such as adding a comment, in which case the action is "add".
    eventAction             VARCHAR(10) ,

    -- The ID of the entity mentioning the DOI.
    subjectPID              VARCHAR(200) ,

    --  Author of the event.
    subjectURL              VARCHAR(200) ,

    -- Name of source that event came from.
    sourceID                VARCHAR(20) ,

    -- Persistent Identifer(PID) of the object (DOI being discussed).
    objectPID               VARCHAR(70) ,

    -- URL of the doi being discussed.
    objectURL               VARCHAR(120) ,

    -- Timestamp of when the Event was created.
    timeObserved            TIMESTAMP ,

    -- Updated date.
    updatedDate             TIMESTAMP ,

    -- Type of relation between subject and object.
    relationType            VARCHAR(15) ,


    PRIMARY KEY (redditLinksIncrement),
    FOREIGN KEY (objectID) REFERENCES Main(objectID) ON DELETE CASCADE
);



CREATE TABLE NewsfeedEvent(
    -- To uniquely identify each row.
    newsfeedIncrement       INTEGER AUTO_INCREMENT,

    -- Unique ID of each event.
    eventID                 VARCHAR(36) ,

    -- A link that contains the Document Object Identifier(DOI) or the scholarly content that was registered at CrossRef.
    objectID                VARCHAR(50),

    -- Author of the .
    -- newsfeedAuthor               VARCHAR(36),

    -- Timestamp of when the Event was reported to have occurred.
    occurredAt              TIMESTAMP ,

    -- A license under which the Event is made available.
    license                 VARCHAR(60) ,

    -- Terms of using the API at the point that you acquire the Event.
    termsOfUse              VARCHAR(50) ,

    -- Link to URL to changes made to the data.
    updatedReason           VARCHAR(100) ,

    -- If an Event is updated, it will have the value of deleted or edited.
    updated                 VARCHAR(10) ,

    -- An id that identifies the Agent that made the Event.
    sourceToken             VARCHAR(40) ,

    -- Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event. As for the type of URL, it's usually the Canonical URL of a webpage, if one is available. If not, then it's a URL of a webpage.
    subjectID               VARCHAR(200) ,

    -- Includes a link to an Evidence Record for this Event. This is used to generate an Event and contains all of the information used to create the Event.
    evidenceRecord          VARCHAR(110) ,

    -- Action is the nature of the event, such as adding a comment, in which case the action is "add".
    eventAction             VARCHAR(10) ,

    -- The ID of the entity mentioning the DOI.
    subjectPID              VARCHAR(200) ,

    --  Type of the subject (post, comment, etc.).
    subjectType             VARCHAR(12) ,

    -- The title of the subject.
    subjectTitle            VARCHAR(125) ,

    -- Author of the event.
    subjectURL              VARCHAR(200) ,

    -- Name of source that event came from.
    sourceID                VARCHAR(20) ,

    -- Persistent Identifer(PID) of the object (DOI being discussed).
    objectPID               VARCHAR(70) ,

    -- URL of the doi being discussed.
    objectURL               VARCHAR(200) ,

    -- Timestamp of when the Event was created.
    timeObserved            TIMESTAMP ,

    -- Updated date.
    updatedDate             TIMESTAMP ,

    -- Nature of the discussion on the doi (discusses, mentions, etc.).
    relationType            VARCHAR(10) ,

    PRIMARY KEY (newsfeedIncrement),
    FOREIGN KEY (objectID) REFERENCES Main(objectID)
);


CREATE TABLE HypothesisEvent(
    -- To uniquely identify each row.
    hypothesisIncrement     INTEGER AUTO_INCREMENT,

    -- Unique ID of each event.
    eventID                 VARCHAR(36) ,

    -- A link that contains the Document Object Identifier(DOI) or the scholarly content that was registered at CrossRef.
    objectID                VARCHAR(50),

    -- Author. hypothesisAuthor
    -- DOIAuthor               VARCHAR(36),

    -- Timestamp of when the Event was reported to have occurred.
    occurredAt              TIMESTAMP ,

    -- A license under which the Event is made available.
    license                 VARCHAR(60) ,

    -- An id that identifies the Agent that made the Event.
    sourceToken            VARCHAR(40) ,

    -- Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event. As for the type of URL, it's usually the Canonical URL of a webpage, if one is available. If not, then it's a URL of a webpage.
    subjectID               VARCHAR(200) ,

    -- Includes a link to an Evidence Record for this Event. This is used to generate an Event and contains all of the information used to create the Event.
    evidenceRecord          VARCHAR(120) ,

    -- Terms of using the API at the point that you acquire the Event.
    termsOfUse              VARCHAR(50) ,

    -- Action is the nature of the event, such as adding a comment, in which case the action is "add".
    eventAction             VARCHAR(10) ,

    -- The ID of the entity mentioning the DOI.
    subjectPID              VARCHAR(50) ,

    -- URL link of the JSON.
    subj_json_url           VARCHAR(70) ,

    -- Author of the event.
    subjectURL              VARCHAR(200) ,

    --  Type of the subject (post, comment, etc.).
    subjectType             VARCHAR(12) ,

    -- The title of the subject. Can be NULL/empty string.
    subjectTitle            VARCHAR(1030),

    -- Date the subject issued the mention.
    subjectIssued           TIMESTAMP ,

    -- Name of source that event came from.
    sourceID                VARCHAR(20) ,

    -- Persistent Identifer(PID) of the object (DOI being discussed).
    objectPID               VARCHAR(70) ,

    -- URL of the doi being discussed.
    objectURL               VARCHAR(100) ,

    -- Timestamp of when the Event was created.
    timeObserved            TIMESTAMP ,

    -- Nature of the discussion on the doi (discusses, mentions, etc.).
    relationType            VARCHAR(10) ,

    PRIMARY KEY (hypothesisIncrement),
    FOREIGN KEY (objectID) REFERENCES Main(objectID) ON DELETE CASCADE
);


CREATE TABLE CambiaEvent(
    -- To uniquely identify each row.
    cambiaIncrement         INTEGER AUTO_INCREMENT,

    -- Unique ID of each event.
    eventID                 VARCHAR(36) ,

    -- A link that contains the Document Object Identifier(DOI) or the scholarly content that was registered at CrossRef.
    objectID                VARCHAR(50),

    -- Author. cambiaAuthor.
    -- DOIAuthor               VARCHAR(36),

    -- A license under which the Event is made available.
    license                 VARCHAR(55) ,

    -- Link to URL to changes made to the data.
    updatedReason           VARCHAR(100) ,

    -- If an Event is updated, it will have the value of deleted or edited.
    updated                 VARCHAR(10) ,

    -- An id that identifies the Agent that made the Event.
    sourceToken             VARCHAR(40) ,

    -- Timestamp of when the Event was reported to have occurred.
    occurredAt              TIMESTAMP ,

    -- Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event. As for the type of URL, it's usually the Canonical URL of a webpage, if one is available. If not, then it's a URL of a webpage.
    subjectID               VARCHAR(200) ,

    -- Terms of using the API at the point that you acquire the Event.
    termsOfUse              VARCHAR(50) ,

    -- Action is the nature of the event, such as adding a comment, in which case the action is "add".
    eventAction             VARCHAR(10) ,

    -- Type of patent.
    workSubtypeID           VARCHAR(25) ,

    -- 'patent'.
    workTypeID              VARCHAR(10) ,

    -- The title of the subject.
    subjectTitle            VARCHAR(140) ,

    -- The ID of the entity mentioning the DOI.
    subjectPID              VARCHAR(50) ,

    -- Patent groups distributing patents.
    jurisdiction            VARCHAR(5) ,

    -- Name of source that event came from.
    sourceID                VARCHAR(20) ,

    -- Timestamp of when the Event was created.
    timeObserved            TIMESTAMP ,

    -- Updated date.
    updatedDate             TIMESTAMP ,

    -- Nature of the discussion on the doi (discusses, mentions, etc.).
    relationType            VARCHAR(10) ,

    PRIMARY KEY (cambiaIncrement),
    FOREIGN KEY (objectID) REFERENCES Main(objectID) ON DELETE CASCADE
);


CREATE TABLE WebEvent(
    -- To uniquely identify each row.
    webIncrement            INTEGER AUTO_INCREMENT,

    -- Unique ID of each event.
    eventID                 VARCHAR(36) ,

    -- A link that contains the Document Object Identifier(DOI) or the scholarly content that was registered at CrossRef.
    objectID                VARCHAR(50),

    -- Author. webAuthor
    -- DOIAuthor               VARCHAR(36),

    -- Timestamp of when the Event was reported to have occurred.
    occurredAt              TIMESTAMP ,

    -- Terms of using the API at the point that you acquire the Event.
    termsOfUse              VARCHAR(50) ,

    -- Link to URL to changes made to the data.
    updatedReason           VARCHAR(100) ,

    -- If an Event is updated, it will have the value of deleted or edited.
    updated                 VARCHAR(10) ,

    -- An id that identifies the Agent that made the Event.
    sourceToken             VARCHAR(40) ,

    -- Subject ID is similar to the object ID, since most events have a URL as a subject ID and the DOI as object ID. The agent that processes the data decides on each event. As for the type of URL, it's usually the Canonical URL of a webpage, if one is available. If not, then it's a URL of a webpage.
    subjectID               VARCHAR(200) ,

    -- Includes a link to an Evidence Record for this Event. This is used to generate an Event and contains all of the information used to create the Event.
    evidenceRecord          VARCHAR(110) ,

    -- Action is the nature of the event, such as adding a comment, in which case the action is "add".
    eventAction             VARCHAR(10) ,

    -- The ID of the entity mentioning the DOI.
    subjectPID              VARCHAR(50) ,

    -- Author of the event.
    subjectURL              VARCHAR(200) ,

    -- Name of source that event came from.
    sourceID                VARCHAR(20) ,

    -- Persistent Identifer(PID) of the object (DOI being discussed).
    objectPID               VARCHAR(70) ,

    -- URL of the doi being discussed.
    objectURL               VARCHAR(60) ,

    -- Timestamp of when the Event was created.
    timeObserved            TIMESTAMP ,

    -- Updated date.
    updatedDate             TIMESTAMP ,

    -- Nature of the discussion on the doi (discusses, mentions, etc.).
    relationType            VARCHAR(10) ,

    PRIMARY KEY (webIncrement),
    FOREIGN KEY (objectID) REFERENCES Main(objectID) ON DELETE CASCADE
);