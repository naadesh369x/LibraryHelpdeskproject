package com.example.demo.servlets.admin;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/AdminRequestsServlet")
public class AdminRequestsServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminRequestsServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> requestsList = new ArrayList<>();
        int totalCount = 0, pendingCount = 0, approvedCount = 0, rejectedCount = 0;

        try (Connection conn = DBConnection.getConnection()) {


            String fetchSQL = """
                SELECT r.requestid, r.title, r.author, r.type, r.justification, r.email, 
                       r.status, r.created_at, m.firstName, m.lastName
                FROM ResourceRequest r
                LEFT JOIN members m ON r.user_id = m.userid
                ORDER BY r.created_at DESC
            """;

            try (PreparedStatement ps = conn.prepareStatement(fetchSQL);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, String> row = new HashMap<>();
                    String status = rs.getString("status");
                    String normalizedStatus = (status != null ? status.toLowerCase() : "unknown");

                    row.put("requestid", String.valueOf(rs.getInt("requestid")));
                    row.put("title", rs.getString("title"));
                    row.put("author", rs.getString("author"));
                    row.put("type", rs.getString("type"));
                    row.put("justification", rs.getString("justification"));
                    row.put("email", rs.getString("email"));
                    row.put("status", status);
                    row.put("created_at", rs.getString("created_at"));
                    row.put("firstName", rs.getString("firstName"));
                    row.put("lastName", rs.getString("lastName"));

                    requestsList.add(row);

                    totalCount++;
                    switch (normalizedStatus) {
                        case "pending" -> pendingCount++;
                        case "approved" -> approvedCount++;
                        case "rejected" -> rejectedCount++;
                    }
                }
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error fetching requests", e);
            request.setAttribute("error", "Error loading data: " + e.getMessage());
        }

        //  Pass data to JSP
        request.setAttribute("requests", requestsList);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);

        //  Forward to JSP
        request.getRequestDispatcher("updaterequests.jsp").forward(request, response);
    }
}
