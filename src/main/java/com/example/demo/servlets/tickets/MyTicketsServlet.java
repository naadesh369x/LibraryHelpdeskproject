package com.example.demo.servlets.tickets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

@WebServlet("/MyTicketsServlet")
public class MyTicketsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("email") : null;

        if (email == null) {
            response.sendRedirect("login.jsp?error=Please+login+first");
            return;
        }

        List<Map<String, String>> ticketsList = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM tickets WHERE email = ? ORDER BY created_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> ticket = new HashMap<>();
                        ticket.put("id", String.valueOf(rs.getInt("id")));
                        ticket.put("category", rs.getString("category"));
                        ticket.put("status", rs.getString("status"));
                        ticket.put("description", rs.getString("description"));
                        ticket.put("created_at", rs.getTimestamp("created_at").toString());
                        ticketsList.add(ticket);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String selectedTicketId = request.getParameter("ticketId");
        Map<String, String> currentTicket = null;
        List<Map<String, String>> repliesList = new ArrayList<>();

        if (selectedTicketId != null) {
            try (Connection conn = DBConnection.getConnection()) {
                // Ticket info
                String ticketSql = "SELECT * FROM tickets WHERE id=? AND email=?";
                try (PreparedStatement ps = conn.prepareStatement(ticketSql)) {
                    ps.setInt(1, Integer.parseInt(selectedTicketId));
                    ps.setString(2, email);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            currentTicket = new HashMap<>();
                            currentTicket.put("id", String.valueOf(rs.getInt("id")));
                            currentTicket.put("category", rs.getString("category"));
                            currentTicket.put("status", rs.getString("status"));
                            currentTicket.put("description", rs.getString("description"));
                            currentTicket.put("created_at", rs.getTimestamp("created_at").toString());
                        }
                    }
                }

                if (currentTicket != null) {
                    String replySql = "SELECT * FROM tickets_replies WHERE ticket_id=? ORDER BY created_at ASC";
                    try (PreparedStatement ps2 = conn.prepareStatement(replySql)) {
                        ps2.setInt(1, Integer.parseInt(selectedTicketId));
                        try (ResultSet rs2 = ps2.executeQuery()) {
                            while (rs2.next()) {
                                Map<String, String> reply = new HashMap<>();
                                reply.put("message", rs2.getString("message")); // make sure column name matches DB
                                reply.put("created_at",
                                        rs2.getTimestamp("created_at") != null
                                                ? rs2.getTimestamp("created_at").toString()
                                                : "");
                                repliesList.add(reply);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("ticketsList", ticketsList);
        request.setAttribute("currentTicket", currentTicket);
        request.setAttribute("repliesList", repliesList);

        request.setAttribute("successMsg", request.getParameter("success"));
        request.setAttribute("errorMsg", request.getParameter("error"));

        request.getRequestDispatcher("myTickets.jsp").forward(request, response);
    }
}
