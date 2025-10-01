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

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phoneNumber");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE members SET firstName=?, lastName=?, phoneNumber=?, password=? WHERE email=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, phone);
                ps.setString(4, password);
                ps.setString(5, email);
                ps.executeUpdate();
            }
            response.sendRedirect("profile.jsp?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=1");
        }
    }
}
