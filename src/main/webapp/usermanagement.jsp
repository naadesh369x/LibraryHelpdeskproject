<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Users</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
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
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
        .sidebar h4 {
            color: var(--text-color);
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
            color: var(--text-color);
        }

        /* Main Content */
        .main-content {
            margin-left: 220px;
            margin-top: 70px;
            padding: 2rem;
        }

        /* Card & User Bubble Styles */
        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 10px;
        }
        .role-section { margin-bottom: 40px; }
        .role-title {
            font-size: 1.4em;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 18px;
            display: flex;
            align-items: center;
        }
        .bubble-container { display: flex; flex-wrap: wrap; gap: 24px; }
        .user-bubble {
            background: linear-gradient(135deg, #3a3a3a 60%, #444 100%);
            border-radius: 16px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.3);
            padding: 22px 18px 16px 18px;
            min-width: 220px; max-width: 260px;
            position: relative;
            transition: transform 0.18s, box-shadow 0.18s;
            border: 1px solid #4a4a4a;
        }
        .user-bubble:hover {
            transform: translateY(-4px) scale(1.02);
            box-shadow: 0 8px 32px rgba(0,0,0,0.5);
            border-color: var(--primary-color);
        }
        .bubble-avatar {
            width: 48px;
            height: 48px;
            background: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.7em;
            color: #fff;
            margin-bottom: 10px;
        }
        .bubble-name { font-weight: 500; color: var(--text-color); margin-bottom: 2px; }
        .bubble-email { font-size: 0.97em; color: var(--muted-text); margin-bottom: 6px; }
        .bubble-role { font-size: 0.92em; color: var(--primary-color); margin-bottom: 8px; }
        .bubble-actions { display: flex; gap: 8px; }
        .bubble-actions a {
            font-size: 0.92em;
            padding: 5px 12px;
            border-radius: 16px;
            color: #fff;
        }
        .bubble-actions .btn-warning { background-color: #ffbb33; border-color: #ffbb33; }
        .bubble-actions .btn-danger { background-color: #ff4444; border-color: #ff4444; }
        .bubble-count { font-size: 1em; color: var(--muted-text); margin-left: 10px; font-weight: 400; }
        .text-muted { color: #888; }

        /* Responsive */
        @media (max-width: 767.98px) {
            .sidebar { position: relative; width: 100%; height: auto; padding: 10px 0; }
            .header-bar { left: 0; }
            .main-content { margin-left: 0; margin-top: 20px; padding: 1rem; }
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<nav class="sidebar" aria-label="Sidebar Navigation">
    <h4>Support Admin</h4>
    <a href="admindashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
    <a href="ManageTicketsServlet"><i class="fas fa-ticket-alt"></i> Manage Tickets</a>
    <a href="AdminRequestsServlet"><i class="fas fa-plus-circle"></i> Manage request resources</a>
    <a href="listFAQAdmin.jsp"><i class="fas fa-plus-circle"></i> Manage FAQ</a>
    <a href="ViewAllRepliesServlet"><i class="fas fa-hourglass-half"></i> Replied Tickets</a>
    <a href="FeedbackListServlet"><i class="fas fa-check-circle"></i> Feedbacks</a>
    <a href="add-staff.jsp"><i class="fas fa-users"></i> Add Staffs</a>
    <a href="manage-users" class="active"><i class="fas fa-play-circle"></i> Manage Users</a>
    <a href="profile.jsp"><i class="fas fa-cog"></i> Profile Settings</a>
</nav>

<!-- Header Bar -->
<header class="header-bar">
    <h5>Manage Users</h5>
    <a href="admindashboard.jsp" class="btn btn-secondary btn-sm">Back to Dashboard</a>
</header>

<!-- Main Content -->
<main class="main-content" role="main">
    <div class="card shadow-lg p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>All Users</h2>
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

        <!-- Staff Section -->
        <div class="role-section">
            <div class="role-title">
                <i class="fas fa-user-tie me-2"></i>Staff Members
                <span class="bubble-count">(<%= staff.size() %>)</span>
            </div>
            <div class="bubble-container">
                <%
                    if (!staff.isEmpty()) {
                        for (Map<String, String> user : staff) {
                %>
                <div class="user-bubble">
                    <div class="bubble-avatar"><%= user.get("firstName").substring(0,1).toUpperCase() %></div>
                    <div class="bubble-name"><%= user.get("firstName") + " " + user.get("lastName") %></div>
                    <div class="bubble-email"><%= user.get("email") %></div>
                    <div class="bubble-role">Staff</div>
                    <div class="bubble-actions">
                        <a href="EditUserServlet?id=<%= user.get("staffid") %>&userType=Staff" class="btn btn-warning btn-sm"><i class="fas fa-edit"></i> Edit</a>
                        <a href="DeleteUserServlet?id=<%= user.get("staffid") %>&userType=Staff" class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this user?');"><i class="fas fa-trash"></i> Delete</a>
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
                <i class="fas fa-users me-2"></i>Members
                <span class="bubble-count">(<%= members.size() %>)</span>
            </div>
            <div class="bubble-container">
                <%
                    if (!members.isEmpty()) {
                        for (Map<String, String> user : members) {
                %>
                <div class="user-bubble">
                    <div class="bubble-avatar"><%= user.get("firstName").substring(0,1).toUpperCase() %></div>
                    <div class="bubble-name"><%= user.get("firstName") + " " + user.get("lastName") %></div>
                    <div class="bubble-email"><%= user.get("email") %></div>
                    <div class="bubble-role">Member</div>
                    <div class="bubble-actions">
                        <a href="EditUserServlet?id=<%= user.get("userid") %>&userType=Member" class="btn btn-warning btn-sm"><i class="fas fa-edit"></i> Edit</a>
                        <a href="DeleteUserServlet?id=<%= user.get("userid") %>&userType=Member" class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this user?');"><i class="fas fa-trash"></i> Delete</a>
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
</main>

</body>
</html>