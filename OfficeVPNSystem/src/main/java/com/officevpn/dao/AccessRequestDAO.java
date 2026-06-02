package com.officevpn.dao;

import com.officevpn.db.DBConnection;
import com.officevpn.model.AccessRequest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Access Request operations.
 */
public class AccessRequestDAO {

    /**
     * Create a new access request.
     */
    public boolean createRequest(int employeeId, int resourceId, String reason) {
        // Check if a pending request already exists
        String checkSql = "SELECT COUNT(*) FROM access_request WHERE employee_id = ? AND resource_id = ? AND status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, employeeId);
            checkPs.setInt(2, resourceId);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // Already has a pending request
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String sql = "INSERT INTO access_request (employee_id, resource_id, reason) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, resourceId);
            ps.setString(3, reason);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all access requests with employee and resource details.
     */
    public List<AccessRequest> getAllRequests() {
        List<AccessRequest> list = new ArrayList<>();
        String sql = "SELECT ar.*, e.full_name AS employee_name, r.resource_name, r.resource_type " +
                     "FROM access_request ar " +
                     "JOIN employee e ON ar.employee_id = e.id " +
                     "JOIN resource r ON ar.resource_id = r.id " +
                     "ORDER BY ar.requested_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get pending requests only.
     */
    public List<AccessRequest> getPendingRequests() {
        List<AccessRequest> list = new ArrayList<>();
        String sql = "SELECT ar.*, e.full_name AS employee_name, r.resource_name, r.resource_type " +
                     "FROM access_request ar " +
                     "JOIN employee e ON ar.employee_id = e.id " +
                     "JOIN resource r ON ar.resource_id = r.id " +
                     "WHERE ar.status = 'PENDING' " +
                     "ORDER BY ar.requested_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get requests by employee.
     */
    public List<AccessRequest> getRequestsByEmployee(int employeeId) {
        List<AccessRequest> list = new ArrayList<>();
        String sql = "SELECT ar.*, e.full_name AS employee_name, r.resource_name, r.resource_type " +
                     "FROM access_request ar " +
                     "JOIN employee e ON ar.employee_id = e.id " +
                     "JOIN resource r ON ar.resource_id = r.id " +
                     "WHERE ar.employee_id = ? " +
                     "ORDER BY ar.requested_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Approve a request (also grants VPN access).
     */
    public boolean approveRequest(int requestId, String adminRemarks) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Update request status
            String updateSql = "UPDATE access_request SET status = 'APPROVED', admin_remarks = ?, processed_at = CURRENT_TIMESTAMP WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, adminRemarks);
                ps.setInt(2, requestId);
                ps.executeUpdate();
            }

            // Get employee_id and resource_id from request
            String selectSql = "SELECT employee_id, resource_id FROM access_request WHERE id = ?";
            int employeeId = 0, resourceId = 0;
            try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                ps.setInt(1, requestId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    employeeId = rs.getInt("employee_id");
                    resourceId = rs.getInt("resource_id");
                }
            }

            // Grant VPN access
            if (employeeId > 0 && resourceId > 0) {
                // Check if access already exists
                String checkSql = "SELECT id FROM vpn_access WHERE employee_id = ? AND resource_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setInt(1, employeeId);
                    ps.setInt(2, resourceId);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        // Update existing
                        String reactivateSql = "UPDATE vpn_access SET status = 'ACTIVE', granted_at = CURRENT_TIMESTAMP WHERE id = ?";
                        try (PreparedStatement ps2 = conn.prepareStatement(reactivateSql)) {
                            ps2.setInt(1, rs.getInt("id"));
                            ps2.executeUpdate();
                        }
                    } else {
                        // Insert new
                        String insertSql = "INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (?, ?, 'admin')";
                        try (PreparedStatement ps2 = conn.prepareStatement(insertSql)) {
                            ps2.setInt(1, employeeId);
                            ps2.setInt(2, resourceId);
                            ps2.executeUpdate();
                        }
                    }
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
        return false;
    }

    /**
     * Reject a request.
     */
    public boolean rejectRequest(int requestId, String adminRemarks) {
        String sql = "UPDATE access_request SET status = 'REJECTED', admin_remarks = ?, processed_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, adminRemarks);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get pending requests count for an employee.
     */
    public int getPendingCountForEmployee(int employeeId) {
        String sql = "SELECT COUNT(*) FROM access_request WHERE employee_id = ? AND status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Map ResultSet to AccessRequest object.
     */
    private AccessRequest mapRequest(ResultSet rs) throws SQLException {
        AccessRequest req = new AccessRequest();
        req.setId(rs.getInt("id"));
        req.setEmployeeId(rs.getInt("employee_id"));
        req.setResourceId(rs.getInt("resource_id"));
        req.setReason(rs.getString("reason"));
        req.setStatus(rs.getString("status"));
        req.setAdminRemarks(rs.getString("admin_remarks"));
        req.setRequestedAt(rs.getTimestamp("requested_at"));
        req.setProcessedAt(rs.getTimestamp("processed_at"));
        req.setEmployeeName(rs.getString("employee_name"));
        req.setResourceName(rs.getString("resource_name"));
        req.setResourceType(rs.getString("resource_type"));
        return req;
    }
}
