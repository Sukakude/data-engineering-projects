from airflow import DAG
from airflow.providers.standard.operators.python import PythonOperator
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount

from datetime import datetime, timedelta
import sys

sys.path.append('/opt/airflow/ingestion')

from load_staging import main as load_staging_data

def ingest_data():
    return load_staging_data()

default_args = {
    'description': 'This is a DAG that will perform the ETL tasks',
    'start_date':datetime(2026, 1, 30),
    'catchup':False
}

with DAG(
    dag_id='ecommerce_dag',
    default_args=default_args,
    schedule='@daily'
) as dag:
    # TASK RESPONSIBLE FOR INGESTING THE DATA FROM API TO STAGING TABLES
    task_1 = PythonOperator(
        task_id='ingest_data_task',
        python_callable=ingest_data,
        retries=3,
        retry_delay=timedelta(seconds=60)
    )

    # TASK RESPONSIBLE FOR TRANSFORMING THE DATA INTO USABLE FORMATS
    task_2 = DockerOperator(
        task_id='transformation_task',
        image='ghcr.io/dbt-labs/dbt-postgres:1.9.latest',
        command='run',
        mounts=[
            Mount(
                source='/home/tshep/repos/ecommerce-analytics-pipeline/dbt/ecommerce_pipeline',
                target='/usr/app',
                type='bind'
            ),
            Mount(
                source='/home/tshep/repos/ecommerce-analytics-pipeline/dbt',
                target='/root/.dbt',
                type='bind'
            )
        ],
        network_mode='ecommerce-analytics-pipeline_ecommerce_network',
        docker_url='unix://var/run/docker.sock',
        auto_remove='success',
        retries=2,
        retry_delay=timedelta(seconds=30)
    )


task_1 >> task_2