{{ config(materialized='table') }}
-- 在模型文件的顶部
{{ config(schema='intermediate') }}

WITH daily_stats AS (
    -- 按每日和應用版本匯總統計：
    -- 1. 記錄當日的事件數量。
    -- 2. 計算當日播放時長的平均值和最大值。
    SELECT
        DATE(created_at) AS event_date,
        app_version,
        COUNT(*) AS event_count,
        AVG(duration_seconds) AS avg_duration_seconds,
        MAX(duration_seconds) AS max_duration_seconds
    FROM {{ ref('int_video_events') }}
    GROUP BY event_date, app_version
),
thresholds AS (
    -- 使用滑動窗口計算每個版本的每日異常閾值：
    -- 1. 基於前 7 天數據計算事件數量的平均值和標準差。
    -- 2. 計算平均播放時長的滑動平均值和標準差。
    SELECT
        event_date,
        app_version,
        event_count,
        avg_duration_seconds,
        max_duration_seconds,
        AVG(event_count) OVER (PARTITION BY app_version ORDER BY event_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg_event_count_7d,
        STDDEV(event_count) OVER (PARTITION BY app_version ORDER BY event_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS stddev_event_count_7d,
        AVG(avg_duration_seconds) OVER (PARTITION BY app_version ORDER BY event_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg_duration_7d,
        STDDEV(avg_duration_seconds) OVER (PARTITION BY app_version ORDER BY event_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS stddev_duration_7d
    FROM daily_stats
)
SELECT
    *
FROM thresholds