-- CREATE SOURCE DATABASE
CREATE DATABASE financial_transactions_db;
GO

-- USE THE SOURCE DATABASE
USE financial_transactions_db;
GO

-- CREATE THE TRANSACTIONS TABLE
CREATE TABLE financial_transactions(
	transaction_id INT PRIMARY KEY,
	customer_id INT,
	supplier_name VARCHAR(50),
	transaction_date DATE,
	amount DECIMAL(10,2),
	currency VARCHAR(10)

);
GO

-- SEED DATA INTO THE TRANSACTIONS TABLE
INSERT INTO financial_transactions(transaction_id, customer_id, supplier_name, transaction_date, amount, currency)
VALUES
	(1, 101, 'XYZ Corp', '2025-12-29', 1000.00, 'USD'),
	(2, 102, 'HZM Holdings', '2022-12-24', 1500.45, 'EUR'),
	(3, 103, 'ABC Inc', '2021-09-12', 2000.00, 'GBP'),
	(4, 104, 'ABW Ltd', '2020-03-29', 500.95, 'USD');

