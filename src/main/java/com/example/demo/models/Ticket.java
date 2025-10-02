package com.example.demo.models;

import java.time.LocalDate;

public class Ticket {
    private int id;
    private String title;
    private String department;
    private LocalDate date;
    private String client;
    private String status;

    public Ticket(String hashtag, String problemOfInstallation, String product, String s, String johnDoe, String pending) {

    }

    public Ticket(int id, String title, String department, LocalDate date, String client, String status) {
        this.id = id;
        this.title = title;
        this.department = department;
        this.date = date;
        this.client = client;
        this.status = status;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubject() {
        return title;
    }

    public String getDepartment() {
        return department;
    }
    public void setDepartment(String department) {
        this.department = department;
    }

    public LocalDate getDate() {
        return date;
    }
    public void setDate(LocalDate date) {
        this.date = date;
    }

    public String getClient() {
        return client;
    }
    public void setClient(String client) {
        this.client = client;
    }

    public String getUserName() {
        return client;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
}
