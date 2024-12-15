from lib.iac_config_helper import IACConfigHelper
from lib.pg_helper import PGConnect
from crud_pg import insert_data, create_table, update_date
import csv
# from lib.json_helper import read_json

if __name__ == "__main__":
    config_path = "config/credential.yaml"
    conn_config = IACConfigHelper.get_conn_info(config_path)
    pg_config = conn_config["database"]["postgres"]
    pg_connection = PGConnect(**pg_config)
    pg_connection.connect()
    conn = pg_connection.conn
    cur = conn.cursor()
    # Check if the table exists
    print(conn)
    table = "video_interactions"
    sqlpath = f"sql/create/stg_video_interactions.sql"
    csv_file_path = "data/video_interactions.csv"
    create_table(conn, sqlpath, table)
    # Read the CSV file and convert to JSON
    with open(csv_file_path, mode='r', encoding='utf-8') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        insert_json = [row for row in csv_reader]
    print(type(insert_json))
    insert_data(conn, insert_json, table)