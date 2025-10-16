package com.example.demo.servlets.tickets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/StaffTicketsManageServlet")
public class StaffTicketsManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String selectedTicketId = request.getParameter("ticketId");

        try (Connection conn = DBConnection.getConnection()) {


            List<Map<String, String>> tickets = new ArrayList<>();
            String query = "SELECT id, ticket_id, category, status, created_at, username, email FROM assigned_tickets";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {

                while (rs.next()) {
                    Map<String, String> ticket = new HashMap<>();
                    ticket.put("id", rs.getString("id"));
                    ticket.put("ticketId", rs.getString("ticket_id"));
                    ticket.put("category", rs.getString("category"));
                    ticket.put("status", rs.getString("status"));
                    ticket.put("created_at", rs.getString("created_at"));
                    ticket.put("username", rs.getString("username"));
                    ticket.put("email", rs.getString("email"));
                    tickets.add(ticket);
                }
            }
            request.setAttribute("tickets", tickets);

            // ===============================
            // 2️⃣ If a specific ticket is selected, fetch its details
            // ===============================
            if (selectedTicketId != null && !selectedTicketId.isEmpty()) {
                String detailsSQL = "SELECT * FROM assigned_tickets WHERE ticket_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(detailsSQL)) {
                    ps.setString(1, selectedTicketId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            request.setAttribute("ticketId", rs.getString("ticket_id"));
                            request.setAttribute("category", rs.getString("category"));
                            request.setAttribute("status", rs.getString("status"));
                            request.setAttribute("created_at", rs.getString("created_at"));
                            request.setAttribute("username", rs.getString("username"));
                            request.setAttribute("email", rs.getString("email"));
                            request.setAttribute("description", rs.getString("description"));
                            request.setAttribute("staff_assigned", rs.getString("staff_reply")); // optional
                        }
                    }
                }

                // ===============================
                // 3️⃣ Fetch replies if you have a replies table
                // ===============================
                List<Map<String, String>> replies = new ArrayList<>();
                String replySQL = "SELECT * FROM ticket_replies WHERE ticket_id = ? ORDER BY created_at ASC";
                try (PreparedStatement ps = conn.prepareStatement(replySQL)) {
                    ps.setString(1, selectedTicketId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> reply = new HashMap<>();
                            reply.put("sender", rs.getString("sender"));
                            reply.put("message", rs.getString("message"));
                            reply.put("created_at", rs.getString("created_at"));
                            replies.add(reply);
                        }
                    }
                } catch (SQLException e) {
                    // ignore if table not exists
                }
                request.setAttribute("replies", replies);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching tickets: " + e.getMessage());
        }

        // Forward to JSP
        request.getRequestDispatcher("staffticketmanagement.jsp").forward(request, response);
    }
}
