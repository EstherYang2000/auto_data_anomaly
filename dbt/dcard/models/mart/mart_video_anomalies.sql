WITH anomaly_ranges AS (
    -- 根據閾值判斷異常：
    -- 1. 如果當日事件數量低於 (滑動平均值 - 1.5 * 標準差)，標記為 "Low Event Count Anomaly"。
    -- 2. 如果當日平均播放時長超過 (滑動平均值 + 1.5 * 標準差)，標記為 "High Avg Duration Anomaly"。
    SELECT
        event_date,
        app_version,
        event_count,
        avg_duration_seconds,
        max_duration_seconds,
        avg_event_count_7d,
        stddev_event_count_7d,
        avg_duration_7d,
        stddev_duration_7d,
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
-- 輸出異常結果：
-- 組合事件數和播放時長的異常標記，並輸出異常記錄。
SELECT
    event_date,
    app_version,
    event_count,
    avg_duration_seconds,
    max_duration_seconds,
    CASE 
        WHEN event_count_anomaly != 'Normal' AND avg_duration_anomaly != 'Normal' THEN 'Both Event Count & Avg Duration Anomaly'
        WHEN event_count_anomaly != 'Normal' THEN event_count_anomaly
        WHEN avg_duration_anomaly != 'Normal' THEN avg_duration_anomaly
        ELSE 'Normal'
    END AS final_anomaly_type
FROM anomaly_ranges
WHERE event_count_anomaly != 'Normal' OR avg_duration_anomaly != 'Normal'
ORDER BY event_date

