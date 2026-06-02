-- ============================================
-- Office VPN Resource Access Management System
-- Database Schema — MySQL
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS office_vpn_db;
USE office_vpn_db;

-- ============================================
-- 1. ADMIN TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- 2. EMPLOYEE TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_code VARCHAR(20) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    designation VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- 3. RESOURCE TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS resource (
    id INT AUTO_INCREMENT PRIMARY KEY,
    resource_name VARCHAR(100) NOT NULL,
    resource_type ENUM('SERVER', 'DATABASE', 'APPLICATION', 'FILE_SHARE', 'API', 'NETWORK') NOT NULL,
    description TEXT,
    ip_address VARCHAR(50),
    access_level ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM',
    status ENUM('ACTIVE', 'INACTIVE', 'MAINTENANCE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- 4. VPN_ACCESS TABLE (Employee <-> Resource mapping)
-- ============================================
CREATE TABLE IF NOT EXISTS vpn_access (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    resource_id INT NOT NULL,
    granted_by VARCHAR(50) NOT NULL DEFAULT 'admin',
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    status ENUM('ACTIVE', 'REVOKED') DEFAULT 'ACTIVE',
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES resource(id) ON DELETE CASCADE,
    UNIQUE KEY unique_access (employee_id, resource_id)
) ENGINE=InnoDB;

-- ============================================
-- 5. ACTIVITY_LOG TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS activity_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    action_type ENUM('LOGIN', 'LOGOUT', 'ACCESS_RESOURCE', 'SEARCH', 'REQUEST_ACCESS', 'VIEW_RESOURCE', 'PROFILE_UPDATE') NOT NULL,
    description TEXT,
    ip_address VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- 6. ACCESS_REQUEST TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS access_request (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    resource_id INT NOT NULL,
    reason TEXT NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    admin_remarks TEXT,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP NULL,
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES resource(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- SEED DATA
-- ============================================

-- Default admin account (username: admin, password: admin123)
INSERT INTO admin (username, password, full_name, email) VALUES
('admin', 'admin123', 'System Administrator', 'admin@officevpn.com');

-- Sample employees
INSERT INTO employee (emp_code, username, password, full_name, email, department, designation, phone) VALUES
('EMP001', 'john.doe', 'john123', 'John Doe', 'john@company.com', 'Engineering', 'Software Engineer', '9876543210'),
('EMP002', 'jane.smith', 'jane123', 'Jane Smith', 'jane@company.com', 'Marketing', 'Marketing Manager', '9876543211'),
('EMP003', 'bob.wilson', 'bob123', 'Bob Wilson', 'bob@company.com', 'Finance', 'Financial Analyst', '9876543212'),
('EMP004', 'alice.brown', 'alice123', 'Alice Brown', 'alice@company.com', 'Engineering', 'DevOps Engineer', '9876543213'),
('EMP005', 'charlie.davis', 'charlie123', 'Charlie Davis', 'charlie@company.com', 'HR', 'HR Specialist', '9876543214');

-- Sample VPN resources
INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level) VALUES
('Production Server', 'SERVER', 'Main production application server', '10.0.1.100', 'CRITICAL'),
('Development Server', 'SERVER', 'Development and testing environment', '10.0.1.101', 'MEDIUM'),
('HR Database', 'DATABASE', 'Employee records and HR data', '10.0.2.50', 'HIGH'),
('Finance Database', 'DATABASE', 'Financial records and reports', '10.0.2.51', 'CRITICAL'),
('Project Management App', 'APPLICATION', 'JIRA project management tool', '10.0.3.10', 'LOW'),
('Shared Documents', 'FILE_SHARE', 'Company shared file repository', '10.0.4.20', 'LOW'),
('Internal API Gateway', 'API', 'Microservices API gateway', '10.0.5.100', 'HIGH'),
('Office Wi-Fi Network', 'NETWORK', 'Secure office wireless network', '10.0.0.1', 'MEDIUM');

-- Sample VPN access grants
INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES
(1, 2, 'admin'),  -- John -> Dev Server
(1, 5, 'admin'),  -- John -> Project Mgmt
(1, 6, 'admin'),  -- John -> Shared Docs
(2, 5, 'admin'),  -- Jane -> Project Mgmt
(2, 6, 'admin'),  -- Jane -> Shared Docs
(3, 4, 'admin'),  -- Bob -> Finance DB
(3, 6, 'admin'),  -- Bob -> Shared Docs
(4, 1, 'admin'),  -- Alice -> Prod Server
(4, 2, 'admin'),  -- Alice -> Dev Server
(4, 7, 'admin'),  -- Alice -> API Gateway
(5, 6, 'admin');  -- Charlie -> Shared Docs

-- Sample activity logs
INSERT INTO activity_log (employee_id, action_type, description, ip_address) VALUES
(1, 'LOGIN', 'John Doe logged in', '192.168.1.10'),
(1, 'ACCESS_RESOURCE', 'Accessed Development Server', '192.168.1.10'),
(2, 'LOGIN', 'Jane Smith logged in', '192.168.1.11'),
(2, 'SEARCH', 'Searched for database resources', '192.168.1.11'),
(4, 'LOGIN', 'Alice Brown logged in', '192.168.1.13'),
(4, 'ACCESS_RESOURCE', 'Accessed Production Server', '192.168.1.13');

-- Sample access requests
INSERT INTO access_request (employee_id, resource_id, reason, status) VALUES
(1, 1, 'Need production access for deployment tasks', 'PENDING'),
(2, 3, 'Require HR database access for campaign targeting', 'PENDING'),
(3, 7, 'Need API access for financial integration', 'APPROVED');

SELECT 'Database setup completed successfully!' AS status;
