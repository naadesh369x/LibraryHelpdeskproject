package com.example.demo.designpatterns.loginstrategy;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminLoginStrategy implements LoginStrategy {
    @Override
    public void login(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {



            String sql = "SELECT * FROM admins WHERE username=? AND password=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Login success: create session
                        HttpSession session = request.getSession();
                        session.setAttribute("adminName", rs.getString("firstname") + " " + rs.getString("lastname"));
                        response.sendRedirect("admin-dashboard");
                    } else {

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