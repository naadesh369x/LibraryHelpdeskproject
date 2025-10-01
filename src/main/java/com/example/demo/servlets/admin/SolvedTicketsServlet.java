package com.example.demo.servlets.admin;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin-SolvedTickets")
public class SolvedTicketsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> tickets = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // Get all solved tickets
            String ticketSql = "SELECT id, username, category, description, email, status, created_at " +
                    "FROM tickets WHERE status='Solved' ORDER BY id DESC";
            try (PreparedStatement ps = conn.prepareStatement(ticketSql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> ticket = new HashMap<>();
                    int ticketId = rs.getInt("id");

                    ticket.put("id", rs.getString("id"));
                    ticket.put("username", rs.getString("username"));
                    ticket.put("category", rs.getString("category"));
                    ticket.put("description", rs.getString("description"));
                    ticket.put("email", rs.getString("email"));
                    ticket.put("status", rs.getString("status"));
                    ticket.put("created_at", rs.getString("created_at"));

                    // Get all replies for this ticket
                    List<Map<String, String>> replies = new ArrayList<>();
                    String replySql = "SELECT sender, message, created_at FROM ticket_replies WHERE ticket_id=? ORDER BY created_at ASC";
                    try (PreparedStatement psReply = conn.prepareStatement(replySql)) {
                        psReply.setInt(1, ticketId);
                        try (ResultSet rsReply = psReply.executeQuery()) {
                            while (rsReply.next()) {
                                Map<String, String> r = new HashMap<>();
                                r.put("sender", rsReply.getString("sender"));
                                r.put("message", rsReply.getString("message"));
                                r.put("created_at", rsReply.getString("created_at"));
                                replies.add(r);
                            }
                        }
                    }
                    ticket.put("replies", replies);

                    tickets.add(ticket);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("adminsolvedtickets.jsp").forward(request, response);
    }
}
