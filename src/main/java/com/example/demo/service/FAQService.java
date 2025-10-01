package com.example.demo.service;


import com.example.demo.models.FAQ;
import com.example.demo.utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FAQService {

    public void addFAQ(FAQ faq) {
        String sql = "INSERT INTO faq (question, answer, image_path, created_at) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, faq.getQuestion());
            ps.setString(2, faq.getAnswer());
            ps.setString(3, faq.getImagePath());
            ps.setTimestamp(4, Timestamp.valueOf(faq.getCreatedAt()));

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<FAQ> getAllFAQs() {
        List<FAQ> faqs = new ArrayList<>();
        String sql = "SELECT * FROM faq ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                FAQ faq = new FAQ();
                faq.setId(rs.getInt("id"));
                faq.setQuestion(rs.getString("question"));
                faq.setAnswer(rs.getString("answer"));
                faq.setImagePath(rs.getString("image_path"));
                faq.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                faqs.add(faq);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return faqs;
    }
}
