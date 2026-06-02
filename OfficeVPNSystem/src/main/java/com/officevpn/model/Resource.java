package com.officevpn.model;

import java.sql.Timestamp;

public class Resource {
    private int id;
    private String resourceName;
    private String resourceType;
    private String description;
    private String ipAddress;
    private String accessLevel;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Resource() {}

    public Resource(int id, String resourceName, String resourceType, String description,
                    String ipAddress, String accessLevel, String status) {
        this.id = id;
        this.resourceName = resourceName;
        this.resourceType = resourceType;
        this.description = description;
        this.ipAddress = ipAddress;
        this.accessLevel = accessLevel;
        this.status = status;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getResourceName() { return resourceName; }
    public void setResourceName(String resourceName) { this.resourceName = resourceName; }

    public String getResourceType() { return resourceType; }
    public void setResourceType(String resourceType) { this.resourceType = resourceType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public String getAccessLevel() { return accessLevel; }
    public void setAccessLevel(String accessLevel) { this.accessLevel = accessLevel; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
