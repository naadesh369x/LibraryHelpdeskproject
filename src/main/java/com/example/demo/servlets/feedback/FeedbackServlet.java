package com.example.demo.servlets.feedback;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");
        String comment = request.getParameter("comment");
        String ratingStr = request.getParameter("rating");

        int rating = 0;
        try {
            rating = Integer.parseInt(ratingStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("addfeedback.jsp?error=Invalid+rating+value");
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=Please+login+first");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");

        try (Connection conn = DBConnection.getConnection()) {

            // Create feedbacks table
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
                    CONSTRAINT FK_Feedback_User FOREIGN KEY (userId) REFERENCES Members(userId)
                )
            """;

            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
            }

            // Insert feedback
            String insertSQL = """
                INSERT INTO feedbacks (userId, firstname, lastname, email, comment, rating)
                VALUES (?, ?, ?, ?, ?, ?)
            """;

            try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
                ps.setInt(1, userId);
                ps.setString(2, firstname);
                ps.setString(3, lastname);
                ps.setString(4, email);
                ps.setString(5, comment);
                ps.setInt(6, rating);
                ps.executeUpdate();
            }

            response.sendRedirect("addfeedback.jsp?success=Feedback+submitted+successfully");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addfeedback.jsp?error=Error+saving+feedback:+"
                    + e.getMessage().replace(" ", "+"));
        }
    }
}
