package com.officevpn.dao;

import com.officevpn.db.DBConnection;
import com.officevpn.model.Resource;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Resource CRUD operations.
 */
public class ResourceDAO {

    /**
     * Get all resources.
     */
    public List<Resource> getAllResources() {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT * FROM resource ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get resource by ID.
     */
    public Resource getResourceById(int id) {
        String sql = "SELECT * FROM resource WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResource(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Add a new resource.
     */
    public boolean addResource(Resource res) {
        String sql = "INSERT INTO resource (resource_name, resource_type, description, ip_address, access_level, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, res.getResourceName());
            ps.setString(2, res.getResourceType());
            ps.setString(3, res.getDescription());
            ps.setString(4, res.getIpAddress());
            ps.setString(5, res.getAccessLevel());
            ps.setString(6, res.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update an existing resource.
     */
    public boolean updateResource(Resource res) {
        String sql = "UPDATE resource SET resource_name=?, resource_type=?, description=?, ip_address=?, access_level=?, status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, res.getResourceName());
            ps.setString(2, res.getResourceType());
            ps.setString(3, res.getDescription());
            ps.setString(4, res.getIpAddress());
            ps.setString(5, res.getAccessLevel());
            ps.setString(6, res.getStatus());
            ps.setInt(7, res.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete a resource by ID.
     */
    public boolean deleteResource(int id) {
        String sql = "DELETE FROM resource WHERE id = ?";
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
     * Search resources by name or type.
     */
    public List<Resource> searchResources(String keyword) {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT * FROM resource WHERE resource_name LIKE ? OR resource_type LIKE ? OR description LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get resources that an employee has access to.
     */
    public List<Resource> getResourcesForEmployee(int employeeId) {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT r.* FROM resource r INNER JOIN vpn_access v ON r.id = v.resource_id WHERE v.employee_id = ? AND v.status = 'ACTIVE' AND r.status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get resources that employee does NOT have access to.
     */
    public List<Resource> getRestrictedResourcesForEmployee(int employeeId) {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT r.* FROM resource r WHERE r.status = 'ACTIVE' AND r.id NOT IN (SELECT resource_id FROM vpn_access WHERE employee_id = ? AND status = 'ACTIVE')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Map ResultSet row to Resource object.
     */
    private Resource mapResource(ResultSet rs) throws SQLException {
        Resource res = new Resource();
        res.setId(rs.getInt("id"));
        res.setResourceName(rs.getString("resource_name"));
        res.setResourceType(rs.getString("resource_type"));
        res.setDescription(rs.getString("description"));
        res.setIpAddress(rs.getString("ip_address"));
        res.setAccessLevel(rs.getString("access_level"));
        res.setStatus(rs.getString("status"));
        res.setCreatedAt(rs.getTimestamp("created_at"));
        res.setUpdatedAt(rs.getTimestamp("updated_at"));
        return res;
    }
}
