package com.example.demo.servlets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/StaffLoginServlet")
public class StaffLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            response.sendRedirect("stafflogin.jsp?error=Please+enter+email+and+password");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            if (conn == null) {
                response.sendRedirect("staffLogin.jsp?error=Database+connection+failed");
                return;
            }

            // Query to check staff credentials
            String sql = "SELECT * FROM Staff WHERE email=? AND password=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Login successful, create session
                        HttpSession session = request.getSession();
                        session.setAttribute("staffName", rs.getString("firstName") + " " + rs.getString("lastName"));
                        session.setAttribute("staffEmail", rs.getString("email"));
                        session.setAttribute("staffRole", rs.getString("role"));

                        response.sendRedirect("staffdashboard.jsp");
                    } else {
                        // Login failed
                        response.sendRedirect("stafflogin.jsp?error=Invalid+email+or+password");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("stafflogin.jsp?error=Database+error");
        }
    }
}
