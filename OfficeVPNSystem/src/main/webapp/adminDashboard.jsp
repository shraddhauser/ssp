<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // Session check
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login");
        return;
    }
    String adminName = (String) session.getAttribute("adminName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — Office VPN System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="layout">

    <!-- SIDEBAR -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo-sm">&#x1F512;</div>
            <div class="brand-text">
                Office VPN
                <small>Admin Panel</small>
            </div>
        </div>
        <nav class="sidebar-menu">
            <div class="menu-label">Main</div>
            <a href="adminDashboard" class="menu-item active">
                <span class="menu-icon">&#x1F4CA;</span> Dashboard
            </a>

            <div class="menu-label">Management</div>
            <a href="manageEmployees" class="menu-item">
                <span class="menu-icon">&#x1F465;</span> Employees
            </a>
            <a href="manageResources" class="menu-item">
                <span class="menu-icon">&#x1F5A5;</span> VPN Resources
            </a>
            <a href="grantAccess" class="menu-item">
                <span class="menu-icon">&#x1F511;</span> Access Control
            </a>

            <div class="menu-label">Monitoring</div>
            <a href="accessLogs" class="menu-item">
                <span class="menu-icon">&#x1F4DD;</span> Activity Logs
            </a>
            <a href="adminRequests?filter=pending" class="menu-item">
                <span class="menu-icon">&#x1F4E9;</span> Access Requests
                <c:if test="${pendingRequests > 0}">
                    <span class="badge-count">${pendingRequests}</span>
                </c:if>
            </a>
        </nav>
        <div class="sidebar-footer">
            <div class="user-info">
                <div class="user-avatar"><%= adminName != null ? adminName.charAt(0) : 'A' %></div>
                <div class="user-details">
                    <div class="user-name"><%= adminName %></div>
                    <div class="user-role">Administrator</div>
                </div>
            </div>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <!-- Top Navbar -->
        <header class="top-navbar">
            <div style="display:flex;align-items:center;gap:12px;">
                <button class="hamburger" onclick="document.getElementById('sidebar').classList.toggle('open')">&#9776;</button>
                <div class="page-title">Dashboard <small>Welcome back, <%= adminName %></small></div>
            </div>
            <div class="navbar-actions">
                <a href="logout" class="btn-logout">&#x1F6AA; Logout</a>
            </div>
        </header>

        <!-- Page Content -->
        <div class="page-content fade-in">

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">&#x1F465;</div>
                    <div class="stat-info">
                        <h3>${totalEmployees}</h3>
                        <p>Total Employees</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">&#x1F5A5;</div>
                    <div class="stat-info">
                        <h3>${totalResources}</h3>
                        <p>VPN Resources</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon purple">&#x1F511;</div>
                    <div class="stat-info">
                        <h3>${activeVPNs}</h3>
                        <p>Active VPN Grants</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">&#x1F4E9;</div>
                    <div class="stat-info">
                        <h3>${pendingRequests}</h3>
                        <p>Pending Requests</p>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x26A1;</span> Quick Actions</h2>
                </div>
                <div class="card-body">
                    <div style="display:flex;gap:12px;flex-wrap:wrap;">
                        <a href="manageEmployees" class="btn btn-primary">&#x2795; Add Employee</a>
                        <a href="manageResources" class="btn btn-success">&#x2795; Add Resource</a>
                        <a href="grantAccess" class="btn btn-outline">&#x1F511; Manage Access</a>
                        <a href="adminRequests?filter=pending" class="btn btn-warning">&#x1F4E9; View Requests</a>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x1F4DD;</span> Recent Activity</h2>
                    <a href="accessLogs" class="btn btn-outline btn-sm">View All</a>
                </div>
                <div class="card-body no-padding">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Action</th>
                                    <th>Description</th>
                                    <th>IP Address</th>
                                    <th>Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="log" items="${recentLogs}">
                                    <tr>
                                        <td><strong>${log.employeeName != null ? log.employeeName : 'System'}</strong></td>
                                        <td>
                                            <span class="badge badge-${log.actionType.toLowerCase()}">${log.actionType}</span>
                                        </td>
                                        <td>${log.description}</td>
                                        <td><code>${log.ipAddress}</code></td>
                                        <td class="text-muted"><fmt:formatDate value="${log.createdAt}" pattern="MMM dd, HH:mm"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentLogs}">
                                    <tr><td colspan="5" class="text-center text-muted" style="padding:32px;">No activity logs yet.</td></tr>
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
