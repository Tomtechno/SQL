DROP DATABASE IF EXISTS exchange;
CREATE DATABASE exchange;
USE exchange;

CREATE TABLE User (
  UserId INT auto_increment PRIMARY KEY,
  Email VARCHAR(100) UNIQUE NOT NULL,
  Passwords VARCHAR(50) NOT NULL,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  PhoneNumber VARCHAR(50) NOT NULL,
  Age SMALLINT NOT NULL CHECK (Age>=18),
  CreatedTime DATETIME,
  LastUpdatedTime DATETIME
);

CREATE TABLE Currency (
	CurrencyId INT auto_increment PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Symbol VARCHAR(10) NOT NULL,
	CreatedTime DATETIME,
	LastUpdatedTime DATETIME
);

CREATE TABLE Account (
	AccountId INT auto_increment PRIMARY KEY,
    UserId INT,
    CurrencyId INT,
    Balance DECIMAL(18, 8) NOT NULL,
	CreatedTime DATETIME,
	LastUpdatedTime DATETIME,
    FOREIGN KEY (UserId) REFERENCES User (UserId),
	FOREIGN KEY (CurrencyId) REFERENCES Currency (CurrencyId)
);

CREATE TABLE Wallet (
	WalletId INT auto_increment  PRIMARY KEY,
    UserId INT,
    CurrencyId INT,
    Balance DECIMAL(18, 8) NOT NULL,
	CreatedTime DATETIME,
	LastUpdatedTime DATETIME,
    FOREIGN KEY (UserId) REFERENCES User (UserId),
	FOREIGN KEY (CurrencyId) REFERENCES Currency (CurrencyId)
);

CREATE TABLE Transaction (
	TxId INT auto_increment PRIMARY KEY,
    OriginWalletId INT,
    DestinationWalletId INT,
    FeeCurrencyId INT,
	Amount DECIMAL(18, 8) NOT NULL,
	FeeAmount DECIMAL(18, 8) NOT NULL,
	CreatedTime DATETIME,
	LastUpdatedTime DATETIME,
	FOREIGN KEY (OriginWalletId) REFERENCES Wallet (WalletId),
	FOREIGN KEY (DestinationWalletId) REFERENCES Wallet (WalletId),
	FOREIGN KEY (FeeCurrencyId) REFERENCES Currency (CurrencyId)
);

CREATE TABLE MarketPair (
	MarketPairId INT auto_increment PRIMARY KEY,
    BaseCurrencyId INT NOT NULL,
    QuoteCurrencyId INT NOT NULL,
	CreatedTime DATETIME,
	LastUpdatedTime DATETIME,
	FOREIGN KEY (BaseCurrencyId) REFERENCES Currency (CurrencyId),
	FOREIGN KEY (QuoteCurrencyId) REFERENCES Currency (CurrencyId)
);

CREATE TABLE TradeOrder (
	OrderId INT auto_increment PRIMARY KEY,
	UserId INT,
	MarketPairId INT,
    BaseCurrencyId INT,
    QuoteCurrencyId INT,
	Side VARCHAR(10) NOT NULL,
	OrderType VARCHAR(10) NOT NULL,
	OrderStatus VARCHAR(20) NOT NULL,
	CreatedTime DATETIME,
	LastUpdatedTime DATETIME,
	FOREIGN KEY (UserId) REFERENCES User (UserId),
	FOREIGN KEY (MarketPairId) REFERENCES MarketPair (MarketPairId),
	FOREIGN KEY (BaseCurrencyId) REFERENCES MarketPair (BaseCurrencyId),
	FOREIGN KEY (QuoteCurrencyId) REFERENCES MarketPair (QuoteCurrencyId)
);

CREATE TABLE Trade (
	TradeId INT auto_increment PRIMARY KEY,
	OrderId INT,
    OriginWalletId INT,
    DestinationWalletId INT,
    FeeCurrencyId INT,
	Amount DECIMAL(18, 8) NOT NULL,
    Price DECIMAL(18, 8) NOT NULL,
	FeeAmount DECIMAL(18, 8) NOT NULL,
	CreatedTime DATETIME,
	LastUpdatedTime DATETIME,
	FOREIGN KEY (OrderId) REFERENCES TradeOrder (OrderId),
	FOREIGN KEY (OriginWalletId) REFERENCES Wallet (WalletId),
	FOREIGN KEY (DestinationWalletId) REFERENCES Wallet (WalletId),
	FOREIGN KEY (FeeCurrencyId) REFERENCES Currency (CurrencyId)
);

CREATE TABLE IF NOT EXISTS LOG_AUDITORIA (
	IdLog  INT AUTO_INCREMENT ,
	CAMPONUEVO_CAMPOANTERIOR VARCHAR(50),
	NOMBRE_DE_ACCION VARCHAR(10) ,
	NOMBRE_TABLA VARCHAR(50) ,
	USUARIO VARCHAR(50) ,
	FECHA_UPD_INS_DEL DATE ,
	PRIMARY KEY (ID_LOG)
);

CREATE TABLE IF NOT EXISTS LOG_AUDITORIA (
	IdLog INT AUTO_INCREMENT ,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Email VARCHAR(50),
	Accion VARCHAR(10) ,
	Tabla VARCHAR(50) ,
	Usuario VARCHAR(50) ,
	FechaUpdate DATE ,
	PRIMARY KEY (ID_LOG)
);