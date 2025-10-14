package com.example.demo.servlets.feedback;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");
        String comment = request.getParameter("comment");
        String ratingStr = request.getParameter("rating");

        int rating = (ratingStr != null && !ratingStr.isEmpty()) ? Integer.parseInt(ratingStr) : 0;

        try (Connection conn = DBConnection.getConnection()) {

            // Create table if not exists
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='feedbacks' AND xtype='U')
                CREATE TABLE feedbacks (
                    faqid INT IDENTITY(1,1) PRIMARY KEY,
                    firstname VARCHAR(100) NOT NULL,
                    lastname VARCHAR(100) NOT NULL,
                    email VARCHAR(150) NOT NULL,
                    comment NVARCHAR(MAX) NOT NULL,
                    rating INT NOT NULL,
                    created_at DATETIME DEFAULT GETDATE()
                )
            """;

            Statement stmt = conn.createStatement();
            stmt.execute(createTableSQL);

            // Insert feedback
            String sql = "INSERT INTO feedbacks (firstname, lastname, email, comment, rating) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, firstname);
            ps.setString(2, lastname);
            ps.setString(3, email);
            ps.setString(4, comment);
            ps.setInt(5, rating);

            ps.executeUpdate();

            // Redirect to list page
            response.sendRedirect("myfeedbacks.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error saving feedback: " + e.getMessage());
        }
    }
}
