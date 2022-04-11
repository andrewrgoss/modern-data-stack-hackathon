#!/usr/bin/env bash
up() {

  echo "Starting Postgres instance..."
  docker stop postgres
  docker run --rm --name postgres -e POSTGRES_PASSWORD=password -p 2000:5432 -d postgres

  echo "Starting Airbyte..."
  docker-compose -f airbyte/docker-compose-airbyte.yaml down -v
  docker-compose -f airbyte/docker-compose-airbyte.yaml up -d

  # echo "Starting Airflow..."
  # cd airflow
  # docker-compose -f docker-compose-airflow.yaml down -v
  # mkdir -p dags airflow/logs airflow/plugins
  # echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" >> .env
  # docker-compose -f docker-compose-airflow.yaml up airflow-init
  # docker-compose -f docker-compose-airflow.yaml up -d
  # cd ..

  # echo "Starting Superset..."
  # cd superset
  # docker-compose -f docker-compose-superset.yaml down -v
  # docker-compose -f docker-compose-superset.yaml up -d
  # cd ..

  # echo "Access Airbyte at http://localhost:8000 and set up a connection."
  # echo "Enter your Airbyte connection ID: "
  # read connection_id
  # # Set connection ID for DAG.
  # docker-compose -f airflow/docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_CONNECTION_ID' "$connection_id"
  # docker-compose -f airflow/docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_example' --conn-uri 'airbyte://host.docker.internal:8000'

  # echo "Access Airflow at http://localhost:8080 to kick off your Airbyte sync DAG."
  # echo "Access Superset at http://localhost:8088 to set up your dashboards."
}

down() {
  echo "Stopping Postgres..."
  docker stop postgres
  echo "Stopping Airbyte..."
  docker-compose -f airbyte/docker-compose-airbyte.yaml down -v
  # echo "Stopping Airflow..."
  # docker-compose -f airflow/docker-compose-airflow.yaml down -v
  # echo "Stopping Superset..."
  # docker-compose -f superset/docker-compose-superset.yaml down -v
}

case $1 in
  up)
    up
    ;;
  down)
    down
    ;;
  *)
    echo "Usage: $0 {up|down}"
    ;;
esac
