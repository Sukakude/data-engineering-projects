from airflow import DAG
from airflow.providers.standard.operators.python import PythonOperator
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount

from datetime import datetime, timedelta
import sys

sys.path.append('/opt/airflow/api-request')

def ingest_data():
    from insert_records import main as ingest_weather_data
    return ingest_weather_data()

default_args = {
    'description': 'DAG for orchestrating data',
    'start_date': datetime(2026, 1, 7),
    'catchup':False
}

with DAG(
    dag_id='weather-api-dbt-orchestrator',
    default_args=default_args,
    schedule=timedelta(minutes=5) # our weather data is updated every 5 minutes
) as dag:
    data_task = PythonOperator(
        task_id='ingest_data_task',
        python_callable=ingest_data,
        retries=3,
        retry_delay=timedelta(seconds=30)
    )
    
    dbt_task = DockerOperator(
        task_id='transform_data_task',
        image='ghcr.io/dbt-labs/dbt-postgres:1.9.latest',
        command='run',
        working_dir='/usr/app',
        mounts=[
            Mount(
                source='/home/user/repos/weather-data-automation/dbt/my_project',
                target='/usr/app',
                type='bind'
            ),
            Mount(
                source='/home/user/repos/weather-data-automation/dbt',
                target='/root/.dbt/',
                type='bind'
            )  
        ],
        network_mode='weather-data-automation_my_network',
        docker_url='unix://var/run/docker.sock',
        auto_remove='success',
        retries=2,
        retry_delay=timedelta(seconds=30)
    )
    
data_task >> dbt_task