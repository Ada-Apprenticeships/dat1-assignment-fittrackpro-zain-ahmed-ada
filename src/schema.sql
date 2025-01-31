-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- TO DO: Add unique and check as constraints

-- Create tables
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number CHAR(8) NOT NULL,
    email VARCHAR(255) NOT NULL,
    opening_hours CHAR(10) NOT NULL
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number CHAR(8) NOT NULL,
    date_of_birth DATE,
    join_date DATE NOT NULL,
    emergency_contact_name VARCHAR(50) NOT NULL,
    emergency_contact_phone CHAR(8) NOT NULL
);

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number CHAR(8) NOT NULL,
    position CHAR(12) NOT NULL,
    hire_date DATE,
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name VARCHAR(89) NOT NULL,
    type CHAR(8) NOT NULL,
    purchase_date DATE NOT NULL,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    name VARCHAR(16) NOT NULL,
    description TEXT NOT NULL,
    capacity INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    start_time DATE NOT NULL,
    end_time DATE NOT NULL,
    class_id INTEGER,
    staff_id INTEGER,
    FOREIGN KEY (class_id) REFERENCES classes (class_id),
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    type TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status TEXT NOT NULL,
    member_id INTEGER,
    FOREIGN KEY (member_id) REFERENCES members (member_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    check_in_time DATE NOT NULL,
    check_out_time DATE NOT NULL,
    member_id INTEGER,
    location_id INTEGER,
    FOREIGN KEY (member_id) REFERENCES members (member_id),
    FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE class_attendance (
    attendance_id INTEGER PRIMARY KEY,
    attendance_status VARCHAR(100),
    member_id INTEGER,
    schedule_id INTEGER,
    FOREIGN KEY (member_id) REFERENCES members (member_id),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule (schedule_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    payment_date DATE NOT NULL,
    payment_method TEXT,
    payment_type TEXT,
    FOREIGN KEY (member_id) REFERENCES members (member_id)
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    session_date DATE NOT NULL,
    start_time DATE NOT NULL,
    end_time DATE NOT NULL,
    notes TEXT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    measurement_date DATE,
    weight INTEGER,
    body_fat_percentage REAL,
    muscle_mass REAL,
    bmi REAL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER NOT NULL,
    maintenance_date DATE NOT NULL,
    description TEXT NOT NULL,
    staff_id INTEGER,
    FOREIGN KEY (equipment_id) REFERENCES equipment (equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);