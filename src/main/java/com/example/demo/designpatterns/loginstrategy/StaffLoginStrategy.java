package com.example.demo.designpatterns.loginstrategy;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StaffLoginStrategy implements LoginStrategy {
    @Override
    public void login(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM Staff WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("role", "Staff");
                session.setAttribute("email", email);
                response.sendRedirect("staff-dashboard");
            } else {
                response.sendRedirect("loginmulti.jsp?error=Invalid Staff Credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("loginmulti.jsp?error=Database Error");
        }
    }
}
