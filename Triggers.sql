use exchange;

-- Se activa después de una inserción en la tabla Transaction.
-- Recupera el monto y el saldo de la billetera de destino de la transacción. Actualiza
-- la tabla Account agregando el monto de la transacción al saldo de la cuenta del usuario.
-- Por último, actualiza la tabla Wallet agregando el monto de la transacción al saldo de la billetera de destino.
CREATE TRIGGER trg_update_account_balance
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
    DECLARE amount DECIMAL(10, 8);
    DECLARE balance DECIMAL(10, 8);
    -- Obtengo la cantidad y el balance de la billetera destino de la transaccion
    SELECT NEW.Amount, Balance
    INTO amount, balance
    FROM Wallet
    WHERE WalletId = NEW.DestinationWalletId;
    -- Actualizo el balance de la cuenta
    UPDATE Account
    SET Balance = Balance + amount
    WHERE UserId = (SELECT UserId FROM Wallet WHERE WalletId = NEW.DestinationWalletId);
    -- Actualizo el balance de la billetera
    UPDATE Wallet
    SET Balance = balance + amount
    WHERE WalletId = NEW.DestinationWalletId;
END;

-- Se activa antes de una actualización en la tabla Account.
-- Recupera el saldo mínimo permitido para la cuenta, que se calcula como 0.1 veces el precio
-- máximo de las operaciones asociadas con la billetera de origen del usuario. Si el saldo
-- actualizado cae por debajo del saldo mínimo, se genera un error utilizando la instrucción SIGNAL

CREATE TRIGGER trg_enforce_minimum_balance
BEFORE UPDATE ON Account
FOR EACH ROW
BEGIN
    DECLARE min_balance DECIMAL(10, 8);
    -- Obtengo el balance minimo permitido para la cuenta
    SELECT 0.1 * MAX(Trade.Price)
    INTO min_balance
    FROM Trade
    WHERE OriginWalletId = (SELECT WalletId FROM Wallet WHERE UserId = NEW.UserId)
    GROUP BY OriginWalletId;
    -- Consulto si el nuevo balance se encuentra debajo del umbral
    IF NEW.Balance < min_balance THEN
        SIGNAL SQLSTATE '3000'
            SET MESSAGE_TEXT = 'No se llego al valor minimo de la cuenta';
    END IF;
END;