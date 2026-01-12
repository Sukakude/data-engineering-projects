import requests
import json

API_KEY = '<YOUR_API_KEY>'
CITY_NAME = '<YOUR_CITY>'
API_URL = f'http://api.weatherstack.com/current?access_key={API_KEY}&query={CITY_NAME}'

def fetch_data():
    """
    This functi
    """
    try:
        print('Fetching weather data from WeatherStack...')
        
        res = requests.get(API_URL)
        res.raise_for_status() # error handling
        
        if res.status_code == 200:
            data = res.json()
        
        print('Data fetched successfully...')
        
        return data
    except requests.exceptions.RequestException as e:
        print('Error in fetch_data: {}'.format(e))
        raise e
            
    
