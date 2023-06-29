use exchange;

DELIMITER //
-- DROP PROCEDURE IF EXISTS SP_SORT;
CREATE PROCEDURE SP_SORT(INOUT PARAM_TABLA VARCHAR(32), INOUT PARAM_ORDENAR VARCHAR(32), INOUT PARAM_ASC_DESC VARCHAR(32))
BEGIN
    SET @t1 = CONCAT('SELECT * FROM ', PARAM_TABLA, ' U ORDER BY ', PARAM_ORDENAR, ' ', PARAM_ASC_DESC);
    PREPARE param_stmt FROM @t1;
    EXECUTE param_stmt;
    DEALLOCATE PREPARE param_stmt;
END //
DELIMITER ;
SET @PARAM_TABLA = 'USER';
SET @PARAM_ORDENAR = 'FirstName';
SET @PARAM_ASC_DESC = 'DESC';
CALL SP_SORT(@PARAM_TABLA, @PARAM_ORDENAR, @PARAM_ASC_DESC);

DELIMITER //
-- DROP PROCEDURE IF EXISTS SP_GetUsersWithWalletBalanceAboveThreshold;
CREATE PROCEDURE SP_GetUsersWithWalletBalanceAboveThreshold(IN threshold DECIMAL)
BEGIN
  SELECT U.UserId, CONCAT(U.FirstName, ' ', U.LastName) AS FullName, W.Balance AS WalletBalance
  FROM User U
  INNER JOIN Wallet W ON U.UserId = W.UserId
  WHERE W.Balance > threshold;
END  //
DELIMITER ;
SET @PARAM_UMBRAL = 0;
CALL SP_GetUsersWithWalletBalanceAboveThreshold(@PARAM_UMBRAL);

DELIMITER //
-- DROP PROCEDURE IF EXISTS SP_INSERT_DELETE;
CREATE PROCEDURE SP_INSERT_DELETE (
    IN nombreTabla VARCHAR(30),
    IN campoOrderBy VARCHAR(30),
    IN orderByTipo VARCHAR(4),
    IN agregarOEliminar VARCHAR(20),
    IN agregarPriNombre VARCHAR(50),
    IN agregarSegNombre VARCHAR(50),
    IN agregarCelular VARCHAR(50),
    IN agregarEdad SMALLINT,
    IN agregarMail VARCHAR(100),
    IN agregarClave VARCHAR(50),
    OUT P_SALIDA VARCHAR(150)
)
BEGIN
    SET @P_SALIDA = '';
    SET @query = CONCAT('SELECT fn_p_mensaje(''', nombreTabla, ''') INTO @P_SALIDA');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    IF @P_SALIDA = 'ERROR' THEN
        SET @P_SALIDA = 'FALLA POR PARAMETRO INEXISTENTE';
    ELSE
        SET @P_SALIDA = 'PARAMETROS INGRESADOS CORRECTAMENTE';
    END IF;
    SET @query = CONCAT('SELECT * FROM ', nombreTabla, ' ORDER BY ', campoOrderBy, ' ', orderByTipo);
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    IF agregarOEliminar = 'Insert' THEN
        SET @agregarEliminar = CONCAT('INSERT INTO ', nombreTabla, ' VALUES (NULL, ', agregarMail, ', ', agregarClave, ', ', agregarPriNombre, ', ', agregarSegNombre, ', ', agregarCelular, ', ', agregarEdad, ', "', DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-%d %H:%i:%s'), '", "', DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-%d %H:%i:%s'), '")');
    ELSE
		IF agregarOEliminar = 'Delete' THEN
			SET @agregarEliminar = CONCAT('DELETE FROM ', nombreTabla, ' WHERE EMAIL = ', agregarMail);
		else
			SET @P_SALIDA = 'Error de tipeo, elija 1.Insert o 2.Delete';
		END if;
    END IF;
    PREPARE stmt FROM @agregarEliminar;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;
set @nombreTabla = 'user';
set @campoOrderBy = 'FirstName';
set @orderByTipo = 'asc';
set @agregarOEliminar = 'Insert';
set @agregarPriNombre = '"Martin"';
set @agregarSegNombre = '"Enrique"';
set @agregarCelular = '"8574835498"';
set @agregarEdad = '52';
set @agregarMail = '"Enrique@gmail.com"';
set @agregarClave = '"119Mart"';
CALL SP_INSERT_DELETE (@nombreTabla, @campoOrderBy, @orderByTipo, @agregarOEliminar,@agregarPriNombre,
@agregarSegNombre, @agregarCelular, @agregarEdad, @agregarMail, @agregarClave, @P_SALIDA);
SELECT * FROM USER;