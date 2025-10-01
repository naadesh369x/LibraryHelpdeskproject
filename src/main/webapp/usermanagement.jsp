<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .role-section {
            margin-bottom: 40px;
        }
        .role-title {
            font-size: 1.4em;
            font-weight: 600;
            color: #007bff;
            margin-bottom: 18px;
        }
        .bubble-container {
            display: flex;
            flex-wrap: wrap;
            gap: 24px;
        }
        .user-bubble {
            background: linear-gradient(135deg, #e3f2fd 60%, #fff 100%);
            border-radius: 32px;
            box-shadow: 0 4px 18px rgba(0,123,255,0.10);
            padding: 22px 18px 16px 18px;
            min-width: 220px;
            max-width: 260px;
            position: relative;
            transition: transform 0.18s, box-shadow 0.18s;
        }
        .user-bubble:hover {
            transform: translateY(-4px) scale(1.03);
            box-shadow: 0 8px 32px rgba(0,123,255,0.18);
        }
        .user-bubble .bubble-avatar {
            width: 48px;
            height: 48px;
            background: #90caf9;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.7em;
            color: #fff;
            margin-bottom: 10px;
        }
        .user-bubble .bubble-name {
            font-weight: 500;
            color: #333;
            margin-bottom: 2px;
        }
        .user-bubble .bubble-email {
            font-size: 0.97em;
            color: #555;
            margin-bottom: 6px;
        }
        .user-bubble .bubble-role {
            font-size: 0.92em;
            color: #007bff;
            margin-bottom: 8px;
        }
        .bubble-actions {
            display: flex;
            gap: 8px;
        }
        .bubble-actions a {
            font-size: 0.92em;
            padding: 5px 12px;
            border-radius: 16px;
        }
        .bubble-count {
            font-size: 1em;
            color: #555;
            margin-left: 10px;
        }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow-lg p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Manage Users</h2>
            <h5 class="text-primary">
                Total Users: <span class="badge bg-secondary">
                    <%
                        List<Map<String, String>> userList = (List<Map<String, String>>) request.getAttribute("users");
                        int totalUsers = (userList != null) ? userList.size() : 0;
                        out.print(totalUsers);
                    %>
                </span>
            </h5>
        </div>

        <%
            // Categorize users by role
            List<Map<String, String>> admins = new ArrayList<>();
            List<Map<String, String>> staff = new ArrayList<>();
            List<Map<String, String>> members = new ArrayList<>();
            if (userList != null) {
                for (Map<String, String> user : userList) {
                    String role = user.get("role");
                    if ("Admin".equalsIgnoreCase(role)) {
                        admins.add(user);
                    } else if ("Staff".equalsIgnoreCase(role)) {
                        staff.add(user);
                    } else {
                        members.add(user);
                    }
                }
            }
        %>

        <!-- Admins Section -->

        <!-- Staff Section -->
        <div class="role-section">
            <div class="role-title">
                Staff Members
                <span class="bubble-count">Count: <%= staff.size() %></span>
            </div>
            <div class="bubble-container">
                <%
                    if (!staff.isEmpty()) {
                        for (Map<String, String> user : staff) {
                %>
                <div class="user-bubble">
                    <div class="bubble-avatar">
                        <%= user.get("firstName").substring(0,1) %>
                    </div>
                    <div class="bubble-name"><%= user.get("firstName") + " " + user.get("lastName") %></div>
                    <div class="bubble-email"><%= user.get("email") %></div>
                    <div class="bubble-role">Staff</div>
                    <div class="bubble-actions">
                        <a href="EditUserServlet?id=<%= user.get("id") %>&userType=Staff"
                           class="btn btn-warning btn-sm">Edit</a>
                        <a href="DeleteUserServlet?id=<%= user.get("id") %>&userType=Staff"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="text-muted">No staff members found</div>
                <%
                    }
                %>
            </div>
        </div>

        <!-- Members Section -->
        <div class="role-section">
            <div class="role-title">
                Members
                <span class="bubble-count">Count: <%= members.size() %></span>
            </div>
            <div class="bubble-container">
                <%
                    if (!members.isEmpty()) {
                        for (Map<String, String> user : members) {
                %>
                <div class="user-bubble">
                    <div class="bubble-avatar">
                        <%= user.get("firstName").substring(0,1) %>
                    </div>
                    <div class="bubble-name"><%= user.get("firstName") + " " + user.get("lastName") %></div>
                    <div class="bubble-email"><%= user.get("email") %></div>
                    <div class="bubble-role">Member</div>
                    <div class="bubble-actions">
                        <a href="EditUserServlet?id=<%= user.get("id") %>&userType=Member"
                           class="btn btn-warning btn-sm">Edit</a>
                        <a href="DeleteUserServlet?id=<%= user.get("id") %>&userType=Member"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="text-muted">No members found</div>
                <%
                    }
                %>
            </div>
        </div>
        </div>

        <!-- Back to Dashboard button -->
        <div class="mt-3">
            <a href="admin-dashboard" class="btn btn-secondary">⬅ Back to Dashboard</a>
        </div>
    </div>
</div>

</body>
</html>
