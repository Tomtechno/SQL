DROP SCHEMA  IF EXISTS  WORKSHOP2;
CREATE SCHEMA  IF NOT EXISTS WORKSHOP2;
USE WORKSHOP2;


 drop table if exists libros, editoriales;
 
 create table libros(
  codigo int unsigned auto_increment,
  titulo varchar(40) not null,
  autor varchar(30) not null default 1,
  codigoeditorial tinyint unsigned not null,
  precio decimal(5,2) unsigned,
  primary key (codigo)
 );
 
 create table editoriales ( 
  codigo tinyint unsigned auto_increment,
  nombre varchar(20),
  primary key (codigo) 
 );

 create table socios(
  documento char(8) not null,
  nombre varchar(30),
  domicilio varchar(30),
  primary key (documento)
 );

 create table prestamos(
  documento char(8) not null,
  codigolibro int unsigned,
  fechaprestamo date not null,
  fechadevolucion date,
  primary key (codigolibro,fechaprestamo)
 );
 
 
 create table clientes(
  codigo int auto_increment,
  nombre varchar(30),
  domicilio varchar(30),
  primary key(codigo)
 );

 create table facturas(
  numero int not null,
  fecha date,
  codigocliente int not null,
  primary key(numero)
 );

 create table detalles(
  numerofactura int not null,
  numeroitem int not null, 
  articulo varchar(30),
  precio decimal(5,2),
  cantidad int,
  primary key(numerofactura,numeroitem)
 );
 
 
 drop table if  exists LOG_AUDITORIA;
CREATE TABLE IF NOT EXISTS LOG_AUDITORIA 
(
ID_LOG INT AUTO_INCREMENT ,
CAMPONUEVO_CAMPOANTERIOR VARCHAR(255),-- camponuevo y viejo solo update
NOMBRE_DE_ACCION VARCHAR(10) ,
NOMBRE_TABLA VARCHAR(50) ,
USUARIO VARCHAR(100) ,
FECHA_UPD_INS_DEL DATE    ,
PRIMARY KEY (ID_LOG)
)
;



 insert into detalles values(1200,1,'lapiz',1,100);
 insert into detalles values(1200,2,'goma',0.5,150);
 insert into detalles values(1201,1,'regla',1.5,80);
 insert into detalles values(1201,2,'goma',0.5,200);
 insert into detalles values(1201,3,'cuaderno',4,90);
 insert into detalles values(1202,1,'lapiz',1,200);
 insert into detalles values(1202,2,'escuadra',2,100);
 insert into detalles values(1300,1,'lapiz',1,300);
 
 
  insert into editoriales (nombre) values ('Planeta');
 insert into editoriales (nombre) values ('Emece');
 insert into editoriales (nombre) values ('Paidos');

 insert into libros (titulo, autor,codigoeditorial,precio)
  values('Alicia en el pais de las maravillas','Lewis Carroll',1,23.5);
 insert into libros (titulo, autor,codigoeditorial,precio)
  values('Alicia a traves del espejo','Lewis Carroll',2,25);
 insert into libros (titulo, autor,codigoeditorial,precio) 
  values('El aleph','Borges',2,15);
 insert into libros (titulo, autor,codigoeditorial,precio)
  values('Matemática estas ahi','Paenza',1,10);
  
insert into socios values('22333444','Juan Perez','Colon 345');
 insert into socios values('23333444','Luis Lopez','Caseros 940');
 insert into socios values('25333444','Ana Herrero','Sucre 120');


 insert into prestamos values('22333444',1,'2016-08-10','2016-08-12');
 insert into prestamos values('22333444',1,'2016-08-15',null);
 insert into prestamos values('25333444',25,'2016-08-10','2016-08-13');
 insert into prestamos values('25333444',42,'2016-08-10',null);
 insert into prestamos values('25333444',25,'2016-08-15',null);
 insert into prestamos values('30333444',42,'2016-08-02','2016-08-05');
 insert into prestamos values('25333444',2,'2016-08-02','2016-08-05');
 
  insert into clientes(nombre,domicilio) values('Juan Lopez','Colon 123');
 insert into clientes(nombre,domicilio) values('Luis Torres','Sucre 987');
 insert into clientes(nombre,domicilio) values('Ana Garcia','Sarmiento 576');

 insert into facturas values(1200,'2007-01-15',1);
 insert into facturas values(1201,'2007-01-15',2);
 insert into facturas values(1202,'2007-01-15',3);
 insert into facturas values(1300,'2007-01-20',1);

DROP TRIGGER if  exists TRG_LOG_AUDITORIA ;

DELIMITER //
CREATE TRIGGER  TRG_LOG_AUDITORIA AFTER INSERT ON WORKSHOP2.detalles
FOR EACH ROW 
BEGIN

INSERT INTO LOG_AUDITORIA (CAMPONUEVO_CAMPOANTERIOR , NOMBRE_DE_ACCION , NOMBRE_TABLA ,USUARIO, FECHA_UPD_INS_DEL)
VALUES ( NEW.numerofactura  , 'INSERT' , 'detalles' ,CURRENT_USER(), NOW());
       
END//
DELIMITER ;

SELECT * FROM LOG_AUDITORIA ;


 select * from editoriales ;
 select * from libros ;


create view vw_consulta_cantidad_precio as ( 
select e.nombre,
 count(l.codigoeditorial) as 'cantidad de libros',
 max(l.precio) as 'mayor precio'
  from editoriales as e
  join libros as l
  on l.codigoeditorial=e.codigo
  group by e.nombre
  );
  
select * from vw_consulta_cantidad_precio ;


drop FUNCTION  if exists fn_p_mensaje ;
DELIMITER //

CREATE FUNCTION fn_p_mensaje ( p_columna varchar(255) )
RETURNS varchar(255)
DETERMINISTIC
BEGIN

   DECLARE v_mensaje varchar(255);

   IF p_columna  = ''  or p_columna  is null THEN
      SET v_mensaje = 'ERROR';     
      

   ELSE
      SET v_mensaje = 'OK';

   END IF;

   RETURN v_mensaje;

END; //

DELIMITER ;

SELECT fn_p_mensaje('') ;


drop procedure if exists sp_ordenamiento;

delimiter //
create procedure sp_ordenamiento (	in nombreTabla varchar (30),
									in campoOrderBy varchar (30),
									in orderByTipo varchar (4),
                                    in agregarOEliminar varchar (20),
								    in agregarNombre varchar (100),
                                    in agregarDireccion varchar (150)
                                    -- , in eliminarID int
                                    ,OUT P_SALIDA varchar (150)
								 )
begin


SET @P_SALIDA =  CONCAT('SELECT fn_p_mensaje(''',nombreTabla,'');

IF @P_SALIDA = 'ERROR' THEN 
 SET @P_SALIDA = 'FALLA POR PARAMETRO INEXISTENTE';
 ELSE 
 SET @P_SALIDA = 'PARAMETROS INGRESADOS CORRECTAMETE';
END IF;

 prepare param_stmt from @P_SALIDA;
-- Ejecuta query
execute param_stmt;
-- Liberar statement compilado
deallocate prepare param_stmt;

/* IF fn_p_mensaje (nombreTabla) = 'ERROR' THEN 
 SET @P_SALIDA = 'FALLA POR PARAMETRO INEXISTENTE';
 ELSE 
 SET @P_SALIDA = 'PARAMETROS INGRESADOS CORRECTAMETE';
 END IF;*/

-- Concatena strings fijos + parámetros de entrada para guardar la query final en una variable
set @algo = CONCAT('SELECT * FROM ', nombreTabla, ' ORDER BY ', campoOrderBy, ' ', orderByTipo);
-- Precompila string con query completa
prepare param_stmt from @algo;
-- Ejecuta query
execute param_stmt;
-- Liberar statement compilado
deallocate prepare param_stmt;



-- Si el valor del parámetro ingresado es insert
IF agregarOEliminar = 'Insert' THEN
-- Generamos la query para insert

set @agregarEliminar = CONCAT('INSERT INTO clientes VALUES (NULL, ', agregarNombre, ', ', agregarDireccion, ')');
 insert into detalles values(13000,1,'lapiz',1,300);
-- Si no generamos la query para delete por id
ELSE
set @agregarEliminar = CONCAT('delete from clientes where domicilio = ', agregarDireccion );

END IF;

-- Precompila string con query completa
prepare param_stmt from @agregarEliminar;
-- Ejecuta query
execute param_stmt;
-- Liberar statement compilado
deallocate prepare param_stmt;

end //
delimiter ;

-- --   insert into clientes(nombre,domicilio) values('Juan Lopez','Colon 123');
-- Inicializar parámetros de entrada para el SP
set @nombreTabla = 'clientes';
set @campoOrderBy = 'nombre';
set @orderByTipo = 'asc';
set @agregarOEliminar = 'Insert';
set @agregarNombre = '"nombre1"';
set @agregarDireccion = '"direccion1"';
-- set @eliminarID = null;

-- Ejecutar SP
call sp_ordenamiento (@nombreTabla, @campoOrderBy, @orderByTipo ,
   @agregarOEliminar, @agregarNombre, @agregarDireccion, @P_SALIDA );

SELECT * FROM clientes ;



CREATE OR REPLACE VIEW VW_FACTURAS_POR_CLIENTE AS  (
SELECT * FROM FACTURAS
WHERE CODIGOCLIENTE = 3 );


SELECT NUMERO AS V_NUMERO FROM FACTURAS
WHERE CODIGOCLIENTE = 3 


DROP FUNCTION IF EXISTS FN_FACTURAS_CLIENTES ;
DELIMITER $$
CREATE FUNCTION FN_FACTURAS_CLIENTES (P_CODIGO_CLIENTE INT ) 
RETURNS INT 
DETERMINISTIC 
BEGIN
DECLARE V_NUMERO INT ;
SELECT NUMERO INTO V_NUMERO
FROM VW_FACTURAS_POR_CLIENTE WHERE CODIGOCLIENTE = P_CODIGO_CLIENTE ;
RETURN V_NUMERO;
END$$
DELIMITER ;  

SELECT FN_FACTURAS_CLIENTES(1) ;

SELECT  NUMERO, FECHA FROM FACTURAS
WHERE CODIGOCLIENTE = 3;


DELIMITER //
CREATE PROCEDURE SP_CODIGO_CLIENTE(IN P_NUMERO INT ,
								   OUT P_FECHA DATE ,
                                   OUT P_CAMPO_NUMERO INT ) 
BEGIN
SELECT  NUMERO, FECHA
INTO    P_CAMPO_NUMERO, P_FECHA  FROM FACTURAS
WHERE CODIGOCLIENTE = P_NUMERO;


END//
DELIMITER ;

CALL SP_CODIGO_CLIENTE(3,@P_FECHA,@P_CAMPO_NUMERO);
EXECUTE 
SELECT @P_FECHA,@P_CAMPO_NUMERO ;



