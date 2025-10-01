<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page import="com.example.demo.utils.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Tickets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid mt-4">
    <div class="row">

        <!-- Tickets List -->
        <div class="col-md-4">
            <div class="list-group">
                <%
                    List<Map<String,String>> tickets = (List<Map<String,String>>) request.getAttribute("tickets");
                    if(tickets != null) {
                        for(Map<String,String> t: tickets) {
                %>
                <a href="TicketDetailsServlet?id=<%= t.get("id") %>" class="list-group-item list-group-item-action">
                    <strong><%= t.get("subject") %></strong><br>
                    <small>From: <%= t.get("userName") %></small>
                </a>
                <%  }
                } else { %>
                <div class="list-group-item text-muted">No tickets found</div>
                <% } %>
            </div>
        </div>

        <!-- Ticket Messages -->
        <div class="col-md-8">
            <h5>Messages</h5>
            <div class="border p-3 mb-3" style="height: 400px; overflow-y: auto;">
                <%
                    List<Map<String,String>> messages = (List<Map<String,String>>) request.getAttribute("messages");
                    if(messages != null && !messages.isEmpty()) {
                        for(Map<String,String> msg: messages) {
                %>
                <div class="mb-2">
                    <strong><%= msg.get("sender") %>:</strong> <%= msg.get("message") %>
                    <br><small><%= msg.get("created_at") %></small>
                </div>
                <%      }
                } else { %>
                <div class="text-muted">No messages yet</div>
                <% } %>
            </div>

            <form method="post" action="ReplyTicketServlet">
                <input type="hidden" name="ticketId" value="<%= request.getAttribute("ticketId") %>">
                <textarea name="reply" class="form-control mb-2" placeholder="Write a reply..." required></textarea>
                <button type="submit" class="btn btn-primary">Mark as Solved & Reply</button>
            </form>
        </div>

    </div>
</div>
</body>
</html>
