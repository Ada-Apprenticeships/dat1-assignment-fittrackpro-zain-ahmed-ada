-- Initial SQLite setup
.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

-- Equipment Management Queries

-- 1. Find equipment due for maintenance
SELECT 
    equipment_id, 
    name, 
    next_maintenance_date
FROM 
    equipment
WHERE 
    next_maintenance_date <= date('now', '+30 days') AND next_maintenance_date >= date('now');

-- 2. Count equipment types in stock
SELECT 
    type AS equipment_type, 
    COUNT(equipment_id) AS count
FROM 
    equipment
GROUP BY 
    type;

-- 3. Calculate average age of equipment by type (in days)
SELECT 
    type AS equipment_type, 
    CAST(AVG(JULIANDAY('now') - JULIANDAY(purchase_date)) AS INTEGER) AS avg_age_days
FROM 
    equipment
GROUP BY 
    type;