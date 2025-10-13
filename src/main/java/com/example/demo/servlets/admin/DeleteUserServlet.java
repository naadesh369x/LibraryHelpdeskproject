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

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = request.getParameter("id");
        String userType = request.getParameter("userType");

        if (userId == null || userId.isEmpty() || userType == null || userType.isEmpty()) {
            response.sendRedirect("manage-users?error=InvalidUserIdOrType");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql;

            if ("Member".equalsIgnoreCase(userType)) {
                sql = "DELETE FROM Members WHERE userid = ?"; // updated column name
            } else if ("Staff".equalsIgnoreCase(userType)) {
                sql = "DELETE FROM Staff WHERE staffid = ?"; // updated column name
            } else {
                response.sendRedirect("manage-users?error=InvalidUserType");
                return;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(userId));
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    response.sendRedirect("manage-users?success=UserDeleted");
                } else {
                    response.sendRedirect("manage-users?error=UserNotFound");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-users?error=ServerError");
        }
    }
}
