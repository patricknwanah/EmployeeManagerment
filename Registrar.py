import psycopg2

from DBUtils import DBUtils
from Employee import Employee
from Role import Role
from EmployeeRole import EmployeeRole

# Read the java properties file.
#
# @param boundle address
# @return a dictionary containing the connection information
def getBundle(filepath, sep='=', comment_char='#'):
    props = {}
    with open(filepath, "rt") as f:
        for line in f:
            l = line.strip()
            if l and not l.startswith(comment_char):
                key_value = l.split(sep)
                key = key_value[0].strip()
                value = sep.join(key_value[1:]).strip().strip('"')
                props[key] = value
    return props


# An implementation of the Registrar
class Registrar:

    def __init__(self):
        self._conn = None
        self._bundle = None


   # Open a database connection.
   #
   # @param boundle address
   # @return connection
    def  openDBConnectionWithBundle(self, bundle):
        prop =getBundle(bundle)
        return self.openDBConnection(prop['dbUser'],prop['dbPass'],prop['dbSID'],prop['dbHost'],prop['dbPort'])

   # Open the database connection.
   # @param dbUser
   # @param dbPass
   # @param dbSID
   # @param dbHost
   # @return
    def openDBConnection(self, dbUser,dbPass,dbSID,dbHost,port):
        if (self._conn != None):
            self.closeDBConnection()
        try:
            self._conn = DBUtils.openDBConnection(dbUser, dbPass, dbSID, dbHost, port)
            res = DBUtils.testConnection(self._conn)
        except psycopg2.Error as e:
            print (e)
        return res


   # Close the database connection.
    def closeConnection(self):
        try:
            DBUtils.closeConnection(self._conn)
        except psycopg2.Error as e:
            print (e)


   

    def getRoleNames(self, num):
        query = "select rolename from roles order by rolename asc"
        if(num == 1):
            return DBUtils.getAsList(self._conn,query)
        else:
            return DBUtils.getAsList2(self._conn,query)
    
    def getManagerNames(self,num):
        query = "select fullname from managers order by fullname asc"
        if(num == 1):
            return DBUtils.getAsList(self._conn,query)
        else:
            return DBUtils.getAsList2(self._conn,query)
        
    
    
    
    def updateRoles(self,EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget, RoleNameT):
        query = "update roles set EngineOilSpendingAmount = %s, EngineOilBuyingAmount = %s,CrudeOilSpendingAmount = %s,CrudeOilBuyingAmount = %s,MotorOilSpendingAmount = %s,MotorOilBuyingAmount = %s,GasolineBuyingAmount = %s,GasolineSpendingAmount = %s,PetroleumSpendingAmount = %s,PetroleumBuyingAmount = %s,InternalSpendingBudget = %s where RoleName = %s"
        DBUtils.executeUpdate(self._conn, query,(EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget, RoleNameT))
        
        
       
    
    def saveEmployeeRoles(self,fullname,managername,rolename,startdate,enddate):

        try:
            if(enddate == None):
                print("Must Specify an end date")
                return False
            roleid = DBUtils.getRow(self._conn, "select roleid from roles where rolename like '" + str(rolename) + "'")
            employeeid = DBUtils.getRow(self._conn, "select employeeid from (SELECT E.EmployeeID, E.FirstName, E.LastName, CONCAT(E.FirstName, ' ' , E.LastName) AS FULLNAME FROM  Employees E JOIN EmployeeRoles ER ON E.EmployeeID = ER.EmployeeID JOIN Roles R ON ER.RoleID = R.RoleID WHERE E.isEmployeed = 0) as data where fullname like '" + str(fullname) + "'")
            managerid = DBUtils.getRow(self._conn, "select ManagerID from (SELECT E.ManagerID, (SELECT FullName FROM Managers where ManagerID = E.ManagerID) AS ManagerName FROM  Employees E JOIN EmployeeRoles ER ON E.EmployeeID = ER.EmployeeID JOIN Roles R ON ER.RoleID = R.RoleID WHERE E.isEmployeed = 0) as data where ManagerName like '" + str(managername) + "'")
            query = "update employeeroles set roleid = " + str(roleid[0]) + ", startdate = '" + str(startdate) + "', enddate = '" + str(enddate) + "' where employeeid = " + str(employeeid[0])
            DBUtils.executeUpdate(self._conn, query)
            query = "update employees set managerid = " + str(managerid[0]) + " where employeeid = " + str(employeeid[0])
            DBUtils.executeUpdate(self._conn, query)
            return True
        except psycopg2.Error as e:
            print (e)
            return False
        
        
        
    
    def getEmRo(self,fullname):
        query1 = "select employeeid from employeewithrole where lower(fullname) like lower('" + str(fullname) + "')"
        employeeid = DBUtils.getRow(self._conn, query1)
        #query = "select * from EmployeeRolesView where employeeid =  " + str(employeeid[0])
        query = "SELECT E.EmployeeID, E.FirstName, E.LastName, CONCAT(E.FirstName, ' ' , E.LastName) AS FULLNAME, E.isEmployeed, E.ManagerID, (SELECT FullName FROM Managers where ManagerID = E.ManagerID) AS ManagerName, R.RoleName, ER.StartDate StartDate, ER.EndDate EndDate FROM  Employees E JOIN EmployeeRoles ER ON E.EmployeeID = ER.EmployeeID JOIN Roles R ON ER.RoleID = R.RoleID where employeeid =  " + str(employeeid[0])
        return DBUtils.getAllRows(self._conn,query)

        
    
    def saveNewRoles2(self,RoleNameT, EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget):
        cnt = DBUtils.getVar(self._conn, "select count(*) from roles where rolename like '" + str(RoleNameT)+"'")
        if(RoleNameT is not None):
            if(len(str(RoleNameT)) > 0):
                if(cnt == 0):
                    query = "insert into roles (RoleName,EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
                    DBUtils.executeUpdate(self._conn, query,(RoleNameT, EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget));
        
      
    
    
    def getLoginInfo(self,loginname, password):
        query = "select count(*) from employees where loginname = '" + loginname + "' and loginpassword = '" + password + "'"
        try:
            cnt = DBUtils.getVar(self._conn, query)
            if (cnt == 0):
                return -1
            else:
                query = "select count(*) from employees where loginname = '" + loginname + "' and loginpassword = '" + password + "' and employeeid = 1"
                cnt = DBUtils.getVar(self._conn, query)
                if(cnt == 0):
                    return 1
                else:
                    return 0
        except psycopg2.Error as e:
            print (e)
            return -1
        
        
    def getEmployeeNames(self):
        query = "select firstname, lastname from employees order by firstname asc"
        return DBUtils.getAsListFullnames(self._conn,query)
        
    
    def getRoleComponent(self,rolename):
        if(rolename == "All"):
            rolename = "%"
        role = None;
        query = "select * from roles where rolename like '"+ str(rolename) + "'"
        row = DBUtils.getRow(self._conn,query)
        role = Role(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12],row[13],row[14])
        return role
    
    def getEmployeeData(self, fullname):
        employeeRoles = None;
        #query = "select * from EmployeeRolesView where lower(fullname) like lower('" + str(fullname) + "%')"
        query = "select * from (SELECT E.EmployeeID,E.FirstName,E.LastName,CONCAT(E.FirstName, ' ' , E.LastName) AS FULLNAME, E.isEmployeed,E.ManagerID,(SELECT FullName FROM Managers where ManagerID = E.ManagerID) AS ManagerName,R.RoleName,ER.StartDate StartDate,ER.EndDate EndDate FROM  Employees E JOIN EmployeeRoles ER ON E.EmployeeID = ER.EmployeeID JOIN Roles R ON ER.RoleID = R.RoleID) as data where lower(fullname) like lower('" + str(fullname) + "%')"
        row = DBUtils.getRow(self._conn,query)
        employeeRoles = EmployeeRole(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9])
        return employeeRoles
        
        
        
    def getFilteredEmployees(self,fullname,managername,rolename):
        if(rolename == "All"):
            rolename = '%'
        if(managername == "All"):
            managername = '%'
        query = "SELECT * FROM (SELECT E.FirstName,E.LastName,CONCAT(E.FirstName, ' ' , E.LastName) AS FULLNAME,E.EmailAddress,R.RoleName,(SELECT FullName FROM Managers where ManagerID = E.ManagerID) AS ManagerName FROM  Employees E JOIN EmployeeRoles ER ON E.EmployeeID = ER.EmployeeID JOIN Roles R ON ER.RoleID = R.RoleID WHERE E.isEmployeed = 0 and lower(rolename) like lower('" + rolename + "%')) AS DATA WHERE lower(managername) like lower('" + str(managername) + "%') AND lower(FULLNAME) like lower('" + str(fullname) + "%')"
        return DBUtils.getAllRows(self._conn,query)
    
    def getAllEmployees(self):
        #query = "select firstname,lastname,fullname,emailaddress,rolename,managername from employeewithrole order by firstname asc"
        query = " SELECT E.FirstName,E.LastName,CONCAT(E.FirstName, ' ' , E.LastName) AS FULLNAME,E.EmailAddress,R.RoleName,(SELECT FullName FROM Managers where ManagerID = E.ManagerID) AS ManagerName FROM  Employees E JOIN EmployeeRoles ER ON E.EmployeeID = ER.EmployeeID JOIN Roles R ON ER.RoleID = R.RoleID WHERE E.isEmployeed = 0 order by firstname asc"
        return DBUtils.getAllRows(self._conn,query)
    
    def getAudits(self,num):
        query = ""
        if(num == 1):
            query = "select * from AuditEmployees"
        elif(num == 2):
            query = "select * from AuditEmployeeRoles"
        else:
            query = "select * from AuditRoles"
        return DBUtils.getAllRows(self._conn,query)
    
    
    def getAllRoles(self):
        query = "select RoleID,RoleName,EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget from roles"
        return DBUtils.getAllRows(self._conn,query)


    
