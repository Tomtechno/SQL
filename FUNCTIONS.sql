USE exchange;

-- Calcula el balance total de las billeteras dado un user_id
DROP FUNCTION IF EXISTS CalculateTotalWalletBalance;
DELIMITER $$
CREATE FUNCTION CalculateTotalWalletBalance(user_id INT)
RETURNS DECIMAL
DETERMINISTIC
BEGIN
  DECLARE total_balance DECIMAL;
SELECT 
    SUM(Balance)
INTO total_balance FROM
    Wallet
WHERE
    UserId = user_id;
  RETURN total_balance;
END $$
DELIMITER ;
SELECT UserId, CalculateTotalWalletBalance(UserId) AS TotalBalance
FROM User;


-- Calcula el monto total de las transacciones para un userId dado. Solo considera las transacciones que superan
-- el valor umbral denominado threshhold
DROP FUNCTION IF EXISTS CalculateUserSpent;
DELIMITER $$
CREATE FUNCTION CalculateUserSpent(userId INT, threshold DECIMAL)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE totalSpent DECIMAL(10, 2);
    SELECT SUM(Trade.Amount * Trade.Price)
    INTO totalSpent
    FROM Wallet
    INNER JOIN Trade ON Wallet.WalletId = Trade.OriginWalletId
    WHERE Wallet.UserId = userId;
    IF totalSpent >= threshold THEN
        RETURN totalSpent;
    ELSE
        RETURN 0.0;
    END IF;
END $$
DELIMITER ;
SELECT User.FirstName, User.LastName, CalculateUserSpent(User.UserId, 150) AS Spent
FROM User;