package com.officevpn.servlet;

import com.officevpn.dao.ResourceDAO;
import com.officevpn.model.Resource;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Manages VPN resources — list, add, update, delete.
 */
@WebServlet("/manageResources")
public class ManageResourcesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        ResourceDAO dao = new ResourceDAO();
        List<Resource> resources = dao.getAllResources();
        request.setAttribute("resources", resources);
        request.getRequestDispatcher("manageResources.jsp").forward(request, response);
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
        ResourceDAO dao = new ResourceDAO();

        if ("add".equals(action)) {
            Resource res = new Resource();
            res.setResourceName(request.getParameter("resourceName"));
            res.setResourceType(request.getParameter("resourceType"));
            res.setDescription(request.getParameter("description"));
            res.setIpAddress(request.getParameter("ipAddress"));
            res.setAccessLevel(request.getParameter("accessLevel"));
            res.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "ACTIVE");

            if (dao.addResource(res)) {
                request.getSession().setAttribute("successMsg", "Resource added successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to add resource.");
            }

        } else if ("update".equals(action)) {
            Resource res = new Resource();
            res.setId(Integer.parseInt(request.getParameter("id")));
            res.setResourceName(request.getParameter("resourceName"));
            res.setResourceType(request.getParameter("resourceType"));
            res.setDescription(request.getParameter("description"));
            res.setIpAddress(request.getParameter("ipAddress"));
            res.setAccessLevel(request.getParameter("accessLevel"));
            res.setStatus(request.getParameter("status"));

            if (dao.updateResource(res)) {
                request.getSession().setAttribute("successMsg", "Resource updated successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to update resource.");
            }

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.deleteResource(id)) {
                request.getSession().setAttribute("successMsg", "Resource deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to delete resource.");
            }
        }

        response.sendRedirect("manageResources");
    }
}
