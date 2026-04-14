# Real-time Analytics in Finance

## Project Overview
This project implements a real-time data pipeline and analytics solution for financial data. It combines **Airflow**, **Kafka**, **Pinot**, **Superset**, and **Trino** to ingest, process, store, and visualize financial transactions in real time.

## Tech Stack
- **Apache Airflow** – workflow orchestration
- **Apache Kafka** – real-time data streaming
- **Apache Pinot** – real-time OLAP datastore
- **Apache Superset** – data visualization
- **Trino** – distributed SQL query engine
- **Docker & Docker Compose** – containerization and orchestration

## How It Works
1. Data ingestion: Backend scripts generate and push financial data into Kafka.
2. ETL with Airflow: DAGs transform and load data into Pinot.
3. Querying with Trino: Unified SQL access across data sources.
4. Visualization with Superset: Dashboards for real-time analytics.

## Use Cases
- Monitor real-time sales transactions
- Track customer and store performance
- Generate dimensional and fact tables for BI analysis