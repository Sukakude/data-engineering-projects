from typing import Any
from airflow.models import BaseOperator
from kafka import KafkaProducer
from kafka.admin import KafkaAdminClient, NewTopic
import json
import requests

import os

# Get the base url for the sales API
API_URL = os.getenv('BASE_API_URL')
API_PORT = os.getenv('API_PORT')

class KafkaProducerOperator(BaseOperator):
    def __init__(self, kafka_broker, kafka_topic, num_records=100, *args, **kwargs):
        super(KafkaProducerOperator, self).__init__(*args, **kwargs)
        self.kafka_broker = kafka_broker
        self.kafka_topic = kafka_topic
        self.num_records = num_records

    def execute(self, context) -> Any:
        # Create kafka topic
        admin_client = KafkaAdminClient(bootstrap_servers=f"{self.kafka_broker}")
        topic = NewTopic(name=self.kafka_topic, num_partitions=1, replication_factor=1)

        try:
            admin_client.create_topics([topic])
        except Exception as e:
            self.log.info(f"Topic may already exist: {e}")

        admin_client.close()

        # Initialize the Kafka producer
        producer = KafkaProducer(
            bootstrap_servers=self.kafka_broker,
            value_serializer=lambda x: json.dumps(x).encode('UTF-8')
        )

        # Fetch sales data from API
        data = requests.get(f'http://{API_URL}:{API_PORT}/api/sales')
        data = data.json()

        # Send the data to kafka
        for record in data[:self.num_records + 1]:
            producer.send(self.kafka_topic, value=record)
            self.log.info(f'Sales transaction sent: {record}')

        producer.flush()
        self.log.info(f'{self.num_records} sales transactions sent to topic \'{self.kafka_topic}\'')