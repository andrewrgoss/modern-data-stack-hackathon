# modern-data-stack-hackathon
Modern data stack hackathon project inspired by https://airbyte.io/recipes/modern-data-stack-docker.

## Components of the Modern Data Stack
Before we set up the project, let’s briefly look at each tool used in this example of a modern data stack to make sure you understand their responsibilities.

### Airbyte
Airbyte is an open-source data integration tool. With Airbyte, you can set up a data pipeline in minutes thanks to its extensive collection of pre-built connectors. Airbyte can replicate data from applications, APIs, and databases into data warehouses and data lakes. Airbyte offers a self-hosted option with Docker Compose that you can run locally. In this modern data stack example, Airbyte is used to replicate data from a CSV file to BigQuery.

### Snowflake
Snowflake is a highly scalable data warehouse. It features a columnar data structure and can query a large volume of data very quickly. In this modern data stack example, Snowflake works as the data store.

### dbt
dbt is an open-source data transformation tool that relies on SQL to build production-grade data pipelines. dbt replaces the usual boilerplate DDL/DML required to transform data with simple modular SQL SELECT statements and handles dependency management. dbt provides a cloud-hosted option and a CLI, a Python API and integration with Airflow. In this modern data stack example, dbt applies a simple transformation on the ingested data using a SQL query. Airbyte's native integration with dbt is used to run the transformations.

### Apache Airflow
Apache Airflow is an open-source data orchestration tool. Airflow offers the ability to develop, monitor, and schedule workflows programmatically. Airflow pipelines are defined in Python, which are then converted into Directed Acyclic Graphs (DAG). Airflow offers numerous integrations with third-party tools, including the Airbyte Airflow Operator and can be run locally using Docker Compose. Airflow is used in this modern data stack example to schedule a daily job that triggers the Airbyte sync, followed by the dbt transformation.

### Apache Superset
Apache Superset is a modern business intelligence, data exploration and visualization platform. Superset connects with a variety of databases and provides an intuitive interface for visualizing datasets. It offers a wide choice of visualizations as well as a no-code visualization builder. You can run Superset locally with Docker Compose or in the cloud using Preset. Superset sits at the end of this modern data stack example and is used to visualize the data stored in BigQuery.

#### Supporting Links
* <a href="https://towardsdatascience.com/building-an-end-to-end-open-source-modern-data-platform-c906be2f31bd" target="_blank">Building an End-to-End Open-Source Modern Data Platform</a>
* <a href="https://www.astronomer.io/blog/airflow-dbt-1" target="_blank">Building a Scalable Analytics Architecture With Airflow and dbt</a>
* <a href="https://towardsdatascience.com/creating-an-environment-with-airflow-and-dbt-on-aws-part-3-2789f35adb5d" target="_blank">Creating an environment with Airflow and DBT on AWS (part 3)</a>
* <a href="https://medium.com/@Cartelis/launching-a-docker-based-modern-open-source-data-stack-a936b1bb0a43" target="_blank">Launching a docker-based modern open-source data stack</a>
* <a href="https://airbyte.io/recipes/modern-data-stack-docker" target="_blank">Set up a modern data stack with Docker</a>
* <a href="https://airflowsummit.org/sessions/2021/the-new-modern-data-stack-airbyte-airflow-dbt" target="_blank">The new modern data stack - Airbyte, Airflow, DBT</a>
* <a href="https://www.castordoc.com/blog/what-if-you-had-to-build-a-data-stack-from-scratch" target="_blank">What if … you had to build a data stack from scratch?</a>