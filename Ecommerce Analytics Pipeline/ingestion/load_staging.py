from fetch_data import fetch_orders, fetch_products, fetch_users, exponential_backoff
import psycopg2
import logging

from dotenv import load_dotenv
import os

load_dotenv()

HOSTNAME=os.getenv('POSTGRES_HOST')
PORT=os.getenv('POSTGRES_PORT')
DBNAME=os.getenv('POSTGRES_DB')
USER=os.getenv('POSTGRES_USER')
PASSWORD=os.getenv('POSTGRES_PASSWORD')

def connect_to_postgres(max_retries=5):
    """
    This function is responsible for connecting to Postgres

    Parameters:
        - max_retries: Maximum number of retries

    Returns:
        - conn: This is the Postgres connection object
    """
    retries = 0

    while retries < max_retries:
        print(f'Connecting to {HOSTNAME} (Attempt {retries}/{max_retries})')
        logging.info(f'Connecting to {HOSTNAME} (Attempt {retries}/{max_retries})')

        try:
            conn = psycopg2.connect(
                host=HOSTNAME,
                port=PORT,
                dbname=DBNAME,
                user=USER,
                password=PASSWORD
            )
            print('Connection successful!')
            logging.info('Connection successful!')

            return conn
        except psycopg2.Error as e:
            print(f'Error in connect_to_postgres: {e}')
            logging.error(f'Error in connect_to_postgres: {e}')

            retries += 1

            exponential_backoff(retries, max_retries)
    print('Max retries reached! Exiting..')
    logging.error('Max retries reached! Exiting..')
    return None

def insert_customers_data(conn, data):
    """
    This function is responsible for inserting the customers data into a table

    Parameters:
        - conn: This is the Postgres connection object.
        - data: This is the customer data to be inserted.

    Returns:
        - None
    """
    print(f'Inserting raw customer data into {DBNAME}')
    try:
        cursor = conn.cursor()

        # EMPTY THE TABLE
        cursor.execute("""TRUNCATE TABLE dev.raw_customers""")

        for customer_data in data:
            # INSERT DATA INTO THE CUSTOMERS TABLE
            cursor.execute("""
                INSERT INTO dev.raw_customers(
                    id,
                    email,
                    username,
                    firstname,
                    lastname,
                    phone,
                    inserted_at                
                ) VALUES (%s, %s, %s, %s, %s, %s, NOW())
            """,
                (customer_data['id'],
                customer_data['email'],
                customer_data['username'],
                customer_data['name']['firstname'],
                customer_data['name']['lastname'],
                customer_data['phone']))

        conn.commit()
        print(f'Data inserted into {DBNAME} successfully!')
    except psycopg2.Error as e:
        print(f'Error while inserting data: {e}')
        logging.error(f'Error while inserting data: {e}')
        raise e

def insert_customer_address_data(conn, data):
    print(f'Inserting raw customer address data into {DBNAME}')
    try:
        cursor = conn.cursor()
        
        cursor.execute("""TRUNCATE TABLE dev.raw_address""")

        for ca in data:
            # INSERT DATA INTO THE ADDRESS TABLE 
            cursor.execute("""
                INSERT INTO dev.raw_address(
                    customer_id,
                    street,
                    city,
                    zipcode,
                    country,
                    inserted_at                
                ) VALUES (%s, %s, %s, %s, %s, NOW())
            """,
                (ca['id'],
                ca['address']['street'],
                ca['address']['city'],
                ca['address']['zipcode'],
                ca['address']['city']))

        conn.commit()
        print(f'Data inserted into {DBNAME} successfully!')
    except psycopg2.Error as e:
        print(f'Error while inserting data: {e}')
        logging.error(f'Error while inserting data: {e}')
        raise e

def insert_products_data(conn, data):
    print(f'Inserting raw products data into {DBNAME}')
    try:
        cursor = conn.cursor()

        cursor.execute("""TRUNCATE TABLE dev.raw_products;""")
        
        for product in data:
            # QUERY TO INSERT DATA INTO THE PRODUCTS TABLE 
            cursor.execute("""
                INSERT INTO dev.raw_products(
                    id,
                    title,
                    price,
                    description,
                    category,
                    brand,
                    stock,
                    image,
                    rating,
                    inserted_at                
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())
            """,
                (product['id'],
                product['title'],
                product['price'],
                product['description'],
                product['category'],
                product['brand'],
                product['stock'],
                product['image'],
                product['rating']['rate']))
    
        conn.commit()
        print(f'Products data inserted into {DBNAME} successfully!')
    except psycopg2.Error as e:
        print(f'Error while inserting data: {e}')
        logging.error(f'Error while inserting data: {e}')
        raise e

def insert_raw_orders_data(conn, data):
    print(f'Inserting raw orders data into {DBNAME}')
    try:
        cursor = conn.cursor()

        cursor.execute("""TRUNCATE TABLE dev.raw_orders""")

        for order in data:
            for idx in range(len(order['products'])):
                # QUERY TO INSERT DATA INTO THE PRODUCTS TABLE 
                cursor.execute("""
                    INSERT INTO dev.raw_orders(
                        customer_id,
                        product_id,
                        quantity,
                        total_amount,
                        status,
                        order_date,
                        delivery_date,
                        inserted_at                
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, NOW())
                """,
                    (
                        order['userId'],
                        order['products'][idx]['productId'],
                        order['products'][idx]['quantity'],
                        order['totalAmount'],
                        order['status'],
                        order['orderDate'],
                        order['deliveryDate']
                    )
                )

        conn.commit()
        print(f'Orders data inserted into {DBNAME} successfully!')
    except psycopg2.Error as e:
        print(f'Error while inserting data: {e}')
        logging.error(f'Error while inserting data: {e}')
        raise e

def main():
    try:
        # GET THE DATA
        orders_data = fetch_orders()
        customers_data = fetch_users()
        products_data = fetch_products()
        
        # CONNECT TO DATABASE
        conn = connect_to_postgres()
        
        # INSERT DATA 
        insert_customers_data(conn, customers_data)
        insert_customer_address_data(conn, customers_data)
        insert_products_data(conn, products_data)
        insert_raw_orders_data(conn, orders_data)

    except Exception as e:
        print('Error in main: {}'.format(e))
        raise e
    finally:
        if 'conn' in locals():
            conn.close()
            print('Database connection closed...')
