-- CREATE THE DATAWAREHOUSE DATABASE
CREATE DATABASE financial_data_warehouse;
GO

-- USE THE DATAWAREHOUSE
USE financial_data_warehouse;
GO

-- CLONE THE financial_transactions TABLE from financial_transactions_db DATABASE AND ADD NEW COLUMNS
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[financial_transactions](
	[transaction_id] [int] NOT NULL,
	[customer_id] [int] NULL,
	[supplier_name] [varchar](50) NULL,
	[supplier_contact_name] [varchar](100) NULL,
	[supplier_phone] [varchar](25) NULL,
	[transaction_date] [date] NULL,
	[amount] [decimal](10, 2) NULL,
	[currency] [varchar](10) NULL,
	[customer_name] [varchar](50) NULL,
	[customer_email] [varchar](100) NULL,
	[customer_phone] [varchar](20) NULL,
	[amount_usd] [float] NULL
PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- CREATE A TABLE THAT WILL STORE THE EXCHANGE RATES
CREATE TABLE dbo.exchange_rates(
	from_currency VARCHAR(10),
	to_currency VARCHAR(10),
	exchange_rate FLOAT,
	effective_date DATE
);

-- CREATE A TABLE THAT WILL STORE THE SUPPLIERS
CREATE TABLE dbo.suppliers(
	supplier_id INT PRIMARY KEY,
	supplier_name VARCHAR(100),
	contact_name VARCHAR(100),
	phone VARCHAR(25)
);


SELECT * FROM dbo.financial_transactions;
SELECT * FROM dbo.exchange_rates;
