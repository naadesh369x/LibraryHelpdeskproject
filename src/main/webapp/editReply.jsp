<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.example.demo.utils.DBConnection" %>
<%
    // Check for error messages from the servlet
    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }

    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }

    // Get reply details from the servlet
    Map<String, String> reply = (Map<String, String>) request.getAttribute("reply");
    Map<String, String> ticket = (Map<String, String>) request.getAttribute("ticket");

    // If reply is null, try to get it from the database (fallback)
    if (reply == null) {
        String replyId = request.getParameter("id");
        if(replyId == null || replyId.isEmpty()){
            response.sendRedirect("ViewAllRepliesServlet?error=Missing+reply+ID");
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
            // Check table structure to determine correct column names
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

            // Fetch reply details along with ticket info
            String sql = "SELECT r." + replyIdColumn + " as replyId, r.message, r.sender, " +
                    "t." + ticketIdColumn + " as ticketId, t.category, t.description, t.status, t.email " +
                    "FROM ticket_replies r " +
                    "JOIN tickets t ON r." + replyTicketIdColumn + " = t." + ticketIdColumn + " " +
                    "WHERE r." + replyIdColumn + " = ?";

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

                        // Create reply and ticket maps for consistency
                        reply = new HashMap<>();
                        reply.put("id", replyId);
                        reply.put("message", currentReply);
                        reply.put("sender", sender);

                        ticket = new HashMap<>();
                        ticket.put("id", ticketId);
                        ticket.put("category", ticketCategory);
                        ticket.put("description", ticketDescription);
                        ticket.put("status", ticketStatus);
                        ticket.put("email", ticketEmail);
                    } else {
                        response.sendRedirect("ViewAllRepliesServlet?error=Reply+not+found");
                        return;
                    }
                }
            }
        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("ViewAllRepliesServlet?error=Database+error");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Reply - Admin Dashboard</title>
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
            color: var(--primary-color);
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
            padding: 20px;
            display: flex;
            justify-content: center;
        }

        .edit-form-container {
            background: var(--light-color);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            padding: 30px;
            width: 100%;
            max-width: 800px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            color: var(--white);
            margin-bottom: 8px;
            display: block;
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

        .form-control:read-only {
            background-color: var(--gray-medium);
            cursor: not-allowed;
            color: var(--gray-dark);
        }

        textarea.form-control {
            resize: none;
            min-height: 100px;
        }

        /* Make placeholder text white */
        .form-control::placeholder {
            color: var(--gray-dark);
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

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 220px;
            background-color: var(--light-color);
            padding-top: 20px;
            overflow-y: auto;
            z-index: 1030;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
        }

        .sidebar a {
            color: var(--white);
            text-decoration: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            transition: background-color 0.3s, color 0.3s;
        }

        .sidebar a:hover, .sidebar a:focus {
            background-color: var(--gray-light);
            color: var(--primary-color);
            outline: none;
        }

        .sidebar a.active {
            background-color: rgba(99, 102, 241, 0.2);
            color: var(--primary-color);
            border-left: 4px solid var(--primary-color);
        }

        .sidebar h4 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
            font-weight: 700;
        }

        .main-content {
            margin-left: 220px;
            padding: 20px;
        }

        .section-title {
            color: var(--primary-color);
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--gray-medium);
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        @media (max-width: 991.98px) {
            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
                padding: 10px 0;
            }

            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<nav class="sidebar" aria-label="Sidebar Navigation">
    <h4>Support Admin</h4>
    <a href="admin-dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
    <a href="ManageTicketsServlet"><i class="fas fa-ticket-alt"></i> Manage Tickets</a>
    <a href="AdminRequestsServlet"><i class="fas fa-plus-circle"></i> Manage request resources</a>
    <a href="listFAQAdmin.jsp"><i class="fas fa-plus-circle"></i> Manage FAQ</a>
    <a href="ViewAllRepliesServlet" class="active"><i class="fas fa-hourglass-half"></i> Replied Tickets</a>
    <a href="FeedbackListServlet"><i class="fas fa-check-circle"></i> Feedbacks</a>
    <a href="add-staff.jsp"><i class="fas fa-users"></i> Add Staffs</a>
    <a href="manage-users"><i class="fas fa-play-circle"></i> Manage Users</a>
    <a href="profile.jsp"><i class="fas fa-cog"></i> Profile Settings</a>
</nav>

<!-- Main Content -->
<div class="main-content">
    <!-- Header Section -->
    <div class="header-section">
        <h2><i class="fas fa-edit me-2"></i>Edit Reply</h2>
        <div class="header-actions">
            <a href="ViewAllRepliesServlet" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Replies
            </a>
        </div>
    </div>

    <!-- Content Section -->
    <div class="content-section">
        <div class="edit-form-container">
            <!-- Success/Error Messages -->
            <% if (successMessage != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if (errorMessage != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i> <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <h3 class="section-title">Edit Reply</h3>

            <% if (reply != null && ticket != null) { %>
            <form method="post" action="EditReplyServlet">
                <input type="hidden" name="id" value="<%= reply.get("id") %>">

                <!-- Ticket Info (read-only) -->
                <div class="form-group">
                    <label class="form-label">Ticket ID</label>
                    <input type="text" class="form-control" value="#<%= ticket.get("id") %>" readonly>
                </div>
                <div class="form-group">
                    <label class="form-label">Ticket Category</label>
                    <input type="text" class="form-control" value="<%= ticket.get("category") %>" readonly>
                </div>
                <div class="form-group">
                    <label class="form-label">Ticket Description</label>
                    <textarea class="form-control" rows="4" readonly><%= ticket.get("description") %></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">Ticket Status</label>
                    <input type="text" class="form-control" value="<%= ticket.get("status") %>" readonly>
                </div>
                <div class="form-group">
                    <label class="form-label">Ticket Email</label>
                    <input type="text" class="form-control" value="<%= ticket.get("email") %>" readonly>
                </div>

                <!-- Reply Info -->
                <div class="form-group">
                    <label class="form-label">Sender</label>
                    <input type="text" class="form-control" value="<%= reply.get("sender") %>" readonly>
                </div>
                <div class="form-group">
                    <label class="form-label">Reply Message</label>
                    <textarea name="replyText" class="form-control" rows="6" required><%= reply.get("message") %></textarea>
                </div>

                <div class="action-buttons">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Update Reply
                    </button>
                    <a href="ViewAllRepliesServlet" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
            <% } else { %>
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i> Reply details not found.
            </div>
            <div class="action-buttons">
                <a href="ViewAllRepliesServlet" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Replies
                </a>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>