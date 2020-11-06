import flask
from flask_mysqldb import MySQL

# Import our functions for other pages
from searchLogic import searchLogic
from articleDashboardLogic import articleDashboardLogic
from journalDashboardLogic import journalDashboardLogic
from authorDashboardLogic import authorDashboardLogic
from getPassword import getPassword
from landingPageStats import landingPageStats
from landingPageArticles import landingPageArticles
from landingPageJournals import landingPageJournals

# get the users password from crossrefeventdata/web/passwd.txt
mysql_password = getPassword()

# Instantiate an object of class Flask
app = flask.Flask(__name__)
# Database connection settings
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = mysql_password
# Or use the database.table which will allow us to join the databases - the one with author, and the one with events
app.config['MYSQL_DB'] = 'dr_bowman_doi_data_tables'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

# Database initialization and cursor
mysql = MySQL(app)

# Instantiate a second object of class Flask
app2 = flask.Flask(__name__)
# Database connection settings
app2.config['MYSQL_USER'] = 'root'
app2.config['MYSQL_PASSWORD'] = mysql_password
# Or use the database.table which will allow us to join the databases - the one with author, and the one with events
app2.config['MYSQL_DB'] = 'crossrefeventdatamain'
app2.config['MYSQL_CURSORCLASS'] = 'DictCursor'
# Database initialization and cursor
mysql2 = MySQL(app2)


@app.route('/')
def index():
    totalSum = landingPageStats(mysql)
    totalSumArticles = landingPageArticles(mysql)
    totalSumJournals = landingPageJournals(mysql)
    return flask.render_template('index.html', totalSum=totalSum, totalSumArticles=totalSumArticles, totalSumJournals=totalSumJournals)


@app.route('/searchResultsPage', methods=["GET", "POST"])
def search():
    cursor = mysql.connection.cursor()
    return searchLogic(mysql, cursor)

@app.route('/articleDashboard', methods=["GET", "POST"])
def articleDashboard():

    # THIS IS THE ENTRY POINT FOR THE YEAR CHECKBOX FORM ON THE DASHBOARD
    years_list = [2016, 2017, 2018, 2019, 2020]

    # radioYears will be None if this is the first page load. Then it will pickup the radio selection
    radioYears = str(flask.request.form.get("optradio"))
    if (radioYears == None):
        years_list = [2016, 2017, 2018, 2019, 2020]
    elif (radioYears == "2011-2015"):
        years_list = [2011, 2012, 2013, 2014, 2015]
    elif (radioYears == "2006-2010"):
        years_list = [2006, 2007, 2008, 2009, 2010]
    elif (radioYears == "2001-2005"):
        years_list = [2001, 2002, 2003, 2004, 2005]
    return articleDashboardLogic(mysql, mysql2, years_list)


@app.route('/journalDashboard', methods=["GET", "POST"])
def journalDashboard():
    return journalDashboardLogic(mysql)


@app.route('/authorDashboard', methods=["GET", "POST"])
def authorDashboard():

    # THIS IS THE ENTRY POINT FOR THE YEAR CHECKBOX FORM ON THE DASHBOARD
    years_list = [2016, 2017, 2018, 2019, 2020]
    
    # radioYears will be None if this is the first page load. Then it will pickup the radio selection
    radioYears = str(flask.request.form.get("optradio"))
    if (radioYears == None):
        years_list = [2016, 2017, 2018, 2019, 2020]
    elif (radioYears == "2011-2015"):
        years_list = [2011, 2012, 2013, 2014, 2015]
    elif (radioYears == "2006-2010"):
        years_list = [2006, 2007, 2008, 2009, 2010]
    elif (radioYears == "2001-2005"):
        years_list = [2001, 2002, 2003, 2004, 2005]
    return authorDashboardLogic(mysql, mysql2, years_list)


@app.route('/about', methods=["GET", "POST"])
def about():
    return flask.render_template('about.html')


@app.route('/team', methods=["GET", "POST"])
def team():
    return flask.render_template('team.html')


@app.route('/licenses', methods=["GET", "POST"])
def licenses():
    return flask.render_template('licenses.html')


if __name__ == "__main__":
    app.run(host='localhost', port=5000, debug=True)
