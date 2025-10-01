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

@WebServlet("/DeleteTicketServlet")
public class DeleteTicketServlet extends HttpServlet {

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
        if (ticketId == null || ticketId.isEmpty()) {
            response.sendRedirect("myTickets.jsp?error=Missing+ticket+ID");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Delete only if ticket belongs to the logged-in user
            String sql = "DELETE FROM tickets WHERE id = ? AND email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, Integer.parseInt(ticketId));
                stmt.setString(2, email);

                int rowsDeleted = stmt.executeUpdate();

                if (rowsDeleted > 0) {
                    response.sendRedirect("myTickets.jsp?success=Ticket+deleted+successfully");
                } else {
                    response.sendRedirect("myTickets.jsp?error=Ticket+not+found+or+not+owned+by+you");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myTickets.jsp?error=Error+deleting+ticket");
        }
    }
}
