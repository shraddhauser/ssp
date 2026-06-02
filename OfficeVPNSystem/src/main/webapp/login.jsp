<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Office VPN System</title>
    <meta name="description" content="Secure login portal for Office VPN Resource Access Management System">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="login-page">
    <div class="login-container">
        <!-- Logo -->
        <div class="login-logo">
            <div class="logo-icon">&#x1F512;</div>
            <h1>Office VPN System</h1>
            <p>Resource Access Management Portal</p>
        </div>

        <!-- Error message -->
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger">
                <span>&#x26A0;</span>
                <%= error %>
                <button class="close-alert">&times;</button>
            </div>
        <% } %>

        <!-- Role Tabs -->
        <div class="role-tabs">
            <button class="role-tab <%= "employee".equals(request.getAttribute("selectedRole")) ? "" : "active" %>"
                    onclick="selectRole('admin')" id="tab-admin">&#x1F464; Admin</button>
            <button class="role-tab <%= "employee".equals(request.getAttribute("selectedRole")) ? "active" : "" %>"
                    onclick="selectRole('employee')" id="tab-employee">&#x1F465; Employee</button>
        </div>

        <!-- Login Form -->
        <form action="login" method="post" data-validate="true">
            <input type="hidden" name="role" id="roleInput"
                   value="<%= "employee".equals(request.getAttribute("selectedRole")) ? "employee" : "admin" %>">

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username" required
                       autocomplete="username">
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required
                       autocomplete="current-password">
            </div>

            <button type="submit" class="btn btn-primary btn-lg">
                &#x1F513; Sign In
            </button>
        </form>

        <!-- Demo credentials -->
        <div style="margin-top: 24px; padding: 16px; background: #F1F5F9; border-radius: 10px; font-size: 12px; color: #64748B;">
            <strong>Demo Credentials:</strong><br>
            Admin: <code>admin</code> / <code>admin123</code><br>
            Employee: <code>john.doe</code> / <code>john123</code>
        </div>
    </div>
</div>

<script>
    function selectRole(role) {
        document.getElementById('roleInput').value = role;
        document.getElementById('tab-admin').className = 'role-tab' + (role === 'admin' ? ' active' : '');
        document.getElementById('tab-employee').className = 'role-tab' + (role === 'employee' ? ' active' : '');
    }
</script>
<script src="js/script.js"></script>
</body>
</html>
