package com.example.demo.servlets.resources;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/ApproveRejectServlet")
public class ApproveRejectServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestIdStr = request.getParameter("requestid");
        String action = request.getParameter("action");
        String newStatus = null;

        // Determine new status
        if ("approve".equalsIgnoreCase(action)) {
            newStatus = "Approved";
        } else if ("reject".equalsIgnoreCase(action)) {
            newStatus = "Rejected";
        } else if ("pending".equalsIgnoreCase(action)) {
            newStatus = "Pending";
        }

        // Update the request status if parameters are valid
        if (requestIdStr != null && newStatus != null) {
            try (Connection conn = DBConnection.getConnection()) {
                String updateSQL = "UPDATE ResourceRequest SET status=? WHERE requestid=?";
                try (PreparedStatement ps = conn.prepareStatement(updateSQL)) {
                    ps.setString(1, newStatus);
                    ps.setInt(2, Integer.parseInt(requestIdStr));
                    ps.executeUpdate();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("AdminRequestsServlet");
    }
}