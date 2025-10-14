package com.example.demo.models;

import java.util.Date;

public class Ticket {
    private int ticketId;
    private int userId;
    private String username;
    private String category;
    private String description;
    private String email;
    private String mobile;
    private String status;
    private Date createdAt;

    // Default constructor
    public Ticket() {
    }

    // Parameterized constructor (for convenience)
    public Ticket(int ticketId, int userId, String username, String category, String description,
                  String email, String mobile, String status, Date createdAt) {
        this.ticketId = ticketId;
        this.userId = userId;
        this.username = username;
        this.category = category;
        this.description = description;
        this.email = email;
        this.mobile = mobile;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // Optional: for logging/debugging
    @Override
    public String toString() {
        return "Ticket{" +
                "ticketId=" + ticketId +
                ", userId=" + userId +
                ", username='" + username + '\'' +
                ", category='" + category + '\'' +
                ", description='" + description + '\'' +
                ", email='" + email + '\'' +
                ", mobile='" + mobile + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
