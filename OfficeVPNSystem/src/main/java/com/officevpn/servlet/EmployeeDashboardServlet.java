package com.officevpn.servlet;

import com.officevpn.dao.VPNAccessDAO;
import com.officevpn.dao.AccessRequestDAO;
import com.officevpn.dao.ActivityLogDAO;
import com.officevpn.model.ActivityLog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Employee Dashboard — shows personal stats and recent activity.
 */
@WebServlet("/employeeDashboard")
public class EmployeeDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"employee".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        int empId = (Integer) session.getAttribute("employeeId");

        VPNAccessDAO vpnDAO = new VPNAccessDAO();
        AccessRequestDAO reqDAO = new AccessRequestDAO();
        ActivityLogDAO logDAO = new ActivityLogDAO();

        // Employee stats
        request.setAttribute("accessCount", vpnDAO.getAccessCountForEmployee(empId));
        request.setAttribute("pendingRequests", reqDAO.getPendingCountForEmployee(empId));

        // Recent activity
        List<ActivityLog> recentLogs = logDAO.getLogsByEmployee(empId);
        if (recentLogs.size() > 5) {
            recentLogs = recentLogs.subList(0, 5);
        }
        request.setAttribute("recentLogs", recentLogs);

        request.getRequestDispatcher("employeeDashboard.jsp").forward(request, response);
    }
}
