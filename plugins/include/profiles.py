from cosmos import ProfileConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping

airflow_db = ProfileConfig(
    profile_name="dcard",  # Profile name matches profiles.yml
    target_name="postgres_dev",  # Use 'postgres_dev' target for PostgreSQL
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="airflow_postgres_db",  # Airflow connection ID for PostgreSQL
        profile_args={"schema": "staging"},  # Schema defined in profiles.yml
    )
)
