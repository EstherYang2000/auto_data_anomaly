{{ config(
    schema='staging',
    materialized='view'
) }}
WITH raw_data AS (
    -- 從來源表中篩選出有 media_id 且長度大於 0 的記錄
    SELECT
        event_id,
        created_at,
        app_version,
        action,
        client_id,
        media_id,
        user_id
    FROM {{ source('dcard', 'video_interactions') }}
    WHERE LENGTH(media_id) > 0
)
    -- 標準化數據：
    -- 1. 將 created_at 轉換為台北時區。
    -- 2. 將 action 字段的值轉為小寫，確保一致性。
SELECT
    event_id,
    created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Taipei' AS created_at_taipei,
    app_version,
    LOWER(action) AS action,
    client_id,
    media_id,
    user_id
FROM raw_data