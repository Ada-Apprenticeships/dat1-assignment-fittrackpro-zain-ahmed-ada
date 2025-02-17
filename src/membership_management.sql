-- Initial SQLite setup
.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- 1. List all active memberships
SELECT m.member_id, m.first_name, m.last_name, ms.type AS membership_type, ms.start_date AS join_date
FROM memberships ms
INNER JOIN members m ON ms.member_id = m.member_id
WHERE status = 'Active';

-- 2. Calculate the average duration of gym visits for each membership type
SELECT memberships.type AS membership_type, CAST(AVG((strftime('%s', attendance.check_out_time) - strftime('%s', attendance.check_in_time)) / 60) AS REAL) AS avg_visit_duration_minutes
FROM memberships
JOIN attendance ON memberships.member_id = attendance.member_id
GROUP BY membership_type;

-- 3. Identify members with expiring memberships this year
SELECT m.member_id, m.first_name, m.last_name, m.email, ms.end_date
FROM memberships ms
INNER JOIN members m ON ms.member_id = m.member_id
WHERE strftime('%Y', end_date) = '2025';