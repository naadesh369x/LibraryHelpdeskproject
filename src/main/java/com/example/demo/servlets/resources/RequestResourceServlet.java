package com.example.demo.servlets.resources;

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

@WebServlet("/RequestResourceServlet")
public class RequestResourceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String type = request.getParameter("type");
        String justification = request.getParameter("justification");
        String email = request.getParameter("email"); // get email from form

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // Add email column if not exists
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ResourceRequest' AND xtype='U')
                CREATE TABLE ResourceRequest (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    title NVARCHAR(255) NOT NULL,
                    author NVARCHAR(255),
                    type NVARCHAR(100),
                    justification NVARCHAR(MAX),
                    email NVARCHAR(255),
                    status NVARCHAR(50) DEFAULT 'Pending',
                    created_at DATETIME DEFAULT GETDATE()
                )
                ELSE
                IF COL_LENGTH('ResourceRequest', 'email') IS NULL
                ALTER TABLE ResourceRequest ADD email NVARCHAR(255)
            """;
            stmt.executeUpdate(createTableSQL);

            String insertSQL = """
                INSERT INTO ResourceRequest (title, author, type, justification, email, status, created_at)
                VALUES (?, ?, ?, ?, ?, 'Pending', GETDATE())
            """;
            try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
                ps.setString(1, title);
                ps.setString(2, author);
                ps.setString(3, type);
                ps.setString(4, justification);
                ps.setString(5, email);
                ps.executeUpdate();
            }

            response.sendRedirect("sucess.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
