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


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = request.getParameter("id");
        String userType = request.getParameter("userType");
        Map<String, String> user = null;

        try (Connection conn = DBConnection.getConnection()) {
            String sql;

            if ("Member".equalsIgnoreCase(userType)) {

                sql = "SELECT userid, firstName, lastName, email, role, phoneNumber, password FROM Members WHERE userid = ?";
            } else { // Staff

                sql = "SELECT staffid, firstName, lastName, email, role, phoneNumber, password FROM Staff WHERE staffid = ?";
                userType = "Staff";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(userId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user = new HashMap<>();

                        if ("Staff".equalsIgnoreCase(userType)) {

                            user.put("staffid", String.valueOf(rs.getInt("staffid")));
                        } else {

                            user.put("userid", String.valueOf(rs.getInt("userid")));
                        }
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


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userType = request.getParameter("userType");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String newPassword = request.getParameter("password");


        String idParam = ("Staff".equalsIgnoreCase(userType)) ? request.getParameter("staffid") : request.getParameter("userid");

        try (Connection conn = DBConnection.getConnection()) {
            String sql;
            boolean updatePassword = newPassword != null && !newPassword.trim().isEmpty();


            if ("Member".equalsIgnoreCase(userType)) {

                sql = updatePassword ?
                        "UPDATE Members SET firstName=?, lastName=?, phoneNumber=?, password=? WHERE userid=?" :
                        "UPDATE Members SET firstName=?, lastName=?, phoneNumber=? WHERE userid=?";
            } else { // Staff

                sql = updatePassword ?
                        "UPDATE Staff SET firstName=?, lastName=?, phoneNumber=?, password=? WHERE staffid=?" :
                        "UPDATE Staff SET firstName=?, lastName=?, phoneNumber=? WHERE staffid=?";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, phone);

                if (updatePassword) {
                    ps.setString(4, newPassword);
                    ps.setInt(5, Integer.parseInt(idParam));
                } else {
                    ps.setInt(4, Integer.parseInt(idParam));
                }

                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating user: " + e.getMessage());

            request.getRequestDispatcher("editusers.jsp").forward(request, response);
            return;
        }

        // redirect back to the user management page
        response.sendRedirect("manage-users?success=UserUpdated");
    }
}