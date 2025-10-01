package com.example.demo.servlets;



import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {

            // Check if admins table exists
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='admins' AND xtype='U')
                CREATE TABLE admins (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    firstname NVARCHAR(50) NOT NULL,
                    lastname NVARCHAR(50) NOT NULL,
                    email NVARCHAR(100) NOT NULL UNIQUE,
                    username NVARCHAR(50) NOT NULL UNIQUE,
                    password NVARCHAR(255) NOT NULL
                )
                """;
            try (Statement stmt = con.createStatement()) {
                stmt.execute(createTableSQL);
            }

            // Query to check admin credentials
            String sql = "SELECT * FROM admins WHERE username=? AND password=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password); // ⚠️ In production, compare hashed passwords
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Login success: create session
                        HttpSession session = request.getSession();
                        session.setAttribute("adminName", rs.getString("firstname") + " " + rs.getString("lastname"));
                        response.sendRedirect("admin-dashboard"); // Redirect to dashboard
                    } else {
                        // Login failed
                        response.sendRedirect("adminlogin.jsp?error=Invalid+username+or+password");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminlogin.jsp?error=Database+error");
        }
    }
}
