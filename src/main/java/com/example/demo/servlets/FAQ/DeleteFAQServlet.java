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

       
        int faqId = Integer.parseInt(request.getParameter("faqid"));

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM faq WHERE faqid=?")) {

            ps.setInt(1, faqId);
            ps.executeUpdate();

            // Set success message
            request.getSession().setAttribute("success", "FAQ deleted successfully!");
            response.sendRedirect("listFAQAdmin.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // Set error message
            request.getSession().setAttribute("error", "Error deleting FAQ: " + e.getMessage());
            response.sendRedirect("listFAQAdmin.jsp");
        }
    }
}