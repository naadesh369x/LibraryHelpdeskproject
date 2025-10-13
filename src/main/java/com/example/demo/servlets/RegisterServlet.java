package com.example.demo.servlets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String ageStr = request.getParameter("age");
        String phoneNumber = request.getParameter("phoneNumber");
        String hometown = request.getParameter("hometown");
        String gender = request.getParameter("gender");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = "Member";

        // Check password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("message", "⚠ Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        //  Validate age
        int age;
        try {
            age = Integer.parseInt(ageStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "⚠ Invalid age!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                request.setAttribute("message", "⚠ Database connection failed!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Create Members table if it does not exist (ID increments by 2)
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Members' AND xtype='U')
                CREATE TABLE Members (
                    userid INT IDENTITY(2,2) PRIMARY KEY,  -- start at 2, increment by 2
                    firstName NVARCHAR(50) NOT NULL,
                    lastName NVARCHAR(50) NOT NULL,
                    email NVARCHAR(100) NOT NULL UNIQUE,
                    password NVARCHAR(255) NOT NULL,
                    age INT NOT NULL,
                    gender NVARCHAR(10),
                    role NVARCHAR(50),
                    phoneNumber NVARCHAR(20),
                    hometown NVARCHAR(50)
                )
                """;

            try (Statement stmt = con.createStatement()) {
                stmt.execute(createTableSQL);
            }

            //  Insert new member
            String insertSQL = "INSERT INTO Members (firstName, lastName, email, password, age, gender, role, phoneNumber, hometown) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(insertSQL)) {
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, email);
                ps.setString(4, password);
                ps.setInt(5, age);
                ps.setString(6, gender);
                ps.setString(7, role);
                ps.setString(8, phoneNumber);
                ps.setString(9, hometown);

                ps.executeUpdate();
            }


            request.setAttribute("message", " Registration successful!");
            request.getRequestDispatcher("mainpage.jsp").forward(request, response);

        } catch (SQLIntegrityConstraintViolationException e) {
            // Email already exists
            request.setAttribute("message", "Email already exists!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", " Registration failed!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
