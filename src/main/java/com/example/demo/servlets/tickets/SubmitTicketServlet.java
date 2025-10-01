package com.example.demo.servlets.tickets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;

@WebServlet("/submitTicket")
public class SubmitTicketServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");

        try (Connection conn = DBConnection.getConnection()) {

            String createTableSQL = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='tickets' AND xtype='U') " +
                    "CREATE TABLE tickets (" +
                    "id INT IDENTITY(1,1) PRIMARY KEY, " +
                    "username NVARCHAR(50) NOT NULL, " +
                    "category NVARCHAR(50) NOT NULL, " +
                    "description NVARCHAR(MAX) NOT NULL, " +
                    "email NVARCHAR(100) NULL, " +
                    "mobile NVARCHAR(15) NULL, " +
                    "status NVARCHAR(20) DEFAULT 'New', " +
                    "created_at DATETIME DEFAULT GETDATE()" +
                    ")";
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
            }

            String insertSQL = "INSERT INTO tickets(username, category, description, email, mobile) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertSQL)) {
                stmt.setString(1, username);
                stmt.setString(2, category);
                stmt.setString(3, description);
                stmt.setString(4, email);
                stmt.setString(5, mobile);

                stmt.executeUpdate();
            }

            response.sendRedirect("myTickets.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠ Error submitting ticket: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("submit-ticket.jsp");
            dispatcher.forward(request, response);
        }
    }
}
