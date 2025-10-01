package com.example.demo.servlets.users;



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

@WebServlet("/DeleteProfileServlet")
public class DeleteProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM members WHERE email=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                ps.executeUpdate();
            }

            // End  after deleting profile
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            response.sendRedirect("mainpage.jsp?deleted=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=delete");
        }
    }
}
