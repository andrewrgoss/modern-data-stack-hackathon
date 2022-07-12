from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow import DAG
from airflow.utils.dates import days_ago
from textwrap import dedent
import json
from airflow.operators.python import PythonOperator
from airflow.models import Variable


airbyte_connection_id = Variable.get("AIRBYTE_CONNECTION_ID")

# instantiate dag
with DAG(dag_id='trigger_airbyte_dbt_job',
         default_args={'owner': 'airflow'},
         schedule_interval='@daily',
         start_date=days_ago(1),
         tags=['airbyte'],
         ) as dag:

    airbyte_extract_load = AirbyteTriggerSyncOperator(
        task_id='run_airbyte_connection',
        airbyte_conn_id='run_airbyte_connection',
        connection_id=airbyte_connection_id,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )

    def dbt_transform(**kwargs):
        print('DBT!')

    transform_task = PythonOperator(
        task_id='dbt_transform',
        python_callable=dbt_transform,
    )

    transform_task.doc_md = dedent(
        """\
    #### Transform task
    TODO: Add more details.
    """
    )
