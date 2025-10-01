package com.example.demo.servlets.resources;

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

        if (userEmail == null) {
            response.sendRedirect("login.jsp?error=Please+login+first");
            return;
        }

        List<Map<String, String>> requestList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // Ensure ResourceRequest table has all required columns
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ResourceRequest' AND xtype='U')
                CREATE TABLE ResourceRequest (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    email VARCHAR(150) NOT NULL,
                    title VARCHAR(255) NOT NULL,
                    author VARCHAR(255) NOT NULL,
                    type VARCHAR(100) NOT NULL,
                    justification NVARCHAR(MAX),
                    status VARCHAR(50) DEFAULT 'Pending',
                    created_at DATETIME DEFAULT GETDATE()
                )
            """;
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
            }

            //  Fetch only current user’s requests
            String sql = "SELECT * FROM ResourceRequest WHERE email=? ORDER BY created_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, userEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> reqData = new HashMap<>();
                        reqData.put("id", String.valueOf(rs.getInt("id")));
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
        }

        //  Pass data to JSP
        request.setAttribute("requestList", requestList);
        request.getRequestDispatcher("viewRequests.jsp").forward(request, response);
    }
}
