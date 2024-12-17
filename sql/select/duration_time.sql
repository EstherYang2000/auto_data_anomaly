WITH
raw AS (
    SELECT
        *
    FROM video_interactions
    WHERE LENGTH(media_id) > 0
    AND created_at >= TIMESTAMP('2024-09-15', 'Asia/Taipei')
    AND created_at < TIMESTAMP('2024-09-16', 'Asia/Taipei')
),
distinct_raw AS (
    SELECT DISTINCT *
    FROM raw
),
first_row AS (
    SELECT
        * EXCEPT(rn)
    FROM (
        SELECT
            media_id,
            client_id,
            created_at,
            action,
            ROW_NUMBER() OVER (PARTITION BY media_id, client_id, action ORDER BY created_at) rn
        FROM distinct_raw
        WHERE action != 'pause'
    )
    WHERE rn = 1
),
core_columns AS (
    SELECT *
    FROM distinct_raw
    JOIN first_row
    USING (media_id, client_id, created_at, action)
),
views_agg_columns AS (
    SELECT
        client_id,
        media_id,
        action,
        created_at,
        LAG(created_at) OVER (PARTITION BY media_id, action ORDER BY created_at) previous_created_at
    FROM distinct_raw
),
SELECT
    * EXCEPT(duration_seconds_per_play, action),
    DATETIME(paused_at, 'Asia/Taipei') paused_at_taipei_zone,
    DATETIME(played_at, 'Asia/Taipei') played_at_taipei_zone,
    SUM(CASE
        WHEN duration_seconds_per_play IS NOT NULL THEN duration_seconds_per_play
        ELSE 0
    END) duration_seconds
FROM (
    SELECT
        * EXCEPT (rn, previous_created_at),
        TIMESTAMP_DIFF(paused_at, played_at, SECOND) duration_seconds_per_play
    FROM (
        SELECT
            pauses.*,
            pauses.created_at paused_at,
            plays.created_at played_at,
            ROW_NUMBER() OVER (PARTITION BY pauses.media_id, pauses.action, pauses.created_at ORDER BY plays.created_at) rn
        FROM views_agg_columns pauses
        JOIN views_agg_columns plays
        ON pauses.media_id = plays.media_id
        AND pauses.created_at > plays.created_at
        AND IF(pauses.previous_created_at IS NOT NULL, pauses.previous_created_at, plays.created_at) <= plays.created_at
        WHERE pauses.action = 'pause'
        AND plays.action != 'pause'
    )
    WHERE rn = 1
)
GROUP BY 1, 2, 3, 4, 5, 6, 7
SELECT
    vs.*,
    cc.* EXCEPT (media_id, client_id, created_at, action)
FROM view_section vs
LEFT JOIN core_columns cc
USING (media_id, client_id)

