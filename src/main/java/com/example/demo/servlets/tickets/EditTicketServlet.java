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

@WebServlet("/EditTicketServlet")
public class EditTicketServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("email") : null;
        if (email == null) {
            response.sendRedirect("login.jsp?error=Please+login+first");
            return;
        }

        String ticketId = request.getParameter("ticketId");
        String description = request.getParameter("description");

        if (ticketId == null || ticketId.isEmpty() || description == null || description.trim().isEmpty()) {
            response.sendRedirect("myTickets.jsp?ticketId=" + ticketId + "&error=Missing+required+fields");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE tickets SET description = ? WHERE id = ? AND email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, description);
                stmt.setInt(2, Integer.parseInt(ticketId));
                stmt.setString(3, email);

                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("myTickets.jsp?ticketId=" + ticketId + "&success=Description+updated+successfully");
                } else {
                    response.sendRedirect("myTickets.jsp?ticketId=" + ticketId + "&error=Ticket+not+found+or+not+owned+by+you");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myTickets.jsp?ticketId=" + ticketId + "&error=Error+updating+description");
        }
    }
}