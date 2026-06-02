package com.officevpn.servlet;

import com.officevpn.dao.ResourceDAO;
import com.officevpn.dao.AccessRequestDAO;
import com.officevpn.dao.ActivityLogDAO;
import com.officevpn.model.Resource;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Employee: Request access to restricted resources.
 */
@WebServlet("/requestAccess")
public class RequestAccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"employee".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        int empId = (Integer) session.getAttribute("employeeId");
        ResourceDAO resDAO = new ResourceDAO();

        // Get resources employee does NOT have access to
        List<Resource> restrictedResources = resDAO.getRestrictedResourcesForEmployee(empId);
        request.setAttribute("restrictedResources", restrictedResources);

        request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"employee".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        int empId = (Integer) session.getAttribute("employeeId");
        String empName = (String) session.getAttribute("employeeName");
        int resourceId = Integer.parseInt(request.getParameter("resourceId"));
        String reason = request.getParameter("reason");

        AccessRequestDAO reqDAO = new AccessRequestDAO();
        ActivityLogDAO logDAO = new ActivityLogDAO();

        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Please provide a reason for your request.");
            response.sendRedirect("requestAccess");
            return;
        }

        if (reqDAO.createRequest(empId, resourceId, reason.trim())) {
            // Log the request
            logDAO.logActivity(empId, "REQUEST_ACCESS",
                empName + " requested access to resource ID: " + resourceId,
                request.getRemoteAddr());
            session.setAttribute("successMsg", "Access request submitted successfully!");
        } else {
            session.setAttribute("errorMsg", "You already have a pending request for this resource.");
        }

        response.sendRedirect("requestAccess");
    }
}
