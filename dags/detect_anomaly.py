# from datetime import datetime
# from airflow.decorators import dag
# from airflow.operators.empty import EmptyOperator
# from cosmos import DbtTaskGroup, ProjectConfig, ExecutionConfig
# from include.profiles import airflow_db

# # Define your dbt project path
# DBT_PROJECT_PATH = "/opt/airflow/dbt/dcard"

# def create_dbt_task_group(stage_name: str, model_filters: list = None) -> DbtTaskGroup:
#     """
#     Helper function to create a dbt task group for each stage.
#     :param stage_name: Name of the dbt stage (e.g., staging, intermediate, mart)
#     :param model_filters: Optional list of dbt model filters for specific ordering
#     :return: DbtTaskGroup for the stage
#     """
#     return DbtTaskGroup(
#         group_id=f"dbt_{stage_name}",
#         project_config=ProjectConfig(DBT_PROJECT_PATH),
#         profile_config=airflow_db,
#         select=model_filters if model_filters else [f"{stage_name}.*"],  # Model filtering directly at the task group level
#     )

# @dag(
#     schedule_interval=None,
#     start_date=datetime(2024, 12, 17),
#     catchup=False,
#     tags=["dbt", "postgres", "bigquery"],
# )
# def dbt_full_pipeline():
#     """
#     Airflow DAG to orchestrate dbt pipeline: staging -> intermediate -> mart
#     """
#     # Empty operators for pre- and post-dbt tasks
#     pre_dbt = EmptyOperator(task_id="pre_dbt")
#     post_dbt = EmptyOperator(task_id="post_dbt")

#     # Create dbt task group for staging
#     dbt_staging = create_dbt_task_group("staging")

#     # Create dbt task group for intermediate (explicit models)
#     dbt_intermediate_1 = create_dbt_task_group("intermediate", ["intermediate.int_video_events"])
#     dbt_intermediate_2 = create_dbt_task_group("intermediate", ["intermediate.int_daily_anomalies"])

#     # Create dbt task group for mart
#     dbt_mart = create_dbt_task_group("mart")

#     # Define task dependencies
#     pre_dbt >> dbt_staging >> dbt_intermediate_1 >> dbt_intermediate_2 >> dbt_mart >> post_dbt

# # Instantiate the DAG
# dbt_full_pipeline()

from datetime import datetime

from airflow.decorators import dag
from airflow.operators.empty import EmptyOperator


from cosmos import DbtTaskGroup, ProjectConfig

from include.profiles import airflow_db
from include.constants import dcard_path, venv_execution_config


@dag(
    schedule_interval=None,
    start_date=datetime(2024, 12, 17),
    catchup=False,
    tags=["simple"],
)
def dcard_task_group() -> None:
    pre_dbt = EmptyOperator(task_id="pre_dbt")

    dcard = DbtTaskGroup(
        group_id="dcard",
        project_config=ProjectConfig(dcard_path),
        profile_config=airflow_db,
        execution_config=venv_execution_config,
    )

    post_dbt = EmptyOperator(task_id="post_dbt")
    final_dbt = EmptyOperator(task_id="final_dbt")

    pre_dbt >> dcard >> post_dbt >> final_dbt


dcard_task_group()
# from airflow import DAG
# from airflow.operators.dagrun_operator import TriggerDagRunOperator
# from datetime import datetime, timedelta
# from airflow.operators.bash import BashOperator

# def dbt_run_command(model):
#     return f'dbt run --models {model}'
# def dbt_run():
#     return f'dbt run'
# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'start_date': datetime(2024, 12, 17),
#     'retries': 1,
#     'retry_delay': timedelta(minutes=5),
# }
# dag = DAG('data_anomaly', default_args=default_args, schedule_interval=timedelta(hours=0.1))
# # Define dbt tasks using BashOperator
# stg_video_interactions = BashOperator(
#     task_id='dbt_task1',
#     # bash_command=dbt_run_command('stg_video_interactions'),
#     bash_command=dbt_run(),
#     dag=dag
# )
# int_video_events = BashOperator(
#     task_id='dbt_task2',
#     bash_command=dbt_run_command('int_video_events'),
#     dag=dag
# )
# int_daily_anomalies = BashOperator(
#     task_id='dbt_task3',
#     bash_command=dbt_run_command('int_daily_anomalies'),
#     dag=dag
# )
# mart_video_anomalies = BashOperator(
#     task_id='dbt_task4',
#     bash_command=dbt_run_command('mart_video_anomalies'),
#     dag=dag
# )
# Set task dependencies
# stg_video_interactions >> int_video_events >> int_daily_anomalies >> mart_video_anomalies
# stg_video_interactions