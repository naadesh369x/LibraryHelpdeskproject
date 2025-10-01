package com.example.demo.models;


import java.sql.Timestamp;

public class ResourceRequest {
    private String title;
    private String author;
    private String type;
    private String justification;
    private String status;
    private Timestamp createdAt;

    public ResourceRequest(String title, String author, String type, String justification, String status, Timestamp createdAt) {
        this.title = title;
        this.author = author;
        this.type = type;
        this.justification = justification;
        this.status = status;
        this.createdAt = createdAt;
    }

    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public String getType() { return type; }
    public String getJustification() { return justification; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
}
