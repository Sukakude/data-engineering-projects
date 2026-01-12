from api_request import mock_fetch_data, fetch_data

import psycopg2


def connect_to_database():
    print('Connecting to database...')
    try:
        conn = psycopg2.connect(
            host='db',
            port=5432,
            dbname='db',
            user='admin',
            password='admin'
        )
        print('Connected successfully to database...')
        return conn
    except psycopg2.Error as e:
        print('Error in connect_to_database: {}'.format(e))
        raise e

def create_table(conn):
    print('Creating table...')
    try:
        cursor = conn.cursor()
        
        cursor.execute('''
            CREATE SCHEMA IF NOT EXISTS dev;
            
            CREATE TABLE IF NOT EXISTS dev.weather(
                id SERIAL PRIMARY KEY,
                city TEXT,
                temperature FLOAT,
                weather_descriptions TEXT,
                wind_speed FLOAT,
                time TIMESTAMP,
                inserted_at TIMESTAMP DEFAULT NOW(),
                utc_offset TEXT
            );               
        ''')
        conn.commit()
        
        print('Success! Table has been created...')
    except psycopg2.Error as e:
        print('Error in create_table: {}'.format(e))
        raise e

def insert_records(conn, data):
    print('Inserting data into the database....')
    try:
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO dev.weather(
                city,
                temperature,
                weather_descriptions,
                wind_speed,
                time,
                inserted_at,
                utc_offset
            ) VALUES (%s, %s, %s, %s, %s, NOW(), %s)               
        """, (
            data['location']['name'],
            data['current']['temperature'],
            data['current']['weather_descriptions'][0],
            data['current']['wind_speed'],
            data['location']['localtime'],
            data['location']['utc_offset']
        ))
        conn.commit()
        print('Success! Data inserted into the table...')
    except psycopg2.Error as e:
        print('Error in insert_records: {}'.format(e))
        raise e

def main():
    try:
        # FETCH DATA FROM API
        # data = mock_fetch_data()
        data = fetch_data()
        
        # CONNECT TO DATABASE
        conn = connect_to_database()
        
        # CREATE TABLE IF THEY DO NOT EXIST
        create_table(conn)
        
        # INSERT DATA INTO DATABASE TABLE
        insert_records(conn, data)
    except Exception as e:
        print('Error in main: {}'.format(e))
        raise e
    finally:
        if 'conn' in locals():
            conn.close()
            print('Database connection closed...')