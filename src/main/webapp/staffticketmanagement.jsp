<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String successMsg = (String) session.getAttribute("ticketSuccess");
    if (successMsg != null) session.removeAttribute("ticketSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Ticket Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { background-color: #111827; color: #fff; font-family: 'Segoe UI', sans-serif; }
        .btn { border-radius: 8px; }
        .ticket-list, .ticket-details { border-radius: 15px; background: #1f2937; padding: 15px; }
        .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-new { background-color: rgba(59, 130, 246, 0.2); color: #3b82f6; }
        .status-pending { background-color: rgba(245, 158, 11, 0.2); color: #f59e0b; }
        .status-solved { background-color: rgba(16, 185, 129, 0.2); color: #10b981; }
        .reply-form textarea { background: #374151; color: #fff; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center py-3">
        <h2>Staff Ticket Management</h2>
        <div class="d-flex gap-2">
            <a href="staff-dashboard.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Dashboard</a>
            <a href="mainpage.jsp" class="btn btn-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <% if (successMsg != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i> <%= successMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="d-flex gap-3">
        <!-- Ticket List -->
        <div class="ticket-list" style="width: 30%; max-height: 600px; overflow-y: auto;">
            <h5><i class="fas fa-ticket-alt"></i> Assigned Tickets</h5>
            <%
                List<Map<String,String>> tickets = (List<Map<String,String>>) request.getAttribute("tickets");
                if (tickets != null && !tickets.isEmpty()) {
                    for (Map<String,String> ticket : tickets) {
                        String ticketId = ticket.get("ticketId");
                        String ticketStatus = ticket.get("status");
                        boolean isActive = request.getAttribute("ticketId") != null &&
                                request.getAttribute("ticketId").toString().equals(ticketId);
            %>
            <div class="ticket-item p-2 mb-2 rounded <%= isActive ? "bg-secondary" : "bg-dark" %>"
                 onclick="window.location.href='StaffTicketsManageServlet?ticketId=<%= ticketId %>'">
                <div><strong><%= ticket.get("username") %></strong> - <%= ticket.get("email") %></div>
                <div>
                    Category: <%= ticket.get("category") %> |
                    Status: <span class="status-badge status-<%= ticketStatus.toLowerCase() %>"><%= ticketStatus %></span><br>
                    Last Reply: <%= ticket.get("last_reply_by") != null ? ticket.get("last_reply_by") : "None" %>
                </div>
            </div>
            <% }} else { %>
            <div class="text-center py-5 text-muted">
                <i class="fas fa-inbox fa-2x mb-2"></i><br>No tickets assigned.
            </div>
            <% } %>
        </div>

        <!-- Ticket Details -->
        <div class="ticket-details flex-fill">
            <h5><%= request.getAttribute("ticketId") != null ? "Ticket #" + request.getAttribute("ticketId") : "Select a Ticket" %></h5>
            <% if (request.getAttribute("ticketId") != null) {
                String status = (String) request.getAttribute("status");
            %>

            <table class="table table-dark mt-3">
                <tr><th>Category</th><td><%= request.getAttribute("category") %></td></tr>
                <tr><th>Status</th><td><span class="status-badge status-<%= status.toLowerCase() %>"><%= status %></span></td></tr>
                <tr><th>Created At</th><td><%= request.getAttribute("created_at") %></td></tr>
                <tr><th>Username</th><td><%= request.getAttribute("username") %></td></tr>
                <tr><th>Email</th><td><%= request.getAttribute("email") %></td></tr>
                <tr><th>Assigned Staff</th><td><%= request.getAttribute("staff_assigned") %></td></tr>
            </table>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea class="form-control" readonly><%= request.getAttribute("description") %></textarea>
            </div>

            <div>
                <h6>Replies</h6>
                <%
                    List<Map<String,String>> replies = (List<Map<String,String>>) request.getAttribute("replies");
                    if (replies != null && !replies.isEmpty()) {
                        for (Map<String,String> reply : replies) {
                %>
                <div class="p-2 mb-2 bg-secondary rounded">
                    <small class="text-muted"><i class="far fa-clock"></i> <%= reply.get("created_at") %></small><br>
                    <strong><%= reply.get("sender") %>:</strong> <%= reply.get("message") %>
                </div>
                <% }} else { %>
                <div class="text-muted text-center py-3">No replies yet.</div>
                <% } %>
            </div>

            <!-- Reply Form -->
            <div class="reply-form mt-3">
                <form method="post" action="ReplyTicketServlet">
                    <input type="hidden" name="ticketId" value="<%= request.getAttribute("ticketId") %>">
                    <input type="hidden" name="sender" value="<%= session.getAttribute("staffName") %>">
                    <textarea name="message" class="form-control mb-2" placeholder="Type your reply..." required></textarea>
                    <button type="submit" class="btn btn-success"><i class="fas fa-paper-plane"></i> Send Reply</button>
                </form>
            </div>

            <% } else { %>
            <div class="text-center py-5 text-muted">
                <i class="fas fa-mouse-pointer fa-2x mb-2"></i><br>Select a ticket to view details and add replies.
            </div>
            <% } %>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
