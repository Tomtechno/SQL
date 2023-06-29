USE exchange;

CREATE OR REPLACE VIEW VW_Basics AS (
	SELECT FirstName, LastName, Age, CAST(Balance AS DECIMAL(10,2)) AS Balance
     FROM User u JOIN Account a ON (u.userid = a.userid)
     WHERE u.Age >= 35
     ORDER BY 1,2
);
     
CREATE OR REPLACE VIEW VW_Wallet AS (
	SELECT WalletId, SUM(Amount*Price)
	FROM Wallet w JOIN Trade t ON (w.WalletId = t.OriginWalletId)
	GROUP BY OriginWalletId
	ORDER BY WalletId
);
     
CREATE OR REPLACE VIEW VW_Currency_Search AS (
	SELECT Name, Symbol, SUM(FeeAmount) AS FeeAmount  
	FROM Currency c JOIN Transaction t ON (c.CurrencyId = t.FeeCurrencyId)
	WHERE Name LIKE "%coin%"
	GROUP BY CurrencyId
	ORDER BY Name
);
     
CREATE OR REPLACE VIEW VW_Currency AS (
    SELECT Symbol, Name, CAST(SUM(Amount) AS DECIMAL(10,2)) AS Amount 
	FROM Currency c JOIN Transaction t ON (c.CurrencyId = t.FeeCurrencyId)
	GROUP BY CurrencyId
	ORDER BY Symbol
);
     
CREATE OR REPLACE VIEW VW_User_Spent AS (
    SELECT User.FirstName, User.LastName, CAST(SUM(Trade.Amount*Trade.Price) AS DECIMAL(10,2)) AS Spent
	FROM User
	INNER JOIN Wallet ON User.UserId = Wallet.UserId
	INNER JOIN Trade ON Wallet.WalletId = Trade.OriginWalletId
	GROUP BY WalletId
	ORDER BY 3 DESC
);