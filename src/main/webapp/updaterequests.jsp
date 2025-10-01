<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String,String>> requests = (List<Map<String,String>>) request.getAttribute("requests");

    List<Map<String,String>> pendingRequests = new ArrayList<>();
    List<Map<String,String>> approvedRequests = new ArrayList<>();
    List<Map<String,String>> rejectedRequests = new ArrayList<>();

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
    <header>
        <h1>📊 Admin Dashboard - Requests</h1>
        <a href="admin-dashboard" class="btn">⬅ Back to Dashboard</a>
    </header>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            margin: 20px;
            background: #f5f7fa;
            color: #333;
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
        }

        h2.section-title {
            margin-top: 40px;
            margin-bottom: 10px;
            color: #34495e;
            border-left: 5px solid #3498db;
            padding-left: 10px;
            font-size: 20px;
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
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.2s;
        }

        .card:hover {
            transform: translateY(-3px);
        }

        .card h2 {
            margin: 0;
            font-size: 28px;
            color: #2c3e50;
        }

        .card p {
            margin: 8px 0 0;
            color: #777;
            font-size: 14px;
        }

        /* Tables */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
        }

        th {
            background: #ecf0f1;
            font-weight: 600;
            font-size: 14px;
        }

        tr:nth-child(even) {
            background: #f9f9f9;
        }

        tr:hover {
            background: #f1f7fd;
        }

        /* Buttons */
        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: background 0.2s, transform 0.1s;
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
            box-shadow: 0 2px 8px rgba(44,62,80,0.07);
        }
        .tab-btn {
            flex: 1;
            padding: 16px 0;
            font-size: 17px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            outline: none;
            background: #ecf0f1;
            color: #34495e;
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
            background: #dfe6e9;
        }
        .tab-section {
            display: none;
        }
        .tab-section.active {
            display: block;
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

<div class="summary">
    <div class="card">
        <h2><%= request.getAttribute("totalCount") != null ? request.getAttribute("totalCount") : "-" %></h2>
        <p>Total Requests</p>
    </div>
    <div class="card">
        <h2><%= request.getAttribute("pendingCount") != null ? request.getAttribute("pendingCount") : "-" %></h2>
        <p>Pending</p>
    </div>
    <div class="card" style="border: 2px solid #27ae60; background: #eafaf1;">
        <h2 style="color:#27ae60;"><%= request.getAttribute("approvedCount") != null ? request.getAttribute("approvedCount") : "-" %></h2>
        <p style="color:#219150;">Approved</p>
    </div>
    <div class="card" style="border: 2px solid #e74c3c; background: #fdeaea;">
        <h2 style="color:#e74c3c;"><%= request.getAttribute("rejectedCount") != null ? request.getAttribute("rejectedCount") : "-" %></h2>
        <p style="color:#c0392b;">Rejected</p>
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

</body>
</html>
