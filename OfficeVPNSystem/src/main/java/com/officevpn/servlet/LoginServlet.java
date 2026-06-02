package com.officevpn.servlet;

import com.officevpn.dao.AdminDAO;
import com.officevpn.dao.EmployeeDAO;
import com.officevpn.dao.ActivityLogDAO;
import com.officevpn.model.Admin;
import com.officevpn.model.Employee;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles login for both Admin and Employee.
 * POST: Authenticates user, creates session, redirects to dashboard.
 * GET: Shows login page.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // If already logged in, redirect
        HttpSession session = request.getSession(false);
        if (session != null) {
            String role = (String) session.getAttribute("role");
            if ("admin".equals(role)) {
                response.sendRedirect("adminDashboard");
                return;
            } else if ("employee".equals(role)) {
                response.sendRedirect("employeeDashboard");
                return;
            }
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username == null || password == null || role == null ||
            username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all fields.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        username = username.trim();
        password = password.trim();

        if ("admin".equals(role)) {
            // Admin login
            AdminDAO adminDAO = new AdminDAO();
            Admin admin = adminDAO.authenticate(username, password);
            if (admin != null) {
                HttpSession session = request.getSession();
                session.setAttribute("role", "admin");
                session.setAttribute("adminId", admin.getId());
                session.setAttribute("adminName", admin.getFullName());
                session.setAttribute("username", admin.getUsername());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                response.sendRedirect("adminDashboard");
            } else {
                request.setAttribute("error", "Invalid admin credentials.");
                request.setAttribute("selectedRole", "admin");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("employee".equals(role)) {
            // Employee login
            EmployeeDAO empDAO = new EmployeeDAO();
            Employee emp = empDAO.authenticate(username, password);
            if (emp != null) {
                HttpSession session = request.getSession();
                session.setAttribute("role", "employee");
                session.setAttribute("employeeId", emp.getId());
                session.setAttribute("employeeName", emp.getFullName());
                session.setAttribute("username", emp.getUsername());
                session.setAttribute("department", emp.getDepartment());
                session.setMaxInactiveInterval(30 * 60);

                // Log the login activity
                ActivityLogDAO logDAO = new ActivityLogDAO();
                logDAO.logActivity(emp.getId(), "LOGIN",
                    emp.getFullName() + " logged in", request.getRemoteAddr());

                response.sendRedirect("employeeDashboard");
            } else {
                request.setAttribute("error", "Invalid employee credentials or account inactive.");
                request.setAttribute("selectedRole", "employee");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Please select a valid role.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
