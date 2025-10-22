<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.example.demo.utils.DBConnection" %>

<%
    HttpSession session1 = request.getSession(false);
    String email = (session1 != null) ? (String) session1.getAttribute("email") : null;
    Integer userId = (session1 != null) ? (Integer) session1.getAttribute("userid") : null;
    String userName = (session1 != null) ? (String) session1.getAttribute("userName") : null;

    if (email == null) {
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }

    List<Map<String, String>> feedbacks = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        // Modified query to get all feedbacks, not just the current user's
        String sql = "SELECT * FROM feedbacks ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> fb = new HashMap<>();
                    fb.put("feedbackid", String.valueOf(rs.getInt("feedbackid")));
                    fb.put("firstname", rs.getString("firstname"));
                    fb.put("lastname", rs.getString("lastname"));
                    fb.put("comment", rs.getString("comment"));
                    fb.put("rating", String.valueOf(rs.getInt("rating")));
                    fb.put("created_at", rs.getTimestamp("created_at").toString());
                    feedbacks.add(fb);
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Feedbacks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url('images/library-bg.jpg') no-repeat center center fixed;
            background-size: cover;
            position: relative;
            color: #fff;
        }
        body::before {
            content: "";
            position: fixed; top:0; left:0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: -1;
        }

        .top-bar {
            width: 100%;
            height: 64px;
            background: rgba(44,62,80,0.9);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .top-bar .logo { display:flex; align-items:center; font-size:1.4rem; font-weight:bold; }
        .top-bar .logo i { margin-right:10px; color:#ffda6a; font-size:2rem; }
        .top-bar .nav a { color:#fff; text-decoration:none; padding:8px 16px; border-radius:8px; background: rgba(0,0,0,0.3); margin-right:10px; transition:0.2s; }
        .top-bar .nav a:hover { background:#6c63ff; }
        .logout-btn { background: linear-gradient(90deg,#e74c3c,#ff7f7f); color:#fff; border-radius:8px; padding:8px 16px; text-decoration:none; }
        .logout-btn:hover { background:#c0392b; }

        .container { max-width: 1200px; margin: 40px auto; position: relative; z-index:1; }
        h2 { text-align:center; margin-bottom:30px; text-shadow:1px 1px 5px rgba(0,0,0,0.5); }

        .feedbacks-grid { display:grid; grid-template-columns:repeat(auto-fit, minmax(320px, 1fr)); gap:24px; }
        .feedback-card {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.25);
            transition:0.3s;
            border:1px solid rgba(255,255,255,0.2);
        }
        .feedback-card:hover { transform: translateY(-6px) scale(1.02); }

        .feedback-header { font-weight:700; color:#ffda6a; margin-bottom:10px; display:flex; justify-content:space-between; align-items:center; }
        .feedback-comment { font-size:0.95rem; margin-bottom:10px; color:#fff; }
        .feedback-date { font-size:0.85rem; color:#ddd; margin-bottom:12px; }

        .feedback-stats {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.25);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            border:1px solid rgba(255,255,255,0.2);
        }

        .stat-item {
            text-align: center;
            padding: 10px 20px;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: #ffda6a;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #ddd;
        }
    </style>
</head>
<body>

<div class="top-bar">
    <div class="logo"><i class="fas fa-star"></i> All Feedbacks</div>
    <div class="nav">
        <a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
        <a href="addfeedback.jsp"><i class="fas fa-plus"></i> Add Feedback</a>
    </div>
    <a href="mainpage.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<div class="container">
    <h2>All Feedbacks</h2>

    <% if(successMsg != null){ %>
    <div class="alert alert-success text-dark"><%= successMsg %></div>
    <% } %>
    <% if(errorMsg != null){ %>
    <div class="alert alert-danger text-dark"><%= errorMsg %></div>
    <% } %>

    <div class="feedback-stats">
        <div class="stat-item">
            <div class="stat-value"><%= feedbacks.size() %></div>
            <div class="stat-label">Total Feedbacks</div>
        </div>
        <div class="stat-item">
            <div class="stat-value">
                <%
                    double avgRating = 0;
                    if (!feedbacks.isEmpty()) {
                        int totalRating = 0;
                        for (Map<String, String> fb : feedbacks) {
                            totalRating += Integer.parseInt(fb.get("rating"));
                        }
                        avgRating = (double) totalRating / feedbacks.size();
                        out.print(String.format("%.1f", avgRating));
                    } else {
                        out.print("0.0");
                    }
                %>
            </div>
            <div class="stat-label">Average Rating</div>
        </div>
        <div class="stat-item">
            <div class="stat-value">
                <%
                    int fiveStarCount = 0;
                    for (Map<String, String> fb : feedbacks) {
                        if (Integer.parseInt(fb.get("rating")) == 5) {
                            fiveStarCount++;
                        }
                    }
                    out.print(fiveStarCount);
                %>
            </div>
            <div class="stat-label">5-Star Reviews</div>
        </div>
    </div>

    <div class="feedbacks-grid">
        <% if(feedbacks != null && !feedbacks.isEmpty()){
            for(Map<String,String> fb : feedbacks){ %>
        <div class="feedback-card">
            <div class="feedback-header">
                <span><%= fb.get("firstname") %> <%= fb.get("lastname") %></span>
                <span>
                    <% int rating = Integer.parseInt(fb.get("rating"));
                        for(int i=1;i<=5;i++){
                            if(i<=rating){ %>
                              <i class="fas fa-star" style="color:#f1c40f;"></i>
                    <% } else { %>
                              <i class="far fa-star" style="color:#f1c40f;"></i>
                    <% }} %>
                </span>
            </div>
            <div class="feedback-comment"><strong>Comment:</strong> <%= fb.get("comment") %></div>
            <div class="feedback-date">Submitted on: <%= fb.get("created_at") %></div>
        </div>
        <% }} else { %>
        <div class="feedback-card text-center">
            <div class="feedback-header">No Feedbacks Yet</div>
            <div class="feedback-comment">No feedbacks have been submitted yet. Be the first to add one!</div>
        </div>
        <% } %>
    </div>
</div>

</body>
</html>