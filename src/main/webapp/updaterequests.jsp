<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    List<Map<String,String>> requests = (List<Map<String,String>>) request.getAttribute("requests");

    List<Map<String,String>> pendingRequests = new ArrayList<>();
    List<Map<String,String>> approvedRequests = new ArrayList<>();
    List<Map<String,String>> rejectedRequests = new ArrayList<>();

    if (requests != null) {
        for (Map<String,String> req : requests) {
            String status = req.get("status");
            if ("pending".equalsIgnoreCase(status)) pendingRequests.add(req);
            else if ("approved".equalsIgnoreCase(status)) approvedRequests.add(req);
            else if ("rejected".equalsIgnoreCase(status)) rejectedRequests.add(req);
        }
    }

    // Format for dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Resource Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
            --dark-color: #5a5c69;
            --light-color: #f8f9fc;
            --secondary-color: #858796;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #5a5c69;
            position: relative;
        }

        /* Background overlay */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('images/admin-bg.jpg') no-repeat center center fixed;
            background-size: cover;
            opacity: 0.15;
            z-index: -1;
        }

        /* Header */
        .dashboard-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            animation: slideDown 0.5s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dashboard-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--dark-color);
            margin: 0;
            display: flex;
            align-items: center;
        }

        .dashboard-title i {
            margin-right: 12px;
            color: var(--primary-color);
        }

        .btn-back {
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-back:hover {
            background: #2e59d9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(78, 115, 223, 0.3);
            color: white;
        }

        /* Summary Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
        }

        .stat-card.total::before { background: var(--primary-color); }
        .stat-card.pending::before { background: var(--warning-color); }
        .stat-card.approved::before { background: var(--success-color); }
        .stat-card.rejected::before { background: var(--danger-color); }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            font-size: 24px;
            color: white;
        }

        .stat-card.total .stat-icon { background: var(--primary-color); }
        .stat-card.pending .stat-icon { background: var(--warning-color); }
        .stat-card.approved .stat-icon { background: var(--success-color); }
        .stat-card.rejected .stat-icon { background: var(--danger-color); }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--dark-color);
        }

        .stat-label {
            font-size: 16px;
            color: var(--secondary-color);
            font-weight: 600;
        }

        /* Search and Filter Bar */
        .filter-bar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .search-container {
            position: relative;
            flex: 1;
            max-width: 400px;
        }

        .search-input {
            width: 100%;
            padding: 12px 45px 12px 20px;
            border: 1px solid #e3e6f0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.1);
        }

        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
        }

        .filter-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-btn.active {
            color: white;
        }

        .filter-btn.all {
            background: var(--primary-color);
            color: white;
        }

        .filter-btn.pending {
            background: var(--warning-color);
            color: white;
        }

        .filter-btn.approved {
            background: var(--success-color);
            color: white;
        }

        .filter-btn.rejected {
            background: var(--danger-color);
            color: white;
        }

        .filter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        /* Tabs */
        .tabs-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px 15px 0 0;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .tab-navigation {
            display: flex;
            background: rgba(0, 0, 0, 0.05);
        }

        .tab-btn {
            flex: 1;
            padding: 15px;
            border: none;
            background: transparent;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            color: var(--secondary-color);
        }

        .tab-btn.active {
            color: var(--dark-color);
            background: white;
        }

        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
        }

        .tab-btn.pending.active::after { background: var(--warning-color); }
        .tab-btn.approved.active::after { background: var(--success-color); }
        .tab-btn.rejected.active::after { background: var(--danger-color); }

        .tab-content {
            display: none;
            padding: 0;
        }

        .tab-content.active {
            display: block;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* Table */
        .table-container {
            background: white;
            border-radius: 0 0 15px 15px;
            overflow: hidden;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
        }

        .table th {
            background: var(--light-color);
            color: var(--dark-color);
            font-weight: 600;
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e3e6f0;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .table td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #e3e6f0;
        }

        .table tbody tr {
            transition: all 0.2s ease;
        }

        .table tbody tr:hover {
            background-color: rgba(78, 115, 223, 0.05);
        }

        .request-id {
            font-weight: 600;
            color: var(--primary-color);
        }

        .request-title {
            font-weight: 600;
            color: var(--dark-color);
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .type-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .type-badge.Book { background: #e3f2fd; color: #1976d2; }
        .type-badge.Journal { background: #f3e5f5; color: #7b1fa2; }
        .type-badge.Thesis { background: #e8f5e9; color: #388e3c; }
        .type-badge.Magazine { background: #fff3e0; color: #f57c00; }
        .type-badge.Other { background: #f1f8e9; color: #689f38; }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }

        .user-details {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: 600;
            color: var(--dark-color);
        }

        .user-email {
            font-size: 12px;
            color: var(--secondary-color);
        }

        .date-cell {
            color: var(--secondary-color);
            font-size: 14px;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 8px 12px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-action.approve {
            background: var(--success-color);
            color: white;
        }

        .btn-action.approve:hover {
            background: #17a673;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(28, 200, 138, 0.3);
        }

        .btn-action.reject {
            background: var(--danger-color);
            color: white;
        }

        .btn-action.reject:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(231, 74, 59, 0.3);
        }

        .btn-action.pending {
            background: var(--warning-color);
            color: white;
        }

        .btn-action.pending:hover {
            background: #f4b619;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(246, 194, 62, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: var(--secondary-color);
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #e3e6f0;
        }

        /* Toast Notification */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050;
        }

        .toast {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 15px 20px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 300px;
            animation: slideInRight 0.3s ease;
        }

        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        .toast.success {
            border-left: 4px solid var(--success-color);
        }

        .toast.error {
            border-left: 4px solid var(--danger-color);
        }

        .toast-icon {
            font-size: 20px;
        }

        .toast.success .toast-icon {
            color: var(--success-color);
        }

        .toast.error .toast-icon {
            color: var(--danger-color);
        }

        /* Responsive */
        @media (max-width: 992px) {
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .dashboard-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .filter-bar {
                flex-direction: column;
            }

            .search-container {
                max-width: 100%;
            }

            .filter-buttons {
                width: 100%;
                justify-content: space-between;
            }

            .table-container {
                overflow-x: auto;
            }

            .action-buttons {
                flex-direction: column;
            }
        }

        @media (max-width: 576px) {
            .stats-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container py-4">
    <!-- Header -->
    <header class="dashboard-header">
        <h1 class="dashboard-title">
            <i class="fas fa-chart-line"></i>
            Resource Requests Management
        </h1>
        <a href="admin-dashboard" class="btn-back">
            <i class="fas fa-arrow-left me-2"></i>
            Back to Dashboard
        </a>
    </header>

    <!-- Summary Cards -->
    <div class="stats-container">
        <div class="stat-card total">
            <div class="stat-icon">
                <i class="fas fa-clipboard-list"></i>
            </div>
            <div class="stat-value"><%= request.getAttribute("totalCount") != null ? request.getAttribute("totalCount") : "0" %></div>
            <div class="stat-label">Total Requests</div>
        </div>
        <div class="stat-card pending">
            <div class="stat-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-value"><%= request.getAttribute("pendingCount") != null ? request.getAttribute("pendingCount") : "0" %></div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-card approved">
            <div class="stat-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-value"><%= request.getAttribute("approvedCount") != null ? request.getAttribute("approvedCount") : "0" %></div>
            <div class="stat-label">Approved</div>
        </div>
        <div class="stat-card rejected">
            <div class="stat-icon">
                <i class="fas fa-times-circle"></i>
            </div>
            <div class="stat-value"><%= request.getAttribute("rejectedCount") != null ? request.getAttribute("rejectedCount") : "0" %></div>
            <div class="stat-label">Rejected</div>
        </div>
    </div>

    <!-- Search and Filter Bar -->
    <div class="filter-bar">
        <div class="search-container">
            <input type="text" id="searchInput" class="search-input" placeholder="Search requests...">
            <i class="fas fa-search search-icon"></i>
        </div>
        <div class="filter-buttons">
            <button class="filter-btn all active" onclick="filterByStatus('all')">
                <i class="fas fa-list"></i>
                All
            </button>
            <button class="filter-btn pending" onclick="filterByStatus('pending')">
                <i class="fas fa-clock"></i>
                Pending
            </button>
            <button class="filter-btn approved" onclick="filterByStatus('approved')">
                <i class="fas fa-check-circle"></i>
                Approved
            </button>
            <button class="filter-btn rejected" onclick="filterByStatus('rejected')">
                <i class="fas fa-times-circle"></i>
                Rejected
            </button>
        </div>
    </div>

    <!-- Tabs -->
    <div class="tabs-container">
        <div class="tab-navigation">
            <button class="tab-btn pending active" onclick="showTab('pending')">
                <i class="fas fa-clock me-2"></i>
                Pending (<%= pendingRequests.size() %>)
            </button>
            <button class="tab-btn approved" onclick="showTab('approved')">
                <i class="fas fa-check-circle me-2"></i>
                Approved (<%= approvedRequests.size() %>)
            </button>
            <button class="tab-btn rejected" onclick="showTab('rejected')">
                <i class="fas fa-times-circle me-2"></i>
                Rejected (<%= rejectedRequests.size() %>)
            </button>
        </div>

        <!-- Pending Requests Tab -->
        <div id="pendingTab" class="tab-content active">
            <div class="table-container">
                <table class="table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Type</th>
                        <th>User</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="pendingTableBody">
                    <% for (Map<String,String> req : pendingRequests) {
                        // Format the date
                        String formattedDate = "";
                        try {
                            if (req.get("created_at") != null) {
                                java.util.Date date = java.sql.Timestamp.valueOf(req.get("created_at"));
                                formattedDate = dateFormat.format(date);
                            }
                        } catch (Exception e) {
                            formattedDate = req.get("created_at");
                        }

                        // Get user initial for avatar
                        String userInitial = "U";
                        if (req.get("userName") != null && !req.get("userName").isEmpty()) {
                            userInitial = req.get("userName").substring(0, 1).toUpperCase();
                        }
                    %>
                    <tr data-status="pending">
                        <td class="request-id">#<%= req.get("requestid") %></td>
                        <td class="request-title" title="<%= req.get("title") %>"><%= req.get("title") %></td>
                        <td><%= req.get("author") %></td>
                        <td><span class="type-badge <%= req.get("type") %>"><%= req.get("type") %></span></td>
                        <td>
                            <div class="user-info">
                                <div class="user-avatar"><%= userInitial %></div>
                                <div class="user-details">
                                    <div class="user-name"><%= req.get("userName") != null ? req.get("userName") : "Unknown" %></div>
                                    <div class="user-email"><%= req.get("email") %></div>
                                </div>
                            </div>
                        </td>
                        <td class="date-cell"><%= formattedDate %></td>
                        <td>
                            <div class="action-buttons">
                                <form action="ApproveRejectServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="requestid" value="<%= req.get("requestid") %>">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn-action approve" title="Approve">
                                        <i class="fas fa-check"></i>
                                    </button>
                                </form>
                                <form action="ApproveRejectServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="requestid" value="<%= req.get("requestid") %>">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn-action reject" title="Reject">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% if (pendingRequests.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>No pending requests found</p>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Approved Requests Tab -->
        <div id="approvedTab" class="tab-content">
            <div class="table-container">
                <table class="table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Type</th>
                        <th>User</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="approvedTableBody">
                    <% for (Map<String,String> req : approvedRequests) {
                        // Format the date
                        String formattedDate = "";
                        try {
                            if (req.get("created_at") != null) {
                                java.util.Date date = java.sql.Timestamp.valueOf(req.get("created_at"));
                                formattedDate = dateFormat.format(date);
                            }
                        } catch (Exception e) {
                            formattedDate = req.get("created_at");
                        }

                        // Get user initial for avatar
                        String userInitial = "U";
                        if (req.get("userName") != null && !req.get("userName").isEmpty()) {
                            userInitial = req.get("userName").substring(0, 1).toUpperCase();
                        }
                    %>
                    <tr data-status="approved">
                        <td class="request-id">#<%= req.get("requestid") %></td>
                        <td class="request-title" title="<%= req.get("title") %>"><%= req.get("title") %></td>
                        <td><%= req.get("author") %></td>
                        <td><span class="type-badge <%= req.get("type") %>"><%= req.get("type") %></span></td>
                        <td>
                            <div class="user-info">
                                <div class="user-avatar"><%= userInitial %></div>
                                <div class="user-details">
                                    <div class="user-name"><%= req.get("userName") != null ? req.get("userName") : "Unknown" %></div>
                                    <div class="user-email"><%= req.get("email") %></div>
                                </div>
                            </div>
                        </td>
                        <td class="date-cell"><%= formattedDate %></td>
                        <td>
                            <div class="action-buttons">
                                <form action="ApproveRejectServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="requestid" value="<%= req.get("requestid") %>">
                                    <input type="hidden" name="action" value="pending">
                                    <button type="submit" class="btn-action pending" title="Move to Pending">
                                        <i class="fas fa-undo"></i>
                                    </button>
                                </form>
                                <form action="ApproveRejectServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="requestid" value="<%= req.get("requestid") %>">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn-action reject" title="Reject">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% if (approvedRequests.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>No approved requests found</p>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Rejected Requests Tab -->
        <div id="rejectedTab" class="tab-content">
            <div class="table-container">
                <table class="table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Type</th>
                        <th>User</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="rejectedTableBody">
                    <% for (Map<String,String> req : rejectedRequests) {
                        // Format the date
                        String formattedDate = "";
                        try {
                            if (req.get("created_at") != null) {
                                java.util.Date date = java.sql.Timestamp.valueOf(req.get("created_at"));
                                formattedDate = dateFormat.format(date);
                            }
                        } catch (Exception e) {
                            formattedDate = req.get("created_at");
                        }

                        // Get user initial for avatar
                        String userInitial = "U";
                        if (req.get("userName") != null && !req.get("userName").isEmpty()) {
                            userInitial = req.get("userName").substring(0, 1).toUpperCase();
                        }
                    %>
                    <tr data-status="rejected">
                        <td class="request-id">#<%= req.get("requestid") %></td>
                        <td class="request-title" title="<%= req.get("title") %>"><%= req.get("title") %></td>
                        <td><%= req.get("author") %></td>
                        <td><span class="type-badge <%= req.get("type") %>"><%= req.get("type") %></span></td>
                        <td>
                            <div class="user-info">
                                <div class="user-avatar"><%= userInitial %></div>
                                <div class="user-details">
                                    <div class="user-name"><%= req.get("userName") != null ? req.get("userName") : "Unknown" %></div>
                                    <div class="user-email"><%= req.get("email") %></div>
                                </div>
                            </div>
                        </td>
                        <td class="date-cell"><%= formattedDate %></td>
                        <td>
                            <div class="action-buttons">
                                <form action="ApproveRejectServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="requestid" value="<%= req.get("requestid") %>">
                                    <input type="hidden" name="action" value="pending">
                                    <button type="submit" class="btn-action pending" title="Move to Pending">
                                        <i class="fas fa-undo"></i>
                                    </button>
                                </form>
                                <form action="ApproveRejectServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="requestid" value="<%= req.get("requestid") %>">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn-action approve" title="Approve">
                                        <i class="fas fa-check"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% if (rejectedRequests.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>No rejected requests found</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<script>
    // Tab functionality
    function showTab(tabName) {
        // Hide all tabs
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.classList.remove('active');
        });

        // Remove active class from all tab buttons
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });

        // Show selected tab
        document.getElementById(tabName + 'Tab').classList.add('active');
        document.querySelector('.tab-btn.' + tabName).classList.add('active');
    }

    // Filter functionality
    function filterByStatus(status) {
        // Update active filter button
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector('.filter-btn.' + status).classList.add('active');

        // Show/hide rows based on status
        const allRows = document.querySelectorAll('#pendingTableBody tr, #approvedTableBody tr, #rejectedTableBody tr');

        allRows.forEach(row => {
            if (status === 'all') {
                row.style.display = '';
            } else {
                const rowStatus = row.getAttribute('data-status');
                row.style.display = rowStatus === status ? '' : 'none';
            }
        });
    }

    // Search functionality
    document.getElementById('searchInput').addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        const allRows = document.querySelectorAll('#pendingTableBody tr, #approvedTableBody tr, #rejectedTableBody tr');

        allRows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? '' : 'none';
        });
    });

    // Show toast notification
    function showToast(message, type = 'success') {
        const toastContainer = document.getElementById('toastContainer');

        const toast = document.createElement('div');
        toast.className = `toast ${type}`;

        const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';

        toast.innerHTML = `
            <i class="fas ${icon} toast-icon"></i>
            <div>${message}</div>
        `;

        toastContainer.appendChild(toast);

        // Auto remove after 3 seconds
        setTimeout(() => {
            toast.style.animation = 'slideInRight 0.3s ease reverse';
            setTimeout(() => {
                toastContainer.removeChild(toast);
            }, 300);
        }, 3000);
    }

    // Initialize with pending tab
    document.addEventListener('DOMContentLoaded', function() {
        showTab('pending');
    });
</script>
</body>
</html>