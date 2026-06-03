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
    <title>Manage Resources — Office VPN System</title>
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
            <a href="manageResources" class="menu-item active"><span class="menu-icon">&#x1F5A5;</span> VPN Resources</a>
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

    <div class="main-content">
        <header class="top-navbar">
            <div style="display:flex;align-items:center;gap:12px;">
                <button class="hamburger" onclick="document.getElementById('sidebar').classList.toggle('open')">&#9776;</button>
                <div class="page-title">Manage VPN Resources</div>
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

            <!-- Add Resource Form -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x2795;</span> Add / Edit Resource</h2>
                    <button class="btn btn-primary btn-sm btn-toggle-form">+ Add New</button>
                </div>
                <div class="add-form-panel" style="display:none; margin:0; border-radius:0; border:none; border-bottom:1px solid #E2E8F0;">
                    <form action="manageResources" method="post" data-validate="true">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="id" value="">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Resource Name *</label>
                                <input type="text" name="resourceName" placeholder="e.g. Production Server" required>
                            </div>
                            <div class="form-group">
                                <label>Resource Type *</label>
                                <select name="resourceType" required>
                                    <option value="">Select Type</option>
                                    <option value="SERVER">Server</option>
                                    <option value="DATABASE">Database</option>
                                    <option value="APPLICATION">Application</option>
                                    <option value="FILE_SHARE">File Share</option>
                                    <option value="API">API</option>
                                    <option value="NETWORK">Network</option>
                                </select>
                            </div>
                            <input type="hidden" name="ipAddress" value="">
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Description</label>
                                <textarea name="description" placeholder="Describe this resource"></textarea>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Access Level *</label>
                                <select name="accessLevel" required>
                                    <option value="LOW">Low</option>
                                    <option value="MEDIUM" selected>Medium</option>
                                    <option value="HIGH">High</option>
                                    <option value="CRITICAL">Critical</option>
                                </select>
                            </div>
                            <input type="hidden" name="status" value="ACTIVE">
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">&#x1F4BE; Save Resource</button>
                            <button type="reset" class="btn btn-outline">Reset</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Resources Table -->
            <div class="card">
                <div class="card-header">
                    <h2><span class="header-icon">&#x1F5A5;</span> All Resources (${resources.size()})</h2>
                    <input type="text" class="table-search-input" placeholder="&#x1F50D; Search resources..."
                           style="padding:8px 14px; border:1.5px solid #E2E8F0; border-radius:6px; font-size:13px; width:240px; outline:none;">
                </div>
                <div class="card-body no-padding">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                    <th>Type</th>
                                    <th>IP Address</th>
                                    <th>Access Level</th>
                                    <th>Status</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="res" items="${resources}" varStatus="i">
                                    <tr>
                                        <td>${i.count}</td>
                                        <td><strong>${res.resourceName}</strong></td>
                                        <td><span class="badge badge-${res.resourceType.toLowerCase()}">${res.resourceType}</span></td>
                                        <td><code>${res.ipAddress}</code></td>
                                        <td><span class="badge badge-${res.accessLevel.toLowerCase()}">${res.accessLevel}</span></td>
                                        <td>
                                            <span class="badge badge-${res.status.toLowerCase()}">${res.status}</span>
                                        </td>
                                        <td class="text-muted" style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">${res.description}</td>
                                        <td>
                                            <div class="action-btns">
                                                <button class="btn btn-primary btn-sm btn-edit"
                                                    data-item='{"id":"${res.id}","resourceName":"${res.resourceName}","resourceType":"${res.resourceType}","description":"${res.description}","ipAddress":"${res.ipAddress}","accessLevel":"${res.accessLevel}","status":"${res.status}"}'>
                                                    &#x270F; Edit
                                                </button>
                                                <form action="manageResources" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${res.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm btn-delete">&#x1F5D1;</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty resources}">
                                    <tr><td colspan="8" class="text-center text-muted" style="padding:32px;">No resources found.</td></tr>
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
