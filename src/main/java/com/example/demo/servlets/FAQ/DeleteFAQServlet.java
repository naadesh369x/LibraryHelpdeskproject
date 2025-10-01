package com.example.demo.servlets.FAQ;


import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/DeleteFAQServlet")
public class DeleteFAQServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM faq WHERE id=?")) {

            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("listFAQAdmin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error deleting FAQ: " + e.getMessage());
        }
    }
}
