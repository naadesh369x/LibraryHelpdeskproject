package com.example.demo.servlets.FAQ;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/EditFAQServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 5,       // 5 MB
        maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class EditFAQServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CORRECTED: Get 'faqid' from the request instead of 'id'
        String faqIdParam = request.getParameter("faqid");
        String question = request.getParameter("question");
        String answer = request.getParameter("answer");

        HttpSession session = request.getSession();

        // Basic validation
        if (faqIdParam == null || faqIdParam.trim().isEmpty() ||
                question == null || question.trim().isEmpty() ||
                answer == null || answer.trim().isEmpty()) {
            session.setAttribute("error", "FAQ ID, question, and answer are required fields.");
            response.sendRedirect("editFAQ.jsp?faqid=" + faqIdParam);
            return;
        }

        int faqId;
        try {
            faqId = Integer.parseInt(faqIdParam);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid FAQ ID format.");
            response.sendRedirect("listFAQAdmin.jsp");
            return;
        }

        // Handle file upload with validation
        String fileName = null;
        try {
            Part filePart = request.getPart("faqImage");
            if (filePart != null && filePart.getSize() > 0) {
                // Validate file type
                String contentType = filePart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    session.setAttribute("error", "Only image files are allowed.");
                    response.sendRedirect("editFAQ.jsp?faqid=" + faqId);
                    return;
                }

                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                filePart.write(uploadPath + File.separator + fileName);
            }
        } catch (Exception e) {
            session.setAttribute("error", "File upload failed: " + e.getMessage());
            response.sendRedirect("editFAQ.jsp?faqid=" + faqId);
            return;
        }

        // Database operations
        try (Connection con = DBConnection.getConnection()) {

            // Check if the 'updated_at' column exists, add it if it doesn't
            try (ResultSet columns = con.getMetaData().getColumns(null, null, "faq", "updated_at")) {
                if (!columns.next()) {
                    try (Statement stmt = con.createStatement()) {
                        stmt.execute("ALTER TABLE faq ADD updated_at DATETIME");
                    }
                }
            }

            // Prepare the UPDATE statement
            String sql;
            if (fileName != null) {
                // If a new image is uploaded, update it
                sql = "UPDATE faq SET question=?, answer=?, image_path=?, updated_at=? WHERE faqid=?";
            } else {
                // Otherwise, only update text and timestamp
                sql = "UPDATE faq SET question=?, answer=?, updated_at=? WHERE faqid=?";
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, question);
                ps.setString(2, answer);

                if (fileName != null) {
                    ps.setString(3, fileName);
                    ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                    ps.setInt(5, faqId);
                } else {
                    ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                    ps.setInt(4, faqId);
                }

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    session.setAttribute("success", "FAQ updated successfully!");
                } else {
                    session.setAttribute("error", "FAQ not found or no changes made.");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
            session.setAttribute("error", "Database error: Failed to update FAQ. " + e.getMessage());
        }

        response.sendRedirect("listFAQAdmin.jsp");
    }
}