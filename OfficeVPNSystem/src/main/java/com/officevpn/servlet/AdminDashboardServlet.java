package com.officevpn.servlet;

import com.officevpn.dao.AdminDAO;
import com.officevpn.dao.ActivityLogDAO;
import com.officevpn.model.ActivityLog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Admin Dashboard — shows statistics and recent activity.
 */
@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        AdminDAO adminDAO = new AdminDAO();
        ActivityLogDAO logDAO = new ActivityLogDAO();

        // Dashboard statistics
        request.setAttribute("totalEmployees", adminDAO.getTotalEmployees());
        request.setAttribute("totalResources", adminDAO.getTotalResources());
        request.setAttribute("activeVPNs", adminDAO.getActiveVPNCount());
        request.setAttribute("pendingRequests", adminDAO.getPendingRequestsCount());

        // Recent activity logs
        List<ActivityLog> recentLogs = logDAO.getRecentLogs(10);
        request.setAttribute("recentLogs", recentLogs);

        request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
    }
}
