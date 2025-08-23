/*
  The purpose of this script is to create a new database called 'DataWarehouse'. It checks if the database exists, and if it does, it will remove the database and recreate it.
  Thereafter, the script creates three schemas within the database called 'Bronze', 'Silver', 'Gold'.

  !IMPORTANT
    Please note that running this script will delete the database if it exists, and all the data in the database will be permanently removed.
    Please proceed with caution and ensure that you have proper backup measures in place before running this script.
*/

-- CREATE DATABASE
USE master;

--CHECK IF DATABASE EXISTS
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;
END;
GO
-- Creates the database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO
-- CREATE SCHEMA FOR Bronze layer
CREATE SCHEMA Bronze;
GO
-- CREATE SCHEMA FOR Silver layer
CREATE SCHEMA Silver;
GO
-- CREATE SCHEMA FOR Gold layer
CREATE SCHEMA Gold;
GO
