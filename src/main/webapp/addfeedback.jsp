<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Get session info
    HttpSession session1 = request.getSession(false);
    String email = (session != null) ? (String) session.getAttribute("email") : null;
    Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
    String userName = (session != null) ? (String) session.getAttribute("userName") : null;

    if (email == null || userId == null) {
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }

    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Submit Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            min-height: 100vh;
            background: url('images/library-bg.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; padding: 0;
        }
        body::before {
            content: '';
            position: fixed; top:0; left:0;
            width:100%; height:100%;
            background: rgba(0,0,0,0.6);
            z-index: -1;
        }
        .top-bar {
            width: 100%; height: 60px;
            background: rgba(44,62,80,0.9);
            color: #fff; display: flex;
            justify-content: space-between; align-items: center;
            padding: 0 30px; position: sticky; top: 0; z-index: 100;
        }
        .top-bar .user-info { font-weight: 600; }
        .top-bar .user-info i { margin-right: 8px; color: #ffda6a; }
        .container { max-width: 600px; margin: 40px auto; position: relative; z-index: 1; }
        .card { border-radius: 16px; box-shadow: 0 12px 30px rgba(0,0,0,0.3); background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); border: none; overflow: hidden; }
        .card-header { background: linear-gradient(135deg, #6c63ff 0%, #74ebd5 100%); color: #fff; font-weight: 600; font-size: 22px; padding: 20px; text-align: center; position: relative; }
        .card-body { padding: 30px; }
        .form-label { font-weight:600; color:#2c3e50; margin-bottom:8px; display:flex; align-items:center; }
        .form-label i { margin-right: 8px; color:#6c63ff; }
        .form-control, .form-select { border-radius:10px; border:1px solid #ddd; padding:12px 15px; transition: all 0.3s ease; }
        .form-control:focus, .form-select:focus { outline:none; border-color:#6c63ff; box-shadow:0 0 0 3px rgba(108,99,255,0.2); }
        .btn-submit { background: linear-gradient(90deg, #6c63ff 0%, #74ebd5 100%); color: #fff; font-weight:600; padding:12px; border-radius:10px; border:none; width:100%; box-shadow:0 4px 10px rgba(108,99,255,0.3); transition: all 0.3s ease; }
        .btn-submit:hover { background: linear-gradient(90deg, #5548d3 0%, #6c63ff 100%); transform: translateY(-2px); box-shadow:0 6px 15px rgba(108,99,255,0.4); }
    </style>
</head>
<body>

<!-- Top bar showing current user -->
<div class="top-bar">
    <div class="user-info">
        <i class="fas fa-user-circle"></i> <%= userName != null ? userName : email %> | ID: <%= userId %>
    </div>
    <a href="dashboard.jsp" class="btn btn-light btn-sm"><i class="fas fa-home"></i> Dashboard</a>
</div>

<div class="container">
    <div class="card">
        <div class="card-header"><i class="fas fa-star me-2"></i> Submit Your Feedback</div>
        <div class="card-body">

            <% if(successMsg != null){ %>
            <div class="alert alert-success"><%= successMsg %></div>
            <% } else if(errorMsg != null){ %>
            <div class="alert alert-danger"><%= errorMsg %></div>
            <% } %>

            <!-- Feedback Form -->
            <form action="FeedbackServlet" method="post" id="feedbackForm">
                <!-- Use hidden field to send userId to servlet -->
                <input type="hidden" name="userId" value="<%= userId %>">

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-user"></i> First Name *</label>
                    <input type="text" name="firstname" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-user"></i> Last Name *</label>
                    <input type="text" name="lastname" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-envelope"></i> Email *</label>
                    <input type="email" name="email" class="form-control" value="<%= email %>" readonly required>
                </div>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-comment"></i> Comment *</label>
                    <textarea name="comment" rows="4" class="form-control" required></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-star"></i> Rating (1-5) *</label>
                    <select name="rating" class="form-select" required>
                        <option value="">Select Rating</option>
                        <option value="1">1 - Poor</option>
                        <option value="2">2 - Fair</option>
                        <option value="3">3 - Good</option>
                        <option value="4">4 - Very Good</option>
                        <option value="5">5 - Excellent</option>
                    </select>
                </div>

                <button type="submit" class="btn-submit"><i class="fas fa-paper-plane me-2"></i> Submit Feedback</button>
            </form>

        </div>
    </div>
</div>

</body>
</html>
