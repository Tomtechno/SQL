USE exchange;

SELECT @@autocommit;
SET @@autocommit = 0;
SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;
DELETE FROM trade WHERE FeeAmount > 0.04;
-- ROLLBACK;
COMMIT;

START TRANSACTION;
INSERT INTO currency (Name, Symbol, CreatedTime, LastUpdatedTime) VALUES ('Cosmos', 'ATOM', '2021-17-06 11:15:00', '2022-04-06 11:15:57');
INSERT INTO currency (Name, Symbol, CreatedTime, LastUpdatedTime) VALUES ('Monero', 'XMR', '2022-02-03 09:30:00', '2023-02-06 09:30:22');
INSERT INTO currency (Name, Symbol, CreatedTime, LastUpdatedTime) VALUES ('TrueUSD', 'TUSD', '2020-11-06 10:00:00', '2022-06-06 10:00:43');
INSERT INTO currency (Name, Symbol, CreatedTime, LastUpdatedTime) VALUES ('Shiba Inu', 'SHIB', '2021-20-11 08:45:00', '2023-02-06 08:45:12');
SAVEPOINT lote_1;
-- RELEASE SAVEPOINT lote_1;
INSERT INTO currency (Name, Symbol, CreatedTime, LastUpdatedTime) VALUES ('Bitcoin Cash', 'BCH', '2022-01-01 11:15:00', '2022-04-06 11:15:51');
INSERT INTO currency (Name, Symbol, CreatedTime, LastUpdatedTime) VALUES ('Polkadot', 'DOT', '2020-02-03 09:30:00', '2023-02-06 09:30:42');
INSERT INTO currency (Name, Symbol, CreatedTime, LastUpdatedTime) VALUES ('Polygon', 'MATIC', '2021-11-06 10:00:00', '2022-06-06 11:00:05');
INSERT INTO currency (Name, Symbol, CreatedTime, LastUpdatedTime) VALUES ('Tron', 'TRX', '2022-20-11 08:45:00', '2023-01-06 09:55:10');
SAVEPOINT lote_2;
-- RELEASE SAVEPOINT lote_2;
-- ROLLBACK TO lote_1;
COMMIT;