<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        body { background-color: #1b1b1b; color: #fff; min-height: 100vh; margin: 0; }
        .sidebar { position: fixed; top: 0; left: 0; height: 100vh; width: 220px; background-color: #0f0f0f; padding-top: 20px; overflow-y: auto; z-index: 1030; }
        .main-content { margin-left: 220px; padding: 2rem; min-height: 100vh; }
        .header-bar { position: fixed; top: 0; left: 220px; right: 0; height: 60px; background-color: #121212; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; border-bottom: 1px solid #333; z-index: 1040; }
        .header-bar h5 { margin: 0; font-weight: 600; color: #fff; }
        .logout-btn { background: #ff4444; border: none; color: #fff; padding: 8px 16px; border-radius: 20px; font-size: 0.9rem; transition: background 0.3s; }
        .logout-btn:hover { background: #cc0000; }
        .main-content { margin-top: 70px; }
        .sidebar a { color: #ccc; text-decoration: none; padding: 12px 20px; display: flex; align-items: center; gap: 10px; font-weight: 500; transition: background-color 0.3s, color 0.3s; }
        .sidebar a:hover, .sidebar a:focus { background-color: #2a2a2a; color: #fff; outline: none; }
        .sidebar h4 { color: #fff; margin-bottom: 1.5rem; text-align: center; font-weight: 700; }
        .card { border: none; border-radius: 10px; }
        .card-green { background-color: #00c851; }
        .card-blue { background-color: #33b5e5; }
        .card-red { background-color: #ff4444; }
        .status-badge { padding: 5px 12px; border-radius: 15px; font-size: 0.85rem; font-weight: 600; color: #fff; display: inline-block; min-width: 70px; text-align: center; }
        .status-new { background-color: #33b5e5; }
        .status-pending { background-color: #ffbb33; color: #000; }
        .status-solved { background-color: #00c851; }
        table { color: #fff; }
        @media (max-width: 767.98px) {
            .sidebar { position: relative; width: 100%; height: auto; padding: 10px 0; overflow-y: visible; }
            .header-bar { left: 0; }
            .main-content { margin-left: 0; margin-top: 70px; padding: 1rem; }
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<nav class="sidebar">
    <h4>Welcome </h4>
    <a href="ManageTicketsServlet"><i class="fas fa-ticket-alt"></i> Manage Tickets</a>
    <a href="listFAQAdmin.jsp"><i class="fas fa-question-circle"></i> ADD BOOKS</a>
    <a href="ViewAllRepliesServlet"><i class="fas fa-hourglass-half"></i> Replied Tickets</a>
    <a href="feedbacks.jsp?type=solved"><i class="fas fa-check-circle"></i> Feedbacks</a>
    <a href="profile.jsp"><i class="fas fa-cog"></i> Profile Settings</a>
</nav>

<!-- Header Bar -->
<header class="header-bar">
    <h5>Staff Dashboard</h5>
    <a href="mainpage.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
</header>

<!-- Main Content -->
<main class="main-content">

    <%
        int totalTickets = 0, solvedTickets = 0, pendingTickets = 0;
        List<Map<String,String>> ticketsList = new ArrayList<>();
        List<Map<String,String>> staffList = new ArrayList<>();

        try (Connection conn = com.example.demo.utils.DBConnection.getConnection()) {

            // Tickets stats
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM tickets");
                 ResultSet rs = ps.executeQuery()) {
                if(rs.next()) totalTickets = rs.getInt("total");
            }

            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS solved FROM tickets WHERE status='Solved'");
                 ResultSet rs = ps.executeQuery()) {
                if(rs.next()) solvedTickets = rs.getInt("solved");
            }
            pendingTickets = totalTickets - solvedTickets;

            // Latest 10 tickets
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT TOP 10 id, username, email, category, status, created_at FROM tickets ORDER BY created_at DESC");
                 ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    Map<String,String> t = new HashMap<>();
                    t.put("id", rs.getString("id"));
                    t.put("username", rs.getString("username"));
                    t.put("email", rs.getString("email"));
                    t.put("category", rs.getString("category"));
                    t.put("status", rs.getString("status"));
                    t.put("created_at", rs.getString("created_at"));
                    ticketsList.add(t);
                }
            }

            // Staff members
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT firstName, lastName, email, role FROM Staff ORDER BY firstName ASC");
                 ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    Map<String,String> s = new HashMap<>();
                    s.put("firstName", rs.getString("firstName"));
                    s.put("lastName", rs.getString("lastName"));
                    s.put("email", rs.getString("email"));
                    s.put("role", rs.getString("role"));
                    staffList.add(s);
                }
            }

        } catch(Exception e) {
            out.println("<div class='alert alert-danger'>Database error: "+e.getMessage()+"</div>");
        }
    %>

    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-md-4 mb-3">
            <div class="card card-green text-white p-3">
                <h5>All Tickets</h5>
                <h2><%= totalTickets %></h2>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card card-blue text-white p-3">
                <h5>Solved Tickets</h5>
                <h2><%= solvedTickets %></h2>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card card-red text-white p-3">
                <h5>Pending Tickets</h5>
                <h2><%= pendingTickets %></h2>
            </div>
        </div>
    </div>

    <!-- Tickets Table -->
    <div class="row">
        <div class="col-md-8 mb-3">
            <div class="card p-3">
                <h5>Recent Tickets</h5>
                <div class="table-responsive">
                    <table class="table table-dark table-hover mb-0">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Category</th>
                            <th>Created At</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            for(Map<String,String> t: ticketsList){
                        %>
                        <tr>
                            <td><%= t.get("id") %></td>
                            <td><%= t.get("username") %></td>
                            <td><%= t.get("email") %></td>
                            <td><%= t.get("category") %></td>
                            <td><%= t.get("created_at") %></td>
                            <td>
                            <span class="status-badge status-<%= t.get("status").toLowerCase() %>">
                                <%= t.get("status") %>
                            </span>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Staff Table -->
        <div class="col-md-4 mb-3">
            <div class="card p-3">
                <h5>Staff Members</h5>
                <div class="table-responsive">
                    <table class="table table-dark table-hover mb-0">
                        <thead>
                        <tr>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Email</th>
                            <th>Role</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            for(Map<String,String> s: staffList){
                        %>
                        <tr>
                            <td><%= s.get("firstName") %></td>
                            <td><%= s.get("lastName") %></td>
                            <td><%= s.get("email") %></td>
                            <td><%= s.get("role") %></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart -->
    <div class="card mt-4 p-3">
        <h5>Tickets Statistics</h5>
        <canvas id="statsChart" style="max-height:300px;width:100%;"></canvas>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const ctx = document.getElementById('statsChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['All Tickets', 'Solved Tickets', 'Pending Tickets'],
                datasets: [{
                    label: 'Ticket Count',
                    data: [<%= totalTickets %>, <%= solvedTickets %>, <%= pendingTickets %>],
                    backgroundColor: ['#33b5e5', '#00c851', '#ffbb33']
                }]
            },
            options: { responsive:true, maintainAspectRatio:false }
        });
    </script>

</main>
</body>
</html>
