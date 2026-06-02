<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (session == null || !"employee".equals(session.getAttribute("role"))) {
        response.sendRedirect("login");
        return;
    }
    String empName = (String) session.getAttribute("employeeName");
    String empDept = (String) session.getAttribute("department");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard — Office VPN System</title>
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
                <small>Employee Portal</small>
            </div>
        </div>
        <nav class="sidebar-menu">
            <div class="menu-label">Main</div>
            <a href="employeeDashboard" class="menu-item active">
                <span class="menu-icon">&#x1F4CA;</span> Dashboard
            </a>

            <div class="menu-label">Resources</div>
            <a href="employeeResources" class="menu-item">
                <span class="menu-icon">&#x1F5A5;</span> My Resources
            </a>
            <a href="requestAccess" class="menu-item">
                <span class="menu-icon">&#x1F4E8;</span> Request Access
            </a>
            <a href="requestStatus" class="menu-item">
                <span class="menu-icon">&#x1F4CB;</span> Request Status
                <c:if test="${pendingRequests > 0}">
                    <span class="badge-count">${pendingRequests}</span>
                </c:if>
            </a>
        </nav>
        <div class="sidebar-footer">
            <div class="user-info">
                <div class="user-avatar"><%= empName != null ? empName.charAt(0) : 'E' %></div>
                <div class="user-details">
                    <div class="user-name"><%= empName %></div>
                    <div class="user-role"><%= empDept %></div>
                </div>
            </div>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <header class="top-navbar">
            <div style="display:flex;align-items:center;gap:12px;">
                <button class="hamburger" onclick="document.getElementById('sidebar').classList.toggle('open')">&#9776;</button>
                <div class="page-title">Dashboard <small>Welcome, <%= empName %></small></div>
            </div>
            <div class="navbar-actions">
                <a href="logout" class="btn-logout">&#x1F6AA; Logout</a>
            </div>
        </header>

        <div class="page-content fade-in">

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon green">&#x1F511;</div>
                    <div class="stat-info">
                        <h3>${accessCount}</h3>
                        <p>Accessible Resources</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">&#x23F3;</div>
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
                        <a href="employeeResources" class="btn btn-primary">&#x1F5A5; View My Resources</a>
                        <a href="requestAccess" class="btn btn-success">&#x1F4E8; Request New Access</a>
                        <a href="requestStatus" class="btn btn-outline">&#x1F4CB; Check Request Status</a>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x1F4DD;</span> Your Recent Activity</h2>
                </div>
                <div class="card-body no-padding">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Action</th>
                                    <th>Description</th>
                                    <th>IP Address</th>
                                    <th>Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="log" items="${recentLogs}">
                                    <tr>
                                        <td><span class="badge badge-${log.actionType.toLowerCase()}">${log.actionType}</span></td>
                                        <td>${log.description}</td>
                                        <td><code>${log.ipAddress}</code></td>
                                        <td class="text-muted"><fmt:formatDate value="${log.createdAt}" pattern="MMM dd, HH:mm"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentLogs}">
                                    <tr><td colspan="4" class="text-center text-muted" style="padding:32px;">No activity yet.</td></tr>
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
