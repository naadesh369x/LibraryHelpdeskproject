<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String,String>> feedbackList = (List<Map<String,String>>) request.getAttribute("feedbackList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Feedbacks</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        :root {
            --primary: #6366f1;
            --secondary: #8b5cf6;
            --accent: #ec4899;
            --bg-dark: #0f172a;
            --card-bg: #1e293b;
            --text-main: #f1f5f9;
            --text-muted: #94a3b8;
            --border: #334155;
            --star: #fbbf24;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-main);
            font-family: 'Inter', sans-serif;
        }

        /* Header Bar */
        .top-bar {
            background: var(--card-bg);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .top-bar .logo {
            display: flex;
            align-items: center;
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-main);
        }

        .top-bar .logo i {
            margin-right: 10px;
            color: var(--primary);
        }

        .top-bar .nav a {
            color: var(--text-muted);
            margin-left: 1rem;
            text-decoration: none;
            transition: 0.3s;
        }

        .top-bar .nav a:hover {
            color: var(--primary);
        }

        /* Content */
        .main-content {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-header h2 {
            font-size: 2.2rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .page-header p {
            color: var(--text-muted);
        }

        /* Feedback Grid */
        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 1.5rem;
        }

        .review-card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 1.5rem;
            border: 1px solid var(--border);
            transition: 0.3s;
        }

        .review-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }

        .review-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .review-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 600;
            margin-right: 12px;
        }

        .review-info h3 {
            font-size: 1.1rem;
            margin: 0;
        }

        .review-info small {
            color: var(--text-muted);
        }

        .review-comment {
            color: var(--text-main);
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .review-rating i {
            color: var(--star);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-muted);
        }

        footer {
            text-align: center;
            padding: 1.5rem;
            background: var(--card-bg);
            border-top: 1px solid var(--border);
            margin-top: 2rem;
            color: var(--text-muted);
        }
    </style>
</head>
<body>

<!-- Header -->
<div class="top-bar">
    <div class="logo">
        <i class="fas fa-star"></i> Library Feedbacks
    </div>
    <div class="nav">
        <a href="admin-dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
        <a href="listFAQAdmin.jsp"><i class="fas fa-question-circle"></i> FAQ</a>
        <a href="FeedbackListServlet"><i class="fas fa-comment-dots"></i> Feedbacks</a>
    </div>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="page-header">
        <h2>All Feedbacks</h2>
        <p>See what users are saying about our library</p>
    </div>

    <% if (feedbackList != null && !feedbackList.isEmpty()) { %>
    <div class="reviews-grid">
        <% for (Map<String, String> fb : feedbackList) {
            int rating = Integer.parseInt(fb.get("rating"));
            String initials = fb.get("firstname").substring(0, 1) + fb.get("lastname").substring(0, 1);
        %>
        <div class="review-card">
            <div class="review-header">
                <div class="review-avatar"><%= initials %></div>
                <div class="review-info">
                    <h3><%= fb.get("firstname") %> <%= fb.get("lastname") %></h3>
                    <small><%= fb.get("created_at") %></small>
                </div>
            </div>

            <div class="review-comment">
                <%= fb.get("comment") %>
            </div>

            <div class="review-rating">
                <% for (int i = 1; i <= 5; i++) { %>
                <% if (i <= rating) { %>
                <i class="fas fa-star"></i>
                <% } else { %>
                <i class="far fa-star"></i>
                <% } %>
                <% } %>
                <span class="ms-2 text-muted"><%= rating %>/5</span>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="empty-state">
        <i class="fas fa-comment-slash fa-3x mb-3"></i>
        <h4>No Feedbacks Yet</h4>
        <p>There are currently no feedbacks to display.</p>
    </div>
    <% } %>
</div>

<footer>
    &copy; 2025 Library Help Desk. All Rights Reserved.
</footer>

</body>
</html>
