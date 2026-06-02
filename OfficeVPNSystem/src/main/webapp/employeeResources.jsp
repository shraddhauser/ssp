<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>My Resources — Office VPN System</title>
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
            <a href="employeeResources" class="menu-item active"><span class="menu-icon">&#x1F5A5;</span> My Resources</a>
            <a href="requestAccess" class="menu-item"><span class="menu-icon">&#x1F4E8;</span> Request Access</a>
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
                <div class="page-title">My Resources <small>VPN accessible resources</small></div>
            </div>
            <div class="navbar-actions">
                <a href="logout" class="btn-logout">&#x1F6AA; Logout</a>
            </div>
        </header>

        <div class="page-content fade-in">

            <!-- Search Bar -->
            <form action="employeeResources" method="get" class="search-bar">
                <input type="text" name="search" placeholder="&#x1F50D; Search your resources by name, type, or description..."
                       value="${searchTerm}">
                <button type="submit" class="btn btn-primary">Search</button>
                <c:if test="${searchTerm != null}">
                    <a href="employeeResources" class="btn btn-outline">Clear</a>
                </c:if>
            </form>

            <c:if test="${searchTerm != null}">
                <div class="alert alert-info">
                    <span>&#x1F50D;</span> Showing results for: <strong>"${searchTerm}"</strong> (${resources.size()} found)
                    <button class="close-alert">&times;</button>
                </div>
            </c:if>

            <!-- Resources Grid -->
            <c:if test="${not empty resources}">
                <div class="resource-grid">
                    <c:forEach var="res" items="${resources}">
                        <div class="resource-card">
                            <div class="rc-header">
                                <div class="rc-name">${res.resourceName}</div>
                                <span class="badge badge-${res.resourceType.toLowerCase()}">${res.resourceType}</span>
                            </div>
                            <div class="rc-desc">${res.description != null ? res.description : 'No description available.'}</div>
                            <div class="rc-meta">
                                <span class="rc-ip">&#x1F310; ${res.ipAddress}</span>
                                <span class="badge badge-${res.accessLevel.toLowerCase()}">${res.accessLevel}</span>
                                <span class="badge badge-${res.status.toLowerCase()}">${res.status}</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty resources}">
                <div class="card">
                    <div class="card-body">
                        <div class="empty-state">
                            <div class="empty-icon">&#x1F512;</div>
                            <h3>No resources available</h3>
                            <p>You don't have access to any resources yet. <a href="requestAccess">Request access</a> to get started.</p>
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
