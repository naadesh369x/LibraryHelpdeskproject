<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String,String>> feedbackList = (List<Map<String,String>>) request.getAttribute("feedbackList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Feedbacks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Bubble background */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: #74ebd5;
            position: relative;
            overflow-x: hidden;
        }
        body::before {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(255,255,255,0.2) 1px, transparent 1px);
            background-size: 60px 60px;
            z-index: 0;
        }

        .container {
            position: relative;
            z-index: 1;
            padding-top: 50px;
            padding-bottom: 50px;
        }

        h2 {
            text-align: center;
            color: #fff;
            margin-bottom: 40px;
            font-weight: 700;
        }

        .top-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
        }

        .top-buttons a {
            font-weight: 600;
            font-size: 16px;
        }

        /* Feedback card */
        .feedback-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .feedback-card:hover { transform: translateY(-5px); }

        .feedback-header {
            font-weight: 700;
            color: #6c63ff;
            margin-bottom: 10px;
        }

        .feedback-comment {
            margin-bottom: 10px;
        }

        .feedback-meta {
            font-size: 13px;
            color: #888;
            margin-bottom: 15px;
        }

        .rating-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 12px;
            background-color: #6c63ff;
            color: white;
            font-weight: 600;
            margin-right: 10px;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 5px 12px;
            font-size: 13px;
            transition: 0.3s;
        }
        .btn-delete:hover { background-color: #bb2d3b; }

        @media(max-width:768px){
            .top-buttons { flex-direction: column; gap: 10px; }
        }
    </style>
</head>
<body>
<div class="container">

    <h2>My Feedbacks</h2>

    <div class="top-buttons">
        <a href="admin-dashboard" class="btn btn-secondary btn-lg">← Back to Dashboard</a>

    </div>

    <% if(feedbackList != null && !feedbackList.isEmpty()) { %>
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <% for(Map<String,String> fb : feedbackList) { %>
        <div class="col">
            <div class="feedback-card">
                <div class="feedback-header">
                    <%= fb.get("firstname") %> <%= fb.get("lastname") %>
                    <span class="rating-badge"><%= fb.get("rating") %>/5</span>
                </div>
                <div class="feedback-comment"><strong>Comment:</strong> <%= fb.get("comment") %></div>
                <div class="feedback-meta">Submitted on: <%= fb.get("created_at") %></div>
                <form action="DeleteFeedbackServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this feedback?');">
                    <input type="hidden" name="id" value="<%= fb.get("id") %>">

                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <p class="text-center text-white">No feedback submitted yet.</p>
    <% } %>

</div>
</body>
</html>
