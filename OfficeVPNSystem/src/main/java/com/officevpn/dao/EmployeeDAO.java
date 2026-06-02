package com.officevpn.dao;

import com.officevpn.db.DBConnection;
import com.officevpn.model.Employee;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Employee CRUD operations.
 */
public class EmployeeDAO {

    /**
     * Authenticate employee by username and password.
     */
    public Employee authenticate(String username, String password) {
        String sql = "SELECT * FROM employee WHERE username = ? AND password = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapEmployee(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all employees.
     */
    public List<Employee> getAllEmployees() {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT * FROM employee ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapEmployee(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get employee by ID.
     */
    public Employee getEmployeeById(int id) {
        String sql = "SELECT * FROM employee WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapEmployee(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Add a new employee.
     */
    public boolean addEmployee(Employee emp) {
        String sql = "INSERT INTO employee (emp_code, username, password, full_name, email, department, designation, phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getEmpCode());
            ps.setString(2, emp.getUsername());
            ps.setString(3, emp.getPassword());
            ps.setString(4, emp.getFullName());
            ps.setString(5, emp.getEmail());
            ps.setString(6, emp.getDepartment());
            ps.setString(7, emp.getDesignation());
            ps.setString(8, emp.getPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update an existing employee.
     */
    public boolean updateEmployee(Employee emp) {
        String sql = "UPDATE employee SET emp_code=?, username=?, full_name=?, email=?, department=?, designation=?, phone=?, status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getEmpCode());
            ps.setString(2, emp.getUsername());
            ps.setString(3, emp.getFullName());
            ps.setString(4, emp.getEmail());
            ps.setString(5, emp.getDepartment());
            ps.setString(6, emp.getDesignation());
            ps.setString(7, emp.getPhone());
            ps.setString(8, emp.getStatus());
            ps.setInt(9, emp.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete an employee by ID.
     */
    public boolean deleteEmployee(int id) {
        String sql = "DELETE FROM employee WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Map ResultSet row to Employee object.
     */
    private Employee mapEmployee(ResultSet rs) throws SQLException {
        Employee emp = new Employee();
        emp.setId(rs.getInt("id"));
        emp.setEmpCode(rs.getString("emp_code"));
        emp.setUsername(rs.getString("username"));
        emp.setPassword(rs.getString("password"));
        emp.setFullName(rs.getString("full_name"));
        emp.setEmail(rs.getString("email"));
        emp.setDepartment(rs.getString("department"));
        emp.setDesignation(rs.getString("designation"));
        emp.setPhone(rs.getString("phone"));
        emp.setStatus(rs.getString("status"));
        emp.setCreatedAt(rs.getTimestamp("created_at"));
        emp.setUpdatedAt(rs.getTimestamp("updated_at"));
        return emp;
    }
}
