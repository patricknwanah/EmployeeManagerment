import pandas as pd #show data as tables


class Role:

    # Constructor

    def __init__(self, RoleID,RoleName,EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget,DateAdded,ModificationDate):
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
        self._DateAdded = DateAdded 
        self._ModificationDate = ModificationDate 


    # ---------------------Getters--------------------
    def getRoleID(self):
        return self._RoleID
    
    def getRoleName(self):
        return self._RoleName
    
    def getEngineOilSpendingAmount(self):
        return int(self._EngineOilSpendingAmount)
    
    def getEngineOilBuyingAmount(self):
        return int(self._EngineOilBuyingAmount)
    
    def getCrudeOilSpendingAmount(self):
        return int(self._CrudeOilSpendingAmount)
    
    def getCrudeOilBuyingAmount(self):
        return int(self._CrudeOilBuyingAmount)
    
    def getMotorOilSpendingAmount(self):
        return int(self._MotorOilSpendingAmount)
    
    def getMotorOilBuyingAmount(self):
        return int(self._MotorOilBuyingAmount)
    
    def getGasolineBuyingAmount(self):
        return int(self._GasolineBuyingAmount)
    
    def getGasolineSpendingAmount(self):
        return int(self._GasolineSpendingAmount)
    
    def getPetroleumSpendingAmount(self):
        return int(self._PetroleumSpendingAmount)
    
    def getPetroleumBuyingAmount(self):
        return int(self._PetroleumBuyingAmount)
    
    def getInternalSpendingBudget(self):
        return int(self._InternalSpendingBudget)
    
    def getDateAdded(self):
        return self._DateAdded
    
    def getModificationDate(self):
        return self._ModificationDate
    
    
    #--------------------Setters--------------------------
    def setRoleID(self,RoleID):
        self._RoleID = RoleID
        
    def setRoleName(self,RoleName):
        self._RoleName = RoleName
    
    def setEngineOilSpendingAmount(self,EngineOilSpendingAmount):
        self._EngineOilSpendingAmount = EngineOilSpendingAmount
        
    def setEngineOilBuyingAmount(self,EngineOilBuyingAmount):
        self._EngineOilBuyingAmount = EngineOilBuyingAmount
        
    def setCrudeOilSpendingAmount(self,CrudeOilSpendingAmount):
        self._CrudeOilSpendingAmount = CrudeOilSpendingAmount
        
    def setCrudeOilBuyingAmount(self,CrudeOilBuyingAmount):
        self._CrudeOilBuyingAmount = CrudeOilBuyingAmount
        
    def setMotorOilSpendingAmount(self,MotorOilSpendingAmount):
        self._MotorOilSpendingAmount = MotorOilSpendingAmount
        
    def setMotorOilBuyingAmount(self,MotorOilBuyingAmount):
        self._MotorOilBuyingAmount = MotorOilBuyingAmount
        
    def setGasolineBuyingAmount(self,GasolineBuyingAmount):
        self._GasolineBuyingAmount = GasolineBuyingAmount
        
    def setGasolineSpendingAmount(self,GasolineSpendingAmount):
        self._GasolineSpendingAmount = GasolineSpendingAmount
        
    def setPetroleumSpendingAmount(self,PetroleumSpendingAmount):
        self._PetroleumSpendingAmount = PetroleumSpendingAmount
        
    def setPetroleumBuyingAmount(self,PetroleumBuyingAmount):
        self._PetroleumBuyingAmount = PetroleumBuyingAmount
        
    def setInternalSpendingBudget(self,InternalSpendingBudget):
        self._InternalSpendingBudget = InternalSpendingBudget
        
    
    

    # Generate a string representation of the student.
    # @return string representation
    def __str__(self):
        return str(self._FirstName) +" "+ str(self._MiddleName) + " " + str(self._LastName) +" "+ str(self._EmployeeID) + " "+ str(self._ManagerID) + " "+ str(self._EmailAddress) + " "+ str(self._isEmployeed)


    # Show a list of roles as panda table.
    # @return panda dataframe
    @staticmethod
    def showAsTable(rows):
        df = pd.DataFrame(columns=["RoleID","RoleName","EngineOilSpendingAmount","EngineOilBuyingAmount","CrudeOilSpendingAmount","CrudeOilBuyingAmount","MotorOilSpendingAmount","MotorOilBuyingAmount","GasolineBuyingAmount","GasolineSpendingAmount","PetroleumSpendingAmount","PetroleumBuyingAmount","InternalSpendingBudget"])
        for i in rows:
            df.loc[df.shape[0]] = i
        return df
    
    @staticmethod
    def showAsTable2(rows):
        df = pd.DataFrame(columns=["Operation","ModificationUser", "DateAdded", "RoleID","RoleName","EngineOilSpendingAmount","EngineOilBuyingAmount","CrudeOilSpendingAmount","CrudeOilBuyingAmount","MotorOilSpendingAmount","MotorOilBuyingAmount","GasolineBuyingAmount","GasolineSpendingAmount","PetroleumSpendingAmount","PetroleumBuyingAmount","InternalSpendingBudget","RoleDateAdded","ModificationDate"])
        for i in rows:
            df.loc[df.shape[0]] = i
        return df
