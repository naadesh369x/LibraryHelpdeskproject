package com.example.demo.servlets;


import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AdminRegisterServlet")
public class AdminRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        //  Validate password match
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("adminRegister.jsp?error=Passwords+do+not+match");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            // Create admins table if it does not exist (SQL Server syntax)
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

            //  Insert admin
            String insertSQL = "INSERT INTO admins (firstname, lastname, email, username, password) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertSQL)) {
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, email);
                ps.setString(4, username);
                ps.setString(5, password);

                ps.executeUpdate();
            }

            // Redirect to login page on success
            response.sendRedirect("adminlogin.jsp?success=Admin+registered+successfully");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminRegister.jsp?error=Email+or+username+already+exists");
        }
    }
}
