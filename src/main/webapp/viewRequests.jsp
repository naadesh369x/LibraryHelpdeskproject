<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String,String>> requestList = (List<Map<String,String>>) request.getAttribute("requestList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #e0f7fa, #f1f8e9);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 40px 20px;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            font-weight: bold;
            margin-bottom: 30px;
        }
        .table {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
        }
        .badge {
            font-size: 0.9em;
            padding: 8px 12px;
            border-radius: 30px;
        }
        .badge-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .badge-approved {
            background-color: #d4edda;
            color: #155724;
        }
        .badge-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }
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
    <h2>📌 My Requests</h2>

    <% if (requestList != null && !requestList.isEmpty()) { %>
    <div class="table-responsive shadow">
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-dark text-center">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Description</th>
                <th>Status</th>
                <th>Date</th>
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
                <td class="text-center"><%= req.get("id") %></td>
                <td><%= req.get("title") %></td>
                <td><%= req.get("justification") %></td>
                <td class="text-center">
                    <span class="badge <%= badgeClass %>"><%= status %></span>
                </td>
                <td class="text-center"><%= req.get("created_at") %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
    <p class="no-req">⚠ No requests found.</p>
    <% } %>
</div>
</body>
</html>
