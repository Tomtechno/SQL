/* *****************************************************************************************   */
/* ******************************   DCL DATA CONTROL LENGUAJE   ****************************   */
/* *****************************************************************************************   */
/* *****************************************************************************************   */
use sys;
show tables;
select * from sys_config;
select * from session;
select * from version ;
select * from host_summary;

use mysql ;
show tables ;
select * from db;
select * from user where user = 'clase_dcl_43410';
select * from server_cost ;


-- creación 
create user if not exists user@host identified by 'mypaswword' ;
create user if not exists 'clase_dcl'@'mimaquina' identified by 'contraseña' ; 
create user if not exists 'clase_dcl'@'137.0.0.1:3306' identified by 'contraseña' ; 
alter user user@host identified by 'mynewpaswwordd' ;
create user if not exists 'clase_dcl_43410'@'localhost' identified by 'abc123' ;
flush privileges; -- refrescar los permisos de mysql

rename user user@host to usuarios@localhost;
select * from user  where user like '%usuarios%';
-- $A$005$`DSmq6%B]o^ZL06Y|LbjS7mPycKf7JHLaAXgOShqrEhSYWpZYRHTdeeiaqXk3 
drop user usuarios@localhost;



select * from user where user not like '%mysql%'  and   user not like '%root%'  ;

drop user 'clase_dcl_43410'@'localhost' ;
-- permisos 
show grants for newuser@localhost ;
show grants for 'clase_dcl_43410'@'localhost';
show grants for root@localhost ; -- es el unico que debe tener permiso de todo.

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, 
      RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, 
      INDEX, ALTER, SHOW DATABASES, SUPER, 
      CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, 
      REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW,
      SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, 
      CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE,
      CREATE ROLE, DROP ROLE ON *.* TO `clase_dcl_43410`@`localhost` WITH GRANT OPTION;


grant all on *.* to 'clase_dcl_43410'@'localhost'; -- objetos.dominio
grant all on gammers.class to 'clase_dcl_43410'@'localhost' ; 
grant all on gammers.comment to 'clase_dcl_43410'@'localhost' ; 
grant all on gammers.* to 'clase_dcl_43410'@'localhost' ; 
select * from user ;

-- 
grant select on clase_8.area to 'clase_dcl_43410'@'localhost' ;  
 grant select , delete on clase_8.area to 'clase_dcl_43410'@'localhost' ;   
grant select ,update on clase_8.area to newuser@localhost ; 

grant  insert on clase_8.area to newuser@localhost ; 

grant update ,  select (id_provincia)
on clase_8.provincia to newuser@localhost ;  -- permisos  sobre columnas

GRANT UPDATE, SELECT (description) 
ON gammers.level_game 
TO newuser@localhost;

show grants for newuser@localhost ; 

revoke all on *.*  from 'clase_dcl_43410'@'localhost'  ; -- quitar todos los permisos 

revoke select on clase_8.area to 'clase_dcl_43410'@'localhost' ;  
 revoke select , delete on clase_8.area to 'clase_dcl_43410'@'localhost' ;   
revoke select ,update on clase_8.area to newuser@localhost ; 

show grants for newuser@localhost ; 

revoke update on *.*  from newuser@localhost ;