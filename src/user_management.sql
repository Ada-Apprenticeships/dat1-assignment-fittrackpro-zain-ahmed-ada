-- Initial SQLite setup
.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

-- User Management Queries

-- 1. Retrieve all members
SELECT 
    member_id, 
    first_name, 
    last_name, 
    email, 
    join_date
FROM 
    members;

-- 2. Update a member's contact information
UPDATE members
SET 
    phone_number = '555-9876', 
    email = 'emily.jones.updated@email.com'
WHERE 
    member_id = 5;

-- 3. Count total number of members
SELECT 
    COUNT(*) AS total_members
FROM 
    members;

-- 4. Find member with the most class registrations
SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    COUNT(ca.class_attendance_id) AS registration_count
FROM 
    members AS m
INNER JOIN 
    class_attendance AS ca 
        ON m.member_id = ca.member_id
GROUP BY 
    m.member_id,
    m.first_name,
    m.last_name
ORDER BY 
    registration_count DESC
LIMIT 1;

-- 5. Find member with the least class registrations
SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    COUNT(ca.class_attendance_id) AS registration_count
FROM 
    members AS m
INNER JOIN 
    class_attendance AS ca
        ON m.member_id = ca.member_id
GROUP BY 
    m.member_id,
    m.first_name,
    m.last_name
ORDER BY 
    registration_count ASC
LIMIT 1;

-- 6. Calculate the percentage of members who have attended at least one class
SELECT 
    ROUND((COUNT(DISTINCT ca.member_id) * 100.0 / (SELECT COUNT(m.member_id))), 1) || '%' AS percentage_attended
FROM 
    members AS m
LEFT JOIN
    class_attendance AS ca
        ON m.member_id = ca.member_id
            AND ca.attendance_status = 'Attended';