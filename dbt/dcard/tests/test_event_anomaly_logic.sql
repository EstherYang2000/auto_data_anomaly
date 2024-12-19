-- tests/test_event_anomaly_logic.sql
WITH anomaly_ranges AS (
    SELECT
        *,
        CASE 
            WHEN event_count < avg_event_count_7d - (1.5 * stddev_event_count_7d) THEN 'Low Event Count Anomaly'
            ELSE 'Normal'
        END AS event_count_anomaly,
        CASE 
            WHEN avg_duration_seconds > avg_duration_7d + (1.5 * stddev_duration_7d) THEN 'High Avg Duration Anomaly'
            ELSE 'Normal'
        END AS avg_duration_anomaly
    FROM {{ ref('int_daily_anomalies') }}
)
SELECT *
FROM anomaly_ranges
WHERE (event_count_anomaly = 'Low Event Count Anomaly' AND event_count >= avg_event_count_7d - (1.5 * stddev_event_count_7d))
   OR (avg_duration_anomaly = 'High Avg Duration Anomaly' AND avg_duration_seconds <= avg_duration_7d + (1.5 * stddev_duration_7d))
