#!/bin/bash

# Create admin user
superset fab create-admin --username "$ADMIN_USERNAME" --firstname Superset --lastname Admin --email "$ADMIN_EMAIL" --password "$ADMIN_PASSWORD"

# Upgrade the metastore
superset db upgrade

# Setup roles and permissions
superset superset init

# Start the server
/bin/sh -c /usr/bin/run-server.sh