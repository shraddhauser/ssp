<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <% if (session==null || !"admin".equals(session.getAttribute("role"))) { response.sendRedirect("login");
                return; } String adminName=(String) session.getAttribute("adminName"); String successMsg=(String)
                session.getAttribute("successMsg"); String errorMsg=(String) session.getAttribute("errorMsg"); if
                (successMsg !=null) session.removeAttribute("successMsg"); if (errorMsg !=null)
                session.removeAttribute("errorMsg"); %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Access Requests — Office VPN System</title>
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
                                <a href="adminDashboard" class="menu-item"><span class="menu-icon">&#x1F4CA;</span>
                                    Dashboard</a>
                                <div class="menu-label">Management</div>
                                <a href="manageEmployees" class="menu-item"><span class="menu-icon">&#x1F465;</span>
                                    Employees</a>
                                <a href="manageResources" class="menu-item"><span class="menu-icon">&#x1F5A5;</span> VPN
                                    Resources</a>
                                <a href="grantAccess" class="menu-item"><span class="menu-icon">&#x1F511;</span> Access
                                    Control</a>
                                <div class="menu-label">Monitoring</div>
                                <a href="accessLogs" class="menu-item"><span class="menu-icon">&#x1F4DD;</span> Activity
                                    Logs</a>
                                <a href="adminRequests?filter=pending" class="menu-item active"><span
                                        class="menu-icon">&#x1F4E9;</span> Access Requests</a>
                            </nav>
                            <div class="sidebar-footer">
                                <div class="user-info">
                                    <div class="user-avatar">
                                        <%= adminName.charAt(0) %>
                                    </div>
                                    <div class="user-details">
                                        <div class="user-name">
                                            <%= adminName %>
                                        </div>
                                        <div class="user-role">Administrator</div>
                                    </div>
                                </div>
                            </div>
                        </aside>

                        <div class="main-content">
                            <header class="top-navbar">
                                <div style="display:flex;align-items:center;gap:12px;">
                                    <button class="hamburger"
                                        onclick="document.getElementById('sidebar').classList.toggle('open')">&#9776;</button>
                                    <div class="page-title">Access Requests <small>Approve or Reject</small></div>
                                </div>
                                <div class="navbar-actions">
                                    <a href="logout" class="btn-logout">&#x1F6AA; Logout</a>
                                </div>
                            </header>

                            <div class="page-content fade-in">

                                <% if (successMsg !=null) { %>
                                    <div class="alert alert-success"><span>&#x2705;</span>
                                        <%= successMsg %> <button class="close-alert">&times;</button>
                                    </div>
                                    <% } %>
                                        <% if (errorMsg !=null) { %>
                                            <div class="alert alert-danger"><span>&#x26A0;</span>
                                                <%= errorMsg %> <button class="close-alert">&times;</button>
                                            </div>
                                            <% } %>

                                                <!-- Filter Tabs -->
                                                <div class="filter-tabs">
                                                    <a href="adminRequests?filter=pending"
                                                        class="filter-tab ${currentFilter == 'pending' ? 'active' : ''}">&#x23F3;
                                                        Pending</a>
                                                    <a href="adminRequests?filter=all"
                                                        class="filter-tab ${currentFilter == 'all' ? 'active' : ''}">&#x1F4CB;
                                                        All Requests</a>
                                                </div>

                                                <!-- Requests Table -->
                                                <div class="card">
                                                    <div class="card-header">
                                                        <h2><span class="header-icon">&#x1F4E9;</span> Access Requests
                                                            (${requests.size()})</h2>
                                                    </div>
                                                    <div class="card-body no-padding">
                                                        <div class="table-responsive">
                                                            <table class="data-table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>#</th>
                                                                        <th>Employee</th>
                                                                        <th>Resource</th>
                                                                        <th>Type</th>
                                                                        <th>Reason</th>
                                                                        <th>Status</th>
                                                                        <th>Requested</th>
                                                                        <th>Actions</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="req" items="${requests}"
                                                                        varStatus="i">
                                                                        <tr>
                                                                            <td>${i.count}</td>
                                                                            <td><strong>${req.employeeName}</strong>
                                                                            </td>
                                                                            <td>${req.resourceName}</td>
                                                                            <td><span
                                                                                    class="badge badge-${req.resourceType.toLowerCase()}">${req.resourceType}</span>
                                                                            </td>
                                                                            <td style="max-width:200px;">${req.reason}
                                                                            </td>
                                                                            <td><span
                                                                                    class="badge badge-${req.status.toLowerCase()}">${req.status}</span>
                                                                            </td>
                                                                            <td class="text-muted">
                                                                                <fmt:formatDate
                                                                                    value="${req.requestedAt}"
                                                                                    pattern="MMM dd, HH:mm" />
                                                                            </td>
                                                                            <td>
                                                                                <c:if test="${req.status == 'PENDING'}">
                                                                                    <div class="action-btns">
                                                                                        <form action="adminRequests"
                                                                                            method="post"
                                                                                            style="display:inline;">
                                                                                            <input type="hidden"
                                                                                                name="action"
                                                                                                value="approve">
                                                                                            <input type="hidden"
                                                                                                name="requestId"
                                                                                                value="${req.id}">
                                                                                            <input type="hidden"
                                                                                                name="remarks"
                                                                                                value="Approved by admin">
                                                                                            <button type="submit"
                                                                                                class="btn btn-success btn-sm">&#x2705;
                                                                                                Approve</button>
                                                                                        </form>
                                                                                        <form action="adminRequests"
                                                                                            method="post"
                                                                                            style="display:inline;">
                                                                                            <input type="hidden"
                                                                                                name="action"
                                                                                                value="reject">
                                                                                            <input type="hidden"
                                                                                                name="requestId"
                                                                                                value="${req.id}">
                                                                                            <input type="hidden"
                                                                                                name="remarks"
                                                                                                value="Rejected by admin">
                                                                                            <button type="submit"
                                                                                                class="btn btn-danger btn-sm">&#x274C;
                                                                                                Reject</button>
                                                                                        </form>
                                                                                    </div>
                                                                                </c:if>
                                                                                <c:if test="${req.status != 'PENDING'}">
                                                                                    <span
                                                                                        class="text-muted">${req.adminRemarks}</span>
                                                                                </c:if>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                    <c:if test="${empty requests}">
                                                                        <tr>
                                                                            <td colspan="8">
                                                                                <div class="empty-state">
                                                                                    <div class="empty-icon">&#x1F4ED;
                                                                                    </div>
                                                                                    <h3>No requests found</h3>
                                                                                    <p>There are no access requests to
                                                                                        display.</p>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
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