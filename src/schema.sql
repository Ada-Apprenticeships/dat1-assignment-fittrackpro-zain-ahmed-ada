-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Drop tables if exist
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS member_classes;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;

-- Create tables
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    opening_hours VARCHAR(50) NOT NULL
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    join_date DATE DEFAULT (date('now')),
    emergency_contact_name VARCHAR(150) NOT NULL,
    emergency_contact_phone VARCHAR(20) NOT NULL
);

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    position VARCHAR(12) NOT NULL CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATE DEFAULT (date('now')),
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(10) NOT NULL CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE NOT NULL,
    last_maintenance_date DATE DEFAULT (date('now')),
    next_maintenance_date DATE NOT NULL,
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(20) NOT NULL,
    description TEXT NOT NULL,
    capacity INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes (class_id),
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    type VARCHAR(7) NOT NULL CHECK (type IN ('Premium', 'Basic')),
    start_date DATE DEFAULT (date('now')),
    end_date DATE DEFAULT (date('now', '+1 year')),
    status VARCHAR(8) NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members (member_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    check_in_time DATETIME DEFAULT (datetime('now')),
    check_out_time DATETIME,
    FOREIGN KEY (member_id) REFERENCES members (member_id),
    FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    schedule_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    attendance_status VARCHAR(10) NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (member_id) REFERENCES members (member_id),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule (schedule_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    payment_date DATE DEFAULT (date('now')),
    payment_method VARCHAR(13) NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type VARCHAR(20) NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members (member_id)
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    session_date DATE DEFAULT (date('now')),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    notes TEXT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    measurement_date DATE DEFAULT (date('now')),
    weight INTEGER NOT NULL,
    body_fat_percentage REAL NOT NULL,
    muscle_mass REAL NOT NULL,
    bmi REAL NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id INTEGER NOT NULL,
    maintenance_date DATE DEFAULT (date('now')),
    description TEXT NOT NULL,
    staff_id INTEGER NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment (equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);