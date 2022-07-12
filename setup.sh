#!/usr/bin/env bash
up() {
  # Build Docker containers for each component of data stack

  ############ POSTGRES ############
  echo "Starting Postgres instance..."
  echo "Enter your target Postgres database name: "
  read pg_tgt_db
  docker run --rm --name postgres -e POSTGRES_PASSWORD=password -e POSTGRES_DB=$pg_tgt_db -p 2000:5432 -d postgres

  ############ AIRBYTE ############
  echo "Starting Airbyte..."
  docker-compose -f airbyte/docker-compose-airbyte.yaml down -v
  docker-compose -f airbyte/docker-compose-airbyte.yaml up -d

  # Wait for Airbyte webapp container to finish initializing
  airbyte_webapp_container_id="`docker ps -aqf "name=webapp"`"
  while [ "`docker inspect -f {{.State.Running}} $airbyte_webapp_container_id`" != "true" ]; do echo "Waiting for Airbyte container to finish initializing..."; sleep 2; done

  # Build Airbyte data pipeline
  # TODO: call Python script here

  echo "Access Airbyte at http://localhost:8000 and set up a connection."
  echo "Enter your Airbyte connection ID: "
  read ab_conn_id

  ############ AIRFLOW ############
  echo "Starting Airflow..."
  docker-compose -f airflow/docker-compose-airflow.yaml down -v
  echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0\n_PIP_ADDITIONAL_REQUIREMENTS=apache-airflow-providers-airbyte" > airflow/.env
  docker-compose -f airflow/docker-compose-airflow.yaml up airflow-init
  docker-compose -f airflow/docker-compose-airflow.yaml up -d
  # set Airbyte connection ID for DAG
  docker-compose -f airflow/docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_CONNECTION_ID' "$ab_conn_id"
  docker-compose -f airflow/docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_example' --conn-uri 'airbyte://host.docker.internal:8000'
  echo "Access Airflow at http://localhost:8080 to kick off your Airbyte sync DAG."

  ############ SUPERSET ############
  # echo "Starting Superset..."
  # cd superset
  # docker-compose -f docker-compose-superset.yaml down -v
  # docker-compose -f docker-compose-superset.yaml up -d
  # echo "Access Superset at http://localhost:8088 to set up your dashboards."
}

down() {
  echo "Stopping Postgres..."
  docker stop postgres
  echo "Stopping Airbyte..."
  docker-compose -f airbyte/docker-compose-airbyte.yaml down -v
  echo "Stopping Airflow..."
  docker-compose -f airflow/docker-compose-airflow.yaml down -v
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
