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
        @media (max-width: 767.98px) {
            .sidebar { position: relative; width: 100%; height: auto; padding: 10px 0; overflow-y: visible; }
            .header-bar { left: 0; }
            .main-content { margin-left: 0; margin-top: 70px; padding: 1rem; }
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
    <a href="listFAQAdmin.jsp"><i class="fas fa-question-circle"></i> Manage FAQ</a>
    <a href="ViewAllRepliesServlet"><i class="fas fa-hourglass-half"></i> Replied Tickets</a>
    <a href="FeedbackListServlet"><i class="fas fa-comment-dots"></i> Feedbacks</a>
    <a href="add-staff.jsp"><i class="fas fa-users"></i> Add Staffs</a>
    <a href="manage-users"><i class="fas fa-user-cog"></i> Manage Users</a>
    <a href="profile.jsp"><i class="fas fa-cog"></i> Profile Settings</a>
</nav>

<!-- Header Bar -->
<header class="header-bar">
    <h5>Admin Dashboard</h5>
    <a href="mainpage.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
</header>

<!-- Main Content -->
<main class="main-content" role="main">
    <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int totalTickets = 0, solvedTickets = 0, pendingTickets = 0;

        try {
            conn = com.example.demo.utils.DBConnection.getConnection();

            // Get Total Tickets
            ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM tickets");
            rs = ps.executeQuery();
            if(rs.next()) totalTickets = rs.getInt("total");
            rs.close(); ps.close();

            // Get Solved Tickets
            ps = conn.prepareStatement("SELECT COUNT(*) AS solved FROM tickets WHERE status='Solved'");
            rs = ps.executeQuery();
            if(rs.next()) solvedTickets = rs.getInt("solved");
            rs.close(); ps.close();

            // Get Pending Tickets
            ps = conn.prepareStatement("SELECT COUNT(*) AS pending FROM tickets WHERE status='Pending'");
            rs = ps.executeQuery();
            if(rs.next()) pendingTickets = rs.getInt("pending");
            rs.close(); ps.close();

        } catch(Exception e) {
            e.printStackTrace();
        }
    %>

    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-md-4 mb-3">
            <div class="card card-green text-white p-3"><h5>All Tickets</h5><h2><%= totalTickets %></h2></div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card card-blue text-white p-3"><h5>Solved Tickets</h5><h2><%= solvedTickets %></h2></div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card card-red text-white p-3"><h5>Pending Tickets</h5><h2><%= pendingTickets %></h2></div>
        </div>
    </div>

    <div class="row">
        <!-- Recent Tickets -->
        <div class="col-md-8 mb-3">
            <div class="card p-3">
                <h5>Recent Tickets</h5>
                <div class="table-responsive">
                    <table class="table table-dark table-hover mb-0">
                        <thead>
                        <tr>
                            <th>Ticket ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Category</th>
                            <th>Created At</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            try {
                                String sqlTickets = "SELECT TOP 10 ticketId, username, email, category, status, created_at FROM tickets ORDER BY created_at DESC";
                                ps = conn.prepareStatement(sqlTickets);
                                rs = ps.executeQuery();
                                while(rs.next()) {
                                    String status = rs.getString("status");
                        %>
                        <tr>
                            <td><%= rs.getInt("ticketId") %></td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("category") %></td>
                            <td><%= rs.getTimestamp("created_at") %></td>
                            <td><span class="status-badge status-<%= status.toLowerCase() %>"><%= status %></span></td>
                        </tr>
                        <%
                            }
                        } catch(Exception e) {
                        %>
                        <tr><td colspan="6" class="text-danger">Error fetching tickets: <%= e.getMessage() %></td></tr>
                        <%
                            } finally {
                                try { if(rs != null) rs.close(); } catch(SQLException e) { e.printStackTrace(); }
                                try { if(ps != null) ps.close(); } catch(SQLException e) { e.printStackTrace(); }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Staff Table -->
        <div class="col-md-4 mb-3">
            <div class="card p-3 mb-3">
                <h5>Staff Members</h5>
                <div class="table-responsive">
                    <table class="table table-dark table-hover mb-0">
                        <thead>
                        <tr>
                            <th>Staff ID</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Email</th>
                            <th>Age</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            PreparedStatement staffPs = null;
                            ResultSet staffRs = null;
                            try {
                                String sqlStaff = "SELECT TOP 5 staffid, firstName, lastName, email, age FROM Staff ORDER BY staffid DESC";
                                staffPs = conn.prepareStatement(sqlStaff);
                                staffRs = staffPs.executeQuery();
                                while(staffRs.next()) {
                        %>
                        <tr>
                            <td><%= staffRs.getInt("staffid") %></td>
                            <td><%= staffRs.getString("firstName") %></td>
                            <td><%= staffRs.getString("lastName") %></td>
                            <td><%= staffRs.getString("email") %></td>
                            <td><%= staffRs.getInt("age") %></td>
                        </tr>
                        <%
                            }
                        } catch(Exception e) {
                        %>
                        <tr><td colspan="5" class="text-danger">Error fetching staff: <%= e.getMessage() %></td></tr>
                        <%
                            } finally {
                                try { if(staffRs != null) staffRs.close(); } catch(SQLException e) { e.printStackTrace(); }
                                try { if(staffPs != null) staffPs.close(); } catch(SQLException e) { e.printStackTrace(); }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Members Table -->
            <div class="card p-3">
                <h5>New Members</h5>
                <div class="table-responsive">
                    <table class="table table-dark table-hover mb-0">
                        <thead>
                        <tr>
                            <th>User ID</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            PreparedStatement memberPs = null;
                            ResultSet memberRs = null;
                            try {
                                String sqlMembers = "SELECT TOP 5 userid, firstName, lastName, email, phoneNumber FROM Members ORDER BY userid DESC";
                                memberPs = conn.prepareStatement(sqlMembers);
                                memberRs = memberPs.executeQuery();
                                while(memberRs.next()) {
                        %>
                        <tr>
                            <td><%= memberRs.getInt("userid") %></td>
                            <td><%= memberRs.getString("firstName") %></td>
                            <td><%= memberRs.getString("lastName") %></td>
                            <td><%= memberRs.getString("email") %></td>
                            <td><%= memberRs.getString("phoneNumber") %></td>
                        </tr>
                        <%
                            }
                        } catch(Exception e) {
                        %>
                        <tr><td colspan="5" class="text-danger">Error fetching members: <%= e.getMessage() %></td></tr>
                        <%
                            } finally {
                                try { if(memberRs != null) memberRs.close(); } catch(SQLException e) { e.printStackTrace(); }
                                try { if(memberPs != null) memberPs.close(); } catch(SQLException e) { e.printStackTrace(); }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart Section -->
    <div class="card mt-4 p-3">
        <h5>Tickets Statistics</h5>
        <canvas id="statsChart" style="max-height: 300px; width: 100%;"></canvas>
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
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, ticks: { color: '#ccc' } },
                    x: { ticks: { color: '#ccc' } }
                },
                plugins: {
                    legend: { labels: { color: '#fff' } }
                }
            }
        });
    </script>

    <%
        // Close connection at the end
        try { if(conn != null) conn.close(); } catch(SQLException e) { e.printStackTrace(); }
    %>
</main>
</body>
</html>
