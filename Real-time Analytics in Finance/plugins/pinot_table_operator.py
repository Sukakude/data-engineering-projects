import glob

from airflow.models import BaseOperator
from airflow.plugins_manager import AirflowPlugin
import requests

class PinotTableSubmitOperator(BaseOperator):
    def __init__(self, folder_path, pinot_url, *args, **kwargs):
        super(PinotTableSubmitOperator, self).__init__(*args, **kwargs)
        self.folder_path = folder_path
        self.pinot_url = pinot_url

    def execute(self, context) -> any:
        try:
            # GETS THE FOLDER PATH AND ALL JSON FILES
            table_files = glob.glob(f'{self.folder_path}/*.json')

            for table_file in table_files:
                with open(table_file, 'r') as file:
                    # READ THE CONTENTS OF THE FILE
                    table_data = file.read()
                    
                    # DEFINE THE HEADERS TO MAKE A HTTP-REQUEST TO PINOT
                    headers = {
                        'Content-Type':'application/json',
                    }

                    # SEND A POST REQUEST
                    response = requests.post(
                        url=self.pinot_url,
                        headers=headers,
                        data=table_data
                    )

                    # CHECK IF THE RESPONSE WAS SUCCESSFUL
                    if response.status_code == 200:
                        self.log.info(f'Good News! Table successfully sent to Apache Pinot!')
                    else:
                        self.log.error(f'{response.status_code} Oops! Failed to send table: {response.text} ')
                        raise Exception(f'Table submission failed with status code: {response.status_code}')
        except Exception as e:
            self.log.error(f'Error occurred: {str(e)}')

class PinotTablePlugin(AirflowPlugin):
    """
    This class is responsible for ensuring that making an operator to an Airflow plugin to be refenced it in a DAG to avoid import errors
    """
    name="pinot_table_plugin"
    operators = [PinotTableSubmitOperator]