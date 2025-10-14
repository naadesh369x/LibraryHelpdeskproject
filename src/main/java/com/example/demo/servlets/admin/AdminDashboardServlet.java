package com.example.demo.servlets.admin;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> tickets = new ArrayList<>();
        int newTicketsCount = 0, solvedTicketsCount = 0, pendingTicketsCount = 0;
        int totalTickets = 0;
        List<String> newClients = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // Fetch tickets
            String ticketQuery = "SELECT id, title, department, CONVERT(varchar, created_at, 120) AS created_at, client, status " +
                    "FROM tickets ORDER BY created_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(ticketQuery);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> t = new HashMap<>();
                    t.put("id", rs.getString("id"));
                    t.put("title", rs.getString("title"));
                    t.put("department", rs.getString("department"));
                    t.put("created_at", rs.getString("created_at"));
                    t.put("client", rs.getString("client"));
                    t.put("status", rs.getString("status"));
                    tickets.add(t);
                }
            }

            totalTickets = tickets.size(); //

            // Count the tickets
            String countQuery = "SELECT status, COUNT(*) AS cnt FROM tickets GROUP BY status";
            try (PreparedStatement ps = conn.prepareStatement(countQuery);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int cnt = rs.getInt("cnt");
                    if ("New".equalsIgnoreCase(status)) newTicketsCount = cnt;
                    else if ("Solved".equalsIgnoreCase(status)) solvedTicketsCount = cnt;
                }
            }


            pendingTicketsCount = totalTickets - solvedTicketsCount;


            String clientQuery = "SELECT TOP 5 name, CONVERT(varchar, created_at, 120) AS created_at " +
                    "FROM clients ORDER BY created_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(clientQuery);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String formatted = rs.getString("name") + " (" + rs.getString("created_at") + ")";
                    newClients.add(formatted);
                }
            }

        } catch (Exception e) {
            log("AdminDashboard DB error", e);
            request.setAttribute("error", "⚠ Database error: " + e.getMessage());
        }


        request.setAttribute("tickets", tickets);
        request.setAttribute("newTicketsCount", newTicketsCount);
        request.setAttribute("solvedTicketsCount", solvedTicketsCount);
        request.setAttribute("pendingTicketsCount", pendingTicketsCount);
        request.setAttribute("newClients", newClients);


        RequestDispatcher dispatcher = request.getRequestDispatcher("admindashboard.jsp");
        dispatcher.forward(request, response);
    }
}
