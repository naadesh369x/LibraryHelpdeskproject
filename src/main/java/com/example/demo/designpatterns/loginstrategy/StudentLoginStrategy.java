package com.example.demo.designpatterns.loginstrategy;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StudentLoginStrategy implements LoginStrategy {
    @Override
    public void login(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");


        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM members WHERE email = ? AND password = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, email);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {

                        HttpSession session = request.getSession();


                        session.setAttribute("role", "Student");


                        session.setAttribute("userId", rs.getInt("userid"));
                        session.setAttribute("firstName", rs.getString("firstname"));
                        session.setAttribute("email", rs.getString("email"));


                        response.sendRedirect("dashboard.jsp?success=Login+successful");
                    } else {

                        response.sendRedirect("login.jsp?error=Invalid+email+or+password");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database+error");
        }
    }
}