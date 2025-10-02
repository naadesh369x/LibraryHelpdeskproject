package com.example.demo.servlets.FAQ;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.sql.*;

import java.time.LocalDateTime;

@WebServlet("/AddFAQServlet")
@MultipartConfig
public class AddFAQServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String question = request.getParameter("question");
        String answer = request.getParameter("answer");

        Part filePart = request.getPart("faqImage");
        String fileName = null;
//validate
        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
        }

        try (Connection con = DBConnection.getConnection()) {

            //  Create table if it does not exist
            String createTableSQL = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='faq' AND xtype='U') " +
                    "CREATE TABLE faq (" +
                    "id INT IDENTITY(1,1) PRIMARY KEY, " +
                    "question NVARCHAR(MAX), " +
                    "answer NVARCHAR(MAX), " +
                    "image_path NVARCHAR(255), " +
                    "created_at DATETIME" +
                    ")";
            try (Statement stmt = con.createStatement()) {
                stmt.execute(createTableSQL);
            }

            //  Insert FAQ
            String insertSQL = "INSERT INTO faq (question, answer, image_path, created_at) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertSQL)) {
                ps.setString(1, question);
                ps.setString(2, answer);
                ps.setString(3, fileName);
                ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                ps.executeUpdate();
            }

            response.sendRedirect("listFAQAdmin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error adding FAQ: " + e.getMessage());
        }
    }
}
