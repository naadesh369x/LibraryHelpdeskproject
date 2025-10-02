package com.example.demo.servlets.admin;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;

@WebServlet("/AddStaffServlet")
public class AddStaffServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String role = request.getParameter("role");
        String phoneNumber = request.getParameter("phoneNumber");
        String hometown = request.getParameter("hometown");

        // Validate  fields
        if (firstName == null || lastName == null || email == null || password == null || ageStr == null ||
                gender == null || role == null || phoneNumber == null || hometown == null ||
                firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || password.isEmpty() || ageStr.isEmpty()) {
            request.setAttribute("message", " Please fill in all required fields!");
            request.getRequestDispatcher("staff-success.jsp").forward(request, response);
            return;
        }

        int age = 0;
        try {
            age = Integer.parseInt(ageStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", " Age must be a valid number!");
            request.getRequestDispatcher("staff-success.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                request.setAttribute("message", "Database connection failed!");
                request.getRequestDispatcher("staff-success.jsp").forward(request, response);
                return;
            }

            //  Create Staff table if it doesn't exist
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Staff' AND xtype='U')
                CREATE TABLE Staff (
                    id INT IDENTITY(1,2) PRIMARY KEY, -- Start at 1, increment by 2
                    firstName NVARCHAR(50),
                    lastName NVARCHAR(50),
                    email NVARCHAR(100),
                    password NVARCHAR(255), 
                    age INT,
                    gender NVARCHAR(10),
                    role NVARCHAR(50),
                    phoneNumber NVARCHAR(20),
                    hometown NVARCHAR(50)
                )
                """;

            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
            }

            //  Insert new staff
            String insertSQL = "INSERT INTO Staff (firstName, lastName, email, password, age, gender, role, phoneNumber, hometown) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, email);
                ps.setString(4, password);
                ps.setInt(5, age);
                ps.setString(6, gender);
                ps.setString(7, role);
                ps.setString(8, phoneNumber);
                ps.setString(9, hometown);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    request.setAttribute("message", " Staff added successfully!");
                } else {
                    request.setAttribute("message", "⚠ Failed to add staff.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", " Database error: " + e.getMessage());
        }

        // Forward to page
        RequestDispatcher dispatcher = request.getRequestDispatcher("staff-success.jsp");
        dispatcher.forward(request, response);
    }
}
