USE exchange;

mysqldump --no-create-info --skip-triggers --skip-add-drop-table --skip-lock-tables -u root -p exchange > D:\BackupData.sql;
