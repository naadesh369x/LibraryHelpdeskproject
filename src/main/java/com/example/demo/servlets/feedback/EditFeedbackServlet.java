package com.example.demo.servlets.feedback;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/EditFeedbackServlet")
public class EditFeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //  Get current logged-in user's email from session
        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("email") : null;


        String feedbackIdStr = request.getParameter("feedbackid");
        String comment = request.getParameter("comment");
        String ratingStr = request.getParameter("rating");

        if (feedbackIdStr == null || email == null) {
            response.sendRedirect("myfeedbacks.jsp?error=Invalid session or feedback ID.");
            return;
        }

        int feedbackId = Integer.parseInt(feedbackIdStr);
        int rating = (ratingStr != null && !ratingStr.isEmpty()) ? Integer.parseInt(ratingStr) : 0;

        try (Connection conn = DBConnection.getConnection()) {


            String sql = """
                UPDATE feedbacks
                SET comment = ?, rating = ?
                WHERE feedbackid = ? AND email = ?
            """;

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, comment);
                ps.setInt(2, rating);
                ps.setInt(3, feedbackId);
                ps.setString(4, email);

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect("myfeedbacks.jsp?success=Feedback updated successfully!");
                } else {
                    response.sendRedirect("myfeedbacks.jsp?error=No feedback found or unauthorized update.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myfeedbacks.jsp?error=Error updating feedback: " + e.getMessage());
        }
    }
}
