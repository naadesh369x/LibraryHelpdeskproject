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
        .reply-list {
            background: #fff;
            padding: 20px;
            border-radius: 16px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            margin-top: 30px;
        }
        h2 {
            margin-bottom: 20px;
            font-weight: 600;
            color: #333;
        }
        .bubble-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 28px;
            justify-content: flex-start;
        }
        .reply-bubble {
            background: linear-gradient(135deg, #e3f2fd 70%, #fff 100%);
            border-radius: 32px;
            box-shadow: 0 4px 18px rgba(0,123,255,0.10);
            padding: 22px 18px 16px 18px;
            min-width: 320px;
            max-width: 400px;
            flex: 1 1 320px;
            transition: transform 0.18s, box-shadow 0.18s;
        }
        .reply-bubble:hover {
            transform: translateY(-4px) scale(1.03);
            box-shadow: 0 8px 32px rgba(0,123,255,0.18);
        }
        .bubble-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }
        .bubble-id {
            background: #90caf9;
            color: #fff;
            font-weight: 600;
            border-radius: 50%;
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1em;
        }
        .bubble-title {
            font-weight: 500;
            color: #007bff;
            font-size: 1.08em;
        }
        .bubble-info {
            font-size: 0.97em;
            color: #555;
            margin-bottom: 4px;
        }
        .bubble-label {
            font-weight: 600;
            color: #333;
            margin-right: 4px;
        }
        .bubble-message {
            background: #fffde7;
            border-radius: 12px;
            padding: 8px 12px;
            margin: 8px 0;
            font-size: 1em;
            color: #444;
            box-shadow: 0 1px 4px rgba(255,193,7,0.07);
        }
        .bubble-actions {
            display: flex;
            gap: 8px;
            margin-top: 10px;
        }
        .bubble-actions a {
            font-size: 0.92em;
            padding: 5px 12px;
            border-radius: 16px;
        }
        .bubble-date {
            font-size: 0.92em;
            color: #888;
            margin-top: 4px;
        }
    </style>
</head>
<body>

<div class="container reply-list">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>All Ticket Replies</h2>
        <a href="admin-dashboard" class="btn btn-secondary btn-sm">⬅ Back to Dashboard</a>
    </div>

    <%
        // replies is a List of Map<String,Object> where each reply has a "ticket" map inside
        List<Map<String, Object>> replies = (List<Map<String, Object>>) request.getAttribute("replies");
        if (replies != null && !replies.isEmpty()) {
    %>
    <div class="bubble-grid">
        <%
            for (Map<String, Object> reply : replies) {
                Map<String, Object> ticket = (Map<String, Object>) reply.get("ticket");
        %>
        <div class="reply-bubble">
            <div class="bubble-header">
                <div class="bubble-id"><%= reply.get("id") %></div>
                <div class="bubble-title">
                    Ticket #<%= ticket.get("id") %> - <%= ticket.get("category") %>
                </div>
            </div>
            <div class="bubble-info">
                <span class="bubble-label">Username:</span> <%= ticket.get("username") %>
            </div>
            <div class="bubble-info">
                <span class="bubble-label">Sender:</span> <%= reply.get("sender") %>
            </div>
            <div class="bubble-info">
                <span class="bubble-label">Ticket Description:</span> <%= ticket.get("description") %>
            </div>
            <div class="bubble-message">
                <span class="bubble-label">Reply:</span> <%= reply.get("message") %>
            </div>
            <div class="bubble-date">
                <span class="bubble-label">Date & Time:</span> <%= reply.get("created_at") %>
            </div>
            <div class="bubble-actions">
                <a href="EditReplyServlet?id=<%= reply.get("id") %>" class="btn btn-warning btn-sm">Edit</a>

                <a href="DeleteReplyServlet?id=<%= reply.get("id") %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Are you sure you want to delete this reply?');">
                    Delete
                </a>
            </div>
        </div>
        <%
            }
        %>
    </div>
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
