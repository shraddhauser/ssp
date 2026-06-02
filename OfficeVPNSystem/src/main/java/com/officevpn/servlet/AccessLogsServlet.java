package com.officevpn.servlet;

import com.officevpn.dao.ActivityLogDAO;
import com.officevpn.model.ActivityLog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * View activity logs — admin monitoring system.
 */
@WebServlet("/accessLogs")
public class AccessLogsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        ActivityLogDAO logDAO = new ActivityLogDAO();

        // Check if filtering by employee
        String empIdParam = request.getParameter("employeeId");
        List<ActivityLog> logs;

        if (empIdParam != null && !empIdParam.isEmpty()) {
            int empId = Integer.parseInt(empIdParam);
            logs = logDAO.getLogsByEmployee(empId);
            request.setAttribute("filteredEmployeeId", empId);
        } else {
            logs = logDAO.getAllLogs();
        }

        request.setAttribute("logs", logs);
        request.getRequestDispatcher("accessLogs.jsp").forward(request, response);
    }
}
