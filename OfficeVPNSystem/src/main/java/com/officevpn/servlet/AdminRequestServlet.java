package com.officevpn.servlet;

import com.officevpn.dao.AccessRequestDAO;
import com.officevpn.model.AccessRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Admin: View and process access requests (approve/reject).
 */
@WebServlet("/adminRequests")
public class AdminRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        AccessRequestDAO dao = new AccessRequestDAO();

        String filter = request.getParameter("filter");
        List<AccessRequest> requests;

        if ("pending".equals(filter)) {
            requests = dao.getPendingRequests();
            request.setAttribute("currentFilter", "pending");
        } else {
            requests = dao.getAllRequests();
            request.setAttribute("currentFilter", "all");
        }

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("accessRequests.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String remarks = request.getParameter("remarks");

        AccessRequestDAO dao = new AccessRequestDAO();

        if ("approve".equals(action)) {
            if (dao.approveRequest(requestId, remarks != null ? remarks : "Approved by admin")) {
                session.setAttribute("successMsg", "Request approved and access granted!");
            } else {
                session.setAttribute("errorMsg", "Failed to approve request.");
            }
        } else if ("reject".equals(action)) {
            if (dao.rejectRequest(requestId, remarks != null ? remarks : "Rejected by admin")) {
                session.setAttribute("successMsg", "Request rejected.");
            } else {
                session.setAttribute("errorMsg", "Failed to reject request.");
            }
        }

        response.sendRedirect("adminRequests?filter=pending");
    }
}
