package com.example.demo.servlets.tickets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AssignToStaffServlet")
public class AssignToStaffServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ticketId = request.getParameter("ticketId");
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String createdAt = request.getParameter("created_at");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String description = request.getParameter("description");
        String staffReply = request.getParameter("staffReply");

        try (Connection conn = DBConnection.getConnection()) {

            // Create table if not exists (for SQL Server)
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='assigned_tickets' AND xtype='U')
                BEGIN
                    CREATE TABLE assigned_tickets (
                        id INT IDENTITY(1,1) PRIMARY KEY,
                        ticket_id VARCHAR(50),
                        category VARCHAR(100),
                        status VARCHAR(50),
                        created_at VARCHAR(50),
                        username VARCHAR(100),
                        email VARCHAR(100),
                        description TEXT,
                        staff_reply TEXT
                    )
                END
            """;
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
            }

            // Insert assigned ticket
            String insertSQL = """
                INSERT INTO assigned_tickets 
                (ticket_id, category, status, created_at, username, email, description, staff_reply)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """;
            try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
                ps.setString(1, ticketId);
                ps.setString(2, category);
                ps.setString(3, status);
                ps.setString(4, createdAt);
                ps.setString(5, username);
                ps.setString(6, email);
                ps.setString(7, description);
                ps.setString(8, staffReply);
                ps.executeUpdate();
            }

            request.getSession().setAttribute("ticketSuccess", "Ticket assigned to staff successfully!");
        } catch (Exception e) {
            request.getSession().setAttribute("ticketSuccess", "Error assigning ticket: " + e.getMessage());
        }

        response.sendRedirect("ManageTicketsServlet");
    }
}
