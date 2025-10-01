<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.example.demo.utils.DBConnection" %>
<%
    String replyId = request.getParameter("id");
    if(replyId == null || replyId.isEmpty()){
        response.sendRedirect("manageReplies.jsp?error=Missing+reply+ID");
        return;
    }

    // Variables to hold reply and ticket details
    String currentReply = "";
    String ticketId = "";
    String ticketCategory = "";
    String ticketDescription = "";
    String ticketStatus = "";
    String ticketEmail = "";
    String sender = "";

    try(Connection conn = DBConnection.getConnection()){
        // Fetch reply details along with ticket info
        String sql = "SELECT r.id as replyId, r.message, r.sender, t.id as ticketId, t.category, t.description, t.status, t.email " +
                "FROM tickets_replies r " +
                "JOIN tickets t ON r.ticket_id = t.id " +
                "WHERE r.id = ?";
        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, Integer.parseInt(replyId));
            try(ResultSet rs = ps.executeQuery()){
                if(rs.next()){
                    currentReply = rs.getString("message");
                    sender = rs.getString("sender");
                    ticketId = String.valueOf(rs.getInt("ticketId"));
                    ticketCategory = rs.getString("category");
                    ticketDescription = rs.getString("description");
                    ticketStatus = rs.getString("status");
                    ticketEmail = rs.getString("email");
                } else {
                    response.sendRedirect("manageReplies.jsp?error=Reply+not+found");
                    return;
                }
            }
        }
    } catch(Exception e){ e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Reply</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family:'Segoe UI', sans-serif; background:#f4f6f9; padding-top:40px; }
        .container { max-width:700px; background:#fff; padding:20px; border-radius:10px; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        textarea { resize:none; }
        .form-label { font-weight:600; }
    </style>
</head>
<body>
<div class="container">
    <h3>Edit Reply</h3>
    <form method="post" action="EditReplyServlet">
        <input type="hidden" name="id" value="<%= replyId %>">

        <!-- Ticket Info (read-only) -->
        <div class="mb-3">
            <label class="form-label">Ticket ID</label>
            <input type="text" class="form-control" value="<%= ticketId %>" readonly>
        </div>
        <div class="mb-3">
            <label class="form-label">Ticket Category</label>
            <input type="text" class="form-control" value="<%= ticketCategory %>" readonly>
        </div>
        <div class="mb-3">
            <label class="form-label">Ticket Description</label>
            <textarea class="form-control" rows="4" readonly><%= ticketDescription %></textarea>
        </div>
        <div class="mb-3">
            <label class="form-label">Ticket Status</label>
            <input type="text" class="form-control" value="<%= ticketStatus %>" readonly>
        </div>
        <div class="mb-3">
            <label class="form-label">Ticket Email</label>
            <input type="text" class="form-control" value="<%= ticketEmail %>" readonly>
        </div>

        <!-- Reply Info -->
        <div class="mb-3">
            <label class="form-label">Sender</label>
            <input type="text" class="form-control" value="<%= sender %>" readonly>
        </div>
        <div class="mb-3">
            <label class="form-label">Reply Message</label>
            <textarea name="replyText" class="form-control" rows="6" required><%= currentReply %></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Update Reply</button>
        <a href="manageReplies.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>
