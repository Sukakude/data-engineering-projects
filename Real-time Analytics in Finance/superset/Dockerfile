FROM apache/superset:latest

USER root

RUN pip install pinotdb
RUN uv pip install sqlalchemy-trino

ENV ADMIN_USERNAME $ADMIN_USERNAME
ENV ADMIN_PASSWORD $ADMIN_PASSWORD
ENV ADMIN_EMAIL $ADMIN_EMAIL

COPY ./superset-init.sh /superset-init.sh

COPY superset_config.py /app/

ENV SUPERSET_CONFIG_PATH /app/superset_config.py

USER superset
ENTRYPOINT ["/superset-init.sh"]