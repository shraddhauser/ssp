<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
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
    <title>Activity Logs — Office VPN System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="layout">

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo-sm">&#x1F512;</div>
            <div class="brand-text">Office VPN<small>Admin Panel</small></div>
        </div>
        <nav class="sidebar-menu">
            <div class="menu-label">Main</div>
            <a href="adminDashboard" class="menu-item"><span class="menu-icon">&#x1F4CA;</span> Dashboard</a>
            <div class="menu-label">Management</div>
            <a href="manageEmployees" class="menu-item"><span class="menu-icon">&#x1F465;</span> Employees</a>
            <a href="manageResources" class="menu-item"><span class="menu-icon">&#x1F5A5;</span> VPN Resources</a>
            <a href="grantAccess" class="menu-item"><span class="menu-icon">&#x1F511;</span> Access Control</a>
            <div class="menu-label">Monitoring</div>
            <a href="accessLogs" class="menu-item active"><span class="menu-icon">&#x1F4DD;</span> Activity Logs</a>
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

    <div class="main-content">
        <header class="top-navbar">
            <div style="display:flex;align-items:center;gap:12px;">
                <button class="hamburger" onclick="document.getElementById('sidebar').classList.toggle('open')">&#9776;</button>
                <div class="page-title">Activity Logs <small>Monitor employee activity</small></div>
            </div>
            <div class="navbar-actions">
                <a href="logout" class="btn-logout">&#x1F6AA; Logout</a>
            </div>
        </header>

        <div class="page-content fade-in">

            <!-- Logs Table -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x1F4DD;</span> All Activity Logs (${logs.size()})</h2>
                    <div style="display:flex;gap:10px;align-items:center;">
                        <c:if test="${filteredEmployeeId != null}">
                            <a href="accessLogs" class="btn btn-outline btn-sm">&#x2715; Clear Filter</a>
                        </c:if>
                        <input type="text" class="table-search-input" placeholder="&#x1F50D; Search logs..."
                               style="padding:8px 14px; border:1.5px solid #E2E8F0; border-radius:6px; font-size:13px; width:220px; outline:none;">
                    </div>
                </div>
                <div class="card-body no-padding">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Employee</th>
                                    <th>Action Type</th>
                                    <th>Description</th>
                                    <th>IP Address</th>
                                    <th>Timestamp</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="log" items="${logs}" varStatus="i">
                                    <tr>
                                        <td>${i.count}</td>
                                        <td>
                                            <c:if test="${log.employeeName != null}">
                                                <a href="accessLogs?employeeId=${log.employeeId}"><strong>${log.employeeName}</strong></a>
                                            </c:if>
                                            <c:if test="${log.employeeName == null}">
                                                <span class="text-muted">System</span>
                                            </c:if>
                                        </td>
                                        <td><span class="badge badge-${log.actionType.toLowerCase()}">${log.actionType}</span></td>
                                        <td>${log.description}</td>
                                        <td><code>${log.ipAddress}</code></td>
                                        <td class="text-muted"><fmt:formatDate value="${log.createdAt}" pattern="MMM dd, yyyy HH:mm:ss"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty logs}">
                                    <tr><td colspan="6" class="text-center text-muted" style="padding:32px;">No activity logs found.</td></tr>
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
