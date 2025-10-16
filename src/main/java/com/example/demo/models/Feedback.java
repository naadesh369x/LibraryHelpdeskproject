package com.example.demo.models;

import java.util.Date;

public class Feedback {
    private int faqId;
    private String firstName;
    private String lastName;
    private String email;
    private String comment;
    private int rating;
    private Date createdAt;

    // Default constructor
    public Feedback() {
    }

    // Parameterized constructor
    public Feedback(int faqId, String firstName, String lastName, String email,
                    String comment, int rating, Date createdAt) {
        this.faqId = faqId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.comment = comment;
        this.rating = rating;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getFaqId() {
        return faqId;
    }

    public void setFaqId(int faqId) {
        this.faqId = faqId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // Optional: toString() for debugging/logging
    @Override
    public String toString() {
        return "Feedback{" +
                "faqId=" + faqId +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", email='" + email + '\'' +
                ", comment='" + comment + '\'' +
                ", rating=" + rating +
                ", createdAt=" + createdAt +
                '}';
    }
}
