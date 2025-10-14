package com.example.demo.servlets.admin;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ReplyTicketServlet")
public class ReplyTicketServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ticketId = request.getParameter("ticketId");
        String message = request.getParameter("message");

        if (ticketId == null || ticketId.isEmpty() || message == null || message.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Missing required fields");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // Create ticket_replies table if it doesn't exist
            String createRepliesTable =
                    "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ticket_replies' AND xtype='U') " +
                            "BEGIN " +
                            "CREATE TABLE ticket_replies (" +
                            "id INT IDENTITY PRIMARY KEY, " +
                            "ticket_id INT NOT NULL, " +
                            "sender NVARCHAR(50) NOT NULL, " +
                            "description NVARCHAR(MAX) NULL, " +
                            "message NVARCHAR(MAX) NOT NULL, " +
                            "created_at DATETIME DEFAULT GETDATE(), " +
                            "FOREIGN KEY (ticket_id) REFERENCES tickets(ticketId) ON DELETE CASCADE" +
                            ") " +
                            "END";

            try (Statement stmt = conn.createStatement()) {
                stmt.executeUpdate(createRepliesTable);
            }

            // Get original ticket description
            String ticketDescription = "";
            String getDescSql = "SELECT description FROM tickets WHERE ticketId=?";
            try (PreparedStatement ps = conn.prepareStatement(getDescSql)) {
                ps.setInt(1, Integer.parseInt(ticketId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        ticketDescription = rs.getString("description");
                    }
                }
            }


            String insertReplySql = "INSERT INTO ticket_replies(ticket_id, sender, description, message) VALUES (?, 'admin', ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertReplySql)) {
                ps.setInt(1, Integer.parseInt(ticketId));
                ps.setString(2, ticketDescription);
                ps.setString(3, message);
                ps.executeUpdate();
            }

            // Update ticket status to Solved
            String updateTicketSql = "UPDATE tickets SET status='Solved' WHERE ticketId=?";
            try (PreparedStatement ps = conn.prepareStatement(updateTicketSql)) {
                ps.setInt(1, Integer.parseInt(ticketId));
                ps.executeUpdate();
            }

            // Get full ticket details
            Map<String, Object> ticketDetails = new HashMap<>();
            String ticketSql = "SELECT ticketId, username, category, description, email, status, created_at FROM tickets WHERE ticketId=?";
            try (PreparedStatement psTicket = conn.prepareStatement(ticketSql)) {
                psTicket.setInt(1, Integer.parseInt(ticketId));
                try (ResultSet rs = psTicket.executeQuery()) {
                    if (rs.next()) {
                        ticketDetails.put("id", rs.getString("ticketId"));
                        ticketDetails.put("username", rs.getString("username"));
                        ticketDetails.put("category", rs.getString("category"));
                        ticketDetails.put("description", rs.getString("description"));
                        ticketDetails.put("email", rs.getString("email"));
                        ticketDetails.put("status", rs.getString("status"));
                        ticketDetails.put("created_at", rs.getString("created_at"));
                    }
                }
            }

            // Get all replies with description
            List<Map<String, String>> replies = new ArrayList<>();
            String replySql = "SELECT sender, description, message, created_at FROM ticket_replies WHERE ticket_id=? ORDER BY created_at ASC";
            try (PreparedStatement psReply = conn.prepareStatement(replySql)) {
                psReply.setInt(1, Integer.parseInt(ticketId));
                try (ResultSet rs = psReply.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> r = new HashMap<>();
                        r.put("sender", rs.getString("sender"));
                        r.put("description", rs.getString("description"));
                        r.put("message", rs.getString("message"));
                        r.put("created_at", rs.getString("created_at"));
                        replies.add(r);
                    }
                }
            }

            ticketDetails.put("replies", replies);


            HttpSession session = request.getSession();
            session.setAttribute("ticketSuccess", "Reply sent successfully! Ticket marked as solved.");

            // Redirect back to admin tickets page
            response.sendRedirect("ManageTicketsServlet");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}