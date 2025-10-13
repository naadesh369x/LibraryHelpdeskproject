<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%
    // Get success message from session
    String successMsg = (String) session.getAttribute("ticketSuccess");
    if(successMsg != null) {
        session.removeAttribute("ticketSuccess");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Tickets - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #6366f1;
            --secondary-color: #6b7280;
            --success-color: #10b981;
            --info-color: #3b82f6;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --light-color: #1f2937;
            --dark-color: #f3f4f6;
            --darker-color: #111827;
            --white: #ffffff;
            --gray-light: #374151;
            --gray-medium: #4b5563;
            --gray-dark: #9ca3af;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background-color: var(--darker-color);
            color: var(--white);
            position: relative;
            display: flex;
        }

        .container-fluid {
            position: relative;
            z-index: 1;
            width: 100%;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .header-section {
            background: var(--light-color);
            padding: 15px 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 5;
        }

        .header-section h2 {
            margin: 0;
            font-size: 24px;
            color: var(--white);
        }

        .header-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 8px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), #4f46e5);
            color: var(--white);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #4f46e5, #6366f1);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(99, 102, 241, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #059669);
            color: var(--white);
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #059669, #10b981);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color), #dc2626);
            color: var(--white);
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #dc2626, #ef4444);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(239, 68, 68, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary-color), #4b5563);
            color: var(--white);
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #4b5563, #6b7280);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(107, 114, 128, 0.3);
        }

        .content-section {
            flex: 1;
            display: flex;
            padding: 20px;
            gap: 20px;
        }

        .ticket-list {
            width: 30%;
            background: var(--light-color);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .ticket-list-header {
            background: linear-gradient(135deg, var(--primary-color), #4f46e5);
            color: var(--white);
            padding: 15px 20px;
            font-weight: 600;
        }

        .ticket-list-body {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
        }

        .ticket-item {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 10px;
            background: var(--gray-light);
            cursor: pointer;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .ticket-item:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-left-color: var(--primary-color);
        }

        .ticket-item.active {
            background: rgba(99, 102, 241, 0.2);
            border-left-color: var(--primary-color);
        }

        .ticket-item-title {
            font-weight: 600;
            color: var(--white);
            margin-bottom: 5px;
        }

        .ticket-item-meta {
            font-size: 12px;
            color: var(--gray-dark);
        }

        .ticket-details {
            flex: 1;
            background: var(--light-color);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .ticket-details-header {
            background: linear-gradient(135deg, var(--primary-color), #4f46e5);
            color: var(--white);
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .ticket-details-body {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
        }

        .ticket-info-table {
            margin-bottom: 20px;
            background: var(--darker-color);
            border-radius: 10px;
            padding: 15px;
            border: 1px solid var(--gray-medium);
        }

        .ticket-info-table th {
            width: 120px;
            font-weight: 600;
            color: var(--white);
            padding: 8px;
            border-bottom: 1px solid var(--gray-medium);
        }

        .ticket-info-table td {
            color: var(--white);
            padding: 8px;
            border-bottom: 1px solid var(--gray-medium);
        }

        .description-section {
            margin-bottom: 20px;
        }

        .description-box {
            width: 100%;
            border: 1px solid var(--gray-medium);
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 14px;
            background: var(--gray-light);
            resize: none;
            min-height: 100px;
            color: var(--white);
        }

        .replies-section {
            margin-top: 20px;
        }

        .reply-item {
            background: var(--gray-light);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            border-left: 4px solid var(--primary-color);
        }

        .reply-time {
            font-size: 12px;
            color: var(--gray-dark);
            margin-bottom: 5px;
        }

        .reply-form {
            margin-top: 20px;
            padding: 15px;
            background: var(--darker-color);
            border-radius: 10px;
            border: 1px solid var(--gray-medium);
        }

        .form-control {
            background-color: var(--gray-light);
            border: 1px solid var(--gray-medium);
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 16px;
            color: var(--white);
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(99, 102, 241, 0.25);
            background-color: var(--gray-light);
            color: var(--white);
        }

        /* Make placeholder text white */
        .form-control::placeholder {
            color: var(--gray-dark);
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--gray-dark);
        }

        .empty-state i {
            font-size: 48px;
            color: var(--gray-medium);
            margin-bottom: 15px;
        }

        .status-badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-new {
            background-color: rgba(59, 130, 246, 0.2);
            color: var(--info-color);
        }

        .status-pending {
            background-color: rgba(245, 158, 11, 0.2);
            color: var(--warning-color);
        }

        .status-solved {
            background-color: rgba(16, 185, 129, 0.2);
            color: var(--success-color);
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 10px;
            border: 1px solid transparent;
        }

        .alert-success {
            background-color: rgba(16, 185, 129, 0.2);
            color: var(--success-color);
            border-color: var(--success-color);
        }

        .alert-danger {
            background-color: rgba(239, 68, 68, 0.2);
            color: var(--danger-color);
            border-color: var(--danger-color);
        }

        @media (max-width: 991.98px) {
            .content-section {
                flex-direction: column;
            }

            .ticket-list {
                width: 100%;
                max-height: 300px;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <!-- Header Section -->
    <div class="header-section">
        <div>
            <a href="admin-dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
        <h2>Manage Tickets</h2>
        <div class="header-actions">
            <a href="admin-dashboard" class="btn btn-primary">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
            <a href="mainpage.jsp" class="btn btn-danger">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <!-- Content Section -->
    <div class="content-section">
        <!-- Success/Error Messages -->
        <% if(successMsg != null){ %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i> <%= successMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Ticket List -->
        <div class="ticket-list">
            <div class="ticket-list-header">
                <i class="fas fa-ticket-alt me-2"></i> All Tickets
            </div>
            <div class="ticket-list-body">
                <%
                    List<Map<String,String>> tickets = (List<Map<String,String>>) request.getAttribute("tickets");
                    if(tickets != null && !tickets.isEmpty()){
                        for(Map<String,String> ticket : tickets){
                            String ticketStatus = ticket.get("status");
                            String ticketId = ticket.get("ticketId");
                            boolean isActive = request.getAttribute("ticketId") != null &&
                                    request.getAttribute("ticketId").toString().equals(ticketId);
                %>
                <div class="ticket-item <%= isActive ? "active" : "" %>"
                     onclick="window.location.href='ManageTicketsServlet?ticketId=<%= ticketId %>'">
                    <div class="ticket-item-title"><%= ticket.get("username") %> - <%= ticket.get("email") %></div>
                    <div class="ticket-item-meta">
                        Category: <%= ticket.get("category") %> |
                        Status: <span class="status-badge status-<%= ticketStatus.toLowerCase() %>"><%= ticketStatus %></span>
                    </div>
                </div>
                <% }} else { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>No tickets found.</p>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Ticket Details -->
        <div class="ticket-details">
            <div class="ticket-details-header">
                <h5><%= request.getAttribute("ticketId") != null ? "Ticket #" + request.getAttribute("ticketId") : "Select a Ticket" %></h5>
                <div class="d-flex align-items-center gap-2">
                    <%
                        String status = (String) request.getAttribute("status");
                        if(status != null) {
                    %>
                    <span class="status-badge status-<%= status.toLowerCase() %>">
                        <%= status %>
                    </span>
                    <% } %>
                    <% if(request.getAttribute("ticketId") != null){ %>
                    <button type="button" class="btn btn-success btn-sm" onclick="showReplyBox()">
                        <i class="fas fa-reply"></i> Reply
                    </button>
                    <% } %>
                </div>
            </div>

            <div class="ticket-details-body">
                <% if(request.getAttribute("ticketId") != null){ %>
                <table class="ticket-info-table">
                    <tbody>
                    <tr>
                        <th>Category</th>
                        <td><%= request.getAttribute("category") %></td>
                    </tr>
                    <tr>
                        <th>Status</th>
                        <td><span class="status-badge status-<%= status.toLowerCase() %>"><%= status %></span></td>
                    </tr>
                    <tr>
                        <th>Created At</th>
                        <td><%= request.getAttribute("created_at") %></td>
                    </tr>
                    <tr>
                        <th>Username</th>
                        <td><%= request.getAttribute("username") %></td>
                    </tr>
                    <tr>
                        <th>Email</th>
                        <td><%= request.getAttribute("email") %></td>
                    </tr>
                    </tbody>
                </table>

                <div class="description-section">
                    <h6 style="color: var(--white);">Description</h6>
                    <textarea class="description-box" readonly><%= request.getAttribute("description") %></textarea>
                </div>

                <div class="replies-section">
                    <h6 style="color: var(--white);">Replies</h6>
                    <%
                        List<Map<String,String>> replies = (List<Map<String,String>>) request.getAttribute("replies");
                        if(replies != null && !replies.isEmpty()){
                            for(Map<String,String> reply: replies){
                    %>
                    <div class="reply-item">
                        <div class="reply-time"><i class="far fa-clock me-1"></i> <%= reply.get("created_at") %></div>
                        <div><strong><%= reply.get("sender") %>:</strong> <%= reply.get("message") %></div>
                    </div>
                    <% }} else { %>
                    <div class="empty-state">
                        <i class="fas fa-comments"></i>
                        <p>No replies yet.</p>
                    </div>
                    <% } %>

                    <!-- Reply Form -->
                    <div class="reply-form" id="replyBox" style="display:none;">
                        <h6 style="color: var(--white);">Add Reply</h6>
                        <form method="post" action="ReplyTicketServlet">
                            <input type="hidden" name="ticketId" value="<%= request.getAttribute("ticketId") %>">
                            <div class="mb-3">
                                <textarea name="message" class="form-control" rows="3" placeholder="Type your reply here..." required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> Send Reply
                            </button>
                        </form>
                    </div>
                </div>
                <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-mouse-pointer"></i>
                    <p>Select a ticket to view details and add replies</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function showReplyBox(){
        document.getElementById('replyBox').style.display='block';
    }
</script>
</body>
</html>