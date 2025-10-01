package com.example.demo.servlets.tickets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ViewAllRepliesServlet")
public class ViewAllRepliesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> replies = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            String sql = "SELECT r.id AS reply_id, r.ticket_id, r.sender, r.message, r.created_at, " +
                    "t.username, t.category, t.description " +   // 👈 Added description
                    "FROM ticket_replies r " +
                    "INNER JOIN tickets t ON r.ticket_id = t.id " +
                    "ORDER BY r.created_at DESC";

            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> reply = new HashMap<>();


                    reply.put("id", rs.getInt("reply_id"));
                    reply.put("sender", rs.getString("sender"));
                    reply.put("message", rs.getString("message"));
                    reply.put("created_at", rs.getString("created_at"));

                    Map<String, String> ticket = new HashMap<>();
                    ticket.put("id", String.valueOf(rs.getInt("ticket_id")));
                    ticket.put("username", rs.getString("username"));
                    ticket.put("category", rs.getString("category"));
                    ticket.put("description", rs.getString("description"));

                    reply.put("ticket", ticket);

                    replies.add(reply);
                }
            }


            request.setAttribute("replies", replies);
            request.getRequestDispatcher("all-replies.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "⚠ Error loading replies: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
