DROP TRIGGER TrEmployeeRoles ON EmployeeRoles;
DROP TRIGGER TrEmployees ON Employees;
DROP TRIGGER TrRoles ON Roles;
DROP TABLE AuditEmployees;
DROP TABLE AuditEmployeeRoles;
DROP TABLE AuditRoles;
DROP VIEW EmployeeRolesView;
DROP VIEW EmployeewithRole;
DROP TABLE EmployeeRoles;
DROP TABLE Roles;
DROP TABLE Employees;
DROP TABLE Managers;

CREATE TABLE Managers
(
	ManagerID SERIAL PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50),
	FullName VARCHAR(50) NOT NULL UNIQUE,
	EmailAddress VARCHAR(100) NOT NULL UNIQUE,
	DateAdded DATE DEFAULT NOW(),
	ModificationDate DATE DEFAULT NOW()
	
);

Insert into Managers (FirstName,LastName,EmailAddress, FullName) values 
('Patrick','Nwanah','Godmode@gmail.com', 'Patrick Nwanah');
Insert into Managers (FirstName,LastName,EmailAddress, FullName) values 
('James','Butt','jbutt@gmail.com', 'James Butt');
Insert into Managers (FirstName,LastName,EmailAddress, FullName) values 
('Josephine','Darakjy','josephine_darakjy@darakjy.org', 
'Josephine Darakjy');



CREATE TABLE Employees
	(
		EmployeeID SERIAL PRIMARY KEY, 
		FirstName VARCHAR(50) NOT NULL,
		LastName VARCHAR(50),
		ManagerID INTEGER,
		isEmployeed INTEGER,
		LoginName VARCHAR(50) NOT NULL UNIQUE,
		LoginPassword VARCHAR(50),
		EmailAddress VARCHAR(100) NOT NULL UNIQUE,
		DateAdded DATE DEFAULT NOW(),
		ModificationDate DATE DEFAULT NOW(),
		FOREIGN KEY (ManagerID) REFERENCES Managers(ManagerID)
	);

CREATE TABLE AuditEmployees
(
	Oper varchar(1),
	ModificationUser text,
	DateAdded timestamp,
	EmployeeID SERIAL, 
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	ManagerID INTEGER,
	isEmployeed INTEGER,
	LoginName VARCHAR(50),
	LoginPassword VARCHAR(50),
	EmailAddress VARCHAR(100),
	EmpDateAdded DATE DEFAULT NOW(),
	ModificationDate DATE DEFAULT NOW()
);


CREATE OR REPLACE FUNCTION process_employee_audit() RETURNS TRIGGER AS $TrEmployees$
    BEGIN
        
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO AuditEmployees SELECT 'D', user, now(), OLD.*;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO AuditEmployees SELECT 'U', user, now(), NEW.*;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO AuditEmployees SELECT 'I', user, now(), NEW.*;
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$TrEmployees$ LANGUAGE plpgsql;


CREATE TRIGGER TrEmployees
AFTER INSERT OR UPDATE OR DELETE ON Employees
FOR EACH ROW EXECUTE PROCEDURE process_employee_audit();


CREATE TABLE Roles
	(
		RoleID SERIAL PRIMARY KEY,
		RoleName VARCHAR(100) NOT NULL UNIQUE,
		EngineOilSpendingAmount INTEGER NOT NULL DEFAULT 0,
		EngineOilBuyingAmount INTEGER NOT NULL DEFAULT 0, 
		CrudeOilSpendingAmount INTEGER NOT NULL DEFAULT 0,
		CrudeOilBuyingAmount INTEGER NOT NULL DEFAULT 0,
		MotorOilSpendingAmount INTEGER NOT NULL DEFAULT 0,
		MotorOilBuyingAmount INTEGER NOT NULL DEFAULT 0,
		GasolineBuyingAmount INTEGER NOT NULL DEFAULT 0,
		GasolineSpendingAmount INTEGER NOT NULL DEFAULT 0,
		PetroleumSpendingAmount INTEGER NOT NULL DEFAULT 0,
		PetroleumBuyingAmount INTEGER NOT NULL DEFAULT 0,
		InternalSpendingBudget INTEGER NOT NULL DEFAULT 0,
		DateAdded DATE DEFAULT NOW(),
		ModificationDate DATE DEFAULT NOW()
	);
	
	
CREATE TABLE AuditRoles
(
	Oper varchar(1),
	ModificationUser text,
	DateAdded timestamp,
	RoleID INTEGER,
	RoleName VARCHAR(100),
	EngineOilSpendingAmount INTEGER,
	EngineOilBuyingAmount INTEGER, 
	CrudeOilSpendingAmount INTEGER,
	CrudeOilBuyingAmount INTEGER,
	MotorOilSpendingAmount INTEGER,
	MotorOilBuyingAmount INTEGER,
	GasolineBuyingAmount INTEGER,
	GasolineSpendingAmount INTEGER,
	PetroleumSpendingAmount INTEGER,
	PetroleumBuyingAmount INTEGER,
	InternalSpendingBudget INTEGER,
	RoleDateAdded DATE,
	ModificationDate DATE
	
);


CREATE OR REPLACE FUNCTION process_role_audit() RETURNS TRIGGER AS $TrRoles$
    BEGIN
        
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO AuditRoles SELECT 'D', user, now(), OLD.*;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO AuditRoles SELECT 'U', user, now(), NEW.*;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO AuditRoles SELECT 'I', user, now(), NEW.*;
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$TrRoles$ LANGUAGE plpgsql;


CREATE TRIGGER TrRoles
AFTER INSERT OR UPDATE OR DELETE ON Roles
FOR EACH ROW EXECUTE PROCEDURE process_role_audit();



CREATE TABLE EmployeeRoles
(
	EmployeeRoleID SERIAL PRIMARY KEY,
	EmployeeID INTEGER,
	RoleID INTEGER,
	StartDate DATE DEFAULT NOW(),
	EndDate DATE,
	DateAdded DATE DEFAULT NOW(),
	ModificationDate DATE DEFAULT NOW(),
	FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
	FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);




CREATE TABLE AuditEmployeeRoles
(
	Oper varchar(1),
	ModificationUser text,
	DateAdded timestamp,
	EmployeeRoleID INTEGER,
	EmployeeID INTEGER,
	RoleID INTEGER,
	StartDate DATE DEFAULT NOW(),
	EndDate DATE,
	EmpDateAdded DATE DEFAULT NOW(),
	ModificationDate DATE DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION process_epr_audit() RETURNS TRIGGER AS $TrEmployeeRoles$
    BEGIN
        
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO AuditEmployeeRoles SELECT 'D', user, now(), OLD.*;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO AuditEmployeeRoles SELECT 'U', user, now(), NEW.*;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO AuditEmployeeRoles SELECT 'I', user, now(), NEW.*;
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$TrEmployeeRoles$ LANGUAGE plpgsql;


CREATE TRIGGER TrEmployeeRoles
AFTER INSERT OR UPDATE OR DELETE ON EmployeeRoles
FOR EACH ROW EXECUTE PROCEDURE process_epr_audit();




CREATE VIEW EmployeewithRole
AS
SELECT
	E.EmployeeID,
	E.FirstName,
	E.LastName,
	CONCAT(E.FirstName, ' ' , E.LastName) AS FULLNAME,
	E.EmailAddress,
	E.LoginName,
	E.isEmployeed,
	E.ManagerID,
	(SELECT FullName FROM Managers where ManagerID = E.ManagerID) AS ManagerName,
	R.RoleID,
	R.RoleName,
	R.CrudeOilBuyingAmount,
	R.CrudeOilSpendingAmount,
	R.EngineOilBuyingAmount,
	R.EngineOilSpendingAmount,
	R.GasolineBuyingAmount,
	R.GasolineSpendingAmount,
	R.InternalSpendingBudget,
	R.MotorOilBuyingAmount,
	R.MotorOilSpendingAmount,
	R.PetroleumBuyingAmount,
	R.PetroleumSpendingAmount,
	E.DateAdded EmployeeDateAdded,
	ER.DateAdded EmployeeRoleAdded
FROM  Employees E
JOIN EmployeeRoles ER ON E.EmployeeID = ER.EmployeeID
JOIN Roles R ON ER.RoleID = R.RoleID
WHERE E.isEmployeed = 0;



CREATE VIEW EmployeeRolesView
AS
SELECT
	E.EmployeeID,
	E.FirstName,
	E.LastName,
	CONCAT(E.FirstName, ' ' , E.LastName) AS FULLNAME,
	E.isEmployeed,
	E.ManagerID,
	(SELECT FullName FROM Managers where ManagerID = E.ManagerID) AS ManagerName,
	R.RoleName,
	ER.StartDate StartDate,
	ER.EndDate EndDate
FROM  Employees E
JOIN EmployeeRoles ER ON E.EmployeeID = ER.EmployeeID
JOIN Roles R ON ER.RoleID = R.RoleID;








Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Patrick','Nwanah','Godmode@gmail.com',0,'PatrickNwanah','PatrickNwanah10');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('James','Butt','jbutt@gmail.com',0,'JamesButt','JamesButt21');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Josephine','Darakjy','josephine_darakjy@darakjy.org',0,'JosephineDarakjy','JosephineDarakjy32');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Art','Venere','art@venere.org',0,'ArtVenere','ArtVenere43');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lenna','Paprocki','lpaprocki@hotmail.com',0,'LennaPaprocki','LennaPaprocki54');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Donette','Foller','donette.foller@cox.net',0,'DonetteFoller','DonetteFoller65');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Simona','Morasca','simona@morasca.com',0,'SimonaMorasca','SimonaMorasca76');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mitsue','Tollner','mitsue_tollner@yahoo.com',0,'MitsueTollner','MitsueTollner87');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Leota','Dilliard','leota@hotmail.com',0,'LeotaDilliard','LeotaDilliard98');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sage','Wieser','sage_wieser@cox.net',0,'SageWieser','SageWieser109');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kris','Marrier','kris@gmail.com',0,'KrisMarrier','KrisMarrier1110');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Minna','Amigon','minna_amigon@yahoo.com',0,'MinnaAmigon','MinnaAmigon1211');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Abel','Maclead','amaclead@gmail.com',0,'AbelMaclead','AbelMaclead1312');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kiley','Caldarera','kiley.caldarera@aol.com',0,'KileyCaldarera','KileyCaldarera1413');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Graciela','Ruta','gruta@cox.net',0,'GracielaRuta','GracielaRuta1514');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cammy','Albares','calbares@gmail.com',0,'CammyAlbares','CammyAlbares1615');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mattie','Poquette','mattie@aol.com',0,'MattiePoquette','MattiePoquette1716');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Meaghan','Garufi','meaghan@hotmail.com',0,'MeaghanGarufi','MeaghanGarufi1817');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gladys','Rim','gladys.rim@rim.org',0,'GladysRim','GladysRim1918');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Yuki','Whobrey','yuki_whobrey@aol.com',0,'YukiWhobrey','YukiWhobrey2019');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Fletcher','Flosi','fletcher.flosi@yahoo.com',0,'FletcherFlosi','FletcherFlosi2120');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Bette','Nicka','bette_nicka@cox.net',0,'BetteNicka','BetteNicka2221');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Veronika','Inouye','vinouye@aol.com',0,'VeronikaInouye','VeronikaInouye2322');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Willard','Kolmetz','willard@hotmail.com',0,'WillardKolmetz','WillardKolmetz2423');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Maryann','Royster','mroyster@royster.com',0,'MaryannRoyster','MaryannRoyster2524');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alisha','Slusarski','alisha@slusarski.com',0,'AlishaSlusarski','AlishaSlusarski2625');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Allene','Iturbide','allene_iturbide@cox.net',0,'AlleneIturbide','AlleneIturbide2726');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Chanel','Caudy','chanel.caudy@caudy.org',0,'ChanelCaudy','ChanelCaudy2827');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ezekiel','Chui','ezekiel@chui.com',0,'EzekielChui','EzekielChui2928');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Willow','Kusko','wkusko@yahoo.com',0,'WillowKusko','WillowKusko3029');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Bernardo','Figeroa','bfigeroa@aol.com',0,'BernardoFigeroa','BernardoFigeroa3130');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ammie','Corrio','ammie@corrio.com',0,'AmmieCorrio','AmmieCorrio3231');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Francine','Vocelka','francine_vocelka@vocelka.com',0,'FrancineVocelka','FrancineVocelka3332');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ernie','Stenseth','ernie_stenseth@aol.com',0,'ErnieStenseth','ErnieStenseth3433');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Albina','Glick','albina@glick.com',0,'AlbinaGlick','AlbinaGlick3534');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alishia','Sergi','asergi@gmail.com',0,'AlishiaSergi','AlishiaSergi3635');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Solange','Shinko','solange@shinko.com',0,'SolangeShinko','SolangeShinko3736');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jose','Stockham','jose@yahoo.com',0,'JoseStockham','JoseStockham3837');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rozella','Ostrosky','rozella.ostrosky@ostrosky.com',0,'RozellaOstrosky','RozellaOstrosky3938');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Valentine','Gillian','valentine_gillian@gmail.com',0,'ValentineGillian','ValentineGillian4039');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kati','Rulapaugh','kati.rulapaugh@hotmail.com',0,'KatiRulapaugh','KatiRulapaugh4140');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Youlanda','Schemmer','youlanda@aol.com',0,'YoulandaSchemmer','YoulandaSchemmer4241');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dyan','Oldroyd','doldroyd@aol.com',0,'DyanOldroyd','DyanOldroyd4342');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Roxane','Campain','roxane@hotmail.com',0,'RoxaneCampain','RoxaneCampain4443');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lavera','Perin','lperin@perin.org',0,'LaveraPerin','LaveraPerin4544');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Erick','Ferencz','erick.ferencz@aol.com',0,'ErickFerencz','ErickFerencz4645');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Fatima','Saylors','fsaylors@saylors.org',0,'FatimaSaylors','FatimaSaylors4746');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jina','Briddick','jina_briddick@briddick.com',0,'JinaBriddick','JinaBriddick4847');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kanisha','Waycott','kanisha_waycott@yahoo.com',0,'KanishaWaycott','KanishaWaycott4948');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Emerson','Bowley','emerson.bowley@bowley.org',0,'EmersonBowley','EmersonBowley5049');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Blair','Malet','bmalet@yahoo.com',0,'BlairMalet','BlairMalet5150');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Brock','Bolognia','bbolognia@yahoo.com',0,'BrockBolognia','BrockBolognia5251');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lorrie','Nestle','lnestle@hotmail.com',0,'LorrieNestle','LorrieNestle5352');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sabra','Uyetake','sabra@uyetake.org',0,'SabraUyetake','SabraUyetake5453');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Marjory','Mastella','mmastella@mastella.com',0,'MarjoryMastella','MarjoryMastella5554');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Karl','Klonowski','karl_klonowski@yahoo.com',0,'KarlKlonowski','KarlKlonowski5655');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tonette','Wenner','twenner@aol.com',0,'TonetteWenner','TonetteWenner5756');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Amber','Monarrez','amber_monarrez@monarrez.org',0,'AmberMonarrez','AmberMonarrez5857');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Shenika','Seewald','shenika@gmail.com',0,'ShenikaSeewald','ShenikaSeewald5958');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Delmy','Ahle','delmy.ahle@hotmail.com',0,'DelmyAhle','DelmyAhle6059');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Deeanna','Juhas','deeanna_juhas@gmail.com',0,'DeeannaJuhas','DeeannaJuhas6160');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Blondell','Pugh','bpugh@aol.com',0,'BlondellPugh','BlondellPugh6261');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jamal','Vanausdal','jamal@vanausdal.org',0,'JamalVanausdal','JamalVanausdal6362');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cecily','Hollack','cecily@hollack.org',0,'CecilyHollack','CecilyHollack6463');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Carmelina','Lindall','carmelina_lindall@lindall.com',0,'CarmelinaLindall','CarmelinaLindall6564');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Maurine','Yglesias','maurine_yglesias@yglesias.com',0,'MaurineYglesias','MaurineYglesias6665');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tawna','Buvens','tawna@gmail.com',0,'TawnaBuvens','TawnaBuvens6766');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Penney','Weight','penney_weight@aol.com',0,'PenneyWeight','PenneyWeight6867');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Elly','Morocco','elly_morocco@gmail.com',0,'EllyMorocco','EllyMorocco6968');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ilene','Eroman','ilene.eroman@hotmail.com',0,'IleneEroman','IleneEroman7069');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Vallie','Mondella','vmondella@mondella.com',0,'VallieMondella','VallieMondella7170');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kallie','Blackwood','kallie.blackwood@gmail.com',0,'KallieBlackwood','KallieBlackwood7271');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Johnetta','Abdallah','johnetta_abdallah@aol.com',0,'JohnettaAbdallah','JohnettaAbdallah7372');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Bobbye','Rhym','brhym@rhym.com',0,'BobbyeRhym','BobbyeRhym7473');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Micaela','Rhymes','micaela_rhymes@gmail.com',0,'MicaelaRhymes','MicaelaRhymes7574');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tamar','Hoogland','tamar@hotmail.com',0,'TamarHoogland','TamarHoogland7675');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Moon','Parlato','moon@yahoo.com',0,'MoonParlato','MoonParlato7776');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Laurel','Reitler','laurel_reitler@reitler.com',0,'LaurelReitler','LaurelReitler7877');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Delisa','Crupi','delisa.crupi@crupi.com',0,'DelisaCrupi','DelisaCrupi7978');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Viva','Toelkes','viva.toelkes@gmail.com',0,'VivaToelkes','VivaToelkes8079');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Elza','Lipke','elza@yahoo.com',0,'ElzaLipke','ElzaLipke8180');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Devorah','Chickering','devorah@hotmail.com',0,'DevorahChickering','DevorahChickering8281');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Timothy','Mulqueen','timothy_mulqueen@mulqueen.org',0,'TimothyMulqueen','TimothyMulqueen8382');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Arlette','Honeywell','ahoneywell@honeywell.com',0,'ArletteHoneywell','ArletteHoneywell8483');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dominque','Dickerson','dominque.dickerson@dickerson.org',0,'DominqueDickerson','DominqueDickerson8584');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lettie','Isenhower','lettie_isenhower@yahoo.com',0,'LettieIsenhower','LettieIsenhower8685');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Myra','Munns','mmunns@cox.net',0,'MyraMunns','MyraMunns8786');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Stephaine','Barfield','stephaine@barfield.com',0,'StephaineBarfield','StephaineBarfield8887');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lai','Gato','lai.gato@gato.org',0,'LaiGato','LaiGato8988');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Stephen','Emigh','stephen_emigh@hotmail.com',0,'StephenEmigh','StephenEmigh9089');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tyra','Shields','tshields@gmail.com',0,'TyraShields','TyraShields9190');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tammara','Wardrip','twardrip@cox.net',0,'TammaraWardrip','TammaraWardrip9291');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cory','Gibes','cory.gibes@gmail.com',0,'CoryGibes','CoryGibes9392');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Danica','Bruschke','danica_bruschke@gmail.com',0,'DanicaBruschke','DanicaBruschke9493');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Wilda','Giguere','wilda@cox.net',0,'WildaGiguere','WildaGiguere9594');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Elvera','Benimadho','elvera.benimadho@cox.net',0,'ElveraBenimadho','ElveraBenimadho9695');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Carma','Vanheusen','carma@cox.net',0,'CarmaVanheusen','CarmaVanheusen9796');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Malinda','Hochard','malinda.hochard@yahoo.com',0,'MalindaHochard','MalindaHochard9897');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Natalie','Fern','natalie.fern@hotmail.com',0,'NatalieFern','NatalieFern9998');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lisha','Centini','lisha@centini.org',0,'LishaCentini','LishaCentini10099');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Arlene','Klusman','arlene_klusman@gmail.com',0,'ArleneKlusman','ArleneKlusman101100');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alease','Buemi','alease@buemi.com',0,'AleaseBuemi','AleaseBuemi102101');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Louisa','Cronauer','louisa@cronauer.com',0,'LouisaCronauer','LouisaCronauer103102');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Angella','Cetta','angella.cetta@hotmail.com',0,'AngellaCetta','AngellaCetta104103');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cyndy','Goldammer','cgoldammer@cox.net',0,'CyndyGoldammer','CyndyGoldammer105104');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rosio','Cork','rosio.cork@gmail.com',0,'RosioCork','RosioCork106105');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Celeste','Korando','ckorando@hotmail.com',0,'CelesteKorando','CelesteKorando107106');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Twana','Felger','twana.felger@felger.org',0,'TwanaFelger','TwanaFelger108107');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Estrella','Samu','estrella@aol.com',0,'EstrellaSamu','EstrellaSamu109108');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Donte','Kines','dkines@hotmail.com',0,'DonteKines','DonteKines110109');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tiffiny','Steffensmeier','tiffiny_steffensmeier@cox.net',0,'TiffinySteffensmeier','TiffinySteffensmeier111110');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Edna','Miceli','emiceli@miceli.org',0,'EdnaMiceli','EdnaMiceli112111');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sue','Kownacki','sue@aol.com',0,'SueKownacki','SueKownacki113112');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jesusa','Shin','jshin@shin.com',0,'JesusaShin','JesusaShin114113');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rolland','Francescon','rolland@cox.net',0,'RollandFrancescon','RollandFrancescon115114');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Pamella','Schmierer','pamella.schmierer@schmierer.org',0,'PamellaSchmierer','PamellaSchmierer116115');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Glory','Kulzer','gkulzer@kulzer.org',0,'GloryKulzer','GloryKulzer117116');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Shawna','Palaspas','shawna_palaspas@palaspas.org',0,'ShawnaPalaspas','ShawnaPalaspas118117');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Brandon','Callaro','brandon_callaro@hotmail.com',0,'BrandonCallaro','BrandonCallaro119118');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Scarlet','Cartan','scarlet.cartan@yahoo.com',0,'ScarletCartan','ScarletCartan120119');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Oretha','Menter','oretha_menter@yahoo.com',0,'OrethaMenter','OrethaMenter121120');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ty','Smith','tsmith@aol.com',0,'TySmith','TySmith122121');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Xuan','Rochin','xuan@gmail.com',0,'XuanRochin','XuanRochin123122');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lindsey','Dilello','lindsey.dilello@hotmail.com',0,'LindseyDilello','LindseyDilello124123');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Devora','Perez','devora_perez@perez.org',0,'DevoraPerez','DevoraPerez125124');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Herman','Demesa','hdemesa@cox.net',0,'HermanDemesa','HermanDemesa126125');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rory','Papasergi','rpapasergi@cox.net',0,'RoryPapasergi','RoryPapasergi127126');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Talia','Riopelle','talia_riopelle@aol.com',0,'TaliaRiopelle','TaliaRiopelle128127');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Van','Shire','van.shire@shire.com',0,'VanShire','VanShire129128');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lucina','Lary','lucina_lary@cox.net',0,'LucinaLary','LucinaLary130129');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Bok','Isaacs','bok.isaacs@aol.com',0,'BokIsaacs','BokIsaacs131130');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rolande','Spickerman','rolande.spickerman@spickerman.com',0,'RolandeSpickerman','RolandeSpickerman132131');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Howard','Paulas','hpaulas@gmail.com',0,'HowardPaulas','HowardPaulas133132');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kimbery','Madarang','kimbery_madarang@cox.net',0,'KimberyMadarang','KimberyMadarang134133');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Thurman','Manno','thurman.manno@yahoo.com',0,'ThurmanManno','ThurmanManno135134');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Becky','Mirafuentes','becky.mirafuentes@mirafuentes.com',0,'BeckyMirafuentes','BeckyMirafuentes136135');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Beatriz','Corrington','beatriz@yahoo.com',0,'BeatrizCorrington','BeatrizCorrington137136');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Marti','Maybury','marti.maybury@yahoo.com',0,'MartiMaybury','MartiMaybury138137');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Nieves','Gotter','nieves_gotter@gmail.com',0,'NievesGotter','NievesGotter139138');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Leatha','Hagele','lhagele@cox.net',0,'LeathaHagele','LeathaHagele140139');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Valentin','Klimek','vklimek@klimek.org',0,'ValentinKlimek','ValentinKlimek141140');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Melissa','Wiklund','melissa@cox.net',0,'MelissaWiklund','MelissaWiklund142141');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sheridan','Zane','sheridan.zane@zane.com',0,'SheridanZane','SheridanZane143142');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Bulah','Padilla','bulah_padilla@hotmail.com',0,'BulahPadilla','BulahPadilla144143');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Audra','Kohnert','audra@kohnert.com',0,'AudraKohnert','AudraKohnert145144');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Daren','Weirather','dweirather@aol.com',0,'DarenWeirather','DarenWeirather146145');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Fernanda','Jillson','fjillson@aol.com',0,'FernandaJillson','FernandaJillson147146');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gearldine','Gellinger','gearldine_gellinger@gellinger.com',0,'GearldineGellinger','GearldineGellinger148147');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Chau','Kitzman','chau@gmail.com',0,'ChauKitzman','ChauKitzman149148');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Theola','Frey','theola_frey@frey.com',0,'TheolaFrey','TheolaFrey150149');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cheryl','Haroldson','cheryl@haroldson.org',0,'CherylHaroldson','CherylHaroldson151150');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Laticia','Merced','lmerced@gmail.com',0,'LaticiaMerced','LaticiaMerced152151');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Carissa','Batman','carissa.batman@yahoo.com',0,'CarissaBatman','CarissaBatman153152');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lezlie','Craghead','lezlie.craghead@craghead.org',0,'LezlieCraghead','LezlieCraghead154153');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ozell','Shealy','oshealy@hotmail.com',0,'OzellShealy','OzellShealy155154');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Arminda','Parvis','arminda@parvis.com',0,'ArmindaParvis','ArmindaParvis156155');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Reita','Leto','reita.leto@gmail.com',0,'ReitaLeto','ReitaLeto157156');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Yolando','Luczki','yolando@cox.net',0,'YolandoLuczki','YolandoLuczki158157');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lizette','Stem','lizette.stem@aol.com',0,'LizetteStem','LizetteStem159158');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gregoria','Pawlowicz','gpawlowicz@yahoo.com',0,'GregoriaPawlowicz','GregoriaPawlowicz160159');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Carin','Deleo','cdeleo@deleo.com',0,'CarinDeleo','CarinDeleo161160');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Chantell','Maynerich','chantell@yahoo.com',0,'ChantellMaynerich','ChantellMaynerich162161');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dierdre','Yum','dyum@yahoo.com',0,'DierdreYum','DierdreYum163162');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Larae','Gudroe','larae_gudroe@gmail.com',0,'LaraeGudroe','LaraeGudroe164163');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Latrice','Tolfree','latrice.tolfree@hotmail.com',0,'LatriceTolfree','LatriceTolfree165164');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kerry','Theodorov','kerry.theodorov@gmail.com',0,'KerryTheodorov','KerryTheodorov166165');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dorthy','Hidvegi','dhidvegi@yahoo.com',0,'DorthyHidvegi','DorthyHidvegi167166');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Fannie','Lungren','fannie.lungren@yahoo.com',0,'FannieLungren','FannieLungren168167');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Evangelina','Radde','evangelina@aol.com',0,'EvangelinaRadde','EvangelinaRadde169168');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Novella','Degroot','novella_degroot@degroot.org',0,'NovellaDegroot','NovellaDegroot170169');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Clay','Hoa','choa@hoa.org',0,'ClayHoa','ClayHoa171170');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jennifer','Fallick','jfallick@yahoo.com',0,'JenniferFallick','JenniferFallick172171');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Irma','Wolfgramm','irma.wolfgramm@hotmail.com',0,'IrmaWolfgramm','IrmaWolfgramm173172');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Eun','Coody','eun@yahoo.com',0,'EunCoody','EunCoody174173');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sylvia','Cousey','sylvia_cousey@cousey.org',0,'SylviaCousey','SylviaCousey175174');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Nana','Wrinkles','nana@aol.com',0,'NanaWrinkles','NanaWrinkles176175');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Layla','Springe','layla.springe@cox.net',0,'LaylaSpringe','LaylaSpringe177176');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Joesph','Degonia','joesph_degonia@degonia.org',0,'JoesphDegonia','JoesphDegonia178177');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Annabelle','Boord','annabelle.boord@cox.net',0,'AnnabelleBoord','AnnabelleBoord179178');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Stephaine','Vinning','stephaine@cox.net',0,'StephaineVinning','StephaineVinning180179');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Nelida','Sawchuk','nelida@gmail.com',0,'NelidaSawchuk','NelidaSawchuk181180');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Marguerita','Hiatt','marguerita.hiatt@gmail.com',0,'MargueritaHiatt','MargueritaHiatt182181');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Carmela','Cookey','ccookey@cookey.org',0,'CarmelaCookey','CarmelaCookey183182');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Junita','Brideau','jbrideau@aol.com',0,'JunitaBrideau','JunitaBrideau184183');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Claribel','Varriano','claribel_varriano@cox.net',0,'ClaribelVarriano','ClaribelVarriano185184');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Benton','Skursky','benton.skursky@aol.com',0,'BentonSkursky','BentonSkursky186185');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Hillary','Skulski','hillary.skulski@aol.com',0,'HillarySkulski','HillarySkulski187186');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Merilyn','Bayless','merilyn_bayless@cox.net',0,'MerilynBayless','MerilynBayless188187');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Teri','Ennaco','tennaco@gmail.com',0,'TeriEnnaco','TeriEnnaco189188');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Merlyn','Lawler','merlyn_lawler@hotmail.com',0,'MerlynLawler','MerlynLawler190189');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Georgene','Montezuma','gmontezuma@cox.net',0,'GeorgeneMontezuma','GeorgeneMontezuma191190');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jettie','Mconnell','jmconnell@hotmail.com',0,'JettieMconnell','JettieMconnell192191');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lemuel','Latzke','lemuel.latzke@gmail.com',0,'LemuelLatzke','LemuelLatzke193192');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Melodie','Knipp','mknipp@gmail.com',0,'MelodieKnipp','MelodieKnipp194193');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Candida','Corbley','candida_corbley@hotmail.com',0,'CandidaCorbley','CandidaCorbley195194');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Karan','Karpin','karan_karpin@gmail.com',0,'KaranKarpin','KaranKarpin196195');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Andra','Scheyer','andra@gmail.com',0,'AndraScheyer','AndraScheyer197196');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Felicidad','Poullion','fpoullion@poullion.com',0,'FelicidadPoullion','FelicidadPoullion198197');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Belen','Strassner','belen_strassner@aol.com',0,'BelenStrassner','BelenStrassner199198');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gracia','Melnyk','gracia@melnyk.com',0,'GraciaMelnyk','GraciaMelnyk200199');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jolanda','Hanafan','jhanafan@gmail.com',0,'JolandaHanafan','JolandaHanafan201200');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Barrett','Toyama','barrett.toyama@toyama.org',0,'BarrettToyama','BarrettToyama202201');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Helga','Fredicks','helga_fredicks@yahoo.com',0,'HelgaFredicks','HelgaFredicks203202');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ashlyn','Pinilla','apinilla@cox.net',0,'AshlynPinilla','AshlynPinilla204203');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Fausto','Agramonte','fausto_agramonte@yahoo.com',0,'FaustoAgramonte','FaustoAgramonte205204');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ronny','Caiafa','ronny.caiafa@caiafa.org',0,'RonnyCaiafa','RonnyCaiafa206205');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Marge','Limmel','marge@gmail.com',0,'MargeLimmel','MargeLimmel207206');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Norah','Waymire','norah.waymire@gmail.com',0,'NorahWaymire','NorahWaymire208207');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Aliza','Baltimore','aliza@aol.com',0,'AlizaBaltimore','AlizaBaltimore209208');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mozell','Pelkowski','mpelkowski@pelkowski.org',0,'MozellPelkowski','MozellPelkowski210209');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Viola','Bitsuie','viola@gmail.com',0,'ViolaBitsuie','ViolaBitsuie211210');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Franklyn','Emard','femard@emard.com',0,'FranklynEmard','FranklynEmard212211');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Willodean','Konopacki','willodean_konopacki@konopacki.org',0,'WillodeanKonopacki','WillodeanKonopacki213212');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Beckie','Silvestrini','beckie.silvestrini@silvestrini.com',0,'BeckieSilvestrini','BeckieSilvestrini214213');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rebecka','Gesick','rgesick@gesick.org',0,'RebeckaGesick','RebeckaGesick215214');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Frederica','Blunk','frederica_blunk@gmail.com',0,'FredericaBlunk','FredericaBlunk216215');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Glen','Bartolet','glen_bartolet@hotmail.com',0,'GlenBartolet','GlenBartolet217216');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Freeman','Gochal','freeman_gochal@aol.com',0,'FreemanGochal','FreemanGochal218217');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Vincent','Meinerding','vincent.meinerding@hotmail.com',0,'VincentMeinerding','VincentMeinerding219218');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rima','Bevelacqua','rima@cox.net',0,'RimaBevelacqua','RimaBevelacqua220219');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Glendora','Sarbacher','gsarbacher@gmail.com',0,'GlendoraSarbacher','GlendoraSarbacher221220');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Avery','Steier','avery@cox.net',0,'AverySteier','AverySteier222221');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cristy','Lother','cristy@lother.com',0,'CristyLother','CristyLother223222');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Nicolette','Brossart','nicolette_brossart@brossart.com',0,'NicoletteBrossart','NicoletteBrossart224223');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tracey','Modzelewski','tracey@hotmail.com',0,'TraceyModzelewski','TraceyModzelewski225224');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Virgina','Tegarden','virgina_tegarden@tegarden.com',0,'VirginaTegarden','VirginaTegarden226225');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tiera','Frankel','tfrankel@aol.com',0,'TieraFrankel','TieraFrankel227226');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alaine','Bergesen','alaine_bergesen@cox.net',0,'AlaineBergesen','AlaineBergesen228227');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Earleen','Mai','earleen_mai@cox.net',0,'EarleenMai','EarleenMai229228');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Leonida','Gobern','leonida@gobern.org',0,'LeonidaGobern','LeonidaGobern230229');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ressie','Auffrey','ressie.auffrey@yahoo.com',0,'RessieAuffrey','RessieAuffrey231230');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Justine','Mugnolo','jmugnolo@yahoo.com',0,'JustineMugnolo','JustineMugnolo232231');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Eladia','Saulter','eladia@saulter.com',0,'EladiaSaulter','EladiaSaulter233232');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Chaya','Malvin','chaya@malvin.com',0,'ChayaMalvin','ChayaMalvin234233');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gwenn','Suffield','gwenn_suffield@suffield.org',0,'GwennSuffield','GwennSuffield235234');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Salena','Karpel','skarpel@cox.net',0,'SalenaKarpel','SalenaKarpel236235');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Yoko','Fishburne','yoko@fishburne.com',0,'YokoFishburne','YokoFishburne237236');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Taryn','Moyd','taryn.moyd@hotmail.com',0,'TarynMoyd','TarynMoyd238237');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Katina','Polidori','katina_polidori@aol.com',0,'KatinaPolidori','KatinaPolidori239238');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rickie','Plumer','rickie.plumer@aol.com',0,'RickiePlumer','RickiePlumer240239');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alex','Loader','alex@loader.com',0,'AlexLoader','AlexLoader241240');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lashon','Vizarro','lashon@aol.com',0,'LashonVizarro','LashonVizarro242241');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lauran','Burnard','lburnard@burnard.com',0,'LauranBurnard','LauranBurnard243242');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ceola','Setter','ceola.setter@setter.org',0,'CeolaSetter','CeolaSetter244243');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('My','Rantanen','my@hotmail.com',0,'MyRantanen','MyRantanen245244');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lorrine','Worlds','lorrine.worlds@worlds.com',0,'LorrineWorlds','LorrineWorlds246245');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Peggie','Sturiale','peggie@cox.net',0,'PeggieSturiale','PeggieSturiale247246');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Marvel','Raymo','mraymo@yahoo.com',0,'MarvelRaymo','MarvelRaymo248247');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Daron','Dinos','daron_dinos@cox.net',0,'DaronDinos','DaronDinos249248');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('An','Fritz','an_fritz@hotmail.com',0,'AnFritz','AnFritz250249');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Portia','Stimmel','portia.stimmel@aol.com',0,'PortiaStimmel','PortiaStimmel251250');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rhea','Aredondo','rhea_aredondo@cox.net',0,'RheaAredondo','RheaAredondo252251');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Benedict','Sama','bsama@cox.net',0,'BenedictSama','BenedictSama253252');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alyce','Arias','alyce@arias.org',0,'AlyceArias','AlyceArias254253');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Heike','Berganza','heike@gmail.com',0,'HeikeBerganza','HeikeBerganza255254');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Carey','Dopico','carey_dopico@dopico.org',0,'CareyDopico','CareyDopico256255');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dottie','Hellickson','dottie@hellickson.org',0,'DottieHellickson','DottieHellickson257256');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Deandrea','Hughey','deandrea@yahoo.com',0,'DeandreaHughey','DeandreaHughey258257');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kimberlie','Duenas','kimberlie_duenas@yahoo.com',0,'KimberlieDuenas','KimberlieDuenas259258');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Martina','Staback','martina_staback@staback.com',0,'MartinaStaback','MartinaStaback260259');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Skye','Fillingim','skye_fillingim@yahoo.com',0,'SkyeFillingim','SkyeFillingim261260');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jade','Farrar','jade.farrar@yahoo.com',0,'JadeFarrar','JadeFarrar262261');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Charlene','Hamilton','charlene.hamilton@hotmail.com',0,'CharleneHamilton','CharleneHamilton263262');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Geoffrey','Acey','geoffrey@gmail.com',0,'GeoffreyAcey','GeoffreyAcey264263');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Stevie','Westerbeck','stevie.westerbeck@yahoo.com',0,'StevieWesterbeck','StevieWesterbeck265264');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Pamella','Fortino','pamella@fortino.com',0,'PamellaFortino','PamellaFortino266265');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Harrison','Haufler','hhaufler@hotmail.com',0,'HarrisonHaufler','HarrisonHaufler267266');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Johnna','Engelberg','jengelberg@engelberg.org',0,'JohnnaEngelberg','JohnnaEngelberg268267');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Buddy','Cloney','buddy.cloney@yahoo.com',0,'BuddyCloney','BuddyCloney269268');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dalene','Riden','dalene.riden@aol.com',0,'DaleneRiden','DaleneRiden270269');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jerry','Zurcher','jzurcher@zurcher.org',0,'JerryZurcher','JerryZurcher271270');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Haydee','Denooyer','hdenooyer@denooyer.org',0,'HaydeeDenooyer','HaydeeDenooyer272271');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Joseph','Cryer','joseph_cryer@cox.net',0,'JosephCryer','JosephCryer273272');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Deonna','Kippley','deonna_kippley@hotmail.com',0,'DeonnaKippley','DeonnaKippley274273');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Raymon','Calvaresi','raymon.calvaresi@gmail.com',0,'RaymonCalvaresi','RaymonCalvaresi275274');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alecia','Bubash','alecia@aol.com',0,'AleciaBubash','AleciaBubash276275');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ma','Layous','mlayous@hotmail.com',0,'MaLayous','MaLayous277276');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Detra','Coyier','detra@aol.com',0,'DetraCoyier','DetraCoyier278277');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Terrilyn','Rodeigues','terrilyn.rodeigues@cox.net',0,'TerrilynRodeigues','TerrilynRodeigues279278');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Salome','Lacovara','slacovara@gmail.com',0,'SalomeLacovara','SalomeLacovara280279');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Garry','Keetch','garry_keetch@hotmail.com',0,'GarryKeetch','GarryKeetch281280');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Matthew','Neither','mneither@yahoo.com',0,'MatthewNeither','MatthewNeither282281');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Theodora','Restrepo','theodora.restrepo@restrepo.com',0,'TheodoraRestrepo','TheodoraRestrepo283282');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Noah','Kalafatis','noah.kalafatis@aol.com',0,'NoahKalafatis','NoahKalafatis284283');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Carmen','Sweigard','csweigard@sweigard.com',0,'CarmenSweigard','CarmenSweigard285284');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lavonda','Hengel','lavonda@cox.net',0,'LavondaHengel','LavondaHengel286285');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Junita','Stoltzman','junita@aol.com',0,'JunitaStoltzman','JunitaStoltzman287286');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Herminia','Nicolozakes','herminia@nicolozakes.org',0,'HerminiaNicolozakes','HerminiaNicolozakes288287');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Casie','Good','casie.good@aol.com',0,'CasieGood','CasieGood289288');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Reena','Maisto','reena@hotmail.com',0,'ReenaMaisto','ReenaMaisto290289');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mirta','Mallett','mirta_mallett@gmail.com',0,'MirtaMallett','MirtaMallett291290');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cathrine','Pontoriero','cathrine.pontoriero@pontoriero.com',0,'CathrinePontoriero','CathrinePontoriero292291');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Filiberto','Tawil','ftawil@hotmail.com',0,'FilibertoTawil','FilibertoTawil293292');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Raul','Upthegrove','rupthegrove@yahoo.com',0,'RaulUpthegrove','RaulUpthegrove294293');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sarah','Candlish','sarah.candlish@gmail.com',0,'SarahCandlish','SarahCandlish295294');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lucy','Treston','lucy@cox.net',0,'LucyTreston','LucyTreston296295');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Judy','Aquas','jaquas@aquas.com',0,'JudyAquas','JudyAquas297296');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Yvonne','Tjepkema','yvonne.tjepkema@hotmail.com',0,'YvonneTjepkema','YvonneTjepkema298297');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kayleigh','Lace','kayleigh.lace@yahoo.com',0,'KayleighLace','KayleighLace299298');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Felix','Hirpara','felix_hirpara@cox.net',0,'FelixHirpara','FelixHirpara300299');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tresa','Sweely','tresa_sweely@hotmail.com',0,'TresaSweely','TresaSweely301300');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kristeen','Turinetti','kristeen@gmail.com',0,'KristeenTurinetti','KristeenTurinetti302301');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jenelle','Regusters','jregusters@regusters.com',0,'JenelleRegusters','JenelleRegusters303302');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Renea','Monterrubio','renea@hotmail.com',0,'ReneaMonterrubio','ReneaMonterrubio304303');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Olive','Matuszak','olive@aol.com',0,'OliveMatuszak','OliveMatuszak305304');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ligia','Reiber','lreiber@cox.net',0,'LigiaReiber','LigiaReiber306305');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Christiane','Eschberger','christiane.eschberger@yahoo.com',0,'ChristianeEschberger','ChristianeEschberger307306');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Goldie','Schirpke','goldie.schirpke@yahoo.com',0,'GoldieSchirpke','GoldieSchirpke308307');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Loreta','Timenez','loreta.timenez@hotmail.com',0,'LoretaTimenez','LoretaTimenez309308');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Fabiola','Hauenstein','fabiola.hauenstein@hauenstein.org',0,'FabiolaHauenstein','FabiolaHauenstein310309');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Amie','Perigo','amie.perigo@yahoo.com',0,'AmiePerigo','AmiePerigo311310');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Raina','Brachle','raina.brachle@brachle.org',0,'RainaBrachle','RainaBrachle312311');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Erinn','Canlas','erinn.canlas@canlas.com',0,'ErinnCanlas','ErinnCanlas313312');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cherry','Lietz','cherry@lietz.com',0,'CherryLietz','CherryLietz314313');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kattie','Vonasek','kattie@vonasek.org',0,'KattieVonasek','KattieVonasek315314');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lilli','Scriven','lilli@aol.com',0,'LilliScriven','LilliScriven316315');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Whitley','Tomasulo','whitley.tomasulo@aol.com',0,'WhitleyTomasulo','WhitleyTomasulo317316');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Barbra','Adkin','badkin@hotmail.com',0,'BarbraAdkin','BarbraAdkin318317');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Hermila','Thyberg','hermila_thyberg@hotmail.com',0,'HermilaThyberg','HermilaThyberg319318');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jesusita','Flister','jesusita.flister@hotmail.com',0,'JesusitaFlister','JesusitaFlister320319');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Caitlin','Julia','caitlin.julia@julia.org',0,'CaitlinJulia','CaitlinJulia321320');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Roosevelt','Hoffis','roosevelt.hoffis@aol.com',0,'RooseveltHoffis','RooseveltHoffis322321');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Helaine','Halter','hhalter@yahoo.com',0,'HelaineHalter','HelaineHalter323322');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lorean','Martabano','lorean.martabano@hotmail.com',0,'LoreanMartabano','LoreanMartabano324323');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('France','Buzick','france.buzick@yahoo.com',0,'FranceBuzick','FranceBuzick325324');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Justine','Ferrario','jferrario@hotmail.com',0,'JustineFerrario','JustineFerrario326325');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Adelina','Nabours','adelina_nabours@gmail.com',0,'AdelinaNabours','AdelinaNabours327326');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Derick','Dhamer','ddhamer@cox.net',0,'DerickDhamer','DerickDhamer328327');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jerry','Dallen','jerry.dallen@yahoo.com',0,'JerryDallen','JerryDallen329328');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Leota','Ragel','leota.ragel@gmail.com',0,'LeotaRagel','LeotaRagel330329');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jutta','Amyot','jamyot@hotmail.com',0,'JuttaAmyot','JuttaAmyot331330');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Aja','Gehrett','aja_gehrett@hotmail.com',0,'AjaGehrett','AjaGehrett332331');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kirk','Herritt','kirk.herritt@aol.com',0,'KirkHerritt','KirkHerritt333332');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Leonora','Mauson','leonora@yahoo.com',0,'LeonoraMauson','LeonoraMauson334333');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Winfred','Brucato','winfred_brucato@hotmail.com',0,'WinfredBrucato','WinfredBrucato335334');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tarra','Nachor','tarra.nachor@cox.net',0,'TarraNachor','TarraNachor336335');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Corinne','Loder','corinne@loder.org',0,'CorinneLoder','CorinneLoder337336');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dulce','Labreche','dulce_labreche@yahoo.com',0,'DulceLabreche','DulceLabreche338337');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kate','Keneipp','kate_keneipp@yahoo.com',0,'KateKeneipp','KateKeneipp339338');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kaitlyn','Ogg','kaitlyn.ogg@gmail.com',0,'KaitlynOgg','KaitlynOgg340339');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sherita','Saras','sherita.saras@cox.net',0,'SheritaSaras','SheritaSaras341340');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lashawnda','Stuer','lstuer@cox.net',0,'LashawndaStuer','LashawndaStuer342341');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ernest','Syrop','ernest@cox.net',0,'ErnestSyrop','ErnestSyrop343342');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Nobuko','Halsey','nobuko.halsey@yahoo.com',0,'NobukoHalsey','NobukoHalsey344343');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lavonna','Wolny','lavonna.wolny@hotmail.com',0,'LavonnaWolny','LavonnaWolny345344');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lashaunda','Lizama','llizama@cox.net',0,'LashaundaLizama','LashaundaLizama346345');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mariann','Bilden','mariann.bilden@aol.com',0,'MariannBilden','MariannBilden347346');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Helene','Rodenberger','helene@aol.com',0,'HeleneRodenberger','HeleneRodenberger348347');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Roselle','Estell','roselle.estell@hotmail.com',0,'RoselleEstell','RoselleEstell349348');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Samira','Heintzman','sheintzman@hotmail.com',0,'SamiraHeintzman','SamiraHeintzman350349');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Margart','Meisel','margart_meisel@yahoo.com',0,'MargartMeisel','MargartMeisel351350');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kristofer','Bennick','kristofer.bennick@yahoo.com',0,'KristoferBennick','KristoferBennick352351');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Weldon','Acuff','wacuff@gmail.com',0,'WeldonAcuff','WeldonAcuff353352');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Shalon','Shadrick','shalon@cox.net',0,'ShalonShadrick','ShalonShadrick354353');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Denise','Patak','denise@patak.org',0,'DenisePatak','DenisePatak355354');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Louvenia','Beech','louvenia.beech@beech.com',0,'LouveniaBeech','LouveniaBeech356355');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Audry','Yaw','audry.yaw@yaw.org',0,'AudryYaw','AudryYaw357356');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kristel','Ehmann','kristel.ehmann@aol.com',0,'KristelEhmann','KristelEhmann358357');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Vincenza','Zepp','vzepp@gmail.com',0,'VincenzaZepp','VincenzaZepp359358');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Elouise','Gwalthney','egwalthney@yahoo.com',0,'ElouiseGwalthney','ElouiseGwalthney360359');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Venita','Maillard','venita_maillard@gmail.com',0,'VenitaMaillard','VenitaMaillard361360');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kasandra','Semidey','kasandra_semidey@semidey.com',0,'KasandraSemidey','KasandraSemidey362361');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Xochitl','Discipio','xdiscipio@gmail.com',0,'XochitlDiscipio','XochitlDiscipio363362');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Maile','Linahan','mlinahan@yahoo.com',0,'MaileLinahan','MaileLinahan364363');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Krissy','Rauser','krauser@cox.net',0,'KrissyRauser','KrissyRauser365364');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Pete','Dubaldi','pdubaldi@hotmail.com',0,'PeteDubaldi','PeteDubaldi366365');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Linn','Paa','linn_paa@paa.com',0,'LinnPaa','LinnPaa367366');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Paris','Wide','paris@hotmail.com',0,'ParisWide','ParisWide368367');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Wynell','Dorshorst','wynell_dorshorst@dorshorst.org',0,'WynellDorshorst','WynellDorshorst369368');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Quentin','Birkner','qbirkner@aol.com',0,'QuentinBirkner','QuentinBirkner370369');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Regenia','Kannady','regenia.kannady@cox.net',0,'RegeniaKannady','RegeniaKannady371370');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sheron','Louissant','sheron@aol.com',0,'SheronLouissant','SheronLouissant372371');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Izetta','Funnell','izetta.funnell@hotmail.com',0,'IzettaFunnell','IzettaFunnell373372');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rodolfo','Butzen','rodolfo@hotmail.com',0,'RodolfoButzen','RodolfoButzen374373');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Zona','Colla','zona@hotmail.com',0,'ZonaColla','ZonaColla375374');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Serina','Zagen','szagen@aol.com',0,'SerinaZagen','SerinaZagen376375');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Paz','Sahagun','paz_sahagun@cox.net',0,'PazSahagun','PazSahagun377376');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Markus','Lukasik','markus@yahoo.com',0,'MarkusLukasik','MarkusLukasik378377');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jaclyn','Bachman','jaclyn@aol.com',0,'JaclynBachman','JaclynBachman379378');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cyril','Daufeldt','cyril_daufeldt@daufeldt.com',0,'CyrilDaufeldt','CyrilDaufeldt380379');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gayla','Schnitzler','gschnitzler@gmail.com',0,'GaylaSchnitzler','GaylaSchnitzler381380');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Erick','Nievas','erick_nievas@aol.com',0,'ErickNievas','ErickNievas382381');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jennie','Drymon','jennie@cox.net',0,'JennieDrymon','JennieDrymon383382');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mitsue','Scipione','mscipione@scipione.com',0,'MitsueScipione','MitsueScipione384383');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ciara','Ventura','cventura@yahoo.com',0,'CiaraVentura','CiaraVentura385384');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Galen','Cantres','galen@yahoo.com',0,'GalenCantres','GalenCantres386385');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Truman','Feichtner','tfeichtner@yahoo.com',0,'TrumanFeichtner','TrumanFeichtner387386');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gail','Kitty','gail@kitty.com',0,'GailKitty','GailKitty388387');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dalene','Schoeneck','dalene@schoeneck.org',0,'DaleneSchoeneck','DaleneSchoeneck389388');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gertude','Witten','gertude.witten@gmail.com',0,'GertudeWitten','GertudeWitten390389');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lizbeth','Kohl','lizbeth@yahoo.com',0,'LizbethKohl','LizbethKohl391390');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Glenn','Berray','gberray@gmail.com',0,'GlennBerray','GlennBerray392391');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lashandra','Klang','lashandra@yahoo.com',0,'LashandraKlang','LashandraKlang393392');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lenna','Newville','lnewville@newville.com',0,'LennaNewville','LennaNewville394393');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Laurel','Pagliuca','laurel@yahoo.com',0,'LaurelPagliuca','LaurelPagliuca395394');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mireya','Frerking','mireya.frerking@hotmail.com',0,'MireyaFrerking','MireyaFrerking396395');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Annelle','Tagala','annelle@yahoo.com',0,'AnnelleTagala','AnnelleTagala397396');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dean','Ketelsen','dean_ketelsen@gmail.com',0,'DeanKetelsen','DeanKetelsen398397');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Levi','Munis','levi.munis@gmail.com',0,'LeviMunis','LeviMunis399398');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sylvie','Ryser','sylvie@aol.com',0,'SylvieRyser','SylvieRyser400399');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sharee','Maile','sharee_maile@aol.com',0,'ShareeMaile','ShareeMaile401400');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cordelia','Storment','cordelia_storment@aol.com',0,'CordeliaStorment','CordeliaStorment402401');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mollie','Mcdoniel','mollie_mcdoniel@yahoo.com',0,'MollieMcdoniel','MollieMcdoniel403402');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Brett','Mccullan','brett.mccullan@mccullan.com',0,'BrettMccullan','BrettMccullan404403');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Teddy','Pedrozo','teddy_pedrozo@aol.com',0,'TeddyPedrozo','TeddyPedrozo405404');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tasia','Andreason','tasia_andreason@yahoo.com',0,'TasiaAndreason','TasiaAndreason406405');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Hubert','Walthall','hubert@walthall.org',0,'HubertWalthall','HubertWalthall407406');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Arthur','Farrow','arthur.farrow@yahoo.com',0,'ArthurFarrow','ArthurFarrow408407');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Vilma','Berlanga','vberlanga@berlanga.com',0,'VilmaBerlanga','VilmaBerlanga409408');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Billye','Miro','billye_miro@cox.net',0,'BillyeMiro','BillyeMiro410409');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Glenna','Slayton','glenna_slayton@cox.net',0,'GlennaSlayton','GlennaSlayton411410');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mitzie','Hudnall','mitzie_hudnall@yahoo.com',0,'MitzieHudnall','MitzieHudnall412411');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Bernardine','Rodefer','bernardine_rodefer@yahoo.com',0,'BernardineRodefer','BernardineRodefer413412');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Staci','Schmaltz','staci_schmaltz@aol.com',0,'StaciSchmaltz','StaciSchmaltz414413');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Nichelle','Meteer','nichelle_meteer@meteer.com',0,'NichelleMeteer','NichelleMeteer415414');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Janine','Rhoden','jrhoden@yahoo.com',0,'JanineRhoden','JanineRhoden416415');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ettie','Hoopengardner','ettie.hoopengardner@hotmail.com',0,'EttieHoopengardner','EttieHoopengardner417416');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Eden','Jayson','eden_jayson@yahoo.com',0,'EdenJayson','EdenJayson418417');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lynelle','Auber','lynelle_auber@gmail.com',0,'LynelleAuber','LynelleAuber419418');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Merissa','Tomblin','merissa.tomblin@gmail.com',0,'MerissaTomblin','MerissaTomblin420419');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Golda','Kaniecki','golda_kaniecki@yahoo.com',0,'GoldaKaniecki','GoldaKaniecki421420');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Catarina','Gleich','catarina_gleich@hotmail.com',0,'CatarinaGleich','CatarinaGleich422421');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Virgie','Kiel','vkiel@hotmail.com',0,'VirgieKiel','VirgieKiel423422');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jolene','Ostolaza','jolene@yahoo.com',0,'JoleneOstolaza','JoleneOstolaza424423');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Keneth','Borgman','keneth@yahoo.com',0,'KenethBorgman','KenethBorgman425424');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rikki','Nayar','rikki@nayar.com',0,'RikkiNayar','RikkiNayar426425');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Elke','Sengbusch','elke_sengbusch@yahoo.com',0,'ElkeSengbusch','ElkeSengbusch427426');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Hoa','Sarao','hoa@sarao.org',0,'HoaSarao','HoaSarao428427');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Trinidad','Mcrae','trinidad_mcrae@yahoo.com',0,'TrinidadMcrae','TrinidadMcrae429428');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mari','Lueckenbach','mari_lueckenbach@yahoo.com',0,'MariLueckenbach','MariLueckenbach430429');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Selma','Husser','selma.husser@cox.net',0,'SelmaHusser','SelmaHusser431430');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Antione','Onofrio','aonofrio@onofrio.com',0,'AntioneOnofrio','AntioneOnofrio432431');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Luisa','Jurney','ljurney@hotmail.com',0,'LuisaJurney','LuisaJurney433432');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Clorinda','Heimann','clorinda.heimann@hotmail.com',0,'ClorindaHeimann','ClorindaHeimann434433');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dick','Wenzinger','dick@yahoo.com',0,'DickWenzinger','DickWenzinger435434');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ahmed','Angalich','ahmed.angalich@angalich.com',0,'AhmedAngalich','AhmedAngalich436435');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Iluminada','Ohms','iluminada.ohms@yahoo.com',0,'IluminadaOhms','IluminadaOhms437436');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Joanna','Leinenbach','joanna_leinenbach@hotmail.com',0,'JoannaLeinenbach','JoannaLeinenbach438437');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Caprice','Suell','caprice@aol.com',0,'CapriceSuell','CapriceSuell439438');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Stephane','Myricks','stephane_myricks@cox.net',0,'StephaneMyricks','StephaneMyricks440439');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Quentin','Swayze','quentin_swayze@yahoo.com',0,'QuentinSwayze','QuentinSwayze441440');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Annmarie','Castros','annmarie_castros@gmail.com',0,'AnnmarieCastros','AnnmarieCastros442441');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Shonda','Greenbush','shonda_greenbush@cox.net',0,'ShondaGreenbush','ShondaGreenbush443442');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cecil','Lapage','clapage@lapage.com',0,'CecilLapage','CecilLapage444443');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jeanice','Claucherty','jeanice.claucherty@yahoo.com',0,'JeaniceClaucherty','JeaniceClaucherty445444');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Josphine','Villanueva','josphine_villanueva@villanueva.com',0,'JosphineVillanueva','JosphineVillanueva446445');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Daniel','Perruzza','dperruzza@perruzza.com',0,'DanielPerruzza','DanielPerruzza447446');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cassi','Wildfong','cassi.wildfong@aol.com',0,'CassiWildfong','CassiWildfong448447');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Britt','Galam','britt@galam.org',0,'BrittGalam','BrittGalam449448');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Adell','Lipkin','adell.lipkin@lipkin.com',0,'AdellLipkin','AdellLipkin450449');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jacqueline','Rowling','jacqueline.rowling@yahoo.com',0,'JacquelineRowling','JacquelineRowling451450');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lonny','Weglarz','lonny_weglarz@gmail.com',0,'LonnyWeglarz','LonnyWeglarz452451');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lonna','Diestel','lonna_diestel@gmail.com',0,'LonnaDiestel','LonnaDiestel453452');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cristal','Samara','cristal@cox.net',0,'CristalSamara','CristalSamara454453');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Kenneth','Grenet','kenneth.grenet@grenet.org',0,'KennethGrenet','KennethGrenet455454');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Elli','Mclaird','emclaird@mclaird.com',0,'ElliMclaird','ElliMclaird456455');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alline','Jeanty','ajeanty@gmail.com',0,'AllineJeanty','AllineJeanty457456');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sharika','Eanes','sharika.eanes@aol.com',0,'SharikaEanes','SharikaEanes458457');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Nu','Mcnease','nu@gmail.com',0,'NuMcnease','NuMcnease459458');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Daniela','Comnick','dcomnick@cox.net',0,'DanielaComnick','DanielaComnick460459');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Cecilia','Colaizzo','cecilia_colaizzo@colaizzo.com',0,'CeciliaColaizzo','CeciliaColaizzo461460');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Leslie','Threets','leslie@cox.net',0,'LeslieThreets','LeslieThreets462461');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Nan','Koppinger','nan@koppinger.com',0,'NanKoppinger','NanKoppinger463462');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Izetta','Dewar','idewar@dewar.com',0,'IzettaDewar','IzettaDewar464463');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Tegan','Arceo','tegan.arceo@arceo.org',0,'TeganArceo','TeganArceo465464');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ruthann','Keener','ruthann@hotmail.com',0,'RuthannKeener','RuthannKeener466465');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Joni','Breland','joni_breland@cox.net',0,'JoniBreland','JoniBreland467466');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Vi','Rentfro','vrentfro@cox.net',0,'ViRentfro','ViRentfro468467');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Colette','Kardas','colette.kardas@yahoo.com',0,'ColetteKardas','ColetteKardas469468');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Malcolm','Tromblay','malcolm_tromblay@cox.net',0,'MalcolmTromblay','MalcolmTromblay470469');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Ryan','Harnos','ryan@cox.net',0,'RyanHarnos','RyanHarnos471470');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jess','Chaffins','jess.chaffins@chaffins.org',0,'JessChaffins','JessChaffins472471');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Sharen','Bourbon','sbourbon@yahoo.com',0,'SharenBourbon','SharenBourbon473472');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Nickolas','Juvera','nickolas_juvera@cox.net',0,'NickolasJuvera','NickolasJuvera474473');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gary','Nunlee','gary_nunlee@nunlee.org',0,'GaryNunlee','GaryNunlee475474');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Diane','Devreese','diane@cox.net',0,'DianeDevreese','DianeDevreese476475');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Roslyn','Chavous','roslyn.chavous@chavous.org',0,'RoslynChavous','RoslynChavous477476');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Glory','Schieler','glory@yahoo.com',0,'GlorySchieler','GlorySchieler478477');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Rasheeda','Sayaphon','rasheeda@aol.com',0,'RasheedaSayaphon','RasheedaSayaphon479478');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alpha','Palaia','alpha@yahoo.com',0,'AlphaPalaia','AlphaPalaia480479');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Refugia','Jacobos','refugia.jacobos@jacobos.com',0,'RefugiaJacobos','RefugiaJacobos481480');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Shawnda','Yori','shawnda.yori@yahoo.com',0,'ShawndaYori','ShawndaYori482481');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Mona','Delasancha','mdelasancha@hotmail.com',0,'MonaDelasancha','MonaDelasancha483482');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gilma','Liukko','gilma_liukko@gmail.com',0,'GilmaLiukko','GilmaLiukko484483');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Janey','Gabisi','jgabisi@hotmail.com',0,'JaneyGabisi','JaneyGabisi485484');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lili','Paskin','lili.paskin@cox.net',0,'LiliPaskin','LiliPaskin486485');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Loren','Asar','loren.asar@aol.com',0,'LorenAsar','LorenAsar487486');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Dorothy','Chesterfield','dorothy@cox.net',0,'DorothyChesterfield','DorothyChesterfield488487');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Gail','Similton','gail_similton@similton.com',0,'GailSimilton','GailSimilton489488');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Catalina','Tillotson','catalina@hotmail.com',0,'CatalinaTillotson','CatalinaTillotson490489');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lawrence','Lorens','lawrence.lorens@hotmail.com',0,'LawrenceLorens','LawrenceLorens491490');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Carlee','Boulter','carlee.boulter@hotmail.com',0,'CarleeBoulter','CarleeBoulter492491');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Thaddeus','Ankeny','tankeny@ankeny.org',0,'ThaddeusAnkeny','ThaddeusAnkeny493492');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jovita','Oles','joles@gmail.com',0,'JovitaOles','JovitaOles494493');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Alesia','Hixenbaugh','alesia_hixenbaugh@hixenbaugh.org',0,'AlesiaHixenbaugh','AlesiaHixenbaugh495494');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Lai','Harabedian','lai@gmail.com',0,'LaiHarabedian','LaiHarabedian496495');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Brittni','Gillaspie','bgillaspie@gillaspie.com',0,'BrittniGillaspie','BrittniGillaspie497496');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Raylene','Kampa','rkampa@kampa.org',0,'RayleneKampa','RayleneKampa498497');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Flo','Bookamer','flo.bookamer@cox.net',0,'FloBookamer','FloBookamer499498');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Jani','Biddy','jbiddy@yahoo.com',0,'JaniBiddy','JaniBiddy500499');
Insert into Employees (FirstName,LastName,EmailAddress,isEmployeed,LoginName,LoginPassword) values ('Chauncey','Motley','chauncey_motley@aol.com',0,'ChaunceyMotley','ChaunceyMotley501500');

--CEO MANAGERS THEIR SELF
--BETWEEN 1 AND 10 2-10
--BETWEEN 10 AND 300 --TRADERS 11-300
--BETWEEN 300 AND 600 --REGULAR WORKERS 301-
--setting managers
UPDATE Employees SET ManagerID = 1 WHERE EmployeeID = 1; 
UPDATE Employees SET ManagerID = 1 WHERE EmployeeID > 1 AND EmployeeID <= 10; 
UPDATE Employees SET ManagerID = 2 WHERE EmployeeID > 10 AND EmployeeID <= 300; 
UPDATE Employees SET ManagerID = 3 WHERE EmployeeID > 300 AND EmployeeID <= 600; 


--Roles

Insert into Roles (RoleName,EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget) values ('CEO',500000000,500000000,500000000,500000000,100000000,100000000,100000000,100000000,100000000,100000000,500000000);
Insert into Roles (RoleName,EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget) values ('CFO',0,187645,7658856,1000000000,1000000000,60000,1000000000,1000000000,698000000,700000000,500000);
Insert into Roles (RoleName,EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget) values ('TRADER',0,1000000000,1000000000,0,10000,10000,100,1000000,10000,100000,0);
Insert into Roles (RoleName,EngineOilSpendingAmount,EngineOilBuyingAmount,CrudeOilSpendingAmount,CrudeOilBuyingAmount,MotorOilSpendingAmount,MotorOilBuyingAmount,GasolineBuyingAmount,GasolineSpendingAmount,PetroleumSpendingAmount,PetroleumBuyingAmount,InternalSpendingBudget) values ('REGULAR',0,0,0,0,0,0,0,0,0,0,0);


--EmployeeRoles

Insert into EmployeeRoles (EmployeeID,RoleID) values (1,1);
Insert into EmployeeRoles (EmployeeID,RoleID) values (2,2);
Insert into EmployeeRoles (EmployeeID,RoleID) values (3,2);
Insert into EmployeeRoles (EmployeeID,RoleID) values (4,2);
Insert into EmployeeRoles (EmployeeID,RoleID) values (5,2);
Insert into EmployeeRoles (EmployeeID,RoleID) values (6,2);
Insert into EmployeeRoles (EmployeeID,RoleID) values (7,2);
Insert into EmployeeRoles (EmployeeID,RoleID) values (8,2);
Insert into EmployeeRoles (EmployeeID,RoleID) values (9,2);
Insert into EmployeeRoles (EmployeeID,RoleID) values (10,2);
Insert into EmployeeRoles (EmployeeID,RoleID) values (11,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (12,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (13,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (14,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (15,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (16,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (17,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (18,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (19,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (20,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (21,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (22,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (23,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (24,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (25,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (26,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (27,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (28,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (29,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (30,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (31,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (32,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (33,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (34,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (35,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (36,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (37,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (38,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (39,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (40,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (41,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (42,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (43,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (44,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (45,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (46,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (47,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (48,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (49,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (50,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (51,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (52,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (53,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (54,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (55,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (56,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (57,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (58,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (59,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (60,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (61,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (62,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (63,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (64,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (65,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (66,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (67,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (68,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (69,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (70,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (71,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (72,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (73,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (74,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (75,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (76,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (77,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (78,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (79,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (80,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (81,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (82,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (83,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (84,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (85,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (86,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (87,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (88,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (89,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (90,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (91,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (92,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (93,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (94,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (95,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (96,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (97,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (98,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (99,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (100,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (101,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (102,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (103,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (104,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (105,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (106,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (107,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (108,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (109,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (110,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (111,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (112,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (113,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (114,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (115,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (116,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (117,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (118,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (119,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (120,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (121,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (122,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (123,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (124,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (125,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (126,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (127,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (128,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (129,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (130,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (131,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (132,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (133,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (134,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (135,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (136,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (137,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (138,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (139,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (140,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (141,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (142,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (143,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (144,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (145,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (146,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (147,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (148,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (149,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (150,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (151,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (152,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (153,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (154,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (155,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (156,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (157,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (158,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (159,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (160,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (161,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (162,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (163,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (164,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (165,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (166,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (167,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (168,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (169,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (170,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (171,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (172,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (173,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (174,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (175,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (176,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (177,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (178,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (179,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (180,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (181,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (182,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (183,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (184,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (185,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (186,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (187,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (188,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (189,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (190,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (191,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (192,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (193,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (194,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (195,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (196,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (197,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (198,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (199,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (200,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (201,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (202,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (203,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (204,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (205,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (206,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (207,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (208,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (209,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (210,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (211,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (212,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (213,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (214,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (215,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (216,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (217,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (218,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (219,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (220,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (221,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (222,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (223,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (224,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (225,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (226,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (227,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (228,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (229,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (230,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (231,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (232,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (233,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (234,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (235,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (236,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (237,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (238,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (239,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (240,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (241,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (242,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (243,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (244,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (245,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (246,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (247,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (248,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (249,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (250,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (251,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (252,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (253,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (254,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (255,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (256,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (257,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (258,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (259,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (260,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (261,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (262,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (263,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (264,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (265,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (266,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (267,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (268,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (269,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (270,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (271,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (272,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (273,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (274,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (275,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (276,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (277,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (278,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (279,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (280,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (281,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (282,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (283,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (284,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (285,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (286,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (287,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (288,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (289,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (290,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (291,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (292,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (293,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (294,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (295,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (296,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (297,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (298,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (299,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (300,3);
Insert into EmployeeRoles (EmployeeID,RoleID) values (301,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (302,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (303,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (304,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (305,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (306,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (307,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (308,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (309,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (310,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (311,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (312,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (313,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (314,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (315,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (316,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (317,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (318,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (319,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (320,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (321,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (322,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (323,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (324,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (325,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (326,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (327,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (328,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (329,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (330,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (331,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (332,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (333,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (334,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (335,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (336,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (337,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (338,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (339,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (340,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (341,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (342,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (343,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (344,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (345,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (346,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (347,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (348,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (349,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (350,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (351,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (352,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (353,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (354,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (355,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (356,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (357,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (358,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (359,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (360,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (361,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (362,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (363,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (364,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (365,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (366,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (367,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (368,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (369,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (370,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (371,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (372,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (373,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (374,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (375,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (376,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (377,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (378,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (379,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (380,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (381,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (382,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (383,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (384,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (385,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (386,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (387,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (388,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (389,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (390,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (391,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (392,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (393,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (394,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (395,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (396,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (397,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (398,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (399,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (400,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (401,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (402,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (403,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (404,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (405,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (406,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (407,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (408,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (409,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (410,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (411,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (412,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (413,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (414,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (415,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (416,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (417,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (418,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (419,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (420,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (421,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (422,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (423,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (424,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (425,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (426,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (427,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (428,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (429,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (430,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (431,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (432,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (433,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (434,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (435,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (436,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (437,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (438,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (439,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (440,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (441,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (442,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (443,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (444,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (445,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (446,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (447,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (448,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (449,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (450,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (451,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (452,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (453,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (454,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (455,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (456,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (457,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (458,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (459,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (460,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (461,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (462,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (463,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (464,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (465,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (466,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (467,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (468,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (469,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (470,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (471,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (472,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (473,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (474,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (475,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (476,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (477,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (478,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (479,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (480,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (481,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (482,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (483,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (484,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (485,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (486,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (487,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (488,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (489,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (490,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (491,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (492,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (493,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (494,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (495,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (496,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (497,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (498,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (499,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (500,4);
Insert into EmployeeRoles (EmployeeID,RoleID) values (501,4);









