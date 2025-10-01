<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title><%= "Admin Dashboard" %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />

    <style>
        body {
            background-color: #1b1b1b;
            color: #fff;
            min-height: 100vh;
            margin: 0;
        }
        /* Fixed sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 220px;
            background-color: #0f0f0f;
            padding-top: 20px;
            overflow-y: auto;
            z-index: 1030;
        }
        /* Shift main content right to fit sidebar */
        .main-content {
            margin-left: 220px;
            padding: 2rem;
            min-height: 100vh;
        }
        .sidebar a {
            color: #ccc;
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
            color: #fff;
            outline: none;
        }
        .sidebar h4 {
            color: #fff;
            margin-bottom: 1.5rem;
            text-align: center;
            font-weight: 700;
        }
        .card {
            border: none;
            border-radius: 10px;
        }
        .card-green { background-color: #00c851; }
        .card-blue { background-color: #33b5e5; }
        .card-red { background-color: #ff4444; }
        .status-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
            color: #fff;
            display: inline-block;
            min-width: 70px;
            text-align: center;
        }
        .status-new { background-color: #33b5e5; }
        .status-pending { background-color: #ffbb33; color: #000; }
        .status-solved { background-color: #00c851; }
        /* Scrollable sidebar on small screens */
        @media (max-width: 767.98px) {
            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
                padding: 10px 0;
                overflow-y: visible;
            }
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<nav class="sidebar" aria-label="Sidebar Navigation">
    <h4>Support Admin</h4>
    <a href="admindashboard.jsp" aria-label="Dashboard"><i class="fas fa-home" aria-hidden="true"></i> Dashboard</a>
    <a href="ticketmanagment.jsp" aria-label="Tickets">
        <i class="fas fa-ticket-alt" aria-hidden="true"></i> Tickets
    </a>
    <a href="Books.jsp?type=new" aria-label="Manage Books">
        <i class="fas fa-plus-circle" aria-hidden="true"></i> Manage Books
    </a>
    <a href="ticketmanagment.jsp?type=pending" aria-label="Pending Tickets">
        <i class="fas fa-hourglass-half" aria-hidden="true"></i> Pending Tickets
    </a>
    <a href="feedbacks.jsp?type=solved" aria-label="Solved Tickets"><i class="fas fa-check-circle" aria-hidden="true"></i> Feedbacks</a>
    <a href="staff.jsp" aria-label="Staffs"><i class="fas fa-users" aria-hidden="true"></i>  Add Staffs</a>
    <a href="usermanagment.jsp" aria-label="Manage users">
        <i class="fas fa-user" aria-hidden="true"></i> Manage Clients
    </a>
    <a href="profile.jsp" aria-label="Settings"><i class="fas fa-cog" aria-hidden="true"></i> Profile Settings</a>
</nav>

<!-- Main Content -->
<main class="main-content" role="main">
    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-md-4 mb-3">
            <div class="card card-green text-white p-3">
                <h5>All Tickets</h5>
                <a href="TicketStatsServlet?type=new" style="color:inherit;text-decoration:none;"><h2>0</h2></a>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card card-blue text-white p-3">
                <h5>Solved Tickets</h5>
                <a href="TicketStatsServlet?type=solved" style="color:inherit;text-decoration:none;"><h2>0</h2></a>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card card-red text-white p-3">
                <h5>Pending Tickets</h5>
                <a href="TicketStatsServlet?type=pending" style="color:inherit;text-decoration:none;"><h2>0</h2></a>
            </div>
        </div>
    </div>

    <!-- Tickets Table & New Clients -->
    <div class="row">
        <div class="col-md-8 mb-3">
            <div class="card p-3">
                <h5>Recent Tickets</h5>
                <div class="table-responsive">
                    <table class="table table-dark table-hover mb-0">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Title</th>
                            <th scope="col">Department</th>
                            <th scope="col">Date</th>
                            <th scope="col">Client</th>
                            <th scope="col">Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% 
                        // Read tickets from tickets.txt
                        String ticketsPath = application.getRealPath("/tickets.txt");
                        try (BufferedReader br = new BufferedReader(new FileReader(ticketsPath))) {
                            String line;
                            while ((line = br.readLine()) != null) {
                                // Assuming format: id|title|department|date|client|status
                                String[] parts = line.split("\\|");
                                if (parts.length == 6) {
                        %>
                        <tr>
                            <td><%= parts[0] %></td>
                            <td><%= parts[1] %></td>
                            <td><%= parts[2] %></td>
                            <td><%= parts[3] %></td>
                            <td><%= parts[4] %></td>
                            <td>
                                <span class="status-badge status-<%= parts[5].toLowerCase() %>">
                                    <%= parts[5] %>
                                </span>
                            </td>
                        </tr>
                        <%      }
                            }
                        } catch (Exception e) { %>
                        <tr><td colspan="6">No ticket data found.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card p-3">
                <h5>New Clients</h5>
                <ul class="list-group list-group-flush">
                    <% 
                    // Read users from users.txt
                    String usersPath = application.getRealPath("/users.txt");
                    try (BufferedReader br = new BufferedReader(new FileReader(usersPath))) {
                        String line;
                        while ((line = br.readLine()) != null) {
                            // Assuming format: username|created_at
                            String[] parts = line.split("\\|");
                            if (parts.length >= 2) {
                    %>
                    <li class="list-group-item bg-dark text-white">
                        <%= parts[0] %> - <%= parts[1] %>
                    </li>
                    <%      }
                        }
                    } catch (Exception e) { %>
                    <li class="list-group-item bg-dark text-white">No client data found.</li>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>

    <!-- Chart -->
    <div class="card mt-4 p-3">
        <h5>Statistics This Month</h5>
        <canvas id="statsChart" style="max-height: 300px; width: 100%;"></canvas>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('statsChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['01', '05', '10', '15', '20', '25'],
            datasets: [{
                label: 'Normal Visitors',
                data: [300, 500, 400, 800, 600, 900],
                borderColor: '#33b5e5',
                backgroundColor: 'rgba(51,181,229,0.2)',
                fill: true,
                tension: 0.3,
                pointRadius: 3,
            }, {
                label: 'Clients',
                data: [200, 300, 350, 600, 500, 700],
                borderColor: '#ff4444',
                backgroundColor: 'rgba(255,68,68,0.2)',
                fill: true,
                tension: 0.3,
                pointRadius: 3,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>

</body>
</html>
