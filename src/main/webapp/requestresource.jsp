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
        /* Background Image */
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: url('images/library-bg.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 40px 20px;
        }

        /* Overlay */
        body::before {
            content: '';
            position: absolute;
            top:0; left:0;
            width:100%; height:100%;
            background: rgba(0,0,0,0.5);
            z-index: 0;
        }

        .container {
            position: relative;
            z-index: 1;
            max-width: 1000px;
            width: 100%;
        }

        h2 {
            text-align: center;
            font-weight: bold;
            color: #27ae60;
            margin-bottom: 30px;
        }

        .table-card {
            background: #fff;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.3);
        }

        .table {
            border-radius: 12px;
        }

        .table thead th {
            border-top: 0;
            border-bottom: 2px solid #dee2e6;
        }

        .badge {
            font-size: 0.85em;
            padding: 8px 12px;
            border-radius: 20px;
            font-weight: 500;
        }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-approved { background: #d4edda; color: #155724; }
        .badge-rejected { background: #f8d7da; color: #721c24; }

        .no-req {
            text-align: center;
            font-size: 18px;
            color: #f0f0f0;
            margin-top: 30px;
            background: rgba(0,0,0,0.5);
            padding: 15px 20px;
            border-radius: 10px;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(39,174,96,0.1);
        }

        @media (max-width: 768px) {
            .table-responsive {
                font-size: 14px;
            }
            h2 { font-size: 28px; }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📚 My Resource Requests</h2>

    <% if (requestList != null && !requestList.isEmpty()) { %>
    <div class="table-card table-responsive shadow">
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
