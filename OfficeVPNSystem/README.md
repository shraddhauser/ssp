# Office VPN Resource Access Management System

A full-stack Java web application for managing VPN resource access in an office environment. Built with JSP, Servlets, JDBC, and MySQL.

---

## 🚀 Quick Start

### Prerequisites

1. **Java JDK 8+** — [Download](https://adoptium.net/)
   - Set `JAVA_HOME` environment variable
   - Add `%JAVA_HOME%\bin` to PATH

2. **Apache Maven 3.6+** — [Download](https://maven.apache.org/download.cgi)
   - Extract and add `bin` folder to PATH
   - Verify: `mvn -version`

3. **MySQL 8.0+** — [Download](https://dev.mysql.com/downloads/mysql/)
   - Install MySQL Server
   - Remember your root password

---

## 📦 Setup Steps

### Step 1: Setup MySQL Database

1. Open **MySQL Workbench** (or MySQL command line)
2. Connect to your MySQL server
3. Open the file `database/schema.sql`
4. Execute the entire SQL script
5. Verify: You should see `office_vpn_db` database with 6 tables

```sql
-- Quick verification
USE office_vpn_db;
SHOW TABLES;
-- Should show: admin, employee, resource, vpn_access, activity_log, access_request
```

### Step 2: Configure Database Connection

Edit the file: `src/main/java/com/officevpn/db/DBConnection.java`

Update these values to match your MySQL setup:
```java
private static final String URL = "jdbc:mysql://localhost:3306/office_vpn_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
private static final String USER = "root";       // Your MySQL username
private static final String PASSWORD = "root";    // Your MySQL password
```

### Step 3: Run the Application

**Option A: Using the batch file (Windows)**
```
Double-click run.bat
```

**Option B: Using Maven command**
```bash
cd OfficeVPNSystem
mvn clean compile tomcat7:run
```

### Step 4: Open in Browser

Navigate to: **http://localhost:8080**

---

## 🔑 Default Login Credentials

| Role | Username | Password |
|------|----------|----------|
| Admin | `admin` | `admin123` |
| Employee | `john.doe` | `john123` |
| Employee | `jane.smith` | `jane123` |
| Employee | `bob.wilson` | `bob123` |
| Employee | `alice.brown` | `alice123` |
| Employee | `charlie.davis` | `charlie123` |

---

## 📋 Features

### Admin Module
- ✅ Secure admin login
- ✅ Dashboard with statistics (employees, resources, VPN grants, pending requests)
- ✅ Add / Update / Delete employees
- ✅ Add / Manage VPN resources
- ✅ Grant / Revoke employee access to resources
- ✅ View employee activity logs
- ✅ Track employee searches and resource access
- ✅ View access requests from employees
- ✅ Approve / Reject access requests
- ✅ Full monitoring system

### Employee Module
- ✅ Secure employee login
- ✅ Employee dashboard
- ✅ View only allowed resources
- ✅ Search available resources
- ✅ Request access for restricted resources
- ✅ View request status
- ✅ All activity logged for admin monitoring

---

## 🗂️ Project Structure

```
OfficeVPNSystem/
├── pom.xml                          # Maven config + embedded Tomcat
├── run.bat                          # One-click launcher
├── database/
│   └── schema.sql                   # Complete MySQL schema
├── src/main/java/com/officevpn/
│   ├── db/DBConnection.java         # JDBC connection utility
│   ├── model/                       # POJOs (Admin, Employee, Resource, etc.)
│   ├── dao/                         # Data Access Objects (CRUD operations)
│   └── servlet/                     # Servlet controllers (12 servlets)
└── src/main/webapp/
    ├── WEB-INF/web.xml
    ├── login.jsp
    ├── adminDashboard.jsp
    ├── employeeDashboard.jsp
    ├── manageEmployees.jsp
    ├── manageResources.jsp
    ├── grantAccess.jsp
    ├── accessLogs.jsp
    ├── accessRequests.jsp
    ├── employeeResources.jsp
    ├── requestAccess.jsp
    ├── requestStatus.jsp
    ├── css/style.css
    └── js/script.js
```

---

## 🗃️ Database Tables

| Table | Description |
|-------|-------------|
| `admin` | Admin login credentials |
| `employee` | Employee profiles and credentials |
| `resource` | VPN-accessible company resources |
| `vpn_access` | Employee ↔ Resource access mapping |
| `activity_log` | All employee activity tracking |
| `access_request` | Employee access requests with status |

---

## 🛠️ Technology Stack

- **Frontend**: JSP, HTML5, CSS3, JavaScript
- **Backend**: Java Servlets (3.1)
- **Database**: MySQL 8.0 with JDBC
- **Build Tool**: Maven
- **Server**: Embedded Tomcat (via Maven plugin)
- **UI**: Custom professional light theme

---

## 🔧 Troubleshooting

### "Driver not found" error
Make sure MySQL Connector JAR is in the classpath. Maven handles this automatically — just run `mvn clean compile tomcat7:run`.

### "Access denied" for MySQL
Update `DBConnection.java` with your correct MySQL username and password.

### Port 8080 already in use
Edit `pom.xml` and change the port in the tomcat7-maven-plugin configuration.

### First time Maven run is slow
Maven needs to download dependencies. The first run may take 2-5 minutes. Subsequent runs are fast.

---

## Expected Output

1. **Login Page**: Professional login card with Admin/Employee role tabs
2. **Admin Dashboard**: 4 stat cards, quick actions, recent activity table
3. **Manage Employees**: Full CRUD table with add/edit forms
4. **Manage Resources**: Resource table with type and access-level badges
5. **Access Control**: Grant/revoke interface with dropdown selectors
6. **Activity Logs**: Complete activity monitoring with employee filter
7. **Access Requests**: Pending/All filter tabs with approve/reject buttons
8. **Employee Dashboard**: Personal stats and recent activity
9. **Employee Resources**: Searchable resource cards
10. **Request Access**: Form to request restricted resources
11. **Request Status**: Track all submitted requests with status badges
