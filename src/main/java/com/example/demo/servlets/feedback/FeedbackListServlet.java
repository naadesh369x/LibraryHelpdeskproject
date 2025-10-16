package com.example.demo.servlets.feedback;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/FeedbackListServlet")
public class FeedbackListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> feedbackList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // Create table if not exists
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='feedbacks' AND xtype='U')
                CREATE TABLE feedbacks (
                    feedbackid INT IDENTITY(1,1) PRIMARY KEY,
                    userId INT NOT NULL,
                    firstname VARCHAR(100) NOT NULL,
                    lastname VARCHAR(100) NOT NULL,
                    email VARCHAR(150) NOT NULL,
                    comment NVARCHAR(MAX) NOT NULL,
                    rating INT NOT NULL,
                    created_at DATETIME DEFAULT GETDATE(),
                    FOREIGN KEY (userId) REFERENCES Members(userId)
                )
            """;

            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
            }

            // Select feedbacks joined with Members table
            String selectSQL = """
                SELECT f.feedbackid, f.firstname, f.lastname, f.email, f.comment, 
                       f.rating, f.created_at, m.userId, m.username
                FROM feedbacks f
                INNER JOIN Members m ON f.userId = m.userId
                ORDER BY f.created_at DESC
            """;

            try (PreparedStatement ps = conn.prepareStatement(selectSQL);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, String> fb = new HashMap<>();
                    fb.put("feedbackid", String.valueOf(rs.getInt("feedbackid")));
                    fb.put("userId", String.valueOf(rs.getInt("userId")));
                    fb.put("username", rs.getString("username"));
                    fb.put("firstname", rs.getString("firstname"));
                    fb.put("lastname", rs.getString("lastname"));
                    fb.put("email", rs.getString("email"));
                    fb.put("comment", rs.getString("comment"));
                    fb.put("rating", String.valueOf(rs.getInt("rating")));
                    fb.put("created_at", rs.getTimestamp("created_at").toString());
                    feedbackList.add(fb);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading feedbacks: " + e.getMessage());
        }

        // Pass data to JSP
        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher("userallfeedbacks.jsp").forward(request, response);
    }
}
