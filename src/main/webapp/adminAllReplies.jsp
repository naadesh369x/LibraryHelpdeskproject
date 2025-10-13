<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Ticket Replies - Admin Dashboard</title>
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
            color: var(--dark-color);
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

        .btn-warning {
            background: linear-gradient(135deg, var(--warning-color), #d97706);
            color: var(--white);
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #d97706, #f59e0b);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(245, 158, 11, 0.3);
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
            padding: 20px;
        }

        .filter-section {
            background: var(--light-color);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            padding: 20px;
            margin-bottom: 20px;
        }

        .filter-form {
            display: flex;
            gap: 15px;
            align-items: end;
        }

        .form-group {
            flex: 1;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            background-color: var(--gray-light);
            border: 1px solid var(--gray-medium);
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 16px;
            color: var(--dark-color);
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(99, 102, 241, 0.25);
            background-color: var(--gray-light);
        }

        .reply-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
        }

        .reply-card {
            background: var(--light-color);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid var(--gray-medium);
        }

        .reply-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }

        .reply-header {
            background: linear-gradient(135deg, var(--primary-color), #4f46e5);
            color: var(--white);
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .reply-id {
            background: rgba(255, 255, 255, 0.2);
            color: var(--white);
            font-weight: 600;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .reply-body {
            padding: 20px;
        }

        .info-row {
            display: flex;
            margin-bottom: 10px;
        }

        .info-label {
            font-weight: 600;
            color: var(--dark-color);
            min-width: 100px;
        }

        .info-value {
            color: var(--gray-dark);
        }

        .message-box {
            background: var(--gray-light);
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
            border-left: 4px solid var(--primary-color);
        }

        .reply-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .pagination-section {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }

        .pagination .page-link {
            color: var(--primary-color);
            background-color: var(--light-color);
            border: 1px solid var(--gray-medium);
            margin: 0 2px;
            border-radius: 8px;
        }

        .pagination .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--gray-dark);
        }

        .empty-state i {
            font-size: 64px;
            color: var(--gray-medium);
            margin-bottom: 20px;
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
            color: var(--dark-color);
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

        .response-time {
            font-size: 12px;
            color: var(--success-color);
            font-weight: 600;
        }

        .updated-indicator {
            font-size: 11px;
            color: var(--warning-color);
            font-style: italic;
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

            .filter-form {
                flex-direction: column;
                align-items: stretch;
            }

            .reply-list {
                grid-template-columns: 1fr;
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
        <h2><i class="fas fa-reply me-2"></i>All Ticket Replies</h2>
        <div class="header-actions">
            <a href="admin-dashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <form class="filter-form" action="ViewAllRepliesServlet" method="get">
            <div class="form-group">
                <label class="form-label">Filter By</label>
                <select class="form-select" name="filterBy">
                    <option value="">All Fields</option>
                    <option value="r.sender" ${"r.sender".equals(request.getAttribute("filterBy")) ? "selected" : ""}>Sender</option>
                    <option value="t.category" ${"t.category".equals(request.getAttribute("filterBy")) ? "selected" : ""}>Category</option>
                    <option value="t.username" ${"t.username".equals(request.getAttribute("filterBy")) ? "selected" : ""}>Username</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Filter Value</label>
                <input type="text" class="form-control" name="filterValue"
                       value="${request.getAttribute("filterValue") != null ? request.getAttribute("filterValue") : ""}"
                       placeholder="Enter search term">
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Search
                </button>
            </div>
        </form>
    </div>

    <!-- Replies List -->
    <div class="content-section">
        <%
            List<Map<String, Object>> replies = (List<Map<String, Object>>) request.getAttribute("replies");
            if (replies != null && !replies.isEmpty()) {
        %>
        <div class="reply-list">
            <%
                for (Map<String, Object> reply : replies) {
                    Map<String, String> ticket = (Map<String, String>) reply.get("ticket");
            %>
            <div class="reply-card">
                <div class="reply-header">
                    <div class="reply-id"><%= reply.get("id") %></div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="status-badge status-<%= ticket.get("status").toLowerCase() %>">
                            <%= ticket.get("status") %>
                        </span>
                    </div>
                </div>
                <div class="reply-body">
                    <div class="info-row">
                        <div class="info-label">Ticket ID:</div>
                        <div class="info-value">#<%= ticket.get("ticketId") %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Category:</div>
                        <div class="info-value"><%= ticket.get("category") %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Username:</div>
                        <div class="info-value"><%= ticket.get("username") %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Sender:</div>
                        <div class="info-value"><%= reply.get("sender") %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Email:</div>
                        <div class="info-value"><%= ticket.get("email") %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Mobile:</div>
                        <div class="info-value"><%= ticket.get("mobile") %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Reply Date:</div>
                        <div class="info-value">
                            <%= reply.containsKey("formatted_date") ? reply.get("formatted_date") : reply.get("created_at") %>
                        </div>
                    </div>

                    <% if (reply.containsKey("response_time")) { %>
                    <div class="info-row">
                        <div class="info-label">Response Time:</div>
                        <div class="info-value response-time">
                            <i class="fas fa-clock me-1"></i> <%= reply.get("response_time") %>
                        </div>
                    </div>
                    <% } %>

                    <% if (reply.containsKey("updated_at")) { %>
                    <div class="info-row">
                        <div class="info-label">Updated:</div>
                        <div class="info-value updated-indicator">
                            <%= reply.containsKey("formatted_updated_date") ? reply.get("formatted_updated_date") : reply.get("updated_at") %>
                        </div>
                    </div>
                    <% } %>

                    <div class="message-box">
                        <div class="info-label mb-2">Ticket Description:</div>
                        <%= ticket.get("description") %>
                    </div>

                    <% if (reply.containsKey("reply_description")) { %>
                    <div class="message-box">
                        <div class="info-label mb-2">Reply Description:</div>
                        <%= reply.get("reply_description") %>
                    </div>
                    <% } %>

                    <div class="message-box">
                        <div class="info-label mb-2">Reply Message:</div>
                        <%= reply.get("message") %>
                    </div>

                    <div class="reply-actions">
                        <a href="editReply.jsp?id=<%= reply.get("id") %>" class="btn btn-warning btn-sm">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a href="DeleteReplyServlet?id=<%= reply.get("id") %>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this reply?');">
                            <i class="fas fa-trash"></i> Delete
                        </a>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>

        <!-- Pagination -->
        <%
            Integer currentPage = (Integer) request.getAttribute("currentPage");
            Integer totalPages = (Integer) request.getAttribute("totalPages");
            Integer totalRecords = (Integer) request.getAttribute("totalRecords");

            if (currentPage != null && totalPages != null && totalPages > 1) {
        %>
        <div class="pagination-section">
            <nav aria-label="Replies pagination">
                <ul class="pagination">
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %>&filterBy=${request.getAttribute("filterBy")}&filterValue=${request.getAttribute("filterValue")}" tabindex="-1">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>

                    <%
                        for (int i = 1; i <= totalPages; i++) {
                            if (i == currentPage || i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
                    %>
                    <li class="page-item <%= i == currentPage ? "active" : "" %>">
                        <a class="page-link" href="?page=<%= i %>&filterBy=${request.getAttribute("filterBy")}&filterValue=${request.getAttribute("filterValue")}"><%= i %></a>
                    </li>
                    <%
                    } else if (i == currentPage - 2 || i == currentPage + 2) {
                    %>
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1">...</a>
                    </li>
                    <%
                            }
                        }
                    %>

                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %>&filterBy=${request.getAttribute("filterBy")}&filterValue=${request.getAttribute("filterValue")}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
            <div class="text-center mt-2">
                <small class="text-muted">Showing <%= (currentPage - 1) * 10 + 1 %> to <%= Math.min(currentPage * 10, totalRecords) %> of <%= totalRecords %> replies</small>
            </div>
        </div>
        <%
            }
        %>
        <%
        } else {
        %>
        <div class="empty-state">
            <i class="fas fa-inbox"></i>
            <h4>No replies found</h4>
            <p>There are no ticket replies to display.</p>
        </div>
        <%
            }
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>