# Automated Data Pipeline with Airflow, dbt, PostgreSQL & Superset

# High Level Architecture
<img src="./images/Automated Data Pipeline.svg" alt="Architecture Diagram" width="500"/>

## Overview
This repository contains the code to build an **automated data pipeline** using:
- **Apache Airflow** for workflow orchestration & scheduling.
- **dbt** for data transformation.
- **PostgreSQL** for data storage.
- **Apache Superset** for data visualization.

# How it works
<ol>
  <li>Airflows schedules the ingestion and transformation DAGs.</li>
  <li>dbt executes SQL transformations on staging tables.</li>
  <li>PostgreSQL stores the raw and transformed data.</li>
  <li>Finally, we use Superset to visualize the data.</li>
</ol>

# Tech Stack
<ul>
  <li>dbt</li>
  <li>Apache Superset</li>
  <li>Apache Airflow</li>
  <li>PostgreSQL</li>
  <li>WSL (Ubuntu)</li>
  <li>Visual Studio Code</li>
</ul>

# Running the Pipeline
docker-compose up -d
- Visit Airflow UI: http://localhost:8080
- Visit Superset UI: http://localhost:8088

# References
- Video: https://youtu.be/vMgFadPxOLk?si=OzFBL1QvTegbPRkh
- Airflow docs: https://airflow.apache.org/
- dbt docs: https://docs.getdbt.com/
- Superset docs: https://superset.apache.org/
