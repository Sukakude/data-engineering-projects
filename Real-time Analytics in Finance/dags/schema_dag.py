from datetime import datetime, timedelta
from airflow import DAG

from airflow.providers.standard.operators.python import PythonOperator
from airflow.providers.docker.operators.docker import DockerOperator

from pinot_schema_operator import PinotSchemaSubmitOperator

import os

PINOT_API_URL = os.getenv("PINOT_API_URL")
PINOT_PORT = os.getenv("PINOT_PORT")

default_args = {
    'description':'This DAG is responsible for uploading the schemas in a folder in Apache Pinot',
    'start_date':datetime(2026, 2, 27),
    'depends_on_past': False,
    'backfill': False,
}

with DAG(
    dag_id='schema_dag',
    dag_display_name='schema_dag',
    default_args=default_args,
    schedule=timedelta(days=1),
    tags=['dimensions']
) as dag:
    upload_schema = PinotSchemaSubmitOperator(
        task_id='submit_schemas',
        folder_path='/opt/airflow/dags/schemas', # this is the folder where the schemas will be stored in Airflow
        pinot_url=f'{PINOT_API_URL}:{PINOT_PORT}/schemas' # pinot broker url
    )

    upload_schema