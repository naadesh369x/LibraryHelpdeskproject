<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession session1 = request.getSession(false);
    String userEmail = (session1 != null) ? (String) session1.getAttribute("email") : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #74ebd5, #ACB6E5);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .feedback-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            padding: 30px;
            max-width: 500px;
            width: 100%;
            transition: 0.3s;
        }
        .feedback-card:hover { transform: translateY(-5px); }
        .form-control:focus {
            border-color: #6c63ff;
            box-shadow: 0 0 5px rgba(108,99,255,0.5);
        }
        .btn-custom {
            background: #6c63ff;
            border: none;
            border-radius: 10px;
            color: white;
            font-weight: 600;
            padding: 10px;
            transition: background 0.3s ease;
        }
        .btn-custom:hover { background: #5548d3; }
    </style>
</head>
<body>
<div class="feedback-card">
    <h3 class="text-center mb-4">We value your feedback</h3>

    <form action="FeedbackServlet" method="post">
        <div class="mb-3">
            <label class="form-label">First Name</label>
            <input type="text" class="form-control" name="firstname" placeholder="Enter First Name" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Last Name</label>
            <input type="text" class="form-control" name="lastname" placeholder="Enter Last Name" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Email address</label>
            <input type="email" class="form-control" name="email"
                   value="<%= (userEmail != null) ? userEmail : "" %>"
                <%= (userEmail != null) ? "readonly" : "" %> required>
        </div>
        <div class="mb-3">
            <label class="form-label">Comments</label>
            <textarea class="form-control" name="comment" rows="4" placeholder="Write your feedback here..." required></textarea>
        </div>
        <div class="mb-3">
            <label class="form-label">Rating (1 to 5)</label>
            <select class="form-select" name="rating" required>
                <option value="">Select Rating</option>
                <option value="1">1 - Poor</option>
                <option value="2">2 - Fair</option>
                <option value="3">3 - Good</option>
                <option value="4">4 - Very Good</option>
                <option value="5">5 - Excellent</option>
            </select>
        </div>
        <div class="d-grid">
            <button type="submit" class="btn btn-custom">Submit Feedback</button>
        </div>
    </form>
</div>
</body>
</html>
