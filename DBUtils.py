import psycopg2

# This class will handle all the database functions. You don't need to change this class.

class DBUtils:
   # Open a database connection.
   #
   # @param user
   # @param pass
   # @param dbSID
   # @param host
   # @return connection
    @staticmethod
    def  openDBConnection(dbUser,dbPass,dbSID,dbHost,dbPort):
        conn = psycopg2.connect("dbname={} user={} password={} host={} port={}".format(dbSID,dbUser,dbPass,dbHost,dbPort))
        return conn;


   # Test a database connection.
   #
   # @param conn
   # @return current date and time if the connection is open.  Otherwise an exception will be thrown.
    @staticmethod
    def testConnection(conn):
        cur = conn.cursor();
        cur.execute("select now() as res")
        res = ""
        row = cur.fetchone()
        while row is not None:
            res = "Servus: " + str(row[0])
            row= cur.fetchone()
        cur.close()
        return res


   # Close the database connection.
   #
   # @param conn
    @staticmethod
    def closeConnection(conn):
        conn.close()


   # Execute an update or a delete query.
   # @param conn
   # @param query
    @staticmethod
    def executeUpdate(conn,query,parameters=None):
        cur = conn.cursor()
        cur.execute(query,parameters)
        conn.commit()
        cur.close()


   # Get a variable that is returned as a result of a query.
   # @param conn
   # @param query
   # @return result
    @staticmethod
    def getVar(conn,query,parameters=None):
        cur = conn.cursor()
        cur.execute(query,parameters)
        result = cur.fetchone()[0]
        cur.close()
        return result

   # Get a row that is returned as a result of a query.
   # @param conn
   # @param query
   # @return result
    @staticmethod
    def getRow(conn,query,parameters=None):
        cur = conn.cursor()
        cur.execute(query,parameters)
        result = cur.fetchone()
        cur.close()
        return result


   # Get  all rows that is returned as a result of a query.
   # @param conn
   # @param query
   # @return result
    @staticmethod
    def getAllRows(conn,query, parameters=None):
        cur = conn.cursor()
        cur.execute(query, parameters)
        result = cur.fetchall()
        cur.close()
        return result
    
    @staticmethod
    def getAsListFullnames(conn,query, parameters=None):
        myList = []
        cur = conn.cursor()
        cur.execute(query, parameters)
        result = cur.fetchall()
        for i in result:
            name = str(i[0]) + ' ' + str(i[1])
            myList.append(name)
        cur.close()
        return myList
    
    @staticmethod
    def getAsList2(conn,query, parameters=None):
        myList = []
        cur = conn.cursor()
        cur.execute(query, parameters)
        result = cur.fetchall()
        for i in result:
            myList.append(i[0])
        cur.close()
        return myList
    
    
    @staticmethod
    def getAsList(conn,query, parameters=None):
        myList = []
        cur = conn.cursor()
        cur.execute(query, parameters)
        result = cur.fetchall()
        myList.append("All")
        for i in result:
            myList.append(i[0])
        cur.close()
        return myList
