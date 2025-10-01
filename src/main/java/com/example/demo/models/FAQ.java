package com.example.demo.models;
import java.time.LocalDateTime;

    public class FAQ {
        private int id;
        private String question;
        private String answer;
        private String imagePath;
        private LocalDateTime createdAt;

        public FAQ() {}

        public FAQ(int id, String question, String answer, String imagePath, LocalDateTime createdAt) {
            this.id = id;
            this.question = question;
            this.answer = answer;
            this.imagePath = imagePath;
            this.createdAt = createdAt;
        }

        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }

        public String getQuestion() { return question; }
        public void setQuestion(String question) { this.question = question; }

        public String getAnswer() { return answer; }
        public void setAnswer(String answer) { this.answer = answer; }

        public String getImagePath() { return imagePath; }
        public void setImagePath(String imagePath) { this.imagePath = imagePath; }

        public LocalDateTime getCreatedAt() { return createdAt; }
        public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    }



