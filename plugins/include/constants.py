from pathlib import Path
from cosmos import ExecutionConfig

dcard_path = Path("/opt/airflow/dbt/dcard")
dbt_executable = Path("/opt/airflow/dbt")

venv_execution_config = ExecutionConfig(
    dbt_executable_path=str(dbt_executable)
)