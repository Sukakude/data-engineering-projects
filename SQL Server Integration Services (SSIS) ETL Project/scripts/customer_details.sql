-- USE THE FINANCIAL TRANSACTIONS DATABASE. MAKE SURE THAT YOU FIRST CREATE THE DATABASE OR ELSE THE LINE BELOW WILL BREAK
USE financial_transactions_db;
GO

-- CREATE THE CUSTOMER DETAILS TABLE
CREATE TABLE customer_details (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);
GO

-- SEED DATA INTO THE CUSTOMER TABLE
INSERT INTO customer_details (customer_id, customer_name, email, phone)
VALUES
    (101, 'John Doe', 'john.doe@example.com', '123-456-7890'),
    (102, 'Jane Smith', 'jane.smith@example.com', '234-567-8901'),
    (103, 'Mike Johnson', 'mike.johnson@example.com', '345-678-9012'),
    (104, 'Emily Davis', 'emily.davis@example.com', '456-789-0123');
