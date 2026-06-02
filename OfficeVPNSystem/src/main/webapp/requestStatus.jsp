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
    <title>Request Status — Office VPN System</title>
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
            <a href="requestAccess" class="menu-item"><span class="menu-icon">&#x1F4E8;</span> Request Access</a>
            <a href="requestStatus" class="menu-item active"><span class="menu-icon">&#x1F4CB;</span> Request Status</a>
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
                <div class="page-title">Request Status <small>Track your access requests</small></div>
            </div>
            <div class="navbar-actions">
                <a href="logout" class="btn-logout">&#x1F6AA; Logout</a>
            </div>
        </header>

        <div class="page-content fade-in">

            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x1F4CB;</span> My Access Requests (${requests.size()})</h2>
                    <a href="requestAccess" class="btn btn-primary btn-sm">+ New Request</a>
                </div>
                <div class="card-body no-padding">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Resource</th>
                                    <th>Type</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Admin Remarks</th>
                                    <th>Requested</th>
                                    <th>Processed</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="req" items="${requests}" varStatus="i">
                                    <tr>
                                        <td>${i.count}</td>
                                        <td><strong>${req.resourceName}</strong></td>
                                        <td><span class="badge badge-${req.resourceType.toLowerCase()}">${req.resourceType}</span></td>
                                        <td style="max-width:200px;">${req.reason}</td>
                                        <td><span class="badge badge-${req.status.toLowerCase()}">${req.status}</span></td>
                                        <td class="text-muted">${req.adminRemarks != null ? req.adminRemarks : '—'}</td>
                                        <td class="text-muted"><fmt:formatDate value="${req.requestedAt}" pattern="MMM dd, HH:mm"/></td>
                                        <td class="text-muted">
                                            <c:if test="${req.processedAt != null}">
                                                <fmt:formatDate value="${req.processedAt}" pattern="MMM dd, HH:mm"/>
                                            </c:if>
                                            <c:if test="${req.processedAt == null}">—</c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty requests}">
                                    <tr><td colspan="8">
                                        <div class="empty-state">
                                            <div class="empty-icon">&#x1F4ED;</div>
                                            <h3>No requests yet</h3>
                                            <p>You haven't submitted any access requests. <a href="requestAccess">Request access</a> to a resource.</p>
                                        </div>
                                    </td></tr>
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
