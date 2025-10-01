package com.example.demo.servlets.tickets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/TicketsServlet")
public class TicketsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, String>> tickets = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT id, subject, userName, status, CONVERT(varchar, created_at, 120) AS created_at FROM tickets ORDER BY created_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    Map<String, String> t = new HashMap<>();
                    t.put("id", rs.getString("id"));
                    t.put("subject", rs.getString("subject"));
                    t.put("userName", rs.getString("userName"));
                    t.put("status", rs.getString("status"));
                    tickets.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("tickets", tickets);
        RequestDispatcher dispatcher = request.getRequestDispatcher("manage-tickets.jsp");
        dispatcher.forward(request, response);
    }
}
