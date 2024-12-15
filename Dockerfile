FROM apache/airflow:2.10.2
COPY requirements.txt .
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r requirements.txt
USER root
RUN apt-get update && apt-get install -y git
USER ${AIRFLOW_UID:-50000}