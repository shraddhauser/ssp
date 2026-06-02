package com.officevpn.servlet;

import com.officevpn.dao.ActivityLogDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles logout — invalidates session and redirects to login.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Log logout activity for employees
            String role = (String) session.getAttribute("role");
            if ("employee".equals(role)) {
                Integer empId = (Integer) session.getAttribute("employeeId");
                String empName = (String) session.getAttribute("employeeName");
                if (empId != null) {
                    ActivityLogDAO logDAO = new ActivityLogDAO();
                    logDAO.logActivity(empId, "LOGOUT",
                        empName + " logged out", request.getRemoteAddr());
                }
            }
            session.invalidate();
        }
        response.sendRedirect("login");
    }
}
