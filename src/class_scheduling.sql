-- Initial SQLite setup
.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
SELECT 
    c.class_id, 
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name
FROM
    class_schedule cs
INNER JOIN
    classes AS c
        ON cs.class_id = c.class_id
INNER JOIN 
    staff AS s 
        ON cs.staff_id = s.staff_id
GROUP BY 
    c.class_id, 
    c.name;

-- 2. Find available classes for a specific date
SELECT 
    c.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    (c.capacity - COUNT(ca.class_attendance_id)) AS available_spots
FROM 
    classes AS c
INNER JOIN 
    class_schedule AS cs
        ON c.class_id = cs.class_id
INNER JOIN 
    class_attendance AS ca
        ON cs.schedule_id = ca.schedule_id
WHERE 
    DATE(cs.start_time) = '2025-02-01'
GROUP BY 
    c.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    c.capacity
ORDER BY 
    cs.start_time;

-- 3. Register a member for a class
INSERT INTO class_attendance (class_attendance_id, attendance_status, member_id, schedule_id)
VALUES (17, 'Registered', 11, 7);

-- 4. Cancel a class registration
DELETE
FROM 
    class_attendance
WHERE 
    member_id = 2 
    AND schedule_id = 7;

-- 5. List top 5 most popular classes
SELECT 
    c.class_id, 
    c.name AS class_name, 
    COUNT(ca.class_attendance_id) AS registration_count
FROM 
    classes AS c
INNER JOIN 
    class_schedule AS cs 
        ON c.class_id = cs.class_id
INNER JOIN 
    class_attendance AS ca 
        ON cs.schedule_id = ca.schedule_id
GROUP BY 
    c.class_id,
    c.name 
ORDER BY 
    registration_count DESC
LIMIT 5;

-- 6. Calculate average number of classes per member
SELECT 
    ROUND(
        (COUNT(CASE WHEN attendance_status = 'Attended' THEN 1 END) * 1.0) / 
        (SELECT COUNT(*) FROM members), 
        2
    ) AS average_classes_per_member
FROM 
    class_attendance;