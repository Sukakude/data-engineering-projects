import glob
from typing import Any

from airflow.models import BaseOperator
from airflow.plugins_manager import AirflowPlugin
import requests

class PinotSchemaSubmitOperator(BaseOperator):

    def __init__(self, folder_path, pinot_url, *args, **kwargs):
        super(PinotSchemaSubmitOperator, self).__init__(*args, **kwargs)
        self.folder_path = folder_path
        self.pinot_url = pinot_url

    def execute(self, context) -> Any:
        try:
            # GETS THE FOLDER PATH AND ALL JSON FILES
            schema_files = glob.glob(f'{self.folder_path}/*.json')

            for schema_file in schema_files:
                with open(schema_file, 'r') as file:
                    # READ THE CONTENTS OF THE FILE
                    schema_data = file.read()
                    
                    # DEFINE THE HEADERS TO MAKE A HTTP-REQUEST TO PINOT
                    headers = {
                        'Content-Type':'application/json',
                    }

                    # SEND A POST REQUEST
                    response = requests.post(
                        url=self.pinot_url,
                        headers=headers,
                        data=schema_data
                    )

                    # CHECK IF THE RESPONSE WAS SUCCESSFUL
                    if response.status_code == 200:
                        self.log.info(f'Good News! Schema successfully sent to Apache Pinot!')
                    else:
                        self.log.error(f'{response.status_code} Oops! Failed to send schema: {response.text} ')
                        raise Exception(f'Schema submission failed with status code: {response.status_code}')
        except Exception as e:
            self.log.error(f'Error occurred: {str(e)}')

class PinotSchemaPlugin(AirflowPlugin):
    """
    This class is responsible for ensuring that making an operator to an Airflow plugin to be refenced it in a DAG to avoid import errors
    """
    name="pinot_schema_plugin"
    operators = [PinotSchemaSubmitOperator]