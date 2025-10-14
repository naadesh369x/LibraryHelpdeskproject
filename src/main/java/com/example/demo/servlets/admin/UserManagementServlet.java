package com.example.demo.servlets.admin;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/manage-users")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> users = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            if (conn == null) {
                request.setAttribute("error", "⚠ Database connection failed!");
            } else {

                // Fetch all Staff
                String staffSQL = "SELECT staffid, firstName, lastName, email, role, age, gender, phoneNumber, hometown FROM Staff";
                try (PreparedStatement ps = conn.prepareStatement(staffSQL);
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        Map<String, String> user = new HashMap<>();
                        user.put("staffid", String.valueOf(rs.getInt("staffid")));
                        user.put("firstName", rs.getString("firstName"));
                        user.put("lastName", rs.getString("lastName"));
                        user.put("email", rs.getString("email"));
                        user.put("role", rs.getString("role"));
                        user.put("age", String.valueOf(rs.getInt("age")));
                        user.put("gender", rs.getString("gender"));
                        user.put("phoneNumber", rs.getString("phoneNumber"));
                        user.put("hometown", rs.getString("hometown"));
                        user.put("userType", "Staff");
                        users.add(user);
                    }
                }

                // Fetch all Members
                String memberSQL = "SELECT userid, firstName, lastName, email, role, age, gender, phoneNumber, hometown FROM Members";
                try (PreparedStatement ps = conn.prepareStatement(memberSQL);
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        Map<String, String> user = new HashMap<>();
                        user.put("userid", String.valueOf(rs.getInt("userid")));
                        user.put("firstName", rs.getString("firstName"));
                        user.put("lastName", rs.getString("lastName"));
                        user.put("email", rs.getString("email"));
                        user.put("role", rs.getString("role"));
                        user.put("age", String.valueOf(rs.getInt("age")));
                        user.put("gender", rs.getString("gender"));
                        user.put("phoneNumber", rs.getString("phoneNumber"));
                        user.put("hometown", rs.getString("hometown"));
                        user.put("userType", "Member");
                        users.add(user);
                    }
                }


            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠ Database error: " + e.getMessage());
        }

        // Send the combined list to JSP
        request.setAttribute("users", users);
        RequestDispatcher dispatcher = request.getRequestDispatcher("usermanagement.jsp");
        dispatcher.forward(request, response);
    }
}
