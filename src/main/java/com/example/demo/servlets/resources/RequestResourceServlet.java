package com.example.demo.servlets.resources;

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

@WebServlet("/RequestResourceServlet")
public class RequestResourceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String type = request.getParameter("type");
        String justification = request.getParameter("justification");
        String email = request.getParameter("email");

        // Basic validation
        if (title == null || title.trim().isEmpty() ||
                author == null || author.trim().isEmpty() ||
                type == null || type.trim().isEmpty() ||
                justification == null || justification.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {

            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "All fields are required. Please fill in all fields.");
            response.sendRedirect("requestResource.jsp");
            return;
        }

        // Get user ID from session
        HttpSession session = request.getSession(false);
        Integer userId = null;


        String userIdParam = request.getParameter("userId");
        if (userIdParam != null && !userIdParam.isEmpty()) {
            try {
                userId = Integer.parseInt(userIdParam);
            } catch (NumberFormatException e) {

            }
        }


        if (userId == null && session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }


        if (userId == null) {
            session.setAttribute("errorMessage", "User not found. Please log in again.");
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Create table if it doesn't exist
            createResourceRequestTable(conn);
            // Insert the resource request
            String insertSQL = """
                INSERT INTO ResourceRequest (title, author, type, justification, email, user_id, status, created_at)
                VALUES (?, ?, ?, ?, ?, ?, 'Pending', GETDATE())
            """;

            try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
                ps.setString(1, title);
                ps.setString(2, author);
                ps.setString(3, type);
                ps.setString(4, justification);
                ps.setString(5, email);
                ps.setInt(6, userId);

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    session.setAttribute("successMessage", "Your resource request has been submitted successfully!");
                    response.sendRedirect("ViewRequestServlet");
                } else {
                    session.setAttribute("errorMessage", "Failed to submit your request. Please try again.");
                    response.sendRedirect("requestResource.jsp");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while processing your request: " + e.getMessage());
            response.sendRedirect("error.jsp");
        }
    }

    private void createResourceRequestTable(Connection conn) throws Exception {
        try (Statement stmt = conn.createStatement()) {
            // Check if table exists, create if not
            stmt.execute("""
                IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceRequest')
                BEGIN
                    CREATE TABLE ResourceRequest (
                        requestid INT IDENTITY(1,1) PRIMARY KEY,
                        title NVARCHAR(255) NOT NULL,
                        author NVARCHAR(255),
                        type NVARCHAR(100),
                        justification NVARCHAR(MAX),
                        email NVARCHAR(255),
                        user_id INT,
                        status NVARCHAR(50) DEFAULT 'Pending',
                        created_at DATETIME DEFAULT GETDATE(),
                        CONSTRAINT FK_ResourceRequest_User FOREIGN KEY (user_id) REFERENCES members(userid)
                    )
                END
                """);
        }
    }
}