DROP SCHEMA  IF EXISTS  TRIGGERSS;
CREATE SCHEMA  IF NOT EXISTS TRIGGERSS;
USE TRIGGERSS;

 SET SQL_SAFE_UPDATES = 0;
 
drop table if  exists PROVINCIA ;
CREATE TABLE IF NOT EXISTS `provincia` (
  `Provincia` varchar(50) DEFAULT NULL,
  `ID_Provincia` int NOT NULL
  ,PRIMARY KEY (`ID_Provincia`)
) ;

drop table if  exists LOG_AUDITORIA;
CREATE TABLE IF NOT EXISTS LOG_AUDITORIA 
(
ID_LOG INT AUTO_INCREMENT ,-- pk de la tabla 
NOMBRE_DE_ACCION VARCHAR(10) ,-- irira si es insert , update ,delete
NOMBRE_TABLA VARCHAR(50) ,-- provincia , class , departamento , etc..
USUARIO VARCHAR(100) , -- quien ejecuta la sentencia DML
FECHA_UPD_INS_DEL DATE , -- momento exacto en el que se genera DML
PRIMARY KEY (ID_LOG)
)
;

drop table if  exists LOG_AUDITORIA_2;
CREATE TABLE IF NOT EXISTS LOG_AUDITORIA_2 
(
ID_LOG INT AUTO_INCREMENT ,
--  PROVINCIA varchar(50) DEFAULT NULL,
-- ID_PROVINCIA int NOT NULL ,
CAMPONUEVO_CAMPOANTERIOR VARCHAR(300),
NOMBRE_DE_ACCION VARCHAR(10) ,
NOMBRE_TABLA VARCHAR(50) ,
USUARIO VARCHAR(100) ,
FECHA_UPD_INS_DEL DATE    ,
PRIMARY KEY (ID_LOG)
)
;

-- SINTAXIS 
/*
create trigger TRG_nombre-del-trigger
  [before / after] [insert / delete / update] 
  on nombre-de-la-tabla_a_la_que_quiero_auditar
  for each row
begin
 todo el código / instrucciones-sql;
end
*/


DELIMITER //
CREATE TRIGGER TRG_LOG_PROVINCIA AFTER INSERT ON TRIGGERSS.PROVINCIA
FOR EACH ROW 
BEGIN

INSERT INTO LOG_AUDITORIA (NOMBRE_DE_ACCION , NOMBRE_TABLA , USUARIO,FECHA_UPD_INS_DEL)
VALUES ( 'INSERT' , 'PROVINCIA' ,CURRENT_USER() , NOW());

END//
DELIMITER ;

DROP TRIGGER IF EXISTS TRG_LOG_PROVINCIA_2 ;
-- INSERT --> NEW.
-- DELETE --> OLD. 
-- UPDATE --> NEW. OLD. 

DELIMITER //
CREATE TRIGGER  TRG_LOG_PROVINCIA_2 AFTER INSERT ON TRIGGERSS.PROVINCIA
FOR EACH ROW 
BEGIN
 
INSERT INTO LOG_AUDITORIA_2 (PROVINCIA , ID_PROVINCIA, NOMBRE_DE_ACCION , NOMBRE_TABLA ,USUARIO, FECHA_UPD_INS_DEL)
VALUES ( NEW.PROVINCIA  ,NEW.ID_PROVINCIA, 'INSERT' , 'PROVINCIA' ,CURRENT_USER(), NOW());
       
END//
DELIMITER ;

SELECT * FROM LOG_AUDITORIA ;
SELECT * FROM LOG_AUDITORIA_2 ;
SELECT * FROM PROVINCIA;

-- CONCAT('PROVINCIA:',NEW.PROVINCIA ,'ID_PROVINCIA:',NEW,ID_PROVINCIA)

'PROVINCIA: CORDOBA ID_PROVINCIA: 1'
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Cordoba',1);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Santa Fe',2);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Santiago Del Estero',3);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Buenos Aires',4);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Entre Rios',5);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Chaco',6);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('La Pampa',7);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('San Luis',8);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Corrientes',9);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Misiones',10);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('San Juan',11);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Santa Cruz',12);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Rio Negro',13);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Chubut',14);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Mendoza',15);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('La Rioja',16);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Catamarca',17);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Tucuman',18);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Neuquen',19);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Salta',20);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Formosa',21);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Jujuy',22);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Ciudad Autonoma de Buenos Aires',23);
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Tierra del Fuego',24); 
INSERT INTO provincia (`Provincia`,`ID_Provincia`) VALUES ('Tierra',25); 
SELECT * FROM LOG_AUDITORIA ;
SELECT * FROM LOG_AUDITORIA_2 ;
SELECT * FROM PROVINCIA ;

DROP TRIGGER IF EXISTS TRG_LOG_PROVINCIA_3 ;
DELIMITER //
CREATE TRIGGER TRG_LOG_PROVINCIA_3 BEFORE UPDATE ON TRIGGERSS.PROVINCIA
FOR EACH ROW 
BEGIN

INSERT INTO LOG_AUDITORIA_2 (CAMPONUEVO_CAMPOANTERIOR, NOMBRE_DE_ACCION , NOMBRE_TABLA , FECHA_UPD_INS_DEL)
VALUES ( CONCAT('PROVINCIA_ANTERIOR',OLD.PROVINCIA,'  PROVINCIA_NUEVA: ' , NEW.PROVINCIA ,' ID_PROVINCIA_ACTUAL : ',OLD.ID_PROVINCIA ), 'UPDATE' , 'PROVINCIA' , NOW());

END//
DELIMITER 

/*
INSERT INTO LOG_AUDITORIA_2 (PROVINCIA,ID_PROVINCIA, NOMBRE_DE_ACCION , NOMBRE_TABLA , FECHA_UPD_INS_DEL)
VALUES ( CONCAT(OLD.PROVINCIA,' -' , NEW.PROVINCIA) ,OLD.ID_PROVINCIA, 'UPDATE' , 'PROVINCIA' , NOW());

*/
SELECT * FROM PROVINCIA; 
UPDATE TRIGGERSS.PROVINCIA SET PROVINCIA = 'BOGOTÀ' WHERE ID_Provincia = 2 ; 
SELECT * FROM LOG_AUDITORIA_2 ;