import pandas as pd #show data as tables


class EmployeeWithRole:

    # Constructor
 
    def __init__(self, EmployeeID, FirstName, LastName, FullName, MiddleName, ManagerID, isEmployeed, LoginName, EmailAddress, RoleID,RoleName,EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget,EmployeeDateAdded,EmployeeRoleAdded,ManagerName):
        self._EmployeeID = EmployeeID
        self._FirstName = FirstName
        self._LastName = LastName
        self._FullName = FullName
        self._EmailAddress = EmailAddress
        self._LoginName = LoginName
        self._isEmployeed = isEmployeed
        self._ManagerID = ManagerID
        self._RoleID = RoleID 
        self._RoleName = RoleName 
        self._EngineOilSpendingAmount = EngineOilSpendingAmount
        self._EngineOilBuyingAmount = EngineOilBuyingAmount 
        self._CrudeOilSpendingAmount = CrudeOilSpendingAmount 
        self._CrudeOilBuyingAmount = CrudeOilBuyingAmount 
        self._MotorOilSpendingAmount = MotorOilSpendingAmount 
        self._MotorOilBuyingAmount = MotorOilBuyingAmount 
        self._GasolineBuyingAmount = GasolineBuyingAmount 
        self._GasolineSpendingAmount = GasolineSpendingAmount 
        self._PetroleumSpendingAmount = PetroleumSpendingAmount
        self._PetroleumBuyingAmount = PetroleumBuyingAmount 
        self._InternalSpendingBudget = InternalSpendingBudget 
        self._EmployeeDateAdded = EmployeeDateAdded
        self._EmployeeRoleAdded = EmployeeRoleAdded
        self._ManagerName = ManagerName
        
        
        

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
    
    def getRoleID(self):
        return self._RoleID
    
    def getRoleName(self):
        return self._RoleName
    
    def getEngineOilSpendingAmount(self):
        return self._EngineOilSpendingAmount
    
    def getEngineOilBuyingAmount(self):
        return self._EngineOilBuyingAmount
    
    def getCrudeOilSpendingAmount(self):
        return self._CrudeOilSpendingAmount
    
    def getCrudeOilBuyingAmount(self):
        return self._CrudeOilBuyingAmount
    
    def getMotorOilSpendingAmount(self):
        return self._MotorOilSpendingAmount
    
    def getMotorOilBuyingAmount(self):
        return self._MotorOilBuyingAmount
    
    def getGasolineBuyingAmount(self):
        return self._GasolineBuyingAmount
    
    def getGasolineSpendingAmount(self):
        return self._GasolineSpendingAmount
    
    def getPetroleumSpendingAmount(self):
        return self._PetroleumSpendingAmount
    
    def getPetroleumBuyingAmount(self):
        return self._PetroleumBuyingAmount
    
    def getInternalSpendingBudget(self):
        return self._InternalSpendingBudget
    
    def getEmployeeDateAdded(self):
        return self._EmployeeDateAdded
    
    def getEmployeeRoleAdded(self):
        return self._EmployeeRoleAdded
    
    def getManagerName(self):
        return self._ManagerName
    
    
    #--------------------Setters--------------------------
    

    # Generate a string representation of the student.
    # @return string representation
    def __str__(self):
        return str(self._FirstName) + " "+ str(self._LastName) +" "+  str(self._FullName) + " " + str(self._EmployeeID) + " "+ str(self._ManagerID) + " "+ str(self._EmailAddress) + " "+ str(self._isEmployeed) + " " + str(self._RoleID) + " " + str(self._RoleName) + " "+ str(self._EngineOilSpendingAmount) + " "+ str(self._EngineOilBuyingAmount) + " "+ str(self._CrudeOilSpendingAmount) + " "+ str(self._CrudeOilBuyingAmount) + " "+ str(self._MotorOilSpendingAmount) + " "+ str(self._MotorOilBuyingAmount) + " "+ str(self._GasolineBuyingAmount) + " "+ str(self._GasolineSpendingAmount) + " "+ str(self._PetroleumSpendingAmount) + " "+ str(self._PetroleumBuyingAmount) + " " + str(self._InternalSpendingBudget) + " " + str(self._EmployeeDateAdded)+ " " + str(self._EmployeeRoleAdded) + " " + str(self._ManagerName) 


    # Show a list of employeewithrole as panda table.
    # @return panda dataframe
    @staticmethod
    def showAsTable(rows):
        df = pd.DataFrame(columns=["firstname","lastname","fullname","emailaddress","rolename", "managername"])
        for i in rows:
            df.loc[df.shape[0]] = i
        return df
