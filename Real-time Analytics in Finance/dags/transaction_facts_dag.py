from airflow import DAG
from datetime import datetime, timedelta
import sys
import os
from kafka_operator import KafkaProducerOperator

# sys.path.append('/opt/airflow/plugins')

KAFKA_HOST = os.getenv('KAFKA_HOST')
KAFKA_PORT = os.getenv('KAFKA_PORT')
KAFKA_TOPIC = os.getenv('KAFKA_TOPIC')

default_args = {
    'description':'This DAG is responsible for sending the sales transaction to Kafka',
    'start_date':datetime(2026, 2, 27),
    'depends_on_past': False,
    'backfill': False,
}

with DAG(
    dag_id='send_sales_transactions',
    default_args=default_args,
    schedule=timedelta(days=1),
    tags=['fact_sales_data']
) as dag:
    send_sales_data = KafkaProducerOperator(
        task_id='send_sales_transactions_data',
        kafka_broker=f'{KAFKA_HOST}:{KAFKA_PORT}',
        kafka_topic=f'{KAFKA_TOPIC}',
        num_records=100
    )