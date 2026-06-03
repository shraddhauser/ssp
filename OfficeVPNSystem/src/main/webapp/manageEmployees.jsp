<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login");
        return;
    }
    String adminName = (String) session.getAttribute("adminName");
    // Flash messages
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg != null) session.removeAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Employees — Office VPN System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="layout">

    <!-- SIDEBAR -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo-sm">&#x1F512;</div>
            <div class="brand-text">Office VPN<small>Admin Panel</small></div>
        </div>
        <nav class="sidebar-menu">
            <div class="menu-label">Main</div>
            <a href="adminDashboard" class="menu-item"><span class="menu-icon">&#x1F4CA;</span> Dashboard</a>
            <div class="menu-label">Management</div>
            <a href="manageEmployees" class="menu-item active"><span class="menu-icon">&#x1F465;</span> Employees</a>
            <a href="manageResources" class="menu-item"><span class="menu-icon">&#x1F5A5;</span> VPN Resources</a>
            <a href="grantAccess" class="menu-item"><span class="menu-icon">&#x1F511;</span> Access Control</a>
            <div class="menu-label">Monitoring</div>
            <a href="accessLogs" class="menu-item"><span class="menu-icon">&#x1F4DD;</span> Activity Logs</a>
            <a href="adminRequests?filter=pending" class="menu-item"><span class="menu-icon">&#x1F4E9;</span> Access Requests</a>
        </nav>
        <div class="sidebar-footer">
            <div class="user-info">
                <div class="user-avatar"><%= adminName.charAt(0) %></div>
                <div class="user-details">
                    <div class="user-name"><%= adminName %></div>
                    <div class="user-role">Administrator</div>
                </div>
            </div>
        </div>
    </aside>

    <!-- MAIN -->
    <div class="main-content">
        <header class="top-navbar">
            <div style="display:flex;align-items:center;gap:12px;">
                <button class="hamburger" onclick="document.getElementById('sidebar').classList.toggle('open')">&#9776;</button>
                <div class="page-title">Manage Employees</div>
            </div>
            <div class="navbar-actions">
                <a href="logout" class="btn-logout">&#x1F6AA; Logout</a>
            </div>
        </header>

        <div class="page-content fade-in">

            <!-- Alerts -->
            <% if (successMsg != null) { %>
                <div class="alert alert-success"><span>&#x2705;</span> <%= successMsg %> <button class="close-alert">&times;</button></div>
            <% } %>
            <% if (errorMsg != null) { %>
                <div class="alert alert-danger"><span>&#x26A0;</span> <%= errorMsg %> <button class="close-alert">&times;</button></div>
            <% } %>

            <!-- Add Employee Form -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x2795;</span> Add / Edit Employee</h2>
                    <button class="btn btn-primary btn-sm btn-toggle-form">+ Add New</button>
                </div>
                <div class="add-form-panel" style="display:none; margin:0; border-radius:0; border:none; border-bottom:1px solid #E2E8F0;">
                    <form action="manageEmployees" method="post" data-validate="true">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="id" value="">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Employee Code *</label>
                                <input type="text" name="empCode" placeholder="e.g. EMP006" required>
                            </div>
                            <div class="form-group">
                                <label>Full Name *</label>
                                <input type="text" name="fullName" placeholder="John Doe" required>
                            </div>
                            <div class="form-group">
                                <label>Username *</label>
                                <input type="text" name="username" placeholder="john.doe" required>
                            </div>
                            <div class="form-group">
                                <label>Password *</label>
                                <input type="text" name="password" placeholder="Enter password" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Email *</label>
                                <input type="email" name="email" placeholder="john@company.com" required>
                            </div>
                            <div class="form-group">
                                <label>Department *</label>
                                <select name="department" required>
                                    <option value="">Select Department</option>
                                    <option value="Engineering">Engineering</option>
                                    <option value="Marketing">Marketing</option>
                                    <option value="Finance">Finance</option>
                                    <option value="HR">HR</option>
                                    <option value="Operations">Operations</option>
                                    <option value="Sales">Sales</option>
                                    <option value="IT">IT</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Designation *</label>
                                <input type="text" name="designation" placeholder="Software Engineer" required>
                            </div>
                            <input type="hidden" name="phone" value="">
                        </div>
                        <div class="form-group" style="display:none;">
                            <label>Status</label>
                            <select name="status">
                                <option value="ACTIVE">Active</option>
                                <option value="INACTIVE">Inactive</option>
                            </select>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">&#x1F4BE; Save Employee</button>
                            <button type="reset" class="btn btn-outline">Reset</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Employee Table -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x1F465;</span> All Employees (${employees.size()})</h2>
                    <input type="text" class="table-search-input" placeholder="&#x1F50D; Search employees..."
                           style="padding:8px 14px; border:1.5px solid #E2E8F0; border-radius:6px; font-size:13px; width:240px; outline:none;">
                </div>
                <div class="card-body no-padding">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Emp Code</th>
                                    <th>Name</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Department</th>
                                    <th>Designation</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="emp" items="${employees}" varStatus="i">
                                    <tr>
                                        <td>${i.count}</td>
                                        <td><strong>${emp.empCode}</strong></td>
                                        <td>${emp.fullName}</td>
                                        <td><code>${emp.username}</code></td>
                                        <td>${emp.email}</td>
                                        <td>${emp.department}</td>
                                        <td>${emp.designation}</td>
                                        <td>
                                            <span class="badge badge-${emp.status.toLowerCase()}">${emp.status}</span>
                                        </td>
                                        <td>
                                            <div class="action-btns">
                                                <button class="btn btn-primary btn-sm btn-edit"
                                                    data-item='{"id":"${emp.id}","empCode":"${emp.empCode}","fullName":"${emp.fullName}","username":"${emp.username}","email":"${emp.email}","department":"${emp.department}","designation":"${emp.designation}","phone":"${emp.phone}","status":"${emp.status}"}'>
                                                    &#x270F; Edit
                                                </button>
                                                <form action="manageEmployees" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${emp.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm btn-delete">&#x1F5D1; Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty employees}">
                                    <tr><td colspan="9" class="text-center text-muted" style="padding:32px;">No employees found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="js/script.js"></script>
</body>
</html>
