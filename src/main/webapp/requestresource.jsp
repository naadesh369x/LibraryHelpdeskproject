<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String,String>> requestList = (List<Map<String,String>>) request.getAttribute("requestList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Resource Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #eef2f3, #dfe9f3);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 30px 20px;
        }
        h2 {
            text-align: center;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 30px;
        }
        .table {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
        }
        .badge {
            font-size: 0.85em;
            padding: 8px 12px;
            border-radius: 20px;
        }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-approved { background: #d4edda; color: #155724; }
        .badge-rejected { background: #f8d7da; color: #721c24; }
        .no-req {
            text-align: center;
            font-size: 18px;
            color: #7f8c8d;
            margin-top: 30px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📚 My Resource Requests</h2>

    <% if (requestList != null && !requestList.isEmpty()) { %>
    <div class="table-responsive shadow">
        <table class="table table-bordered table-hover align-middle text-center">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Author</th>
                <th>Type</th>
                <th>Justification</th>
                <th>Status</th>
                <th>Requested On</th>
            </tr>
            </thead>
            <tbody>
            <% for (Map<String,String> req : requestList) {
                String status = req.get("status");
                String badgeClass = "badge-pending";
                if ("Approved".equalsIgnoreCase(status)) badgeClass = "badge-approved";
                else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "badge-rejected";
            %>
            <tr>
                <td><%= req.get("id") %></td>
                <td><%= req.get("title") %></td>
                <td><%= req.get("author") %></td>
                <td><%= req.get("type") %></td>
                <td><%= req.get("justification") %></td>
                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                <td><%= req.get("created_at") %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
    <p class="no-req">⚠ You haven’t submitted any requests yet.</p>
    <% } %>
</div>
</body>
</html>
