import pandas as pd
import logging

FOLDER_DIR = './data'

def fetch_customer_data():
    try:
        return pd.read_csv(f'{FOLDER_DIR}/customer.csv')
        pass
    except Exception as e:
        print(f'Error in fetch_customer_data: {e}')
        logging.error(f'Error in fetch_customer_data: {e}')

def fetch_order_lines_data():
    try:
        return pd.read_csv(f'{FOLDER_DIR}/order_lines.csv')
        pass
    except Exception as e:
        print(f'Error in fetch_order_lines_data: {e}')
        logging.error(f'Error in fetch_order_lines_data: {e}')

def fetch_sales_transactions_data():
    try:
        return pd.read_csv(f'{FOLDER_DIR}/sales_transactions.csv')
        pass
    except Exception as e:
        print(f'Error in fetch_sales_transactions_data: {e}')
        logging.error(f'Error in fetch_sales_transactions_data: {e}')

def fetch_store_data():
    try:
        return pd.read_csv(f'{FOLDER_DIR}/store.csv')
        pass
    except Exception as e:
        print(f'Error in fetch_store: {e}')
        logging.error(f'Error in fetch_store: {e}')

def format_data(df: pd.DataFrame):
    """
    This function is responsible for formatting the data into JSON.

    Parameters:
        - df: Data to be formatted
    
    Returns:
        - formatted_data: List of JSON-formatted data
    """
    # List to hold the formatted data
    formatted_data = []

    try:
        # Check if the dataframe is not empty
        if df is not None:
            # Iterate over each row
            for _, row in df.iterrows():
                # Format the row into JSON
                data = row.to_json()

                # Add the formatted data to the list
                formatted_data.append(data)

            logging.info('Data formatted successfully')
            return formatted_data
        else:
            logging.warning('Warning! Empty data structure passed.')
    except Exception as e:
        print(f'Error in format_data: {e}')


"""
if __name__ == "__main__":
    df = fetch_order_lines_data()
    print(format_data(df))
"""