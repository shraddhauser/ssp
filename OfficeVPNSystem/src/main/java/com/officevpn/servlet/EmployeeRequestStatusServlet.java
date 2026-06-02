package com.officevpn.servlet;

import com.officevpn.dao.AccessRequestDAO;
import com.officevpn.model.AccessRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Employee: View status of submitted access requests.
 */
@WebServlet("/requestStatus")
public class EmployeeRequestStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"employee".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        int empId = (Integer) session.getAttribute("employeeId");
        AccessRequestDAO dao = new AccessRequestDAO();

        List<AccessRequest> requests = dao.getRequestsByEmployee(empId);
        request.setAttribute("requests", requests);

        request.getRequestDispatcher("requestStatus.jsp").forward(request, response);
    }
}
