<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login");
        return;
    }
    String adminName = (String) session.getAttribute("adminName");
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
    <title>Access Control — Office VPN System</title>
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
            <a href="grantAccess" class="menu-item active"><span class="menu-icon">&#x1F511;</span> Access Control</a>
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

    <div class="main-content">
        <header class="top-navbar">
            <div style="display:flex;align-items:center;gap:12px;">
                <button class="hamburger" onclick="document.getElementById('sidebar').classList.toggle('open')">&#9776;</button>
                <div class="page-title">Access Control <small>Grant / Revoke VPN Access</small></div>
            </div>
            <div class="navbar-actions">
                <a href="logout" class="btn-logout">&#x1F6AA; Logout</a>
            </div>
        </header>

        <div class="page-content fade-in">

            <% if (successMsg != null) { %>
                <div class="alert alert-success"><span>&#x2705;</span> <%= successMsg %> <button class="close-alert">&times;</button></div>
            <% } %>
            <% if (errorMsg != null) { %>
                <div class="alert alert-danger"><span>&#x26A0;</span> <%= errorMsg %> <button class="close-alert">&times;</button></div>
            <% } %>

            <!-- Grant Access Form -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x2795;</span> Grant New Access</h2>
                </div>
                <div class="card-body">
                    <form action="grantAccess" method="post" data-validate="true">
                        <input type="hidden" name="action" value="grant">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Select Employee *</label>
                                <select name="employeeId" required>
                                    <option value="">Choose Employee</option>
                                    <c:forEach var="emp" items="${employees}">
                                        <option value="${emp.id}">${emp.fullName} (${emp.empCode})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Select Resource *</label>
                                <select name="resourceId" required>
                                    <option value="">Choose Resource</option>
                                    <c:forEach var="res" items="${resources}">
                                        <option value="${res.id}">${res.resourceName} (${res.resourceType})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group" style="display:flex;align-items:flex-end;">
                                <button type="submit" class="btn btn-success">&#x1F511; Grant Access</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Current Access Table -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x1F511;</span> Current Access Grants (${accessList.size()})</h2>
                </div>
                <div class="card-body no-padding">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Employee</th>
                                    <th>Resource</th>
                                    <th>Granted By</th>
                                    <th>Granted At</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="access" items="${accessList}" varStatus="i">
                                    <tr>
                                        <td>${i.count}</td>
                                        <td><strong>${access.employeeName}</strong></td>
                                        <td>${access.resourceName}</td>
                                        <td>${access.grantedBy}</td>
                                        <td class="text-muted"><fmt:formatDate value="${access.grantedAt}" pattern="MMM dd, yyyy HH:mm"/></td>
                                        <td><span class="badge badge-${access.status.toLowerCase()}">${access.status}</span></td>
                                        <td>
                                            <c:if test="${access.status == 'ACTIVE'}">
                                                <form action="grantAccess" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="revoke">
                                                    <input type="hidden" name="employeeId" value="${access.employeeId}">
                                                    <input type="hidden" name="resourceId" value="${access.resourceId}">
                                                    <button type="submit" class="btn btn-danger btn-sm btn-revoke">&#x1F6AB; Revoke</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${access.status == 'REVOKED'}">
                                                <span class="text-muted">Revoked</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty accessList}">
                                    <tr><td colspan="7" class="text-center text-muted" style="padding:32px;">No access grants found.</td></tr>
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
