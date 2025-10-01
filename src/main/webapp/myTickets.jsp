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

    List<Map<String,String>> ticketsList = new ArrayList<>();
    try(Connection conn = DBConnection.getConnection()){
        String sql = "SELECT * FROM tickets WHERE email = ? ORDER BY created_at DESC";
        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1, email);
            try(ResultSet rs = ps.executeQuery()){
                while(rs.next()){
                    Map<String,String> ticket = new HashMap<>();
                    ticket.put("id", String.valueOf(rs.getInt("id")));
                    ticket.put("category", rs.getString("category"));
                    ticket.put("status", rs.getString("status"));
                    ticket.put("description", rs.getString("description"));
                    ticket.put("created_at", rs.getTimestamp("created_at").toString());
                    ticketsList.add(ticket);
                }
            }
        }
    } catch(Exception e){ e.printStackTrace(); }

    // Get selected ticket details if "ticketId" parameter exists
    String selectedTicketId = request.getParameter("ticketId");
    Map<String,String> currentTicket = null;
    List<Map<String,String>> repliesList = new ArrayList<>();
    if(selectedTicketId != null){
        try(Connection conn = DBConnection.getConnection()){
            // Ticket info
            String ticketSql = "SELECT * FROM tickets WHERE id=? AND email=?";
            try(PreparedStatement ps = conn.prepareStatement(ticketSql)){
                ps.setInt(1, Integer.parseInt(selectedTicketId));
                ps.setString(2, email);
                try(ResultSet rs = ps.executeQuery()){
                    if(rs.next()){
                        currentTicket = new HashMap<>();
                        currentTicket.put("id", String.valueOf(rs.getInt("id")));
                        currentTicket.put("category", rs.getString("category"));
                        currentTicket.put("status", rs.getString("status"));
                        currentTicket.put("description", rs.getString("description"));
                        currentTicket.put("created_at", rs.getTimestamp("created_at").toString());
                    }
                }
            }

            // Fetch replies for the selected ticket (fixed table name)
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

    // Messages from servlet redirects
    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Tickets - Library Help Desk</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        html, body { height:100%; margin:0; font-family:'Segoe UI', sans-serif; background:#f4f6f9; }
        .top-bar { background:#2c3e50; color:white; padding:12px 30px; display:flex; justify-content:space-between; align-items:center; }
        .top-bar h2 { margin:0; font-size:24px; }
        .top-bar a { color:white; text-decoration:none; margin-left:10px; background:#3498db; padding:6px 12px; border-radius:5px; }
        .top-bar a:hover{ background:#2980b9; }
        .ticket-list { height:calc(100% - 80px); overflow-y:auto; background:#fff; border-right:1px solid #ddd; box-shadow:0 2px 8px rgba(0,0,0,0.07); }
        .ticket-item { cursor:pointer; padding:18px 20px; border-bottom:1px solid #eee; transition:0.2s; border-radius:8px; margin:8px 12px; }
        .ticket-item:hover { background-color:#e9ecef; box-shadow:0 2px 8px rgba(51,181,229,0.08); }
        .ticket-item strong { display:block; color:#0d6efd; font-size:16px; }
        .ticket-item small { color:#888; font-size:13px; }
        .ticket-details { background:#fff; height:100%; display:flex; flex-direction:column; padding:20px; box-shadow:0 2px 8px rgba(0,0,0,0.07); overflow-y:auto; }
        .ticket-header { background:linear-gradient(90deg,#0d6efd 60%,#33b5e5 100%); color:#fff; border-radius:12px; padding:18px 24px; margin-bottom:16px; display:flex; justify-content:space-between; align-items:center; }
        .ticket-header h5 { margin:0; font-size:22px; font-weight:600; letter-spacing:1px; }
        .description-box { height:120px; resize:none; border-radius:10px; padding:12px; font-size:14px; background-color:#f8f9fa; width:100%; border:1px solid #e2e6ea; margin-bottom:12px; }
        .reply-item { border-left:3px solid #0d6efd; padding-left:12px; margin-bottom:8px; font-size:14px; background:#f1f1f1; border-radius:5px; }
        .btn-primary, .btn-danger, .btn-secondary { font-size:14px; font-weight:500; border-radius:5px; box-shadow:0 1px 4px rgba(51,181,229,0.08); }
        @media (max-width:991.98px){ .ticket-list{height:auto; min-height:200px;} .ticket-details{padding:12px;} }
    </style>
</head>
<body>

<!-- Top Bar -->
<div class="top-bar">
    <div>
        <a href="dashboard.jsp" class="me-2"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </div>
    <h2>Library Help Desk</h2>
    <div>
        <a href="submitTicket.jsp"><i class="fas fa-plus"></i> Submit New Ticket</a>
        <a href="mainpage.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</div>

<div class="container-fluid h-100 mt-2">
    <% if(successMsg != null){ %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= successMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <% if(errorMsg != null){ %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= errorMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="row h-100">

        <!-- Left Panel -->
        <div class="col-md-4 p-0">
            <div class="ticket-list h-100">
                <div class="p-3 bg-dark text-white fw-bold">My Tickets</div>
                <%
                    if(ticketsList != null && !ticketsList.isEmpty()){
                        for(Map<String,String> ticket : ticketsList){
                %>
                <div class="ticket-item" onclick="window.location.href='myTickets.jsp?ticketId=<%=ticket.get("id")%>'">
                    <strong>Ticket #<%= ticket.get("id") %></strong>
                    <small>Category: <%= ticket.get("category") %> | Status: <%= ticket.get("status") %></small>
                </div>
                <% }} else { %>
                <div class="p-3 text-muted">No tickets found.</div>
                <% } %>
            </div>
        </div>

        <!-- Right Panel -->
        <div class="col-md-8 p-0">
            <div class="ticket-details h-100">
                <div class="ticket-header">
                    <h5><%= (currentTicket != null) ? "Ticket #" + currentTicket.get("id") : "Select a Ticket" %></h5>
                    <div class="d-flex align-items-center gap-2">
                        <% String status = (currentTicket != null) ? currentTicket.get("status") : "-"; %>
                        <span class="badge <%= "Solved".equalsIgnoreCase(status) ? "bg-success" :
                                               "Pending".equalsIgnoreCase(status) ? "bg-warning text-dark" : "bg-info" %>">
                            <%= status %>
                        </span>
                        <% if(currentTicket != null){ %>
                        <form method="post" action="DeleteTicketServlet" style="display:inline;">
                            <input type="hidden" name="ticketId" value="<%= currentTicket.get("id") %>">
                            <button type="submit" class="btn btn-danger btn-sm"
                                    onclick="return confirm('Are you sure you want to delete this ticket?');">
                                Delete
                            </button>
                        </form>
                        <% } %>
                    </div>
                </div>

                <% if(currentTicket != null){ %>
                <table class="table table-bordered table-sm w-auto mb-2">
                    <tbody>
                    <tr><th>Category</th><td><%= currentTicket.get("category") %></td></tr>
                    <tr><th>Created At</th><td><%= currentTicket.get("created_at") %></td></tr>
                    <tr><th>Email</th><td><%= email %></td></tr>
                    </tbody>
                </table>

                <div class="mb-2">
                    <label class="form-label fw-bold">Description</label>
                    <form action="EditTicketServlet" method="post">
                        <input type="hidden" name="ticketId" value="<%= currentTicket.get("id") %>">
                        <div class="d-flex align-items-start">
                            <textarea name="description" id="description" class="description-box" readonly required><%= currentTicket.get("description") %></textarea>
                            <button type="button" class="btn btn-sm btn-outline-secondary ms-2"
                                    onclick="document.getElementById('description').removeAttribute('readonly'); this.style.display='none'; document.getElementById('saveBtn').style.display='inline-block';">
                                Edit
                            </button>
                            <button type="submit" id="saveBtn" class="btn btn-sm btn-primary ms-2" style="display:none;">
                                Save
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Ticket Replies -->
                <div class="reply-box">
                    <h6>Replies</h6>
                    <% if(repliesList != null && !repliesList.isEmpty()){
                        for(Map<String,String> reply: repliesList){ %>
                    <div class="reply-item mb-2">
                        <small class="text-muted"><%= reply.get("created_at") %></small><br/>
                        <%= reply.get("message") %>
                    </div>
                    <% } } else { %>
                    <div class="text-muted">No replies yet.</div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="text-center text-muted mt-4">Select a ticket to view details and replies</div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
