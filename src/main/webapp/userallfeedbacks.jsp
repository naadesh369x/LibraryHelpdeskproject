<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String,String>> feedbackList = (List<Map<String,String>>) request.getAttribute("feedbackList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Reviews</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(to right, #74ebd5, #ACB6E5);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding: 0;
        }

        .top-bar {
            width: 100%;
            height: 64px;
            background: rgba(44,62,80,0.92);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 4px 18px rgba(44,62,80,0.18);
            padding: 0 32px;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .top-bar .logo {
            display: flex;
            align-items: center;
            font-size: 1.4rem;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .top-bar .logo i {
            margin-right: 10px;
            font-size: 2rem;
            color: #6c63ff;
        }

        .top-bar .nav {
            display: flex;
            gap: 24px;
        }

        .top-bar .nav a {
            color: #fff;
            font-size: 1.1rem;
            text-decoration: none;
            padding: 8px 14px;
            border-radius: 8px;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .top-bar .nav a:hover {
            background: #6c63ff;
            color: #fff;
        }

        .container {
            position: relative;
            z-index: 1;
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px 0 20px;
        }

        h2 {
            text-align: center;
            color: #23272f;
            margin-bottom: 30px;
            font-weight: 700;
            letter-spacing: 1px;
        }

        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 28px;
        }

        .review-bubble {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 25px;
            padding: 24px 22px 18px 22px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.13);
            position: relative;
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid #e6e6e6;
        }

        .review-bubble:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 16px 40px rgba(44,62,80,0.18), 0 2px 12px rgba(44,62,80,0.13);
        }

        .review-header {
            font-weight: bold;
            color: #6c63ff;
            margin-bottom: 10px;
            font-size: 1.13rem;
        }

        .review-comment {
            font-size: 15px;
            margin-bottom: 12px;
            color: #23272f;
        }

        .review-rating {
            color: #f1c40f;
            font-size: 17px;
            margin-bottom: 8px;
        }

        .review-date {
            font-size: 12px;
            color: #7f8c8d;
        }

        body::before {
            content: "";
            position: absolute;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 1px, transparent 1px);
            background-size: 60px 60px;
            z-index: 0;
            top: 0;
            left: 0;
        }

        .footer {
            width: 100%;
            background: rgba(44,62,80,0.92);
            color: #fff;
            text-align: center;
            padding: 18px 0 12px 0;
            position: fixed;
            left: 0;
            bottom: 0;
            font-size: 1rem;
            letter-spacing: 1px;
        }

        @media(max-width:768px) {
            .container { padding: 24px 6px 0 6px; }
            .top-bar { padding: 0 10px; }
            .reviews-grid { gap: 16px; }
        }
    </style>
</head>
<body>
<div class="top-bar">
    <div class="logo">
        <i class="fas fa-star"></i> Library Reviews
    </div>
    <div class="nav">
        <a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
        <a href="faq.jsp"><i class="fas fa-question-circle"></i> FAQ</a>
        <a href="myfeedbacks.jsp"><i class="fas fa-user"></i> My Feedbacks</a>
    </div>
</div>
<div class="container">
    <h2>All Reviews</h2>
    <% if (feedbackList != null && !feedbackList.isEmpty()) { %>
    <div class="reviews-grid">
        <% for (Map<String,String> fb : feedbackList) {
            int rating = Integer.parseInt(fb.get("rating"));
        %>
        <div class="review-bubble">
            <div class="review-header">
                <%= fb.get("firstname") %> <%= fb.get("lastname") %>
            </div>
            <div class="review-comment">
                <%= fb.get("comment") %>
            </div>
            <div class="review-rating">
                <% for(int i=1;i<=5;i++){ %>
                <% if(i <= rating){ %>
                <i class="fas fa-star"></i>
                <% } else { %>
                <i class="far fa-star"></i>
                <% } %>
                <% } %>
            </div>
            <div class="review-date">
                Submitted on: <%= fb.get("created_at") %>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <p class="text-center text-white">No reviews available.</p>
    <% } %>
</div>
<div class="footer">
    &copy; 2025 Library Help Desk. All Rights Reserved.
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/js/all.min.js"></script>
</body>
</html>
