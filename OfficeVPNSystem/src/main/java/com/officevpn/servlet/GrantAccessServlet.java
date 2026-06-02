package com.officevpn.servlet;

import com.officevpn.dao.EmployeeDAO;
import com.officevpn.dao.ResourceDAO;
import com.officevpn.dao.VPNAccessDAO;
import com.officevpn.model.Employee;
import com.officevpn.model.Resource;
import com.officevpn.model.VPNAccess;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Grant / Revoke employee access to VPN resources.
 */
@WebServlet("/grantAccess")
public class GrantAccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        EmployeeDAO empDAO = new EmployeeDAO();
        ResourceDAO resDAO = new ResourceDAO();
        VPNAccessDAO vpnDAO = new VPNAccessDAO();

        List<Employee> employees = empDAO.getAllEmployees();
        List<Resource> resources = resDAO.getAllResources();
        List<VPNAccess> accessList = vpnDAO.getAllAccess();

        request.setAttribute("employees", employees);
        request.setAttribute("resources", resources);
        request.setAttribute("accessList", accessList);
        request.getRequestDispatcher("grantAccess.jsp").forward(request, response);
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
        VPNAccessDAO vpnDAO = new VPNAccessDAO();

        if ("grant".equals(action)) {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            int resourceId = Integer.parseInt(request.getParameter("resourceId"));
            String grantedBy = (String) session.getAttribute("username");

            if (vpnDAO.grantAccess(employeeId, resourceId, grantedBy)) {
                session.setAttribute("successMsg", "Access granted successfully!");
            } else {
                session.setAttribute("errorMsg", "Failed to grant access.");
            }

        } else if ("revoke".equals(action)) {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            int resourceId = Integer.parseInt(request.getParameter("resourceId"));

            if (vpnDAO.revokeAccess(employeeId, resourceId)) {
                session.setAttribute("successMsg", "Access revoked successfully!");
            } else {
                session.setAttribute("errorMsg", "Failed to revoke access.");
            }
        }

        response.sendRedirect("grantAccess");
    }
}
