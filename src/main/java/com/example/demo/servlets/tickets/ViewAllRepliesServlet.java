package com.example.demo.servlets.tickets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ViewAllRepliesServlet")
public class ViewAllRepliesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> replies = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // Use correct column names for join and select
            String sql = "SELECT r.id AS reply_id, r.ticket_id, r.sender, r.message, r.created_at, " +
                    "t.ticketid AS ticketId, t.username, t.category, t.description, t.status, t.email, t.mobile " +
                    "FROM ticket_replies r " +
                    "INNER JOIN tickets t ON r.ticket_id = t.ticketid " +
                    "ORDER BY r.created_at DESC";

            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> reply = new HashMap<>();

                    reply.put("id", rs.getInt("reply_id"));
                    reply.put("sender", rs.getString("sender"));
                    reply.put("message", rs.getString("message"));
                    reply.put("created_at", rs.getString("created_at"));

                    Map<String, String> ticket = new HashMap<>();
                    ticket.put("ticketId", String.valueOf(rs.getInt("ticketId")));
                    ticket.put("username", rs.getString("username"));
                    ticket.put("category", rs.getString("category"));
                    ticket.put("description", rs.getString("description"));
                    ticket.put("status", rs.getString("status"));
                    ticket.put("email", rs.getString("email"));
                    ticket.put("mobile", rs.getString("mobile"));

                    reply.put("ticket", ticket);

                    replies.add(reply);
                }
            }

            request.setAttribute("replies", replies);
            request.getRequestDispatcher("adminAllReplies.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading replies: " + (e.getMessage() != null ? e.getMessage() : "Unknown error"));
            request.setAttribute("replies", null);
            request.getRequestDispatcher("adminAllReplies.jsp").forward(request, response);
        }
    }
}