package com.officevpn.db;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Automatically creates database tables and seeds data when the app starts.
 * Works with H2 embedded database — no manual SQL execution needed!
 */
@WebListener
public class DBInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("==============================================");
        System.out.println(" Office VPN System — Database Initializer");
        System.out.println("==============================================");

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // ── Create Tables ──
            createTables(stmt);

            // ── Check if data already exists ──
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM admin");
            rs.next();
            int adminCount = rs.getInt(1);

            if (adminCount == 0) {
                // First run — seed initial data
                seedData(stmt);
                System.out.println("[DB] Initial data seeded successfully!");
            } else {
                System.out.println("[DB] Database already contains data. Skipping seed.");
            }

            System.out.println("[DB] Database initialization complete!");
            System.out.println("==============================================");

        } catch (Exception e) {
            System.err.println("[DB] ERROR during database initialization!");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[DB] Application shutting down.");
    }

    /**
     * Create all database tables if they don't exist.
     */
    private void createTables(Statement stmt) throws Exception {

        // 1. ADMIN TABLE
        stmt.execute(
            "CREATE TABLE IF NOT EXISTS admin (" +
            "  id INT AUTO_INCREMENT PRIMARY KEY," +
            "  username VARCHAR(50) NOT NULL UNIQUE," +
            "  password VARCHAR(100) NOT NULL," +
            "  full_name VARCHAR(100) NOT NULL," +
            "  email VARCHAR(100) NOT NULL," +
            "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")"
        );
        System.out.println("[DB] Table 'admin' ready.");

        // 2. EMPLOYEE TABLE
        stmt.execute(
            "CREATE TABLE IF NOT EXISTS employee (" +
            "  id INT AUTO_INCREMENT PRIMARY KEY," +
            "  emp_code VARCHAR(20) NOT NULL UNIQUE," +
            "  username VARCHAR(50) NOT NULL UNIQUE," +
            "  password VARCHAR(100) NOT NULL," +
            "  full_name VARCHAR(100) NOT NULL," +
            "  email VARCHAR(100) NOT NULL," +
            "  department VARCHAR(50) NOT NULL," +
            "  designation VARCHAR(50) NOT NULL," +
            "  phone VARCHAR(15)," +
            "  status VARCHAR(10) DEFAULT 'ACTIVE'," +
            "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")"
        );
        System.out.println("[DB] Table 'employee' ready.");

        // 3. RESOURCE TABLE
        stmt.execute(
            "CREATE TABLE IF NOT EXISTS resource (" +
            "  id INT AUTO_INCREMENT PRIMARY KEY," +
            "  resource_name VARCHAR(100) NOT NULL," +
            "  resource_type VARCHAR(20) NOT NULL," +
            "  description VARCHAR(500)," +
            "  ip_address VARCHAR(50)," +
            "  access_level VARCHAR(10) DEFAULT 'MEDIUM'," +
            "  status VARCHAR(15) DEFAULT 'ACTIVE'," +
            "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")"
        );
        System.out.println("[DB] Table 'resource' ready.");

        // 4. VPN_ACCESS TABLE
        stmt.execute(
            "CREATE TABLE IF NOT EXISTS vpn_access (" +
            "  id INT AUTO_INCREMENT PRIMARY KEY," +
            "  employee_id INT NOT NULL," +
            "  resource_id INT NOT NULL," +
            "  granted_by VARCHAR(50) NOT NULL DEFAULT 'admin'," +
            "  granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "  expires_at TIMESTAMP NULL," +
            "  status VARCHAR(10) DEFAULT 'ACTIVE'," +
            "  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE," +
            "  FOREIGN KEY (resource_id) REFERENCES resource(id) ON DELETE CASCADE," +
            "  UNIQUE (employee_id, resource_id)" +
            ")"
        );
        System.out.println("[DB] Table 'vpn_access' ready.");

        // 5. ACTIVITY_LOG TABLE
        stmt.execute(
            "CREATE TABLE IF NOT EXISTS activity_log (" +
            "  id INT AUTO_INCREMENT PRIMARY KEY," +
            "  employee_id INT," +
            "  action_type VARCHAR(20) NOT NULL," +
            "  description VARCHAR(500)," +
            "  ip_address VARCHAR(50)," +
            "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE SET NULL" +
            ")"
        );
        System.out.println("[DB] Table 'activity_log' ready.");

        // 6. ACCESS_REQUEST TABLE
        stmt.execute(
            "CREATE TABLE IF NOT EXISTS access_request (" +
            "  id INT AUTO_INCREMENT PRIMARY KEY," +
            "  employee_id INT NOT NULL," +
            "  resource_id INT NOT NULL," +
            "  reason VARCHAR(500) NOT NULL," +
            "  status VARCHAR(10) DEFAULT 'PENDING'," +
            "  admin_remarks VARCHAR(500)," +
            "  requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "  processed_at TIMESTAMP NULL," +
            "  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE," +
            "  FOREIGN KEY (resource_id) REFERENCES resource(id) ON DELETE CASCADE" +
            ")"
        );
        System.out.println("[DB] Table 'access_request' ready.");
    }

    /**
     * Seed initial data into the database.
     */
    private void seedData(Statement stmt) throws Exception {

        // Default admin account
        stmt.execute("INSERT INTO admin (username, password, full_name, email) VALUES " +
            "('admin', 'admin123', 'System Administrator', 'admin@officevpn.com')");

        // Sample employees
        stmt.execute("INSERT INTO employee (emp_code, username, password, full_name, email, department, designation, phone) VALUES " +
            "('EMP001', 'john.doe', 'john123', 'John Doe', 'john@company.com', 'Engineering', 'Software Engineer', '9876543210')");
        stmt.execute("INSERT INTO employee (emp_code, username, password, full_name, email, department, designation, phone) VALUES " +
            "('EMP002', 'jane.smith', 'jane123', 'Jane Smith', 'jane@company.com', 'Marketing', 'Marketing Manager', '9876543211')");
        stmt.execute("INSERT INTO employee (emp_code, username, password, full_name, email, department, designation, phone) VALUES " +
            "('EMP003', 'bob.wilson', 'bob123', 'Bob Wilson', 'bob@company.com', 'Finance', 'Financial Analyst', '9876543212')");
        stmt.execute("INSERT INTO employee (emp_code, username, password, full_name, email, department, designation, phone) VALUES " +
            "('EMP004', 'alice.brown', 'alice123', 'Alice Brown', 'alice@company.com', 'Engineering', 'DevOps Engineer', '9876543213')");
        stmt.execute("INSERT INTO employee (emp_code, username, password, full_name, email, department, designation, phone) VALUES " +
            "('EMP005', 'charlie.davis', 'charlie123', 'Charlie Davis', 'charlie@company.com', 'HR', 'HR Specialist', '9876543214')");

        // Sample VPN resources
        stmt.execute("INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level) VALUES " +
            "('Production Server', 'SERVER', 'Main production application server', '10.0.1.100', 'CRITICAL')");
        stmt.execute("INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level) VALUES " +
            "('Development Server', 'SERVER', 'Development and testing environment', '10.0.1.101', 'MEDIUM')");
        stmt.execute("INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level) VALUES " +
            "('HR Database', 'DATABASE', 'Employee records and HR data', '10.0.2.50', 'HIGH')");
        stmt.execute("INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level) VALUES " +
            "('Finance Database', 'DATABASE', 'Financial records and reports', '10.0.2.51', 'CRITICAL')");
        stmt.execute("INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level) VALUES " +
            "('Project Management App', 'APPLICATION', 'JIRA project management tool', '10.0.3.10', 'LOW')");
        stmt.execute("INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level) VALUES " +
            "('Shared Documents', 'FILE_SHARE', 'Company shared file repository', '10.0.4.20', 'LOW')");
        stmt.execute("INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level) VALUES " +
            "('Internal API Gateway', 'API', 'Microservices API gateway', '10.0.5.100', 'HIGH')");
        stmt.execute("INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level) VALUES " +
            "('Office Wi-Fi Network', 'NETWORK', 'Secure office wireless network', '10.0.0.1', 'MEDIUM')");

        // Sample VPN access grants
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (1, 2, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (1, 5, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (1, 6, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (2, 5, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (2, 6, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (3, 4, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (3, 6, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (4, 1, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (4, 2, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (4, 7, 'admin')");
        stmt.execute("INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (5, 6, 'admin')");

        // Sample activity logs
        stmt.execute("INSERT INTO activity_log (employee_id, action_type, description, ip_address) VALUES " +
            "(1, 'LOGIN', 'John Doe logged in', '192.168.1.10')");
        stmt.execute("INSERT INTO activity_log (employee_id, action_type, description, ip_address) VALUES " +
            "(1, 'ACCESS_RESOURCE', 'Accessed Development Server', '192.168.1.10')");
        stmt.execute("INSERT INTO activity_log (employee_id, action_type, description, ip_address) VALUES " +
            "(2, 'LOGIN', 'Jane Smith logged in', '192.168.1.11')");
        stmt.execute("INSERT INTO activity_log (employee_id, action_type, description, ip_address) VALUES " +
            "(2, 'SEARCH', 'Searched for database resources', '192.168.1.11')");
        stmt.execute("INSERT INTO activity_log (employee_id, action_type, description, ip_address) VALUES " +
            "(4, 'LOGIN', 'Alice Brown logged in', '192.168.1.13')");
        stmt.execute("INSERT INTO activity_log (employee_id, action_type, description, ip_address) VALUES " +
            "(4, 'ACCESS_RESOURCE', 'Accessed Production Server', '192.168.1.13')");

        // Sample access requests
        stmt.execute("INSERT INTO access_request (employee_id, resource_id, reason, status) VALUES " +
            "(1, 1, 'Need production access for deployment tasks', 'PENDING')");
        stmt.execute("INSERT INTO access_request (employee_id, resource_id, reason, status) VALUES " +
            "(2, 3, 'Require HR database access for campaign targeting', 'PENDING')");
        stmt.execute("INSERT INTO access_request (employee_id, resource_id, reason, status) VALUES " +
            "(3, 7, 'Need API access for financial integration', 'APPROVED')");

        System.out.println("[DB] Seeded: 1 admin, 5 employees, 8 resources, 11 access grants, 6 logs, 3 requests");
    }
}
