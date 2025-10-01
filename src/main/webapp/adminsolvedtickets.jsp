<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Ticket Replies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .table-container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            margin-top: 30px;
        }
        h2 {
            margin-bottom: 20px;
            font-weight: 600;
            color: #333;
        }
    </style>
</head>
<body>

<div class="container table-container">
    <h2>All Ticket Replies</h2>

    <%
        List<Map<String, Object>> replies = (List<Map<String, Object>>) request.getAttribute("replies");
        if (replies != null && !replies.isEmpty()) {
    %>
    <table class="table table-striped table-hover">
        <thead class="table-dark">
        <tr>
            <th>Username</th>
            <th>Category</th>
            <th>Sender</th>
            <th>Message</th>
            <th>Date & Time</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (Map<String, Object> reply : replies) {
                Map<String, String> ticket = (Map<String, String>) reply.get("ticket");
        %>
        <tr>
            <td><%= ticket.get("username") %></td>
            <td><%= ticket.get("category") %></td>
            <td><%= reply.get("sender") %></td>
            <td><%= reply.get("message") %></td>
            <td><%= reply.get("created_at") %></td>
            <td>
                <!-- Delete button -->
                <form action="DeleteReplyServlet" method="post" style="display:inline;">
                    <input type="hidden" name="replyId" value="<%= reply.get("id") %>">
                    <!-- ticketId optional, remove if not needed -->
                    <button type="submit" class="btn btn-danger btn-sm"
                            onclick="return confirm('Are you sure you want to delete this reply?');">
                        Delete
                    </button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
    } else {
    %>
    <div class="alert alert-info">No replies found.</div>
    <%
        }
    %>
</div>

</body>
</html>
