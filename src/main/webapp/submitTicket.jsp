<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentEmail = (session != null) ? (String) session.getAttribute("email") : null;
    String firstName = (session != null) ? (String) session.getAttribute("firstName") : null;

    if (currentEmail == null) {
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;

    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit Ticket</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow-lg p-4">
        <h2 class="mb-4">Submit a New Ticket</h2>
        <form action="submitTicket" method="post">


            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" name="username" class="form-control"
                       value="<%= firstName != null ? firstName : "" %>" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label">Issue Category</label>
                <select name="category" class="form-select" required>
                    <option value="">-- Select Category --</option>
                    <option>Borrow & Return</option>
                    <option>Accounts & Membership</option>
                    <option>Book Search Help</option>
                    <option>Tech Support</option>
                    <option>Account Issue</option>
                    <option>Other</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="6" required></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control"
                       value="<%= currentEmail %>" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label">Mobile Number (optional)</label>
                <input type="tel" name="mobile" class="form-control"
                       pattern="[0-9]{10}" placeholder="Enter 10-digit number">
            </div>

            <button type="submit" class="btn btn-primary">Submit Ticket</button>
        </form>
    </div>
</div>

</body>
</html>
