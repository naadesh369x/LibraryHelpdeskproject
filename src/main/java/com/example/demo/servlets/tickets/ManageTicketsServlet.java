package com.example.demo.servlets.tickets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ManageTicketsServlet")
public class ManageTicketsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> tickets = new ArrayList<>();
        String selectedTicketId = request.getParameter("ticketId");

        // Selected ticket details
        String selectedDescription = "";
        String selectedEmail = "";
        String selectedCategory = "";
        String selectedDateTime = "";
        String selectedUsername = "";
        String selectedStatus = "";

        // Replies for the selected ticket
        List<Map<String, String>> replies = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // Updated query to use ticketId instead of id
            String query = "SELECT ticketId, username, category, description, email, status, " +
                    "CONVERT(varchar, created_at, 120) AS created_at " +
                    "FROM tickets ORDER BY created_at DESC";

            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, String> ticket = new HashMap<>();
                    ticket.put("ticketId", rs.getString("ticketId"));
                    ticket.put("username", rs.getString("username"));
                    ticket.put("category", rs.getString("category"));
                    ticket.put("description", rs.getString("description"));
                    ticket.put("email", rs.getString("email"));
                    ticket.put("status", rs.getString("status"));
                    ticket.put("created_at", rs.getString("created_at"));
                    tickets.add(ticket);

                    if (selectedTicketId != null && selectedTicketId.equals(rs.getString("ticketId"))) {
                        selectedDescription = rs.getString("description");
                        selectedEmail = rs.getString("email");
                        selectedCategory = rs.getString("category");
                        selectedDateTime = rs.getString("created_at");
                        selectedUsername = rs.getString("username");
                        selectedStatus = rs.getString("status");
                    }
                }
            }

            // Fetch replies for the selected ticket if one is selected
            if (selectedTicketId != null) {
                String replyQuery = "SELECT sender, message, " +
                        "CONVERT(varchar, created_at, 120) AS created_at " +
                        "FROM ticket_replies WHERE ticket_id = ? ORDER BY created_at ASC";

                try (PreparedStatement replyPs = conn.prepareStatement(replyQuery)) {
                    replyPs.setInt(1, Integer.parseInt(selectedTicketId));
                    try (ResultSet replyRs = replyPs.executeQuery()) {
                        while (replyRs.next()) {
                            Map<String, String> reply = new HashMap<>();
                            reply.put("sender", replyRs.getString("sender"));
                            reply.put("message", replyRs.getString("message"));
                            reply.put("created_at", replyRs.getString("created_at"));
                            replies.add(reply);
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠ Database error: " + e.getMessage());
        }

        // Pass data to JSP
        request.setAttribute("tickets", tickets);
        request.setAttribute("ticketId", selectedTicketId);
        request.setAttribute("category", selectedCategory);
        request.setAttribute("created_at", selectedDateTime);
        request.setAttribute("username", selectedUsername);
        request.setAttribute("email", selectedEmail);
        request.setAttribute("description", selectedDescription);
        request.setAttribute("status", selectedStatus);
        request.setAttribute("replies", replies);

        // Updated to forward to the correct JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("ticketmanagement.jsp");
        dispatcher.forward(request, response);
    }
}