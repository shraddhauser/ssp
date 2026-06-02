package com.officevpn.servlet;

import com.officevpn.dao.ResourceDAO;
import com.officevpn.dao.ActivityLogDAO;
import com.officevpn.model.Resource;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Employee: View allowed resources and search.
 */
@WebServlet("/employeeResources")
public class EmployeeResourcesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"employee".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        int empId = (Integer) session.getAttribute("employeeId");
        String empName = (String) session.getAttribute("employeeName");
        ResourceDAO resDAO = new ResourceDAO();
        ActivityLogDAO logDAO = new ActivityLogDAO();

        // Check if searching
        String search = request.getParameter("search");
        List<Resource> resources;

        if (search != null && !search.trim().isEmpty()) {
            // Log the search activity
            logDAO.logActivity(empId, "SEARCH",
                empName + " searched for: " + search.trim(), request.getRemoteAddr());

            // Get allowed resources and filter by search term
            resources = resDAO.getResourcesForEmployee(empId);
            String searchLower = search.trim().toLowerCase();
            resources.removeIf(r ->
                !r.getResourceName().toLowerCase().contains(searchLower) &&
                !r.getResourceType().toLowerCase().contains(searchLower) &&
                (r.getDescription() == null || !r.getDescription().toLowerCase().contains(searchLower))
            );
            request.setAttribute("searchTerm", search.trim());
        } else {
            resources = resDAO.getResourcesForEmployee(empId);
        }

        // Log resource view
        logDAO.logActivity(empId, "VIEW_RESOURCE",
            empName + " viewed resources", request.getRemoteAddr());

        request.setAttribute("resources", resources);
        request.getRequestDispatcher("employeeResources.jsp").forward(request, response);
    }
}
