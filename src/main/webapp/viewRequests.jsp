<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    List<Map<String,String>> requestList = (List<Map<String,String>>) request.getAttribute("requestList");
    String errorMessage = (String) request.getAttribute("errorMessage");

    // Format for dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Requests Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
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
            background: url('https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=1740&q=80') no-repeat center center fixed;
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

        /* Table */
        .table-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 0;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
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

        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .status-badge.pending { background: #f8d7da; color: #721c24; }
        .status-badge.approved { background: #d4edda; color: #155724; }
        .status-badge.rejected { background: #f8d7da; color: #721c24; }

        .date-cell {
            color: var(--secondary-color);
            font-size: 14px;
        }

        .btn-view {
            background: var(--info-color);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 6px 12px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-view:hover {
            background: #2c9faf;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(54, 185, 204, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--secondary-color);
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #e3e6f0;
        }

        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: var(--dark-color);
        }

        .empty-state p {
            font-size: 16px;
            max-width: 500px;
            margin: 0 auto;
        }

        .error-message {
            background-color: rgba(231, 76, 60, 0.9);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.2);
            animation: shake 0.5s;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }

        /* Modal Styles */
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), #2e59d9);
            color: white;
            border-radius: 15px 15px 0 0;
            border: none;
            padding: 20px;
        }

        .modal-title {
            font-weight: 600;
        }

        .btn-close {
            filter: brightness(0) invert(1);
        }

        .modal-body {
            padding: 25px;
        }

        .detail-row {
            display: flex;
            margin-bottom: 15px;
            border-bottom: 1px solid #f1f3f4;
            padding-bottom: 15px;
        }

        .detail-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .detail-label {
            font-weight: 600;
            color: var(--dark-color);
            min-width: 120px;
            padding-right: 15px;
        }

        .detail-value {
            color: var(--secondary-color);
            flex: 1;
        }

        .modal-footer {
            border-top: 1px solid #e3e6f0;
            padding: 15px 25px;
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

            .detail-row {
                flex-direction: column;
            }

            .detail-label {
                min-width: auto;
                padding-right: 0;
                margin-bottom: 5px;
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
            <i class="fas fa-book-reader"></i>
            My Resource Requests
        </h1>
        <a href="dashboard.jsp" class="btn-back">
            <i class="fas fa-arrow-left me-2"></i>
            Back to Dashboard
        </a>
    </header>

    <!-- Error Message -->
    <% if (errorMessage != null) { %>
    <div class="error-message">
        <i class="fas fa-exclamation-triangle me-2"></i> <%= errorMessage %>
    </div>
    <% } %>

    <!-- Summary Cards -->
    <div class="stats-container">
        <div class="stat-card total">
            <div class="stat-icon">
                <i class="fas fa-clipboard-list"></i>
            </div>
            <div class="stat-value"><%= requestList != null ? requestList.size() : 0 %></div>
            <div class="stat-label">Total Requests</div>
        </div>
        <div class="stat-card pending">
            <div class="stat-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-value"><%= requestList != null ? requestList.stream().filter(r -> "pending".equalsIgnoreCase(r.get("status"))).count() : 0 %></div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-card approved">
            <div class="stat-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-value"><%= requestList != null ? requestList.stream().filter(r -> "approved".equalsIgnoreCase(r.get("status"))).count() : 0 %></div>
            <div class="stat-label">Approved</div>
        </div>
        <div class="stat-card rejected">
            <div class="stat-icon">
                <i class="fas fa-times-circle"></i>
            </div>
            <div class="stat-value"><%= requestList != null ? requestList.stream().filter(r -> "rejected".equalsIgnoreCase(r.get("status"))).count() : 0 %></div>
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
            <button class="filter-btn all active" onclick="filterRequests('all')">
                <i class="fas fa-list"></i>
                All
            </button>
            <button class="filter-btn pending" onclick="filterRequests('pending')">
                <i class="fas fa-clock"></i>
                Pending
            </button>
            <button class="filter-btn approved" onclick="filterRequests('approved')">
                <i class="fas fa-check-circle"></i>
                Approved
            </button>
            <button class="filter-btn rejected" onclick="filterRequests('rejected')">
                <i class="fas fa-times-circle"></i>
                Rejected
            </button>
        </div>
    </div>

    <!-- Table -->
    <div class="table-container">
        <% if (requestList != null && !requestList.isEmpty()) { %>
        <div class="table-responsive">
            <table class="table" id="requestsTable">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Type</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Map<String,String> req : requestList) {
                    String status = req.get("status").toLowerCase();
                    String badgeClass = "status-badge pending";
                    if ("approved".equalsIgnoreCase(status)) badgeClass = "status-badge approved";
                    else if ("rejected".equalsIgnoreCase(status)) badgeClass = "status-badge rejected";

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
                %>
                <tr data-status="<%= status %>">
                    <td class="request-id">#<%= req.get("requestid") %></td>
                    <td class="request-title" title="<%= req.get("title") %>"><%= req.get("title") %></td>
                    <td><%= req.get("author") %></td>
                    <td><span class="type-badge <%= req.get("type") %>"><%= req.get("type") %></span></td>
                    <td><span class="<%= badgeClass %>"><%= status.substring(0,1).toUpperCase() + status.substring(1) %></span></td>
                    <td class="date-cell"><%= formattedDate %></td>
                    <td>
                        <button class="btn-view" onclick="showDetails('<%= req.get("requestid") %>', '<%= req.get("title") %>', '<%= req.get("author") %>', '<%= req.get("type") %>', '<%= req.get("justification") %>', '<%= req.get("email") %>', '<%= formattedDate %>', '<%= status %>')">
                            <i class="fas fa-eye"></i>
                            View
                        </button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-inbox"></i>
            <h3>No Requests Found</h3>
            <p>You haven't submitted any resource requests yet. Click the "Request New Resource" button to get started.</p>
            <a href="addrequest.jsp" class="btn btn-primary mt-3">
                <i class="fas fa-plus me-2"></i>Request New Resource
            </a>
        </div>
        <% } %>
    </div>
</div>

<!-- Details Modal -->
<div class="modal fade" id="detailsModal" tabindex="-1" aria-labelledby="detailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailsModalLabel">
                    <i class="fas fa-info-circle me-2"></i>Request Details
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="detail-row">
                    <div class="detail-label">Request ID:</div>
                    <div class="detail-value" id="modalRequestId"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Title:</div>
                    <div class="detail-value" id="modalTitle"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Author:</div>
                    <div class="detail-value" id="modalAuthor"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Type:</div>
                    <div class="detail-value" id="modalType"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Email:</div>
                    <div class="detail-value" id="modalEmail"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Status:</div>
                    <div class="detail-value" id="modalStatus"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Date:</div>
                    <div class="detail-value" id="modalDate"></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Justification:</div>
                    <div class="detail-value" id="modalJustification"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Close
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Filter functionality
    function filterRequests(status) {
        // Update active filter button
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector('.filter-btn.' + status).classList.add('active');

        // Show/hide rows based on status
        const rows = document.querySelectorAll("#requestsTable tbody tr");

        rows.forEach(row => {
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
        const rows = document.querySelectorAll("#requestsTable tbody tr");

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? '' : 'none';
        });
    });

    // Show details modal
    function showDetails(id, title, author, type, justification, email, date, status) {
        document.getElementById('modalRequestId').textContent = '#' + id;
        document.getElementById('modalTitle').textContent = title;
        document.getElementById('modalAuthor').textContent = author;
        document.getElementById('modalType').innerHTML = '<span class="type-badge ' + type + '">' + type + '</span>';
        document.getElementById('modalEmail').textContent = email;
        document.getElementById('modalDate').textContent = date;
        document.getElementById('modalJustification').textContent = justification;

        // Set status with appropriate badge
        let statusElement = document.getElementById('modalStatus');
        let badgeClass = 'status-badge pending';
        if (status === 'approved') badgeClass = 'status-badge approved';
        else if (status === 'rejected') badgeClass = 'status-badge rejected';

        statusElement.innerHTML = '<span class="' + badgeClass + '">' + status.charAt(0).toUpperCase() + status.slice(1) + '</span>';

        // Show modal
        let modal = new bootstrap.Modal(document.getElementById('detailsModal'));
        modal.show();
    }

    // Initialize with all filter
    document.addEventListener('DOMContentLoaded', function() {
        filterRequests('all');
    });
</script>

</body>
</html>