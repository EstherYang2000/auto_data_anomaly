{{ config(
    schema='intermediate',
    materialized='table'
) }}

WITH base AS (
    SELECT *
    FROM {{ ref('stg_video_interactions') }}  -- 正確引用 Staging 層的模型
),
lagged_actions AS (
    SELECT
        client_id,
        media_id,
        action,
        created_at_taipei AS created_at,
        app_version,
        LAG(created_at_taipei) OVER (PARTITION BY client_id, media_id, action ORDER BY created_at_taipei) AS prev_created_at
    FROM base
),
duration_per_play AS (
    SELECT
        client_id,
        media_id,
        action,
        app_version,
        created_at,
        prev_created_at,
        EXTRACT(EPOCH FROM (created_at - prev_created_at)) AS duration_seconds
    FROM lagged_actions
    WHERE action = 'pause' AND prev_created_at IS NOT NULL
)
SELECT
    *
FROM duration_per_play
