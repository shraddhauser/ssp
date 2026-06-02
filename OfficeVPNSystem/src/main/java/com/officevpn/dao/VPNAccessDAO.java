package com.officevpn.dao;

import com.officevpn.db.DBConnection;
import com.officevpn.model.VPNAccess;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for VPN Access grant/revoke operations.
 */
public class VPNAccessDAO {

    /**
     * Get all active VPN access records with employee and resource names.
     */
    public List<VPNAccess> getAllAccess() {
        List<VPNAccess> list = new ArrayList<>();
        String sql = "SELECT v.*, e.full_name AS employee_name, r.resource_name " +
                     "FROM vpn_access v " +
                     "JOIN employee e ON v.employee_id = e.id " +
                     "JOIN resource r ON v.resource_id = r.id " +
                     "ORDER BY v.granted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapVPNAccess(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Grant access to an employee for a resource.
     */
    public boolean grantAccess(int employeeId, int resourceId, String grantedBy) {
        // First check if access already exists
        String checkSql = "SELECT id, status FROM vpn_access WHERE employee_id = ? AND resource_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, employeeId);
            checkPs.setInt(2, resourceId);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next()) {
                // Record exists — reactivate if revoked
                if ("REVOKED".equals(rs.getString("status"))) {
                    String updateSql = "UPDATE vpn_access SET status = 'ACTIVE', granted_by = ?, granted_at = CURRENT_TIMESTAMP WHERE id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setString(1, grantedBy);
                        updatePs.setInt(2, rs.getInt("id"));
                        return updatePs.executeUpdate() > 0;
                    }
                }
                return true; // Already active
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Insert new access record
        String sql = "INSERT INTO vpn_access (employee_id, resource_id, granted_by) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, resourceId);
            ps.setString(3, grantedBy);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Revoke an employee's access to a resource.
     */
    public boolean revokeAccess(int employeeId, int resourceId) {
        String sql = "UPDATE vpn_access SET status = 'REVOKED' WHERE employee_id = ? AND resource_id = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, resourceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if employee has active access to a resource.
     */
    public boolean hasAccess(int employeeId, int resourceId) {
        String sql = "SELECT COUNT(*) FROM vpn_access WHERE employee_id = ? AND resource_id = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, resourceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get VPN access count for an employee.
     */
    public int getAccessCountForEmployee(int employeeId) {
        String sql = "SELECT COUNT(*) FROM vpn_access WHERE employee_id = ? AND status = 'ACTIVE'";
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
     * Map ResultSet to VPNAccess object.
     */
    private VPNAccess mapVPNAccess(ResultSet rs) throws SQLException {
        VPNAccess access = new VPNAccess();
        access.setId(rs.getInt("id"));
        access.setEmployeeId(rs.getInt("employee_id"));
        access.setResourceId(rs.getInt("resource_id"));
        access.setGrantedBy(rs.getString("granted_by"));
        access.setGrantedAt(rs.getTimestamp("granted_at"));
        access.setExpiresAt(rs.getTimestamp("expires_at"));
        access.setStatus(rs.getString("status"));
        access.setEmployeeName(rs.getString("employee_name"));
        access.setResourceName(rs.getString("resource_name"));
        return access;
    }
}
