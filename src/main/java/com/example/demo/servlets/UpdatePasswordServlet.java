package com.example.demo.servlets;


import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = (String) request.getSession().getAttribute("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        try (Connection conn = DBConnection.getConnection()) {
            // First verify the current password
            String verifySql = "SELECT password FROM members WHERE email=?";
            try (PreparedStatement verifyPs = conn.prepareStatement(verifySql)) {
                verifyPs.setString(1, email);
                try (ResultSet rs = verifyPs.executeQuery()) {
                    if (rs.next()) {
                        String storedPassword = rs.getString("password");

                        // Check if current password matches (in a real app, you'd use proper password hashing)
                        if (storedPassword.equals(currentPassword)) {
                            // Update the password
                            String updateSql = "UPDATE members SET password=? WHERE email=?";
                            try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                                updatePs.setString(1, newPassword);
                                updatePs.setString(2, email);
                                updatePs.executeUpdate();
                            }
                            response.sendRedirect("profile.jsp?success=password");
                        } else {
                            // Current password doesn't match
                            response.sendRedirect("profile.jsp?error=currentPassword");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=password");
        }
    }
}