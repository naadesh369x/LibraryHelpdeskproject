package com.example.demo.servlets.admin;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DatabaseMetaData;
import java.util.HashMap;
import java.util.Map;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/EditReplyServlet")
public class EditReplyServlet extends HttpServlet {

    // Load reply with ticket
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String replyId = request.getParameter("id");
        Map<String, String> reply = null;
        Map<String, String> ticket = null;

        if (replyId == null || replyId.isEmpty()) {
            request.setAttribute("error", "Reply ID is missing");
            request.getRequestDispatcher("adminAllReplies.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // Check table structure
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet ticketsColumns = metaData.getColumns(null, null, "tickets", null);
            Set<String> ticketColumnNames = new HashSet<>();
            while (ticketsColumns.next()) {
                ticketColumnNames.add(ticketsColumns.getString("COLUMN_NAME").toLowerCase());
            }
            ticketsColumns.close();

            ResultSet repliesColumns = metaData.getColumns(null, null, "ticket_replies", null);
            Set<String> replyColumnNames = new HashSet<>();
            while (repliesColumns.next()) {
                replyColumnNames.add(repliesColumns.getString("COLUMN_NAME").toLowerCase());
            }
            repliesColumns.close();

            // Determine the correct column names based on what exists in the database
            String ticketIdColumn = ticketColumnNames.contains("ticketid") ? "ticketId" :
                    (ticketColumnNames.contains("id") ? "id" : "ticket_id");
            String replyIdColumn = replyColumnNames.contains("id") ? "id" : "reply_id";
            String replyTicketIdColumn = replyColumnNames.contains("ticket_id") ? "ticket_id" :
                    (replyColumnNames.contains("ticketid") ? "ticketId" : "id");

            // Get reply details
            String replySql = "SELECT " + replyIdColumn + " AS id, " + replyTicketIdColumn + " AS ticket_id, " +
                    "sender, message, created_at, updated_at FROM ticket_replies WHERE " + replyIdColumn + " = ?";

            try (PreparedStatement ps = conn.prepareStatement(replySql)) {
                ps.setInt(1, Integer.parseInt(replyId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        reply = new HashMap<>();
                        reply.put("id", String.valueOf(rs.getInt("id")));
                        reply.put("ticket_id", String.valueOf(rs.getInt("ticket_id")));
                        reply.put("sender", rs.getString("sender"));
                        reply.put("message", rs.getString("message"));
                        reply.put("created_at", rs.getString("created_at"));

                        // Check if updated_at exists
                        if (replyColumnNames.contains("updated_at")) {
                            String updatedAt = rs.getString("updated_at");
                            if (updatedAt != null) {
                                reply.put("updated_at", updatedAt);
                            }
                        }
                    }
                }
            }

            // Get ticket details for this reply
            if (reply != null) {
                String ticketSql = "SELECT " + ticketIdColumn + " AS id, username, email, category, " +
                        "description, status, created_at FROM tickets WHERE " + ticketIdColumn + " = ?";

                try (PreparedStatement ps = conn.prepareStatement(ticketSql)) {
                    ps.setInt(1, Integer.parseInt(reply.get("ticket_id")));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            ticket = new HashMap<>();
                            ticket.put("id", String.valueOf(rs.getInt("id")));
                            ticket.put("username", rs.getString("username"));
                            ticket.put("email", rs.getString("email"));
                            ticket.put("category", rs.getString("category"));
                            ticket.put("description", rs.getString("description"));
                            ticket.put("status", rs.getString("status"));
                            ticket.put("created_at", rs.getString("created_at"));
                        }
                    }
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid reply ID format");
            request.getRequestDispatcher("adminAllReplies.jsp").forward(request, response);
            return;
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("adminAllReplies.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading reply: " + e.getMessage());
            request.getRequestDispatcher("adminAllReplies.jsp").forward(request, response);
            return;
        }

        request.setAttribute("reply", reply);
        request.setAttribute("ticket", ticket);
        request.getRequestDispatcher("editReply.jsp").forward(request, response);
    }

    // Update reply message
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String message = request.getParameter("replyText");

        if (id == null || message == null || message.trim().isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Missing required data");
            response.sendRedirect("ViewAllRepliesServlet");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // Check if updated_at column exists
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet columns = metaData.getColumns(null, null, "ticket_replies", "updated_at");
            boolean hasUpdatedAt = columns.next();
            columns.close();


            String sql;
            if (hasUpdatedAt) {
                sql = "UPDATE ticket_replies SET message = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
            } else {
                sql = "UPDATE ticket_replies SET message = ? WHERE id = ?";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, message);
                ps.setInt(2, Integer.parseInt(id));

                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated == 0) {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", "Reply not found or update failed");
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Reply updated successfully");
                }
            }
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid reply ID format");
        } catch (SQLException e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Error updating reply: " + e.getMessage());
        }

        // Redirect back to replies management page
        response.sendRedirect("ViewAllRepliesServlet");
    }
}