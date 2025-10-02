package com.example.demo.servlets.admin;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteReplyServlet")
public class DeleteReplyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String replyId = request.getParameter("id");

      //validate reply id
        if (replyId == null || replyId.isEmpty()) {
            request.setAttribute("errorMessage", "Invalid reply ID.");
            request.getRequestDispatcher("/nonexistentvv.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String deleteSql = "DELETE FROM ticket_replies WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, Integer.parseInt(replyId));
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {

                    request.setAttribute("errorMessage", "Deleted successfully, but showing 404 test.");
                    request.getRequestDispatcher("ViewAllRepliesServlet").forward(request, response);
                } else {

                    request.setAttribute("errorMessage", "Reply not found.");
                    request.getRequestDispatcher("/nonexistent2.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("errorMessage", "Error deleting reply: " + e.getMessage());
            request.getRequestDispatcher("/nonexistent3.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
