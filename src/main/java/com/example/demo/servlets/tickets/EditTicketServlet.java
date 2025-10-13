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
            // First get the userId from the email
            int userId = 0;
            String getUserSql = "SELECT userId FROM members WHERE email = ?";
            try (PreparedStatement getUserStmt = conn.prepareStatement(getUserSql)) {
                getUserStmt.setString(1, email);
                try (ResultSet rs = getUserStmt.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("userId");
                    } else {
                        response.sendRedirect("myTickets.jsp?error=User+not+found");
                        return;
                    }
                }
            }

            // Update the ticket description using ticketId and userId
            String sql = "UPDATE tickets SET description = ? WHERE ticketId = ? AND userId = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, description);
                stmt.setInt(2, Integer.parseInt(ticketId));
                stmt.setInt(3, userId);

                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    // Set success message in session
                    session.setAttribute("ticketSuccess", "Ticket description updated successfully!");
                    response.sendRedirect("myTickets.jsp?ticketId=" + ticketId);
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