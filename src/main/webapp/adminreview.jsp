<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.example.demo.utils.DBConnection" %>

<%
    List<Map<String, String>> feedbacks = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        
        String sql = "SELECT * FROM feedbacks ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> fb = new HashMap<>();
                    fb.put("feedbackid", String.valueOf(rs.getInt("feedbackid")));
                    fb.put("firstname", rs.getString("firstname"));
                    fb.put("lastname", rs.getString("lastname"));
                    fb.put("email", rs.getString("email"));
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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedbacks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #000000;
            background-image:
                    radial-gradient(circle at 10% 20%, rgba(120, 119, 198, 0.3) 0%, transparent 20%),
                    radial-gradient(circle at 80% 80%, rgba(255, 119, 198, 0.3) 0%, transparent 20%),
                    radial-gradient(circle at 40% 40%, rgba(120, 219, 255, 0.2) 0%, transparent 20%);
            color: #e0e0e0;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated background particles */
        .particles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
        }

        .particle {
            position: absolute;
            width: 2px;
            height: 2px;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 50%;
            animation: float 20s infinite linear;
        }

        @keyframes float {
            0% {
                transform: translateY(100vh) translateX(0);
                opacity: 0;
            }
            10% {
                opacity: 1;
            }
            90% {
                opacity: 1;
            }
            100% {
                transform: translateY(-100vh) translateX(100px);
                opacity: 0;
            }
        }

        .top-bar {
            width: 100%;
            height: 70px;
            background: linear-gradient(90deg, #0a0a0a 0%, #1a1a1a 100%);
            border-bottom: 1px solid #333;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 40px;
            position: sticky;
            top: 0;
            z-index: 1000;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
        }

        .top-bar .logo {
            display: flex;
            align-items: center;
            font-size: 1.5rem;
            font-weight: bold;
            background: linear-gradient(45deg, #ff006e, #8338ec);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .top-bar .logo i {
            margin-right: 12px;
            background: linear-gradient(45deg, #ff006e, #8338ec);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 2.2rem;
        }

        .container {
            max-width: 1400px;
            margin: 40px auto;
            position: relative;
            z-index: 1;
            padding: 0 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 40px;
            font-size: 2.5rem;
            font-weight: 300;
            letter-spacing: 2px;
            background: linear-gradient(45deg, #fff, #b0b0b0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .feedback-stats {
            background: linear-gradient(135deg, #1a1a1a 0%, #0f0f0f 100%);
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 20px;
            border: 1px solid #333;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }

        .stat-item {
            text-align: center;
            padding: 20px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 12px;
            min-width: 150px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.05);
            border-color: #333;
        }

        .stat-value {
            font-size: 2.5rem;
            font-weight: bold;
            background: linear-gradient(45deg, #ff006e, #8338ec);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #808080;
            margin-top: 5px;
        }

        .feedbacks-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 25px;
        }

        .feedback-card {
            background: linear-gradient(135deg, #1a1a1a 0%, #0f0f0f 100%);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            transition: all 0.3s ease;
            border: 1px solid #333;
            position: relative;
            overflow: hidden;
        }

        .feedback-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #ff006e, #8338ec, #3a86ff);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .feedback-card:hover::before {
            opacity: 1;
        }

        .feedback-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.7);
            border-color: #444;
        }

        .feedback-user {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff006e, #8338ec);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
            color: #fff;
            box-shadow: 0 5px 15px rgba(255, 0, 110, 0.3);
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: bold;
            color: #fff;
            font-size: 1.1rem;
        }

        .user-email {
            font-size: 0.85rem;
            color: #808080;
        }

        .feedback-comment {
            font-size: 0.95rem;
            margin-bottom: 15px;
            color: #b0b0b0;
            line-height: 1.6;
            background: rgba(255, 255, 255, 0.02);
            padding: 15px;
            border-radius: 8px;
            border-left: 3px solid #8338ec;
        }

        .feedback-date {
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 15px;
        }

        .rating-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(10px);
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #333;
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: linear-gradient(135deg, #1a1a1a 0%, #0f0f0f 100%);
            border-radius: 16px;
            border: 1px solid #333;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }

        .empty-state i {
            font-size: 4rem;
            background: linear-gradient(45deg, #ff006e, #8338ec);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: #fff;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #808080;
        }

        @media (max-width: 768px) {
            .top-bar {
                padding: 0 20px;
            }

            .feedbacks-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<!-- Animated particles background -->
<div class="particles" id="particles"></div>

<div class="top-bar">
    <div class="logo"><i class="fas fa-comments"></i> Feedbacks</div>
</div>

<div class="container">
    <h2>User Feedbacks</h2>

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
        <div class="stat-item">
            <div class="stat-value">
                <%
                    int todayCount = 0;
                    for (Map<String, String> fb : feedbacks) {
                        String feedbackDate = fb.get("created_at").substring(0, 10);
                        String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
                        if (feedbackDate.equals(today)) {
                            todayCount++;
                        }
                    }
                    out.print(todayCount);
                %>
            </div>
            <div class="stat-label">Today's Feedbacks</div>
        </div>
    </div>

    <div class="feedbacks-grid">
        <% if(feedbacks != null && !feedbacks.isEmpty()){
            for(Map<String,String> fb : feedbacks){ %>
        <div class="feedback-card">
            <div class="rating-badge">
                <% int rating = Integer.parseInt(fb.get("rating"));
                    for(int i=1;i<=5;i++){
                        if(i<=rating){ %>
                <i class="fas fa-star" style="color:#ffd700;"></i>
                <% } else { %>
                <i class="far fa-star" style="color:#666;"></i>
                <% }} %>
                <span style="color: #fff;"><%= fb.get("rating") %>/5</span>
            </div>
            <div class="feedback-user">
                <div class="user-avatar"><%= fb.get("firstname").charAt(0) %><%= fb.get("lastname").charAt(0) %></div>
                <div class="user-info">
                    <div class="user-name"><%= fb.get("firstname") %> <%= fb.get("lastname") %></div>
                    <div class="user-email"><%= fb.get("email") %></div>
                </div>
            </div>
            <div class="feedback-comment"><%= fb.get("comment") %></div>
            <div class="feedback-date">Submitted on: <%= fb.get("created_at") %></div>
        </div>
        <% }} else { %>
        <div class="empty-state">
            <i class="fas fa-inbox"></i>
            <h3>No Feedbacks Yet</h3>
            <p>No feedbacks have been submitted yet.</p>
        </div>
        <% } %>
    </div>
</div>

<script>
    // Create animated particles
    function createParticles() {
        const particlesContainer = document.getElementById('particles');
        const particleCount = 50;

        for (let i = 0; i < particleCount; i++) {
            const particle = document.createElement('div');
            particle.className = 'particle';
            particle.style.left = Math.random() * 100 + '%';
            particle.style.animationDelay = Math.random() * 20 + 's';
            particle.style.animationDuration = (15 + Math.random() * 10) + 's';
            particlesContainer.appendChild(particle);
        }
    }

    createParticles();
</script>
</body>
</html>