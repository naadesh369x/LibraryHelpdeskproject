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
    <title>All Reviews</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        :root {
            --primary-color: #6366f1;
            --secondary-color: #8b5cf6;
            --accent-color: #ec4899;
            --dark-bg: #0f172a;
            --card-bg: #1e293b;
            --text-primary: #f1f5f9;
            --text-secondary: #cbd5e1;
            --border-color: #334155;
            --rating-color: #fbbf24;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--dark-bg);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Modern Top Bar */
        .top-bar {
            background: linear-gradient(135deg, var(--card-bg) 0%, rgba(30, 41, 59, 0.8) 100%);
            backdrop-filter: blur(10px);
            padding: 1rem 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            position: sticky;
            top: 0;
            z-index: 100;
            border-bottom: 1px solid var(--border-color);
        }

        .top-bar .logo {
            display: flex;
            align-items: center;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .top-bar .logo i {
            margin-right: 12px;
            font-size: 1.8rem;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .top-bar .nav a {
            color: var(--text-secondary);
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }

        .top-bar .nav a:hover {
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary-color);
            transform: translateY(-2px);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }

        .page-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .page-header h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .page-header p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        /* Reviews Grid */
        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
        }

        /* Modern Review Cards */
        .review-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .review-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--accent-color));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }

        .review-card:hover::before {
            transform: scaleX(1);
        }

        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
        }

        .review-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .review-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.2rem;
            margin-right: 1rem;
        }

        .review-info h3 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.2rem;
        }

        .review-date {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .review-comment {
            margin-bottom: 1rem;
            line-height: 1.6;
            color: var(--text-primary);
        }

        .review-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .review-rating .stars {
            display: flex;
            gap: 2px;
        }

        .review-rating i {
            color: var(--rating-color);
            font-size: 1rem;
        }

        .review-rating .rating-value {
            font-weight: 600;
            color: var(--text-secondary);
            margin-left: 0.5rem;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }

        .empty-state p {
            color: var(--text-secondary);
        }

        /* Footer */
        .footer {
            background: var(--card-bg);
            padding: 1.5rem;
            text-align: center;
            color: var(--text-secondary);
            border-top: 1px solid var(--border-color);
            margin-top: auto;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .top-bar {
                padding: 1rem;
            }

            .top-bar .logo {
                font-size: 1.2rem;
            }

            .top-bar .logo i {
                font-size: 1.5rem;
            }

            .main-content {
                padding: 1rem;
            }

            .page-header h2 {
                font-size: 2rem;
            }

            .reviews-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
        }
    </style>
</head>
<body>

<!-- Modern Top Bar -->
<nav class="top-bar">
    <div class="container-fluid">
        <div class="row align-items-center">
            <div class="col-md-4">
                <div class="logo">
                    <i class="fas fa-star"></i>
                    Library Reviews
                </div>
            </div>
            <div class="col-md-8">
                <div class="nav d-flex justify-content-end">
                    <a href="admin-dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
                    <a href="listFAQAdmin.jsp"><i class="fas fa-question-circle"></i> FAQ</a>
                    <a href="FeedbackListServlet"><i class="fas fa-comment-dots"></i> Feedbacks</a>
                </div>
            </div>
        </div>
    </div>
</nav>

<!-- Main Content -->
<main class="main-content">
    <div class="page-header">
        <h2>All Reviews</h2>
        <p>See what people are saying about our library</p>
    </div>

    <% if (feedbackList != null && !feedbackList.isEmpty()) { %>
    <div class="reviews-grid">
        <% for (Map<String,String> fb : feedbackList) {
            int rating = Integer.parseInt(fb.get("rating"));
            String initials = fb.get("firstname").substring(0,1) + fb.get("lastname").substring(0,1);
        %>
        <div class="review-card">
            <div class="review-header">
                <div class="review-avatar"><%= initials %></div>
                <div class="review-info">
                    <h3><%= fb.get("firstname") %> <%= fb.get("lastname") %></h3>
                    <div class="review-date"><%= fb.get("created_at") %></div>
                </div>
            </div>
            <div class="review-comment">
                <%= fb.get("comment") %>
            </div>
            <div class="review-rating">
                <div class="stars">
                    <% for(int i=1;i<=5;i++){ %>
                    <% if(i <= rating){ %>
                    <i class="fas fa-star"></i>
                    <% } else { %>
                    <i class="far fa-star"></i>
                    <% } %>
                    <% } %>
                </div>
                <span class="rating-value"><%= rating %>/5</span>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="empty-state">
        <i class="fas fa-comment-slash"></i>
        <h3>No Reviews Available</h3>
        <p>There are no reviews to display at this time.</p>
    </div>
    <% } %>
</main>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        &copy; 2025 Library Help Desk. All Rights Reserved.
    </div>
</footer>

</body>
</html>