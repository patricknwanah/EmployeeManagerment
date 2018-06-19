#Import libraries
from ipywidgets import *
from IPython import display
from datetime import date
from datetime import datetime

from Registrar import Registrar
from Employee import Employee
from Role import Role
from EmployeeWithRole import EmployeeWithRole
from EmployeeRole import EmployeeRole




today = str(date.today().strftime('%m/%d/%Y'))

today = datetime.strptime(today , '%m/%d/%Y').date()

#Define Widgets.

dropdownRole = widgets.Dropdown(
    description='Role Name:',
    disabled=False,)   

def on_change(change):
    if change['type'] == 'change' and change['name'] == 'value':
        reg = Registrar()
        response = reg.openDBConnectionWithBundle("PgBundle.properties")
        curRole = reg.getRoleComponent(dropdownRole.value)
        reg.closeConnection()
        EngineOilSpendingAmount.value = curRole.getEngineOilSpendingAmount()
        EngineOilBuyingAmount.value = curRole.getEngineOilBuyingAmount()
        CrudeOilSpendingAmount.value = curRole.getCrudeOilSpendingAmount()
        CrudeOilBuyingAmount.value = curRole.getCrudeOilBuyingAmount()
        MotorOilSpendingAmount.value = curRole.getMotorOilSpendingAmount()
        MotorOilBuyingAmount.value = curRole.getMotorOilBuyingAmount()
        GasolineBuyingAmount.value = curRole.getGasolineBuyingAmount()
        GasolineSpendingAmount.value = curRole.getGasolineSpendingAmount()
        PetroleumSpendingAmount.value = curRole.getPetroleumSpendingAmount()
        PetroleumBuyingAmount.value = curRole.getPetroleumBuyingAmount()
        InternalSpendingBudget.value = curRole.getInternalSpendingBudget()
        #print("changed to %s" % change['new'])
        
        




employeeRoleFullName = widgets.Dropdown(
            description='Full Name:',
            disabled=False
    )

def on_changeE(change):
    if change['type'] == 'change' and change['name'] == 'value':
        reg = Registrar()
        response = reg.openDBConnectionWithBundle("PgBundle.properties")
        curE = reg.getEmployeeData(employeeRoleFullName.value)
        managerDropDown.value = curE.getManagerName()
        employeeRoleStartDate.value = curE.getStartDate()
        employeeRoleEndDate.value = curE.getEndDate()
        dropdownRole.value = curE.getRoleName()
        reg.closeConnection()
        


  

searchHeader = widgets.HTML(
    value="<b>Search for Employees. Scroll to the bottom to see new results</b>",
    placeholder='',
    description='',
)

employeeFullName = widgets.Textarea(
    value='',
    placeholder='Firstname Lastname',
    description='Name:',
    disabled=False
)

managerDropDown = widgets.Dropdown(
    description='Manager Name:',
    disabled=False
)




rolesHeader = widgets.HTML(
    value="<b>Add or Edit roles. Roles must have a unique name</b>",
    placeholder='',
    description='',
)



########################Edit Employee##################################
########################Edit Employee##################################
########################Edit Employee##################################
########################Edit Employee##################################
########################Edit Employee##################################
########################Edit Employee##################################
#EmployeeRoles = None

wantToEditHeader = widgets.HTML(
    value="<b>Do you want to edit a user? (Hint) Employee must exist so make sure you are looking for exactly one person</b>",
    placeholder='',
    description='',
)

EmployeeRolesHeader = widgets.HTML(
    value="<b>Edit Employee (Hint) Employee must exist so make sure you are looking for exactly one person and fullname cannot be changed</b>",
    placeholder='',
    description='',
)




employeeRoleStartDate = widgets.DatePicker(
    value = today,
    description='Start Date:',
    disabled=False
)

employeeRoleEndDate = widgets.DatePicker(
    value = today,
    description='End Date:',
    disabled=False
)





    
###########################################################################
###########################################################################
###########################################################################
###########################################################################


    
    
    
    
    
def filter_employees(sender):
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    employees = reg.getFilteredEmployees(employeeFullName.value,managerDropDown.value,dropdownRole.value)
    employeeTable = EmployeeWithRole.showAsTable(employees)
    #display.display(employeeTable)
    display.display(display.HTML(employeeTable.to_html()))


def search_Employee():
    display.clear_output()
    searchButtonE = widgets.Button(description="Search")
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    managerDropDown.options = reg.getManagerNames(1)
    dropdownRole.options = reg.getRoleNames(1)
    managerDropDown.value = managerDropDown.options[0]
    dropdownRole.value = dropdownRole.options[0]
    display.display(searchHeader)
    display.display(employeeFullName)
    display.display(managerDropDown)
    display.display(dropdownRole)
    display.display(searchButtonE)
    searchButtonE.on_click(filter_employees)
    
def show_Employee_With_Role():
    display.clear_output()
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    employees = reg.getAllEmployees()
    reg.closeConnection();
    employeeTable=EmployeeWithRole.showAsTable(employees)
    #display.display(employeeTable)
    display.display(display.HTML(employeeTable.to_html()))
    
    
def show_Audit_Tables(num):
    display.clear_output()
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    audit = reg.getAudits(num)
    audittable = None
    if(num == 1):
        audittable = Employee.showAsTable2(audit)
    elif(num == 2):
        audittable = EmployeeRole.showAsTable2(audit)
    else:
        audittable = Role.showAsTable2(audit)
    reg.closeConnection();
    display.display(display.HTML(audittable.to_html()))
    
    
    
    
def show_Roles():
    display.clear_output()
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    roles = reg.getAllRoles()
    reg.closeConnection();
    rolesTable = Role.showAsTable(roles)
    display.display(rolesTable)


def view_role_components(sender):
    display.clear_output(wait=False)
    
def add_edit_Role():
    addoreditrolesButton = widgets.Button(description="Add or Edit role +")
    display.display(rolesHeader)
    display.display(addoreditrolesButton)
    addoreditrolesButton.on_click(view_role_components)
    
    
    
    
    
#ViewEditUsers
def sign_out(sender):
    display.clear_output()
    loginName.value = ''
    loginPassword.value = ''
    begin_DOA()
    
def admingoBack(sender):
    viewEditEmployees()
    
def goBack(sender):
    viewEmployees()
    
def viewAllUsersAdmin(sender):
    back_button = widgets.Button(description="Back to main menu")
    show_Employee_With_Role()
    display.display(back_button)
    back_button.on_click(admingoBack)
    
def viewAuditsE(sender):
    back_button = widgets.Button(description="Back to main menu")
    show_Audit_Tables(1)
    display.display(back_button)
    back_button.on_click(admingoBack)
    
def viewAuditsER(sender):
    back_button = widgets.Button(description="Back to main menu")
    show_Audit_Tables(2)
    display.display(back_button)
    back_button.on_click(admingoBack)
    
def viewAuditsR(sender):
    back_button = widgets.Button(description="Back to main menu")
    show_Audit_Tables(3)
    display.display(back_button)
    back_button.on_click(admingoBack)
    
def viewAllUsers(sender):
    back_button = widgets.Button(description="Back to main menu")
    show_Employee_With_Role()
    display.display(back_button)
    back_button.on_click(goBack)
    
def viewAllRolesAdmin(sender):
    back_button = widgets.Button(description="Back to main menu")
    show_Roles()
    display.display(back_button)
    back_button.on_click(admingoBack)
    
def viewAllRoles(sender):
    back_button = widgets.Button(description="Back to main menu")
    show_Roles()
    display.display(back_button)
    back_button.on_click(goBack)
    
    
def searchforUserAdmin(sender):
    back_button = widgets.Button(description="Back to main menu")
    search_Employee()
    display.display(back_button)
    back_button.on_click(admingoBack)
    
def searchforUser(sender):
    back_button = widgets.Button(description="Back to main menu")
    search_Employee()
    display.display(back_button)
    back_button.on_click(goBack)
    





##############################Edit EMPLOYEE#########################################
#######################################################################    
#######################################################################
#######################################################################  


def saveEmployeeChanges():
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    returnvalue = reg.saveEmployeeRoles(employeeRoleFullName.value,managerDropDown.value,dropdownRole.value, employeeRoleStartDate.value,employeeRoleEndDate.value)
    
    if(returnvalue == True):
        print("Update Successful")
    else:
        print("Update Failure")
    reg.closeConnection();
    
    
def show_edit_employee_section():
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    employeeRoleFullName.options = reg.getEmployeeNames()
    managerDropDown.options = reg.getManagerNames(2)
    dropdownRole.options = reg.getRoleNames(2)
    curE = reg.getEmployeeData(employeeRoleFullName.value)
    managerDropDown.value = curE.getManagerName()
    employeeRoleStartDate.value = curE.getStartDate()
    employeeRoleEndDate.value = curE.getEndDate()
    dropdownRole.value = curE.getRoleName()
    reg.closeConnection();
    display.display(EmployeeRolesHeader)
    display.display(employeeRoleFullName)
    display.display(managerDropDown)
    display.display(dropdownRole)
    display.display(employeeRoleStartDate)
    display.display(employeeRoleEndDate)




    
def saveadmingoBack(sender):
    saveEmployeeChanges()
    
def editEmployee(sender):
    display.clear_output()
    back_button = widgets.Button(description="Back to main menu")
    save_back_button = widgets.Button(description="Save")
    show_edit_employee_section()
    display.display(save_back_button)
    display.display(back_button)
    save_back_button.on_click(saveadmingoBack) 
    back_button.on_click(admingoBack)
    
#######################################################################
#######################################################################    
#######################################################################
#######################################################################    
   


 
EngineOilSpendingAmount = widgets.IntText(description="EngineOilSpendingAmount", value='0')
EngineOilBuyingAmount = widgets.IntText(description="EngineOilBuyingAmount", value='0')
CrudeOilSpendingAmount = widgets.IntText(description="CrudeOilSpendingAmount", value='0')
CrudeOilBuyingAmount = widgets.IntText(description="CrudeOilBuyingAmount", value='0')
MotorOilSpendingAmount = widgets.IntText(description="MotorOilSpendingAmount", value='0')
MotorOilBuyingAmount = widgets.IntText(description="MotorOilBuyingAmount", value='0')
GasolineBuyingAmount = widgets.IntText(description="GasolineBuyingAmount", value='0')
GasolineSpendingAmount = widgets.IntText(description="GasolineSpendingAmount", value='0')
PetroleumSpendingAmount = widgets.IntText(description="PetroleumSpendingAmount", value='0')
PetroleumBuyingAmount = widgets.IntText(description="PetroleumBuyingAmount", value='0')
InternalSpendingBudget = widgets.IntText(description="InternalSpendingBudget", value='0')
textRoleName = widgets.Textarea(description="Role Name")

    
def addNR(sender):
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    if str(textRoleName.value).strip() in dropdownRole.options:
        print("Role name already exists!!")
    elif textRoleName.value == None or len(str(textRoleName.value).strip()) < 1:
        print("Role name was not given!!")
    else:
        reg.saveNewRoles2(textRoleName.value, EngineOilSpendingAmount.value,EngineOilBuyingAmount.value,CrudeOilSpendingAmount.value,CrudeOilBuyingAmount.value,MotorOilSpendingAmount.value,MotorOilBuyingAmount.value,GasolineBuyingAmount.value,GasolineSpendingAmount.value,PetroleumSpendingAmount.value,PetroleumBuyingAmount.value,InternalSpendingBudget.value)
        print("New role created!!!")
    reg.closeConnection();
    
def addNewRoles():
    saveNewRoleButton = widgets.Button(description="Save")
    resetValues()
    display.display(textRoleName)
    displayRolesComponents()
    display.display(saveNewRoleButton)
    saveNewRoleButton.on_click(addNR)
    
    
def displayRolesComponents():
    display.display(EngineOilSpendingAmount) 
    display.display(EngineOilBuyingAmount 	)
    display.display(CrudeOilSpendingAmount )
    display.display(MotorOilSpendingAmount )
    display.display(MotorOilBuyingAmount 	)
    display.display(GasolineBuyingAmount 	)
    display.display(GasolineSpendingAmount )
    display.display(PetroleumSpendingAmount) 
    display.display(PetroleumBuyingAmount 	)
    display.display(InternalSpendingBudget )
    
    
def editR(sender):
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    reg.updateRoles(EngineOilSpendingAmount.value,EngineOilBuyingAmount.value,CrudeOilSpendingAmount.value,CrudeOilBuyingAmount.value,MotorOilSpendingAmount.value,MotorOilBuyingAmount.value,GasolineBuyingAmount.value,GasolineSpendingAmount.value,PetroleumSpendingAmount.value,PetroleumBuyingAmount.value,InternalSpendingBudget.value, dropdownRole.value)
    print("Updated role: " + str(dropdownRole.value))
    reg.closeConnection()



def editExistRoles():
    saveNewRoleButton = widgets.Button(description="Save")
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    dropdownRole.options = reg.getRoleNames(2)
    curRole = reg.getRoleComponent(dropdownRole.value)
    EngineOilSpendingAmount.value = curRole.getEngineOilSpendingAmount()
    EngineOilBuyingAmount.value = curRole.getEngineOilBuyingAmount()
    CrudeOilSpendingAmount.value = curRole.getCrudeOilSpendingAmount()
    CrudeOilBuyingAmount.value = curRole.getCrudeOilBuyingAmount()
    MotorOilSpendingAmount.value = curRole.getMotorOilSpendingAmount()
    MotorOilBuyingAmount.value = curRole.getMotorOilBuyingAmount()
    GasolineBuyingAmount.value = curRole.getGasolineBuyingAmount()
    GasolineSpendingAmount.value = curRole.getGasolineSpendingAmount()
    PetroleumSpendingAmount.value = curRole.getPetroleumSpendingAmount()
    PetroleumBuyingAmount.value = curRole.getPetroleumBuyingAmount()
    InternalSpendingBudget.value = curRole.getInternalSpendingBudget()
    reg.closeConnection()
    display.display(dropdownRole)
    displayRolesComponents()
    display.display(saveNewRoleButton)
    
    saveNewRoleButton.on_click(editR)

def addRolesAdmin(sender):
    display.clear_output()
    back_button = widgets.Button(description="Back to main menu")
    addNewRoles()
    display.display(back_button)
    back_button.on_click(admingoBack)
    
def editRolesAdmin(sender):
    display.clear_output()
    back_button = widgets.Button(description="Back to main menu")
    editExistRoles()
    display.display(back_button)
    back_button.on_click(admingoBack)
    
def resetValues():
    textRoleName.value = ''
    EngineOilSpendingAmount.value = '0'
    EngineOilBuyingAmount.value= '0'
    CrudeOilSpendingAmount.value= '0'
    CrudeOilBuyingAmount.value= '0'
    MotorOilSpendingAmount.value= '0'
    MotorOilBuyingAmount.value= '0'
    GasolineBuyingAmount.value= '0'
    GasolineSpendingAmount.value= '0'
    PetroleumSpendingAmount.value= '0'
    PetroleumBuyingAmount.value= '0'
    InternalSpendingBudget.value= '0'
    

#######################################################################
#######################################################################    
#######################################################################
#######################################################################
def viewEditEmployees():#main menu
    #resetValues()
    display.clear_output()
    viewEmployeesButton = widgets.Button(description="View All Employees")
    editEmployeesButton = widgets.Button(description="Edit an Employee")
    searchEmployeesButton = widgets.Button(description="Search for Employees")
    addRolesButton = widgets.Button(description="Add Roles")
    editRolesButton = widgets.Button(description="Edit Roles")
    viewEmpAuditButton = widgets.Button(description="View Employees Audit Table")
    viewEmpRoleAuditButton = widgets.Button(description="View EmployeeRole Audit Table")
    viewRoleAuditButton = widgets.Button(description="View Role Audit Table")
    signoutButton = widgets.Button(description="Signout")
    display.display(viewEmployeesButton)
    display.display(searchEmployeesButton)
    display.display(editEmployeesButton)
    display.display(addRolesButton)
    display.display(editRolesButton)
    display.display(viewEmpAuditButton)
    display.display(viewEmpRoleAuditButton)
    display.display(viewRoleAuditButton)
    display.display(signoutButton)
    viewEmployeesButton.on_click(viewAllUsersAdmin)
    editEmployeesButton.on_click(editEmployee)
    searchEmployeesButton.on_click(searchforUserAdmin)
    editRolesButton.on_click(editRolesAdmin)
    addRolesButton.on_click(addRolesAdmin)
    viewEmpAuditButton.on_click(viewAuditsE)
    viewEmpRoleAuditButton.on_click(viewAuditsER)
    viewRoleAuditButton.on_click(viewAuditsR)
    signoutButton.on_click(sign_out)
     
#ViewUsers
def viewEmployees():#main menu
    #resetValues()
    display.clear_output()
    viewEmployeesButton = widgets.Button(description="View All Employees")
    searchEmployeesButton = widgets.Button(description="Search for Employees")
    viewRolesButton = widgets.Button(description="View Roles")
    signoutButton = widgets.Button(description="Signout")
     
    display.display(viewEmployeesButton)
    display.display(searchEmployeesButton)
    display.display(viewRolesButton)
    display.display(signoutButton)
     
    viewEmployeesButton.on_click(viewAllUsers)
    viewRolesButton.on_click(viewAllRoles)
    searchEmployeesButton.on_click(searchforUser)
    signoutButton.on_click(sign_out)
     
    
    
    
    
    
#Login Screen---------------------------------
#Login Screen---------------------------------
#Login Screen---------------------------------
loginName = widgets.Textarea(
    value='',
    placeholder='Enter Loginname',
    description='Login Name:',
    disabled=False
)
loginPassword = widgets.Textarea(
    value='',
    placeholder='Enter Password',
    description='Password:',
    disabled=False
)
    
def userLogin(sender):
    reg = Registrar()
    response = reg.openDBConnectionWithBundle("PgBundle.properties")
    managerDropDown.options = reg.getManagerNames(2)
    dropdownRole.options = reg.getRoleNames(2)
    employeeRoleFullName.options = reg.getEmployeeNames()
    #print (response)
    success = reg.getLoginInfo(loginName.value,loginPassword.value)
    reg.closeConnection();
    if(success == 0): #admin
        viewEditEmployees()
    elif(success == 1): #not an admin
        viewEmployees()
    else:
        print("Invalid Login information Check sql script!")
        
    
def login_():
    loginbutton = widgets.Button(description="Login")
    employeeRoleStartDate.value = today
    dropdownRole.observe(on_change)    
    employeeRoleFullName.observe(on_changeE)
    display.display(loginName)
    display.display(loginPassword)
    display.display(loginbutton) 
    loginbutton.on_click(userLogin)
    
    

    
    
    


#ACTING MAIN FUNCTION--------------
#----------------------------------   

def begin_DOA():
    login_()
    #print (response)
    #search_Employee()
    #want_to_edit_button()
    #show_Employee_With_Role()
    #add_edit_Role()
    #show_Roles()
    
    
    

