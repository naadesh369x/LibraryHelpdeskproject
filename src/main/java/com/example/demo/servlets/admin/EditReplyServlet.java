package com.example.demo.servlets.admin;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/EditReplyServlet")
public class EditReplyServlet extends HttpServlet {

    // Load reply with ticket
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String replyId = request.getParameter("id");
        Map<String, String> reply = null;
        Map<String, String> ticket = null;

        try (Connection conn = DBConnection.getConnection()) {

            // Get reply details
            String replySql = "SELECT id, ticket_id, sender, message, created_at FROM tickets_replies WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(replySql)) {
                ps.setInt(1, Integer.parseInt(replyId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        reply = new HashMap<>();
                        reply.put("id", String.valueOf(rs.getInt("id")));
                        reply.put("ticket_id", String.valueOf(rs.getInt("ticket_id")));
                        reply.put("sender", rs.getString("sender"));
                        reply.put("message", rs.getString("message"));
                        reply.put("created_at", rs.getString("created_at"));
                    }
                }
            }

            // Get ticket details for this reply
            if (reply != null) {
                String ticketSql = "SELECT id, username, email, category, description, status, created_at FROM tickets WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(ticketSql)) {
                    ps.setInt(1, Integer.parseInt(reply.get("ticket_id")));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            ticket = new HashMap<>();
                            ticket.put("id", String.valueOf(rs.getInt("id")));
                            ticket.put("username", rs.getString("username"));
                            ticket.put("email", rs.getString("email"));
                            ticket.put("category", rs.getString("category"));
                            ticket.put("description", rs.getString("description"));
                            ticket.put("status", rs.getString("status"));
                            ticket.put("created_at", rs.getString("created_at"));
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading reply: " + e.getMessage());
        }

        request.setAttribute("reply", reply);
        request.setAttribute("ticket", ticket);
        request.getRequestDispatcher("editReply.jsp").forward(request, response);
    }

    // Update reply message
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String message = request.getParameter("replyText");

        if (id == null || message == null || message.trim().isEmpty()) {
            response.sendRedirect("all-replies.jsp?error=Missing+data");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE tickets_replies SET message = ?, updated_at = NOW() WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, message);
                ps.setInt(2, Integer.parseInt(id));
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating reply: " + e.getMessage());
            request.getRequestDispatcher("editReply.jsp").forward(request, response);
            return;
        }

        // Redirect back to replies management page
        response.sendRedirect("all-replies.jsp?success=ReplyUpdated");
    }
}
