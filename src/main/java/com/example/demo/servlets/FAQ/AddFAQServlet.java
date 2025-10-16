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

@WebServlet("/AddFAQServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5 MB max file size
public class AddFAQServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String question = request.getParameter("question");
        String answer = request.getParameter("answer");

        // Basic validation
        if (question == null || question.trim().isEmpty() || answer == null || answer.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Question and answer are required fields.");
            response.sendRedirect("addFAQ.jsp");
            return;
        }


        Integer adminId = 1;

        // Handle file upload with validation
        String fileName = null;
        try {
            Part filePart = request.getPart("faqImage");
            if (filePart != null && filePart.getSize() > 0) {
                // Validate file type
                String contentType = filePart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    request.getSession().setAttribute("error", "Only image files are allowed.");
                    response.sendRedirect("addFAQ.jsp");
                    return;
                }

                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                filePart.write(uploadPath + File.separator + fileName);
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "File upload failed: " + e.getMessage());
            response.sendRedirect("addFAQ.jsp");
            return;
        }

        // Database operations to insert FAQ
        try (Connection con = DBConnection.getConnection()) {

            // --- Check if table exists, create if it doesn't ---
            ResultSet tables = con.getMetaData().getTables(null, null, "faq", new String[]{"TABLE"});
            if (!tables.next()) {
                // Table does not exist, create it
                try (Statement stmt = con.createStatement()) {
                    String createTableSQL = "CREATE TABLE faq (" +
                            "faqid INT IDENTITY(1,1) PRIMARY KEY, " +
                            "question NVARCHAR(MAX), " +
                            "answer NVARCHAR(MAX), " +
                            "image_path NVARCHAR(255), " +
                            "created_at DATETIME, " +
                            "adminid INT" +
                            ")";
                    stmt.execute(createTableSQL);
                }
            } else {
                // Table exists, check if adminid column exists
                ResultSet columns = con.getMetaData().getColumns(null, null, "faq", "adminid");
                if (!columns.next()) {
                    // Column doesn't exist, add it
                    try (Statement stmt = con.createStatement()) {
                        stmt.execute("ALTER TABLE faq ADD adminid INT");
                    }
                }
            }
            // --- End of table creation ---

            // Insert FAQ into database
            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO faq (question, answer, image_path, created_at, adminid) VALUES (?, ?, ?, ?, ?)")) {

                ps.setString(1, question);
                ps.setString(2, answer);
                ps.setString(3, fileName);
                ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                ps.setInt(5, adminId); // Use the hardcoded adminId (1)

                ps.executeUpdate();

                request.getSession().setAttribute("success", "FAQ added successfully!");
                response.sendRedirect("listFAQAdmin.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace(); // For debugging
            request.getSession().setAttribute("error", "Database error: Failed to add FAQ. " + e.getMessage());
            response.sendRedirect("addFAQ.jsp");
        }
    }
}