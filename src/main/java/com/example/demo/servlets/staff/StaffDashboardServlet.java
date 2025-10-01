package com.example.demo.servlets.staff;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/staff-dashboard")
public class StaffDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get logged-in staff username or ID from session
        HttpSession session = request.getSession(false);
        String staffUsername = (session != null) ? (String) session.getAttribute("username") : null;

        if (staffUsername == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, String>> tickets = new ArrayList<>();
        int newTicketsCount = 0, solvedTicketsCount = 0, pendingTicketsCount = 0;
        int totalTickets = 0;

        try (Connection conn = DBConnection.getConnection()) {

            // ✅ Fetch tickets assigned to this staff
            String ticketQuery = "SELECT id, title, department, CONVERT(varchar, created_at, 120) AS created_at, client, status " +
                    "FROM tickets WHERE assigned_to = ? ORDER BY created_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(ticketQuery)) {
                ps.setString(1, staffUsername);
                try (ResultSet rs = ps.executeQuery()) {
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
            }

            totalTickets = tickets.size(); // ✅ total tickets

            // ✅ Count tickets by status
            String countQuery = "SELECT status, COUNT(*) AS cnt FROM tickets WHERE assigned_to = ? GROUP BY status";
            try (PreparedStatement ps = conn.prepareStatement(countQuery)) {
                ps.setString(1, staffUsername);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String status = rs.getString("status");
                        int cnt = rs.getInt("cnt");
                        if ("New".equalsIgnoreCase(status)) newTicketsCount = cnt;
                        else if ("Solved".equalsIgnoreCase(status)) solvedTicketsCount = cnt;
                    }
                }
            }

            // ✅ Pending = Total - Solved
            pendingTicketsCount = totalTickets - solvedTicketsCount;

        } catch (Exception e) {
            log("StaffDashboard DB error", e);
            request.setAttribute("error", "⚠ Database error: " + e.getMessage());
        }


        request.setAttribute("tickets", tickets);
        request.setAttribute("newTicketsCount", newTicketsCount);
        request.setAttribute("solvedTicketsCount", solvedTicketsCount);
        request.setAttribute("pendingTicketsCount", pendingTicketsCount);

        // Forward to staff dashboard JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("staffdashboard.jsp");
        dispatcher.forward(request, response);
    }
}
