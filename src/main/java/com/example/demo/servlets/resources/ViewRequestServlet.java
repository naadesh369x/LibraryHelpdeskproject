package com.example.demo.servlets.resources;

// View

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ViewRequestServlet")
public class ViewRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        if (userEmail == null) {
            response.sendRedirect("login.jsp?error=Please+login+first");
            return;
        }

        List<Map<String, String>> requestList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // Ensure ResourceRequest table has all required columns
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceRequest')
                BEGIN
                    CREATE TABLE ResourceRequest (
                        requestid INT IDENTITY(1,1) PRIMARY KEY,
                        email NVARCHAR(255) NOT NULL,
                        title NVARCHAR(255) NOT NULL,
                        author NVARCHAR(255) NOT NULL,
                        type NVARCHAR(100) NOT NULL,
                        justification NVARCHAR(MAX),
                        status NVARCHAR(50) DEFAULT 'Pending',
                        user_id INT,
                        created_at DATETIME DEFAULT GETDATE(),
                        CONSTRAINT FK_ResourceRequest_User FOREIGN KEY (user_id) REFERENCES members(userid)
                    )
                END
                ELSE
                BEGIN
                    -- Add missing columns if they don't exist
                    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ResourceRequest' AND COLUMN_NAME = 'user_id')
                    BEGIN
                        ALTER TABLE ResourceRequest ADD user_id INT
                        ALTER TABLE ResourceRequest ADD CONSTRAINT FK_ResourceRequest_User FOREIGN KEY (user_id) REFERENCES members(userid)
                    END
                END
            """;
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
            }

            // Query to get resource requests - prioritize by user_id if available, otherwise by email
            String sql;
            if (userId != null) {
                sql = "SELECT * FROM ResourceRequest WHERE user_id=? ORDER BY created_at DESC";
            } else {
                sql = "SELECT * FROM ResourceRequest WHERE email=? ORDER BY created_at DESC";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                if (userId != null) {
                    ps.setInt(1, userId);
                } else {
                    ps.setString(1, userEmail);
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> reqData = new HashMap<>();
                        reqData.put("requestid", String.valueOf(rs.getInt("requestid")));
                        reqData.put("email", rs.getString("email"));
                        reqData.put("title", rs.getString("title"));
                        reqData.put("author", rs.getString("author"));
                        reqData.put("type", rs.getString("type"));
                        reqData.put("justification", rs.getString("justification"));
                        reqData.put("status", rs.getString("status"));
                        reqData.put("created_at", rs.getTimestamp("created_at").toString());
                        requestList.add(reqData);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving resource requests: " + e.getMessage());
        }

        // Pass data to JSP
        request.setAttribute("requestList", requestList);
        request.getRequestDispatcher("viewRequests.jsp").forward(request, response);
    }
}