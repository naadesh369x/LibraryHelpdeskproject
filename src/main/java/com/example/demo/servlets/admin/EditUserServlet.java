package com.example.demo.servlets.admin;

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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {

    // Load user data
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = request.getParameter("id");
        String userType = request.getParameter("userType"); // "Staff" or "Member"
        Map<String, String> user = null;

        try (Connection conn = DBConnection.getConnection()) {
            String sql;
            if ("Member".equalsIgnoreCase(userType)) {
                sql = "SELECT id, firstName, lastName, email, role, phoneNumber, password FROM Members WHERE id = ?";
            } else {
                sql = "SELECT id, firstName, lastName, email, role, phoneNumber, password FROM Staff WHERE id = ?";
                userType = "Staff";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(userId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user = new HashMap<>();
                        user.put("id", String.valueOf(rs.getInt("id")));
                        user.put("firstName", rs.getString("firstName"));
                        user.put("lastName", rs.getString("lastName"));
                        user.put("email", rs.getString("email"));
                        user.put("role", rs.getString("role"));
                        user.put("phone", rs.getString("phoneNumber"));
                        user.put("password", rs.getString("password"));
                        user.put("userType", userType);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading user: " + e.getMessage());
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("editusers.jsp").forward(request, response);
    }

    // Update user data
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String userType = request.getParameter("userType");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String newPassword = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String sql;
            boolean updatePassword = newPassword != null && !newPassword.trim().isEmpty();

            if ("Member".equalsIgnoreCase(userType)) {
                sql = updatePassword ?
                        "UPDATE Members SET firstName=?, lastName=?, phoneNumber=?, password=? WHERE id=?" :
                        "UPDATE Members SET firstName=?, lastName=?, phoneNumber=? WHERE id=?";
            } else {
                sql = updatePassword ?
                        "UPDATE Staff SET firstName=?, lastName=?, phoneNumber=?, password=? WHERE id=?" :
                        "UPDATE Staff SET firstName=?, lastName=?, phoneNumber=? WHERE id=?";
                userType = "Staff";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, phone);

                if (updatePassword) {
                    ps.setString(4, newPassword);
                    ps.setInt(5, Integer.parseInt(id));
                } else {
                    ps.setInt(4, Integer.parseInt(id));
                }

                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating user: " + e.getMessage());
            request.getRequestDispatcher("editusers.jsp").forward(request, response);
            return;
        }

        // Redirect back to management page
        response.sendRedirect("manage-users?success=UserUpdated");
    }
}
