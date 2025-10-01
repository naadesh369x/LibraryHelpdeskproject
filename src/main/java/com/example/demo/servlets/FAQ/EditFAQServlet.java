package com.example.demo.servlets.FAQ;


import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/EditFAQServlet")
@MultipartConfig
public class EditFAQServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String question = request.getParameter("question");
        String answer = request.getParameter("answer");

        Part filePart = request.getPart("faqImage");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
        }

        try (Connection con = DBConnection.getConnection()) {
            String sql;
            if (fileName != null) {
                sql = "UPDATE faq SET question=?, answer=?, image_path=?, created_at=? WHERE id=?";
            } else {
                sql = "UPDATE faq SET question=?, answer=?, created_at=? WHERE id=?";
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, question);
            ps.setString(2, answer);
            if (fileName != null) {
                ps.setString(3, fileName);
                ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                ps.setInt(5, id);
            } else {
                ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                ps.setInt(4, id);
            }
            ps.executeUpdate();
            response.sendRedirect("listFAQAdmin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error editing FAQ: " + e.getMessage());
        }
    }
}
