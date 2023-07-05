USE mysql;

-- Se crean los usuarios
CREATE USER IF NOT EXISTS 'user1@localhost' IDENTIFIED BY 'psrd85';
CREATE USER IF NOT EXISTS 'user2@localhost' IDENTIFIED BY 'psswrd33';

-- Se visualiza el contenido en la table user en la db mysql
SELECT * FROM mysql.user WHERE user LIKE '%user1@localhost%';
SELECT * FROM mysql.user WHERE user LIKE '%user2@localhost%';

-- Se verifican los permisos de los usuarios creados (no deberian tener ningun permiso aún)
SHOW GRANTS FOR 'user1@localhost';
SHOW GRANTS FOR 'user2@localhost';

-- Se otorgan los permisos según lo requerido
GRANT SELECT ON exchange.* TO 'user1@localhost';
GRANT SELECT, INSERT, UPDATE ON exchange.* TO 'user2@localhost';

-- Se verifica que los permisos se hayan sido asignados de forma correcta
SHOW GRANTS FOR 'user1@localhost';
SHOW GRANTS FOR 'user2@localhost';

