import pandas as pd #show data as tables


class Employee:

    # Constructor

    def __init__(self, EmployeeID, FirstName, LastName, FullName, ManagerID, isEmployeed, LoginName, LoginPassword, EmailAddress):
        self._EmployeeID = EmployeeID
        self._FirstName = FirstName
        self._LastName = LastName
        self._FullName = FullName
        self._ManagerID = ManagerID
        self._isEmployeed = isEmployeed
        self._LoginName = LoginName
        self._LoginPassword = LoginPassword
        self._EmailAddress = EmailAddress

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
    
    def getIsEmployeed(self):
        return self._isEmployeed
    
    def getLoginName(self):
        return self._LoginName
    
    def getLoginPassword(self):
        return self._LoginPassword
    
    def getEmailAddress(self):
        return self._EmailAddress
    
    
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
    
    def setLoginName(self, LoginName):
        self._LoginName = LoginName
    
    def setLoginPassword(self, LoginPassword):
        self._LoginPassword = LoginPassword
    
    def setEmailAddress(self, EmailAddress):
        self._EmailAddress = EmailAddress

    # Generate a string representation of the student.
    # @return string representation
    def __str__(self):
        return str(self._FirstName) +" "+ str(self._LastName) +" "+  str(self._FullName) + " " + str(self._EmployeeID) + " "+ str(self._ManagerID) + " "+ str(self._EmailAddress) + " "+ str(self._isEmployeed)


    # Show a list of employees as panda table.
    # @return panda dataframe
    @staticmethod
    def showAsTable(rows):
        df = pd.DataFrame(columns=["firstname","lastname", "fullname","employeeid","managerid","isemployeed","loginname","emailaddress"])
        for i in rows:
            df.loc[df.shape[0]] = i
        return df
    
    @staticmethod
    def showAsTable2(rows):
        df = pd.DataFrame(columns=["Operation","ModificationUser", "DateAdded", "firstname","lastname", "fullname","employeeid","managerid","isemployeed","loginname","emailaddress","EmpDateAdded","ModificationDate"])
        for i in rows:
            df.loc[df.shape[0]] = i
        return df
