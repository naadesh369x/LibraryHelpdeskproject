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

        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("email") : null;

        String id = request.getParameter("id");
        String comment = request.getParameter("comment");
        String ratingStr = request.getParameter("rating");
        int rating = Integer.parseInt(ratingStr);

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE feedbacks SET comment=?, rating=? WHERE id=? AND email=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, comment);
                ps.setInt(2, rating);
                ps.setInt(3, Integer.parseInt(id));
                ps.setString(4, email);
                ps.executeUpdate();
            }
            response.sendRedirect("myfeedbacks.jsp?success=Feedback updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myfeedbacks.jsp?error=Error updating feedback");
        }
    }
}
