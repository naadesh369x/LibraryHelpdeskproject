<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Tickets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            background: #181a20;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #eaeaea;
        }
        .ticket-list {
            height: 100%;
            overflow-y: auto;
            background: #23272f;
            border-right: 1px solid #222;
            box-shadow: 0 2px 8px rgba(0,0,0,0.18);
        }
        .ticket-item {
            cursor: pointer;
            padding: 18px 20px;
            border-bottom: 1px solid #222;
            transition: background 0.2s, box-shadow 0.2s;
            border-radius: 10px;
            margin: 8px 12px;
            background: #23272f;
            color: #eaeaea;
        }
        .ticket-item:hover {
            background-color: #2c313c;
            box-shadow: 0 2px 8px rgba(51,181,229,0.13);
        }
        .ticket-item strong {
            display: block;
            color: #33b5e5;
            font-size: 16px;
        }
        .ticket-item small {
            color: #b0b0b0;
            font-size: 13px;
        }
        .ticket-details {
            background: #23272f;
            height: 100%;
            display: flex;
            flex-direction: column;
            padding: 32px 28px 24px 28px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.18);
            overflow-y: auto;
            border-radius: 18px;
        }
        .ticket-header {
            background: linear-gradient(90deg,#33b5e5 60%,#0d6efd 100%);
            color: #fff;
            border-radius: 14px;
            padding: 18px 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(51,181,229,0.18);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .ticket-header h5 {
            margin: 0;
            font-size: 22px;
            font-weight: 600;
            letter-spacing: 1px;
        }
        .ticket-header .badge {
            font-size: 15px;
            padding: 8px 18px;
            border-radius: 18px;
            font-weight: 500;
        }
        .description-box {
            height: 300px;
            resize: none;
            border-radius: 12px;
            padding: 18px;
            font-size: 15px;
            background-color: #181a20;
            color: #eaeaea;
            width: 100%;
            border: 1px solid #333;
            margin-bottom: 18px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.12);
        }
        .reply-box {
            border-top: 1px solid #333;
            padding-top: 14px;
            margin-top: 10px;
        }
        .btn-primary, .btn-success, .btn-secondary {
            font-size: 15px;
            font-weight: 500;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(51,181,229,0.13);
        }
        .btn-primary {
            background: linear-gradient(90deg,#33b5e5 60%,#0d6efd 100%);
            border: none;
        }
        .btn-secondary {
            background: #23272f;
            color: #eaeaea;
            border: 1px solid #33b5e5;
        }
        .btn-secondary:hover {
            background: #181a20;
            color: #33b5e5;
        }
        .table {
            background: #23272f;
            color: #eaeaea;
            border-radius: 10px;
            overflow: hidden;
        }
        .table th, .table td {
            background: #23272f;
            color: #eaeaea;
            border-color: #333;
        }
        .bg-dark {
            background: #181a20 !important;
            color: #33b5e5 !important;
        }
        .text-muted {
            color: #b0b0b0 !important;
        }
        @media (max-width: 991.98px) {
            .ticket-list { height: auto; min-height: 200px; }
            .ticket-details { padding: 18px 12px; }
        }
    </style>
</head>
<body>
<div class="container-fluid h-100">
    <div class="row h-100">
        <!-- Left Panel -->
        <div class="col-md-4 p-0">
            <div class="ticket-list h-100">
                <div class="p-3 bg-dark text-white fw-bold">All Tickets</div>

                <!-- Back Buttons -->

                <a class="btn btn-dashboard" href="admin-dashboard">🏠  Back to Dashboard</a>

                <%
                    List<Map<String,String>> tickets = (List<Map<String,String>>) request.getAttribute("tickets");
                    if(tickets != null && !tickets.isEmpty()){
                        for(Map<String,String> ticket : tickets){
                            String ticketStatus = ticket.get("status");
                            String itemStyle = "new".equalsIgnoreCase(ticketStatus) ? "color:#ff3b3b;" : "";
                %>
                <div class="ticket-item" style="<%= itemStyle %>" onclick="window.location.href='ManageTicketsServlet?id=<%=ticket.get("id")%>'">
                    <strong><%= ticket.get("username") %> - <%= ticket.get("email") %></strong>
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
                    <h5>Ticket Details</h5>
                    <div class="d-flex align-items-center gap-2">
                        <% String status = (String) request.getAttribute("status"); %>
                        <span class="badge <%= "solved".equalsIgnoreCase(status) ? "bg-success" :
                                               "pending".equalsIgnoreCase(status) ? "bg-warning text-dark" : "bg-info" %>">
                            <%= status != null ? status : "Unknown" %>
                        </span>
                        <button type="button" class="btn btn-primary btn-sm" onclick="showReplyBox()">Reply</button>
                    </div>
                </div>

                <table class="table table-bordered table-sm w-auto mb-3">
                    <tbody>
                    <tr><th>Category</th><td><%= request.getAttribute("category") %></td></tr>
                    <tr><th>Created At</th><td><%= request.getAttribute("created_at") %></td></tr>
                    <tr><th>Username</th><td><%= request.getAttribute("username") %></td></tr>
                    <tr><th>Email</th><td><%= request.getAttribute("email") %></td></tr>
                    </tbody>
                </table>

                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea class="description-box" readonly><%= request.getAttribute("description") %></textarea>
                </div>

                <div class="reply-box" id="replyBox" style="display:none;">
                    <form method="post" action="ReplyTicketServlet">
                        <input type="hidden" name="ticketId" value="<%= request.getAttribute("ticketId") %>">
                        <textarea name="reply" rows="4" class="form-control mb-2" placeholder="Type your reply..." required></textarea>
                        <button type="submit" class="btn btn-primary">Send Reply</button>
                    </form>
                </div>

                <script>
                    function showReplyBox(){
                        document.getElementById('replyBox').style.display='block';
                    }
                </script>
            </div>
        </div>
    </div>
</div>
</body>
</html>
