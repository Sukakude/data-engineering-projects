CREATE SCHEMA IF NOT EXISTS dev;

CREATE TABLE dev.raw_customers(
    id INT,
    email VARCHAR(100),
    username VARCHAR(100),
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    phone VARCHAR(20),
    inserted_at DATE,

    PRIMARY KEY (id)
);

CREATE TABLE dev.raw_address(
    id SERIAL,
    customer_id INT,
    street VARCHAR(100),
    city VARCHAR(100),
    zipcode VARCHAR(20),
    country VARCHAR(100),
    inserted_at DATE,
    
    PRIMARY KEY(id)
);

CREATE TABLE dev.raw_products(
    id INT,
    title VARCHAR(100),
    price DECIMAL,
    description VARCHAR(100),
    category VARCHAR(100),
    brand VARCHAR(100),
    stock INT,
    image VARCHAR(100),
    rating FLOAT,
    inserted_at DATE,

    PRIMARY KEY (id)    
);

CREATE TABLE dev.raw_orders(
    id SERIAL,
    customer_id INT,
    product_id INT,
    quantity INT,
    total_amount DECIMAL,
    status VARCHAR(20),
    order_date DATE,
    delivery_date DATE,
    inserted_at DATE,

    PRIMARY KEY (id)
);