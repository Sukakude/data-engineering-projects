import logging
import time

import json
import requests
from requests.exceptions import RequestException, ConnectionError, Timeout

# URL FOR THE API
API_URL = 'https://fakeapi.net/'

def exponential_backoff(attempt, max_retries):
    """
    This function is responsible for attempting to make a request to an API while increasing the delay between retries.

    Parameters:
        - attempt: Number of times the request has been attempted
        - max_retries: Maximum number of retries
    
    Returns:
        - None
    """
    if attempt == max_retries - 1:
        raise
    time.sleep(2 ** attempt)

def fetch_orders(max_retries=3):
    """
    This function is responsible for fetching all the order data from an application programming interface (API). 
    The API is paginated, which means that it only returns a subset of the total data per request.

    Parameters:
        - None

    Returns:
        - data: This is the orders data
    """
    for attempt in range(max_retries):
        print(f'Attempt {attempt} to fetch_orders data from {API_URL}')
        try:
            all_orders = []
            page = 1
            limit = 10

            while True:
                # API CALL
                response = requests.get(
                    API_URL + 'orders',
                    params={"page": page, "limit": limit}
                )
                response.raise_for_status()

                # FORMAT THE DATA INTO JSON
                response = response.json()
                all_orders.extend(response['data'])
                total_orders = response['pagination']['total']

                # CHECK IF THE WE HAVE REACHED MAX LENGTH OF THE DATA IN THE DATABASE
                if (page * limit) > total_orders:
                    break

                page = page + 1

            print('Orders fetched successfully!')
            logging.info('Orders fetched successfully!')
            return all_orders
            
        except RequestException as request_error:
            logging.error(f'API request failed: {request_error}')
            print(f'API request failed: {request_error}')
            exponential_backoff(attempt, max_retries)

        except Timeout as timeout_error:
            print(f'Request timed out: {timeout_error}')
            logging.error(f'Request timed out: {timeout_error}')
            exponential_backoff(attempt, max_retries)

        except ConnectionError as connection_error:
            print(f'Network connection failed: {connection_error}')
            logging.error(f'Network connection failed: {connection_error}')
            exponential_backoff(attempt, max_retries)

        except ValueError as value_error:
            print(f'Invalid response: {value_error}')
            logging.error(f'Invalid response: {value_error}')
            exponential_backoff(attempt, max_retries)
        
        except requests.HTTPError as http_error:
            print(f'An HTTP error occurred: {http_error}')
            logging.error(f'An HTTP error occurred: {http_error}')
            exponential_backoff(attempt, max_retries)

def fetch_products(max_retries=3):
    """
    This function is responsible for fetching all the products data from an application programming interface (API). 
    The API is paginated, which means that it only returns a subset of the total data per request.

    Parameters:
        - None

    Returns:
        - data: This is the products data
    """
    for attempt in range(max_retries):
        print(f'Attempt {attempt} to fetch products data from {API_URL}')
        try:
            all_products = []
            page = 1
            limit = 10

            while True:
                # API CALL
                response = requests.get(
                    API_URL + 'products',
                    params={"page": page, "limit": limit}
                )
                response.raise_for_status()

                # FORMAT THE DATA INTO JSON
                response = response.json()
                all_products.extend(response['data'])
                total_products = response['pagination']['total']

                # CHECK IF THE WE HAVE REACHED MAX LENGTH OF THE DATA IN THE DATABASE
                if (page * limit) > total_products:
                    break

                page = page + 1

            print(f'Products fetched successfully!')
            logging.info(f'Products fetched successfully!')

            return all_products
            
        except RequestException as request_error:
            logging.error(f'API request failed: {request_error}')
            print(f'API request failed: {request_error}')
            exponential_backoff(attempt, max_retries)

        except Timeout as timeout_error:
            print(f'Request timed out: {timeout_error}')
            logging.error(f'Request timed out: {timeout_error}')
            exponential_backoff(attempt, max_retries)

        except ConnectionError as connection_error:
            print(f'Network connection failed: {connection_error}')
            logging.error(f'Network connection failed: {connection_error}')
            exponential_backoff(attempt, max_retries)

        except ValueError as value_error:
            print(f'Invalid response: {value_error}')
            logging.error(f'Invalid response: {value_error}')
            exponential_backoff(attempt, max_retries)
        
        except requests.HTTPError as http_error:
            print(f'An HTTP error occurred: {http_error}')
            logging.error(f'An HTTP error occurred: {http_error}')
            exponential_backoff(attempt, max_retries)

def fetch_users(max_retries=3):
    """
    This function is responsible for fetching all the users data from an application programming interface (API). 
    The API is paginated, which means that it only returns a subset of the total data per request.

    Parameters:
        - None

    Returns:
        - data: This is the users data
    """
    for attempt in range(max_retries):
        print(f'Attempt {attempt} to fetch users data from {API_URL}')
        try:
            all_users = []
            page = 1
            limit = 10

            while True:
                # API CALL
                response = requests.get(
                    API_URL + 'users',
                    params={"page": page, "limit": limit}
                )
                response.raise_for_status()

                # FORMAT THE DATA INTO JSON
                response = response.json()
                all_users.extend(response['data'])
                total_users = response['pagination']['total']

                # CHECK IF THE WE HAVE REACHED MAX LENGTH OF THE DATA IN THE DATABASE
                if (page * limit) > total_users:
                    break

                page = page + 1

            print('Users data fetched successfully!')
            logging.info('Users data fetched successfully!')

            return all_users
            
        except RequestException as request_error:
            logging.error(f'API request failed: {request_error}')
            print(f'API request failed: {request_error}')
            exponential_backoff(attempt, max_retries)

        except Timeout as timeout_error:
            print(f'Request timed out: {timeout_error}')
            logging.error(f'Request timed out: {timeout_error}')
            exponential_backoff(attempt, max_retries)

        except ConnectionError as connection_error:
            print(f'Network connection failed: {connection_error}')
            logging.error(f'Network connection failed: {connection_error}')
            exponential_backoff(attempt, max_retries)

        except ValueError as value_error:
            print(f'Invalid response: {value_error}')
            logging.error(f'Invalid response: {value_error}')
            exponential_backoff(attempt, max_retries)
        
        except requests.HTTPError as http_error:
            print(f'An HTTP error occurred: {http_error}')
            logging.error(f'An HTTP error occurred: {http_error}')
            exponential_backoff(attempt, max_retries)

# UNCOMMENT LINES BELOW TO DEBUG
"""
if __name__ == "__main__":
    data = fetch_orders()
    print(data)
"""