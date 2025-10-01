package com.example.demo.servlets.admin;



import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/AdminRequestsServlet")
public class AdminRequestsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> requestsList = new ArrayList<>();
        int totalCount = 0, pendingCount = 0, approvedCount = 0, rejectedCount = 0;

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            

            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ResourceRequest' AND xtype='U')
                CREATE TABLE ResourceRequest (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    title NVARCHAR(255) NOT NULL,
                    author NVARCHAR(255),
                    type NVARCHAR(100),
                    justification NVARCHAR(MAX),
                    status NVARCHAR(50) DEFAULT 'Pending',
                    created_at DATETIME DEFAULT GETDATE()
                )
            """;
            stmt.executeUpdate(createTableSQL);


            String countQuery = "SELECT status, COUNT(*) as cnt FROM ResourceRequest GROUP BY status";
            try (PreparedStatement ps = conn.prepareStatement(countQuery);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int cnt = rs.getInt("cnt");
                    switch (status.toLowerCase()) {
                        case "pending" -> pendingCount = cnt;
                        case "approved" -> approvedCount = cnt;
                        case "rejected" -> rejectedCount = cnt;
                    }
                    totalCount += cnt;
                }
            }


            String fetchSQL = "SELECT id, title, author, type, justification, status FROM ResourceRequest ORDER BY created_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(fetchSQL);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> row = new HashMap<>();
                    row.put("id", String.valueOf(rs.getInt("id")));
                    row.put("title", rs.getString("title"));
                    row.put("author", rs.getString("author"));
                    row.put("type", rs.getString("type"));
                    row.put("justification", rs.getString("justification"));
                    row.put("status", rs.getString("status"));
                    requestsList.add(row);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }


        request.setAttribute("requests", requestsList);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);

        // Forward to JSP
        request.getRequestDispatcher("managerequests.jsp").forward(request, response);
    }
}
