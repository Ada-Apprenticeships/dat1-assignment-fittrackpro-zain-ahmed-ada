-- Initial SQLite setup
.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
SELECT 
    c.class_id, 
    c.name AS class_name,
    STRING_AGG(s.first_name || ' ' || s.last_name, ', ') AS instructor_names
FROM classes c
INNER JOIN staff s ON c.location_id = s.location_id
GROUP BY c.class_id, c.name;

-- 2. Find available classes for a specific date
SELECT c.class_id, c.name, strftime('%Y-%m-%d', cs.start_time) AS start_time, strftime('%Y-%m-%d', cs.end_time) AS end_time, capacity AS available_spots
FROM classes c
INNER JOIN class_schedule cs on c.class_id = cs.class_id;

-- 3. Register a member for a class
INSERT INTO class_attendance (attendance_id, attendance_status, member_id, schedule_id)
VALUES (17, 'Registered', 11, 7);

-- 4. Cancel a class registration
DELETE
FROM class_attendance
WHERE member_id = 2 AND schedule_id = 7;

-- 5. List top 5 most popular classes
SELECT c.class_id, c.name AS class_name, COUNT(ca.attendance_status) AS registration_count
FROM classes c
LEFT JOIN class_schedule cs on c.class_id = cs.class_id
LEFT JOIN class_attendance ca on cs.schedule_id = ca.schedule_id
WHERE ca.attendance_status = 'Registered'
GROUP BY c.class_id, c.name
ORDER BY registration_count DESC
LIMIT 5;

-- 6. Calculate average number of classes per member
SELECT
ROUND((COUNT(CASE WHEN attendance_status = 'Attended' THEN 1 END) * 1.0) / (SELECT COUNT(*) FROM members), 2) AS average_classes_per_member
FROM class_attendance;