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
        String selectedTicketId = request.getParameter("id");

        // Selected ticket details
        String selectedDescription = "";
        String selectedEmail = "";
        String selectedCategory = "";
        String selectedDateTime = "";
        String selectedUsername = "";
        String selectedStatus = "";

        try (Connection conn = DBConnection.getConnection()) {

            String query = "SELECT id, username, category, description, email, status, " +
                    "CONVERT(varchar, created_at, 120) AS created_at " +
                    "FROM tickets ORDER BY created_at DESC";

            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, String> ticket = new HashMap<>();
                    ticket.put("id", rs.getString("id"));
                    ticket.put("username", rs.getString("username"));
                    ticket.put("category", rs.getString("category"));
                    ticket.put("description", rs.getString("description"));
                    ticket.put("email", rs.getString("email"));
                    ticket.put("status", rs.getString("status"));
                    ticket.put("created_at", rs.getString("created_at"));
                    tickets.add(ticket);

                    if (selectedTicketId != null && selectedTicketId.equals(rs.getString("id"))) {
                        selectedDescription = rs.getString("description");
                        selectedEmail = rs.getString("email");
                        selectedCategory = rs.getString("category");
                        selectedDateTime = rs.getString("created_at");
                        selectedUsername = rs.getString("username");
                        selectedStatus = rs.getString("status");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠ Database error: " + e.getMessage());
        }

        // Message history
        List<String> messages = new ArrayList<>();

        // Pass data to JSP
        request.setAttribute("tickets", tickets);
        request.setAttribute("ticketId", selectedTicketId);
        request.setAttribute("category", selectedCategory);
        request.setAttribute("created_at", selectedDateTime);
        request.setAttribute("username", selectedUsername);
        request.setAttribute("email", selectedEmail);
        request.setAttribute("description", selectedDescription);
        request.setAttribute("status", selectedStatus);
        request.setAttribute("messages", messages);

        RequestDispatcher dispatcher = request.getRequestDispatcher("ticketmanagement.jsp");
        dispatcher.forward(request, response);
    }
}
