package com.example.demo.models;

import java.util.Date;

public class ResourceRequest {
    private int requestId;
    private String title;
    private String author;
    private String type;
    private String justification;
    private String email;
    private int userId;
    private String status;
    private Date createdAt;

    // Default constructor
    public ResourceRequest() {
    }

    // Parameterized constructor
    public ResourceRequest(int requestId, String title, String author, String type,
                           String justification, String email, int userId,
                           String status, Date createdAt) {
        this.requestId = requestId;
        this.title = title;
        this.author = author;
        this.type = type;
        this.justification = justification;
        this.email = email;
        this.userId = userId;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getJustification() {
        return justification;
    }

    public void setJustification(String justification) {
        this.justification = justification;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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
        return "ResourceRequest{" +
                "requestId=" + requestId +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", type='" + type + '\'' +
                ", justification='" + justification + '\'' +
                ", email='" + email + '\'' +
                ", userId=" + userId +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
