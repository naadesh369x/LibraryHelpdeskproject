package com.example.demo.optional;



import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/TicketDetailsServlet")
public class TicketDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketId = request.getParameter("id");
        List<Map<String, String>> messages = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT sender, message, CONVERT(varchar, created_at, 120) AS created_at FROM ticket_replies WHERE ticket_id=? ORDER BY created_at ASC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, ticketId);
                try (ResultSet rs = ps.executeQuery()) {
                    while(rs.next()) {
                        Map<String, String> msg = new HashMap<>();
                        msg.put("sender", rs.getString("sender"));
                        msg.put("message", rs.getString("message"));
                        msg.put("created_at", rs.getString("created_at"));
                        messages.add(msg);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("messages", messages);
        request.setAttribute("ticketId", ticketId);
        RequestDispatcher dispatcher = request.getRequestDispatcher("manage-tickets.jsp");
        dispatcher.forward(request, response);
    }
}
