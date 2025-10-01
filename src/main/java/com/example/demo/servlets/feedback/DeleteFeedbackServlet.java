package com.example.demo.servlets.feedback;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/DeleteFeedbackServlet")
public class DeleteFeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("email") : null;

        if (email == null) {
            response.sendRedirect("login.jsp?error=Please+login+first");
            return;
        }

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try (Connection conn = DBConnection.getConnection()) {
                // Delete only feedback for the current logged-in user
                String sql = "DELETE FROM feedbacks WHERE id = ? AND email = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, Integer.parseInt(idStr));
                    ps.setString(2, email);
                    int rowsDeleted = ps.executeUpdate();

                    if (rowsDeleted == 0) {
                        // No row deleted: either wrong id or not your feedback
                        System.out.println("No feedback deleted. Either invalid ID or not your feedback.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Redirect back to the feedback list
        response.sendRedirect("myfeedbacks.jsp?message=Feedback+deleted");
    }
}
