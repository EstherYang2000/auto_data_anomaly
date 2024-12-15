CREATE TABLE video_interactions (
    id SERIAL PRIMARY KEY, -- Auto-incrementing primary key
    event_id VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    app_version VARCHAR(255),
    action VARCHAR(255),
    client_id VARCHAR(255),
    media_id VARCHAR(255),
    user_id VARCHAR(255)
);
