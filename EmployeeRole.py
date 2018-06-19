import pandas as pd #show data as tables


class EmployeeRole:

    # Constructor

    def __init__(self, EmployeeID, FirstName, LastName, FullName, isEmployeed, ManagerID, ManagerName, RoleName, StartDate, EndDate):
        self._EmployeeID = EmployeeID
        self._FirstName = FirstName
        self._LastName = LastName
        self._FullName = FullName
        self._ManagerID = ManagerID
        self._ManagerName = ManagerName
        self._isEmployeed = isEmployeed
        self._RoleName = RoleName
        self._StartDate = StartDate
        self._EndDate = EndDate

    # ---------------------Getters--------------------
    def getFirstName(self):
        return self._FirstName
    
    def getLastName(self):
        return self._LastName
    
    def getFullName(self):
        return self._FullName
    
    def getEmployeeID(self):
        return self._EmployeeID
    
    def getManagerID(self):
        return self._ManagerID
    
    def getManagerName(self):
        return self._ManagerName
    
    def getIsEmployeed(self):
        return self._isEmployeed
    
    def getRoleName(self):
        return self._RoleName
    
    def getStartDate(self):
        return self._StartDate
    
    def getEndDate(self):
        return self._EndDate
    
    
    #--------------------Setters--------------------------
    def setFirstName(self,FirstName):
        self._FirstName = FirstName
   
    def setLastName(self, LastName):
        self._LastName = LastName

    def setFullname(self, FullName):
        self._FullName = FullName

    def setEmployeeID(self, EmployeeID):
        self._EmployeeID = EmployeeID

    def setManagerID(self, ManagerID):
        self._ManagerID = ManagerID
    

    def setIsEmployeed(self, isEmployeed):
        self._isEmployeed = isEmployeed

    def setLoginName(self, RoleName):
        self._LoginName = RoleName

    def setLoginPassword(self, StartDate):
        self._LoginPassword = StartDate

    def setEmailAddress(self, EndDate):
        self._EmailAddress = EndDate

    # Generate a string representation of the student.
    # @return string representation
    def __str__(self):
        return str(self._FirstName) +" "+ str(self._LastName) +" "+  str(self._FullName) + " " + str(self._EmployeeID) + " "+ str(self._ManagerID) + " "+ str(self._EmailAddress) + " "+ str(self._isEmployeed)


    # Show a list of employees as panda table.
    # @return panda dataframe
    @staticmethod
    def showAsTable(rows):
        df = pd.DataFrame(columns=["employeeid","firstname","lastname", "fullname","isemployeed","managerid","managername","rolename","startdate","enddate"])
        for i in rows:
            df.loc[df.shape[0]] = i
        return df
    
    @staticmethod
    def showAsTable2(rows):
        df = pd.DataFrame(columns=["Operation","ModificationUser", "DateAdded", "EmployeeRoleID", "employeeid","roleid","startdate","enddate","EmpDateAdded","ModificationDate"])
        for i in rows:
            df.loc[df.shape[0]] = i
        return df
