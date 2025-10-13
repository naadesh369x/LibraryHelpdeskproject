<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String,String>> requests = (List<Map<String,String>>) request.getAttribute("requests");

    List<Map<String,String>> pendingRequests = new ArrayList<>();
    List<Map<String,String>> approvedRequests = new ArrayList<>();
    List<Map<String,String>> rejectedRequests = new ArrayList<>();

//validate status
    if (requests != null) {
        for (Map<String,String> req : requests) {
            String status = req.get("status");
            if ("pending".equalsIgnoreCase(status)) {
                pendingRequests.add(req);
            } else if ("approved".equalsIgnoreCase(status)) {
                approvedRequests.add(req);
            } else if ("rejected".equalsIgnoreCase(status)) {
                rejectedRequests.add(req);
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard - Requests</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --bg-color: #1b1b1b;
            --sidebar-bg: #0f0f0f;
            --card-bg: #2a2a2a;
            --header-bg: #121212;
            --text-color: #fff;
            --muted-text: #ccc;
            --primary-color: #33b5e5;
            --border-color: #333;
            --input-bg: #3a3a3a;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            margin: 0;
        }

        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 220px;
            background-color: var(--sidebar-bg);
            padding-top: 20px;
            overflow-y: auto;
            z-index: 1030;
        }
        .sidebar a {
            color: var(--muted-text);
            text-decoration: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            transition: background-color 0.3s, color 0.3s;
        }
        .sidebar a:hover, .sidebar a:focus {
            background-color: #2a2a2a;
            color: var(--text-color);
            outline: none;
        }
        .sidebar a.active {
            background-color: var(--primary-color);
            color: #fff;
        }
        .sidebar h4 {
            color: #fff;
            margin-bottom: 1.5rem;
            text-align: center;
            font-weight: 700;
        }

        /* Header */
        .header-bar {
            position: fixed;
            top: 0;
            left: 220px;
            right: 0;
            height: 60px;
            background-color: var(--header-bg);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            border-bottom: 1px solid var(--border-color);
            z-index: 1040;
        }
        .header-bar h5 {
            margin: 0;
            font-weight: 600;
            color: #fff;
        }
        .header-bar a {
            color: var(--text-color);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }
        .header-bar a:hover {
            color: var(--primary-color);
        }

        /* Main Content */
        .main-content {
            margin-left: 220px;
            margin-top: 70px;
            padding: 2rem;
        }

        /* Summary cards */
        .summary {
            display: flex;
            gap: 20px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .card {
            flex: 1;
            min-width: 180px;
            padding: 20px;
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            text-align: center;
            transition: transform 0.2s;
            border: 1px solid var(--border-color);
        }

        .card:hover {
            transform: translateY(-3px);
        }

        .card h2 {
            margin: 0;
            font-size: 28px;
            color: var(--text-color);
        }

        .card p {
            margin: 8px 0 0;
            color: var(--muted-text);
            font-size: 14px;
        }

        /* Section titles */
        h2.section-title {
            margin-top: 40px;
            margin-bottom: 10px;
            color: var(--text-color);
            border-left: 5px solid var(--primary-color);
            padding-left: 10px;
            font-size: 20px;
        }

        /* Tables */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background: var(--card-bg);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        th {
            background: var(--input-bg);
            font-weight: 600;
            font-size: 14px;
            color: var(--muted-text);
        }

        tr:nth-child(even) {
            background: rgba(255,255,255,0.05);
        }

        tr:hover {
            background: rgba(51, 181, 229, 0.1);
        }

        /* Buttons - keeping original colors as requested */
        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: background 0.2s, transform 0.1s;
            margin-right: 5px;
        }

        .btn:hover {
            transform: scale(1.05);
        }

        .approve {
            background: #27ae60;
            color: white;
        }
        .approve:hover {
            background: #219150;
        }

        .reject {
            background: #e74c3c;
            color: white;
        }
        .reject:hover {
            background: #c0392b;
        }

        .pending {
            background: #f1c40f;
            color: black;
        }
        .pending:hover {
            background: #d4ac0d;
        }

        /* Tab Bar Styles */
        .tab-bar {
            display: flex;
            gap: 0;
            margin-top: 32px;
            margin-bottom: 0;
            border-radius: 12px 12px 0 0;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .tab-btn {
            flex: 1;
            padding: 16px 0;
            font-size: 17px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            outline: none;
            background: var(--input-bg);
            color: var(--muted-text);
            transition: background 0.2s, color 0.2s;
        }
        .tab-btn.active.pending {
            background: #f1c40f;
            color: #23272f;
        }
        .tab-btn.active.approved {
            background: #27ae60;
            color: #fff;
        }
        .tab-btn.active.rejected {
            background: #e74c3c;
            color: #fff;
        }
        .tab-btn:not(.active):hover {
            background: rgba(255,255,255,0.1);
        }
        .tab-section {
            display: none;
            background: var(--card-bg);
            padding: 20px;
            border-radius: 0 0 12px 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        .tab-section.active {
            display: block;
        }

        /* Responsive */
        @media (max-width: 767.98px) {
            .sidebar { position: relative; width: 100%; height: auto; padding: 10px 0; }
            .header-bar { left: 0; }
            .main-content { margin-left: 0; margin-top: 20px; padding: 1rem; }
        }
    </style>
    <script>
        function showTab(tab) {
            document.getElementById('pendingTab').classList.remove('active');
            document.getElementById('approvedTab').classList.remove('active');
            document.getElementById('rejectedTab').classList.remove('active');
            document.getElementById('pendingSection').classList.remove('active');
            document.getElementById('approvedSection').classList.remove('active');
            document.getElementById('rejectedSection').classList.remove('active');
            document.getElementById(tab + 'Tab').classList.add('active');
            document.getElementById(tab + 'Section').classList.add('active');
        }
        window.onload = function() {
            showTab('pending');
        }
    </script>
</head>
<body>

<!-- Sidebar -->
<nav class="sidebar" aria-label="Sidebar Navigation">
    <h4>Support Admin</h4>
    <a href="admindashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
    <a href="ManageTicketsServlet"><i class="fas fa-ticket-alt"></i> Manage Tickets</a>
    <a href="AdminRequestsServlet" class="active"><i class="fas fa-plus-circle"></i> Manage request resources</a>
    <a href="listFAQAdmin.jsp"><i class="fas fa-plus-circle"></i> Manage FAQ</a>
    <a href="ViewAllRepliesServlet"><i class="fas fa-hourglass-half"></i> Replied Tickets</a>
    <a href="FeedbackListServlet"><i class="fas fa-check-circle"></i> Feedbacks</a>
    <a href="add-staff.jsp"><i class="fas fa-users"></i> Add Staffs</a>
    <a href="manage-users"><i class="fas fa-play-circle"></i> Manage Users</a>
    <a href="profile.jsp"><i class="fas fa-cog"></i> Profile Settings</a>
</nav>

<!-- Header Bar -->
<header class="header-bar">
    <h5><i class="fas fa-tasks me-2"></i>Resource Requests</h5>
    <a href="admindashboard.jsp"><i class="fas fa-arrow-left me-2"></i>Back to Dashboard</a>
</header>

<!-- Main Content -->
<main class="main-content" role="main">
    <div class="summary">
        <div class="card">
            <h2><%= request.getAttribute("totalCount") != null ? request.getAttribute("totalCount") : "-" %></h2>
            <p>Total Requests</p>
        </div>
        <div class="card">
            <h2><%= request.getAttribute("pendingCount") != null ? request.getAttribute("pendingCount") : "-" %></h2>
            <p>Pending</p>
        </div>
        <div class="card" style="border: 2px solid #27ae60; background: rgba(39, 174, 96, 0.1);">
            <h2 style="color:#27ae60;"><%= request.getAttribute("approvedCount") != null ? request.getAttribute("approvedCount") : "-" %></h2>
            <p style="color:#2ecc71;">Approved</p>
        </div>
        <div class="card" style="border: 2px solid #e74c3c; background: rgba(231, 76, 60, 0.1);">
            <h2 style="color:#e74c3c;"><%= request.getAttribute("rejectedCount") != null ? request.getAttribute("rejectedCount") : "-" %></h2>
            <p style="color:#ec7063;">Rejected</p>
        </div>
    </div>

    <!-- Tab Bar -->
    <div class="tab-bar">
        <button id="pendingTab" class="tab-btn pending" onclick="showTab('pending')">
            ⏳ Pending (<%= pendingRequests.size() %>)
        </button>
        <button id="approvedTab" class="tab-btn approved" onclick="showTab('approved')">
            ✅ Approved (<%= approvedRequests.size() %>)
        </button>
        <button id="rejectedTab" class="tab-btn rejected" onclick="showTab('rejected')">
            ❌ Rejected (<%= rejectedRequests.size() %>)
        </button>
    </div>

    <!-- Pending Section -->
    <div id="pendingSection" class="tab-section">
        <h2 class="section-title">⏳ Pending Requests</h2>
        <table>
            <tr>
                <th>ID</th><th>Title</th><th>Author</th><th>Type</th><th>Justification</th><th>Actions</th>
            </tr>
            <%
                for (Map<String,String> req : pendingRequests) {
            %>
            <tr>
                <td><%= req.get("id") %></td>
                <td><%= req.get("title") %></td>
                <td><%= req.get("author") %></td>
                <td><%= req.get("type") %></td>
                <td><%= req.get("justification") %></td>
                <td>
                    <form action="ApproveRejectServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= req.get("id") %>">
                        <input type="hidden" name="action" value="approve">
                        <button type="submit" class="btn approve">Approve</button>
                    </form>
                    <form action="ApproveRejectServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= req.get("id") %>">
                        <input type="hidden" name="action" value="reject">
                        <button type="submit" class="btn reject">Reject</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
    </div>

    <!-- Approved Section -->
    <div id="approvedSection" class="tab-section">
        <h2 class="section-title">✅ Approved Requests</h2>
        <table>
            <tr>
                <th>ID</th><th>Title</th><th>Author</th><th>Type</th><th>Justification</th><th>Actions</th>
            </tr>
            <%
                for (Map<String,String> req : approvedRequests) {
            %>
            <tr>
                <td><%= req.get("id") %></td>
                <td><%= req.get("title") %></td>
                <td><%= req.get("author") %></td>
                <td><%= req.get("type") %></td>
                <td><%= req.get("justification") %></td>
                <td>
                    <form action="ApproveRejectServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= req.get("id") %>">
                        <input type="hidden" name="action" value="pending">
                        <button type="submit" class="btn pending">Move to Pending</button>
                    </form>
                    <form action="ApproveRejectServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= req.get("id") %>">
                        <input type="hidden" name="action" value="reject">
                        <button type="submit" class="btn reject">Reject</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
    </div>

    <!-- Rejected Section -->
    <div id="rejectedSection" class="tab-section">
        <h2 class="section-title">❌ Rejected Requests</h2>
        <table>
            <tr>
                <th>ID</th><th>Title</th><th>Author</th><th>Type</th><th>Justification</th><th>Actions</th>
            </tr>
            <%
                for (Map<String,String> req : rejectedRequests) {
            %>
            <tr>
                <td><%= req.get("id") %></td>
                <td><%= req.get("title") %></td>
                <td><%= req.get("author") %></td>
                <td><%= req.get("type") %></td>
                <td><%= req.get("justification") %></td>
                <td>
                    <form action="ApproveRejectServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= req.get("id") %>">
                        <input type="hidden" name="action" value="pending">
                        <button type="submit" class="btn pending">Move to Pending</button>
                    </form>
                    <form action="ApproveRejectServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= req.get("id") %>">
                        <input type="hidden" name="action" value="approve">
                        <button type="submit" class="btn approve">Approve</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</main>

</body>
</html>