<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session == null || !"employee".equals(session.getAttribute("role"))) {
        response.sendRedirect("login");
        return;
    }
    String empName = (String) session.getAttribute("employeeName");
    String empDept = (String) session.getAttribute("department");
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
    <title>Request Access — Office VPN System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="layout">

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo-sm">&#x1F512;</div>
            <div class="brand-text">Office VPN<small>Employee Portal</small></div>
        </div>
        <nav class="sidebar-menu">
            <div class="menu-label">Main</div>
            <a href="employeeDashboard" class="menu-item"><span class="menu-icon">&#x1F4CA;</span> Dashboard</a>
            <div class="menu-label">Resources</div>
            <a href="employeeResources" class="menu-item"><span class="menu-icon">&#x1F5A5;</span> My Resources</a>
            <a href="requestAccess" class="menu-item active"><span class="menu-icon">&#x1F4E8;</span> Request Access</a>
            <a href="requestStatus" class="menu-item"><span class="menu-icon">&#x1F4CB;</span> Request Status</a>
        </nav>
        <div class="sidebar-footer">
            <div class="user-info">
                <div class="user-avatar"><%= empName.charAt(0) %></div>
                <div class="user-details">
                    <div class="user-name"><%= empName %></div>
                    <div class="user-role"><%= empDept %></div>
                </div>
            </div>
        </div>
    </aside>

    <div class="main-content">
        <header class="top-navbar">
            <div style="display:flex;align-items:center;gap:12px;">
                <button class="hamburger" onclick="document.getElementById('sidebar').classList.toggle('open')">&#9776;</button>
                <div class="page-title">Request Access <small>Request VPN resource access</small></div>
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

            <!-- Request Form -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x1F4E8;</span> Submit Access Request</h2>
                </div>
                <div class="card-body">
                    <c:if test="${not empty restrictedResources}">
                        <form action="requestAccess" method="post" data-validate="true">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Select Resource *</label>
                                    <select name="resourceId" required>
                                        <option value="">Choose a resource to request access</option>
                                        <c:forEach var="res" items="${restrictedResources}">
                                            <option value="${res.id}">${res.resourceName} (${res.resourceType}) — ${res.accessLevel}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Reason for Access *</label>
                                <textarea name="reason" placeholder="Explain why you need access to this resource. This will be reviewed by admin." required rows="4"></textarea>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">&#x1F4E8; Submit Request</button>
                            </div>
                        </form>
                    </c:if>
                    <c:if test="${empty restrictedResources}">
                        <div class="empty-state">
                            <div class="empty-icon">&#x2705;</div>
                            <h3>You have access to all resources!</h3>
                            <p>There are no restricted resources to request access for.</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Restricted Resources Info -->
            <c:if test="${not empty restrictedResources}">
                <div class="card">
                    <div class="card-header">
                        <h2><span class="header-icon">&#x1F512;</span> Restricted Resources (${restrictedResources.size()})</h2>
                    </div>
                    <div class="card-body no-padding">
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Resource</th>
                                        <th>Type</th>
                                        <th>Description</th>
                                        <th>Access Level</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="res" items="${restrictedResources}">
                                        <tr>
                                            <td><strong>${res.resourceName}</strong></td>
                                            <td><span class="badge badge-${res.resourceType.toLowerCase()}">${res.resourceType}</span></td>
                                            <td class="text-muted">${res.description}</td>
                                            <td><span class="badge badge-${res.accessLevel.toLowerCase()}">${res.accessLevel}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>

        </div>
    </div>
</div>

<script src="js/script.js"></script>
</body>
</html>
