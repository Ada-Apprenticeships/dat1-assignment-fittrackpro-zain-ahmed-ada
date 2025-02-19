-- Initial SQLite setup
.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
INSERT INTO attendance(attendance_id, check_in_time, member_id, location_id)
VALUES (11, CURRENT_TIMESTAMP, 7, 1);

-- 2. Retrieve a member's attendance history
SELECT 
    date(check_in_time) AS visit_date, 
    check_in_time, 
    check_out_time
FROM 
    attendance
WHERE 
    member_id = 5;

-- 3. Find the busiest day of the week based on gym visits
SELECT 
    CASE strftime('%w', check_in_time)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        ELSE 'Saturday'
    END AS day_of_week,
    COUNT(*) AS visit_count
FROM 
    attendance
GROUP BY
    day_of_week 
ORDER BY
    visit_count DESC
LIMIT 1;

-- 4. Calculate the average daily attendance for each location
SELECT 
    l.name AS location_name, 
    CAST(COUNT (a.location_id) AS REAL) / COUNT(DISTINCT DATE(a.check_in_time)) AS avg_daily_attendance
FROM 
    attendance AS a
INNER JOIN 
    locations AS l 
        ON a.location_id = l.location_id
GROUP BY 
    a.location_id;