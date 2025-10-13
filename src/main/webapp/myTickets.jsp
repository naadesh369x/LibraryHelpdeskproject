<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.example.demo.utils.DBConnection" %>
<%
    HttpSession session1 = request.getSession(false);
    String email = (session1 != null) ? (String) session1.getAttribute("email") : null;
    if(email == null){
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }

    // Get user details
    String firstName = "", lastName = "";
    int userId = 0;
    try(Connection conn = DBConnection.getConnection()){
        String userSql = "SELECT userId, firstName, lastName FROM members WHERE email=?";
        try(PreparedStatement ps = conn.prepareStatement(userSql)){
            ps.setString(1, email);
            try(ResultSet rs = ps.executeQuery()){
                if(rs.next()){
                    userId = rs.getInt("userId");
                    firstName = rs.getString("firstName");
                    lastName = rs.getString("lastName");
                }
            }
        }
    } catch(Exception e){ e.printStackTrace(); }

    List<Map<String,String>> ticketsList = new ArrayList<>();
    try(Connection conn = DBConnection.getConnection()){
        // Updated to use userId instead of email for foreign key relationship
        String sql = "SELECT * FROM tickets WHERE userId = ? ORDER BY created_at DESC";
        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, userId);
            try(ResultSet rs = ps.executeQuery()){
                while(rs.next()){
                    Map<String,String> ticket = new HashMap<>();
                    ticket.put("ticketId", String.valueOf(rs.getInt("ticketId")));
                    ticket.put("category", rs.getString("category"));
                    ticket.put("status", rs.getString("status"));
                    ticket.put("description", rs.getString("description"));
                    ticket.put("created_at", rs.getTimestamp("created_at").toString());
                    ticketsList.add(ticket);
                }
            }
        }
    } catch(Exception e){ e.printStackTrace(); }

    String selectedTicketId = request.getParameter("ticketId");
    Map<String,String> currentTicket = null;
    List<Map<String,String>> repliesList = new ArrayList<>();
    if(selectedTicketId != null){
        try(Connection conn = DBConnection.getConnection()){
            // Ticket info - updated to use ticketId instead of id
            String ticketSql = "SELECT * FROM tickets WHERE ticketId=? AND userId=?";
            try(PreparedStatement ps = conn.prepareStatement(ticketSql)){
                ps.setInt(1, Integer.parseInt(selectedTicketId));
                ps.setInt(2, userId);
                try(ResultSet rs = ps.executeQuery()){
                    if(rs.next()){
                        currentTicket = new HashMap<>();
                        currentTicket.put("ticketId", String.valueOf(rs.getInt("ticketId")));
                        currentTicket.put("category", rs.getString("category"));
                        currentTicket.put("status", rs.getString("status"));
                        currentTicket.put("description", rs.getString("description"));
                        currentTicket.put("created_at", rs.getTimestamp("created_at").toString());
                    }
                }
            }

            // Fetch replies for the selected ticket
            if(currentTicket != null){
                String replySql = "SELECT * FROM ticket_replies WHERE ticket_id=? ORDER BY created_at ASC";
                try(PreparedStatement ps2 = conn.prepareStatement(replySql)){
                    ps2.setInt(1, Integer.parseInt(selectedTicketId));
                    try(ResultSet rs2 = ps2.executeQuery()){
                        while(rs2.next()){
                            Map<String,String> reply = new HashMap<>();
                            reply.put("message", rs2.getString("message"));
                            reply.put("created_at",
                                    rs2.getTimestamp("created_at") != null
                                            ? rs2.getTimestamp("created_at").toString()
                                            : "");
                            repliesList.add(reply);
                        }
                    }
                }
            }
        } catch(Exception e){ e.printStackTrace(); }
    }

    String successMsg = (String) session.getAttribute("ticketSuccess");
    String errorMsg = request.getParameter("error");

    // Clear success message from session after displaying
    if(successMsg != null) {
        session.removeAttribute("ticketSuccess");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tickets - Library Help Desk</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #6c757d;
            --success-color: #2ecc71;
            --info-color: #3498db;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --white: #ffffff;
            --gray-light: #f1f3f5;
            --gray-medium: #dee2e6;
            --gray-dark: #6c757d;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background-color: #f5f7fb;
            color: var(--dark-color);
            position: relative;
        }

        .container-fluid {
            position: relative;
            z-index: 1;
            width: 100%;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .header-section {
            background: var(--white);
            padding: 15px 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 5;
        }

        .header-section h2 {
            margin: 0;
            font-size: 24px;
            color: var(--primary-color);
        }

        .header-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 8px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), #3f37c9);
            color: var(--white);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #3f37c9, #4361ee);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(67, 97, 238, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color), #c0392b);
            color: var(--white);
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c0392b, #e74c3c);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary-color), #5a6268);
            color: var(--white);
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #5a6268, #6c757d);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
        }

        .content-section {
            flex: 1;
            display: flex;
            padding: 20px;
            gap: 20px;
        }

        .ticket-list {
            width: 30%;
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .ticket-list-header {
            background: linear-gradient(135deg, var(--primary-color), #3f37c9);
            color: var(--white);
            padding: 15px 20px;
            font-weight: 600;
        }

        .ticket-list-body {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
        }

        .ticket-item {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 10px;
            background: var(--gray-light);
            cursor: pointer;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .ticket-item:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-left-color: var(--primary-color);
        }

        .ticket-item.active {
            background: rgba(67, 97, 238, 0.1);
            border-left-color: var(--primary-color);
        }

        .ticket-item-title {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .ticket-item-meta {
            font-size: 12px;
            color: var(--gray-dark);
        }

        .ticket-details {
            flex: 1;
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .ticket-details-header {
            background: linear-gradient(135deg, var(--primary-color), #3f37c9);
            color: var(--white);
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .ticket-details-body {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
        }

        .ticket-info-table {
            margin-bottom: 20px;
        }

        .ticket-info-table th {
            width: 120px;
            font-weight: 600;
            color: var(--dark-color);
        }

        .description-section {
            margin-bottom: 20px;
        }

        .description-box {
            width: 100%;
            border: 1px solid var(--gray-medium);
            border-radius: 10px;
            padding: 12px;
            font-size: 14px;
            background: var(--gray-light);
            resize: none;
            min-height: 100px;
        }

        .replies-section {
            margin-top: 20px;
        }

        .reply-item {
            background: var(--gray-light);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            border-left: 4px solid var(--primary-color);
        }

        .reply-time {
            font-size: 12px;
            color: var(--gray-dark);
            margin-bottom: 5px;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--gray-dark);
        }

        .empty-state i {
            font-size: 48px;
            color: var(--gray-medium);
            margin-bottom: 15px;
        }

        .status-badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-new {
            background-color: rgba(52, 152, 219, 0.2);
            color: var(--info-color);
        }

        .status-pending {
            background-color: rgba(243, 156, 18, 0.2);
            color: var(--warning-color);
        }

        .status-solved {
            background-color: rgba(46, 204, 113, 0.2);
            color: var(--success-color);
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 10px;
            border: 1px solid transparent;
        }

        .alert-success {
            background-color: rgba(46, 204, 113, 0.1);
            color: var(--success-color);
            border-color: var(--success-color);
        }

        .alert-danger {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger-color);
            border-color: var(--danger-color);
        }

        @media (max-width: 991.98px) {
            .content-section {
                flex-direction: column;
            }

            .ticket-list {
                width: 100%;
                max-height: 300px;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <!-- Header Section -->
    <div class="header-section">
        <div>
            <a href="dashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back
            </a>
        </div>
        <h2>My Tickets</h2>
        <div class="header-actions">
            <a href="submitTicket.jsp" class="btn btn-primary">
                <i class="fas fa-plus"></i> New Ticket
            </a>
            <a href="mainpage.jsp" class="btn btn-danger">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <!-- Content Section -->
    <div class="content-section">
        <!-- Success/Error Messages -->
        <% if(successMsg != null){ %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i> <%= successMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        <% if(errorMsg != null){ %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i> <%= errorMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Ticket List -->
        <div class="ticket-list">
            <div class="ticket-list-header">
                <i class="fas fa-ticket-alt me-2"></i> My Tickets
            </div>
            <div class="ticket-list-body">
                <% if(ticketsList != null && !ticketsList.isEmpty()){
                    for(Map<String,String> ticket : ticketsList){
                        boolean isActive = selectedTicketId != null && selectedTicketId.equals(ticket.get("ticketId"));
                %>
                <div class="ticket-item <%= isActive ? "active" : "" %>"
                     onclick="window.location.href='myTickets.jsp?ticketId=<%=ticket.get("ticketId")%>'">
                    <div class="ticket-item-title">Ticket #<%= ticket.get("ticketId") %></div>
                    <div class="ticket-item-meta">
                        Category: <%= ticket.get("category") %> |
                        Status: <span class="status-badge status-<%= ticket.get("status").toLowerCase() %>"><%= ticket.get("status") %></span>
                    </div>
                </div>
                <% }} else { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>No tickets found.</p>
                    <a href="submitTicket.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Create Your First Ticket
                    </a>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Ticket Details -->
        <div class="ticket-details">
            <div class="ticket-details-header">
                <h5><%= (currentTicket != null) ? "Ticket #" + currentTicket.get("ticketId") : "Select a Ticket" %></h5>
                <div class="d-flex align-items-center gap-2">
                    <% if(currentTicket != null){
                        String status = currentTicket.get("status");
                    %>
                    <span class="status-badge status-<%= status.toLowerCase() %>">
                        <%= status %>
                    </span>
                    <form method="post" action="DeleteTicketServlet" style="display:inline;">
                        <input type="hidden" name="ticketId" value="<%= currentTicket.get("ticketId") %>">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Are you sure you want to delete this ticket?');">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </form>
                    <% } %>
                </div>
            </div>

            <div class="ticket-details-body">
                <% if(currentTicket != null){ %>
                <table class="table table-borderless ticket-info-table">
                    <tbody>
                    <tr>
                        <th>Category</th>
                        <td><%= currentTicket.get("category") %></td>
                    </tr>
                    <tr>
                        <th>Status</th>
                        <td><span class="status-badge status-<%= currentTicket.get("status").toLowerCase() %>"><%= currentTicket.get("status") %></span></td>
                    </tr>
                    <tr>
                        <th>Created At</th>
                        <td><%= currentTicket.get("created_at") %></td>
                    </tr>
                    <tr>
                        <th>Email</th>
                        <td><%= email %></td>
                    </tr>
                    </tbody>
                </table>

                <div class="description-section">
                    <h6>Description</h6>
                    <form action="EditTicketServlet" method="post" id="editForm">
                        <input type="hidden" name="ticketId" value="<%= currentTicket.get("ticketId") %>">
                        <div class="d-flex align-items-start">
                            <textarea name="description" id="description" class="description-box" readonly required><%= currentTicket.get("description") %></textarea>
                            <div class="ms-2 d-flex flex-column">
                                <button type="button" class="btn btn-secondary btn-sm mb-2" id="editBtn"
                                        onclick="enableEdit()">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <button type="submit" class="btn btn-primary btn-sm" id="saveBtn" style="display:none;">
                                    <i class="fas fa-save"></i> Save
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="replies-section">
                    <h6>Replies</h6>
                    <% if(repliesList != null && !repliesList.isEmpty()){
                        for(Map<String,String> reply: repliesList){ %>
                    <div class="reply-item">
                        <div class="reply-time"><i class="far fa-clock me-1"></i> <%= reply.get("created_at") %></div>
                        <div><%= reply.get("message") %></div>
                    </div>
                    <% } } else { %>
                    <div class="empty-state">
                        <i class="fas fa-comments"></i>
                        <p>No replies yet.</p>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-mouse-pointer"></i>
                    <p>Select a ticket to view details and replies</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function enableEdit() {
        document.getElementById('description').removeAttribute('readonly');
        document.getElementById('editBtn').style.display = 'none';
        document.getElementById('saveBtn').style.display = 'inline-block';
        document.getElementById('description').focus();
    }
</script>
</body>
</html>