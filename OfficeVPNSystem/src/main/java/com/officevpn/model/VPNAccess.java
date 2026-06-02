package com.officevpn.model;

import java.sql.Timestamp;

public class VPNAccess {
    private int id;
    private int employeeId;
    private int resourceId;
    private String grantedBy;
    private Timestamp grantedAt;
    private Timestamp expiresAt;
    private String status;

    // Joined fields (for display)
    private String employeeName;
    private String resourceName;

    public VPNAccess() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public int getResourceId() { return resourceId; }
    public void setResourceId(int resourceId) { this.resourceId = resourceId; }

    public String getGrantedBy() { return grantedBy; }
    public void setGrantedBy(String grantedBy) { this.grantedBy = grantedBy; }

    public Timestamp getGrantedAt() { return grantedAt; }
    public void setGrantedAt(Timestamp grantedAt) { this.grantedAt = grantedAt; }

    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getResourceName() { return resourceName; }
    public void setResourceName(String resourceName) { this.resourceName = resourceName; }
}
