package com.officevpn.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.officevpn.dao.EmployeeDAO;
import com.officevpn.model.Employee;

/**
 * Manages employees — list, add, update, delete.
 */
@WebServlet("/manageEmployees")
public class ManageEmployeesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        EmployeeDAO dao = new EmployeeDAO();
        List<Employee> employees = dao.getAllEmployees();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("manageEmployees.jsp").forward(request, response);
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
        EmployeeDAO dao = new EmployeeDAO();

        if ("add".equals(action)) {
            Employee emp = new Employee();
            emp.setEmpCode(request.getParameter("empCode"));
            emp.setUsername(request.getParameter("username"));
            emp.setPassword(request.getParameter("password"));
            emp.setFullName(request.getParameter("fullName"));
            emp.setEmail(request.getParameter("email"));
            emp.setDepartment(request.getParameter("department"));
            emp.setDesignation(request.getParameter("designation"));
            emp.setPhone(request.getParameter("phone"));

            if (dao.addEmployee(emp)) {
                request.getSession().setAttribute("successMsg", "Employee added successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to add employee. Username or Emp Code may already exist.");
            }

        } else if ("update".equals(action)) {
            Employee emp = new Employee();
            emp.setId(Integer.parseInt(request.getParameter("id")));
            emp.setEmpCode(request.getParameter("empCode"));
            emp.setUsername(request.getParameter("username"));
            emp.setFullName(request.getParameter("fullName"));
            emp.setEmail(request.getParameter("email"));
            emp.setDepartment(request.getParameter("department"));
            emp.setDesignation(request.getParameter("designation"));
            emp.setPhone(request.getParameter("phone"));
            emp.setStatus(request.getParameter("status"));

            if (dao.updateEmployee(emp)) {
                request.getSession().setAttribute("successMsg", "Employee updated successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to update employee.");
            }

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.deleteEmployee(id)) {
                request.getSession().setAttribute("successMsg", "Employee deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to delete employee.");
            }
        }

        response.sendRedirect("manageEmployees");
    }
}
