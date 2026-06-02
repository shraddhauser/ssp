package com.officevpn.dao;

import com.officevpn.db.DBConnection;
import com.officevpn.model.ActivityLog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Activity Log operations.
 */
public class ActivityLogDAO {

    /**
     * Log an activity.
     */
    public boolean logActivity(int employeeId, String actionType, String description, String ipAddress) {
        String sql = "INSERT INTO activity_log (employee_id, action_type, description, ip_address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setString(2, actionType);
            ps.setString(3, description);
            ps.setString(4, ipAddress);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all activity logs (most recent first), with employee names.
     */
    public List<ActivityLog> getAllLogs() {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT a.*, e.full_name AS employee_name FROM activity_log a " +
                     "LEFT JOIN employee e ON a.employee_id = e.id " +
                     "ORDER BY a.created_at DESC LIMIT 200";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapLog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get logs for a specific employee.
     */
    public List<ActivityLog> getLogsByEmployee(int employeeId) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT a.*, e.full_name AS employee_name FROM activity_log a " +
                     "LEFT JOIN employee e ON a.employee_id = e.id " +
                     "WHERE a.employee_id = ? ORDER BY a.created_at DESC LIMIT 100";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapLog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get recent logs (for dashboard).
     */
    public List<ActivityLog> getRecentLogs(int limit) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT a.*, e.full_name AS employee_name FROM activity_log a " +
                     "LEFT JOIN employee e ON a.employee_id = e.id " +
                     "ORDER BY a.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapLog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Map ResultSet to ActivityLog object.
     */
    private ActivityLog mapLog(ResultSet rs) throws SQLException {
        ActivityLog log = new ActivityLog();
        log.setId(rs.getInt("id"));
        log.setEmployeeId(rs.getInt("employee_id"));
        log.setActionType(rs.getString("action_type"));
        log.setDescription(rs.getString("description"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        log.setEmployeeName(rs.getString("employee_name"));
        return log;
    }
}
