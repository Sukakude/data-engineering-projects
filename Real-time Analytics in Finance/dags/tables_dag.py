from datetime import datetime, timedelta
from airflow import DAG

from airflow.providers.standard.operators.python import PythonOperator
from airflow.providers.docker.operators.docker import DockerOperator

from pinot_table_operator import PinotTableSubmitOperator

import os

PINOT_API_URL = os.getenv("PINOT_API_URL")
PINOT_PORT = os.getenv("PINOT_PORT")

default_args = {
    'owner': 'sukakude',
    'depends_on_past': False,
    'backfill': False,
}

with DAG(
    dag_id='table_dag',
    dag_display_name='table_dag',
    description='This DAG is responsible for uploading the tables in a folder in Apache Pinot',
    default_args=default_args,
    schedule=timedelta(days=1),
    start_date=datetime(2026, 2, 27),
    tags=['dimensions']
) as dag:
    upload_table = PinotTableSubmitOperator(
        task_id='submit_tables',
        folder_path='/opt/airflow/dags/tables', # this is the folder where the schemas will be stored in Airflow
        pinot_url=f'{PINOT_API_URL}:{PINOT_PORT}/tables' # pinot broker url
    )

    upload_table