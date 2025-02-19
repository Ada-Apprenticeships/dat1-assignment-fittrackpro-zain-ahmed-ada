-- Initial SQLite setup
.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
SELECT 
    session_id, 
    m.first_name || ' ' || m.last_name AS member_name, 
    session_date, 
    start_time, 
    end_time
FROM 
    personal_training_sessions pts
INNER JOIN 
    members AS m 
        ON pts.member_id = m.member_id
INNER JOIN 
    staff AS s 
        ON pts.staff_id = s.staff_id
WHERE 
    s.first_name = 'Ivy' AND s.last_name = 'Irwin';