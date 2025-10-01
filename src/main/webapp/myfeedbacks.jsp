<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.example.demo.utils.DBConnection" %>
<%
    HttpSession session1 = request.getSession(false);
    String userEmail = (session1 != null) ? (String) session1.getAttribute("email") : null;
    if(userEmail == null){
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }

    List<Map<String,String>> feedbacks = new ArrayList<>();
    try(Connection conn = DBConnection.getConnection()){
        String sql = "SELECT * FROM feedbacks WHERE email=? ORDER BY created_at DESC";
        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1, userEmail);
            try(ResultSet rs = ps.executeQuery()){
                while(rs.next()){
                    Map<String,String> fb = new HashMap<>();
                    fb.put("id", String.valueOf(rs.getInt("id")));
                    fb.put("firstname", rs.getString("firstname"));
                    fb.put("lastname", rs.getString("lastname"));
                    fb.put("comment", rs.getString("comment"));
                    fb.put("rating", String.valueOf(rs.getInt("rating")));
                    fb.put("created_at", rs.getTimestamp("created_at").toString());
                    feedbacks.add(fb);
                }
            }
        }
    } catch(Exception e){ e.printStackTrace(); }

    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Feedbacks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Bubble background */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #74ebd5 0%, #ACB6E5 100%);
            overflow-x: hidden;
            position: relative;
        }

        body::before {
            content: "";
            position: absolute;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(255,255,255,0.2) 1px, transparent 1px);
            background-size: 50px 50px;
            z-index: 0;
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

        .top-bar .logout-btn {
            background: #e74c3c;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 7px;
            text-decoration: none;
        }

        .top-bar .logout-btn:hover {
            background: #c0392b;
        }

        .container {
            position: relative;
            z-index: 1;
            margin-top: 40px;
        }

        h2 {
            text-align: center;
            color: #23272f;
            margin-bottom: 30px;
        }

        .btn-top {
            margin-bottom: 20px;
        }

        .feedback-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(44,62,80,0.13), 0 1.5px 8px rgba(44,62,80,0.09);
            padding: 28px 28px 20px 28px;
            margin-bottom: 24px;
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid #e6e6e6;
        }

        .feedback-card:hover {
            transform: translateY(-6px) scale(1.02);
            box-shadow: 0 16px 40px rgba(44,62,80,0.18), 0 2px 12px rgba(44,62,80,0.13);
        }

        .feedback-header {
            font-weight: 700;
            color: #6c63ff;
            margin-bottom: 10px;
            font-size: 1.15rem;
        }

        .btn-edit {
            background: linear-gradient(90deg, #6c63ff 60%, #74ebd5 100%);
            color: #fff;
            border-radius: 8px;
            margin-right: 5px;
            border: none;
            padding: 8px 18px;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(44,62,80,0.08);
        }

        .btn-edit:hover { background: #5548d3; }

        .btn-delete {
            background: linear-gradient(90deg, #e74c3c 60%, #ffb6b6 100%);
            color: #fff;
            border-radius: 8px;
            border: none;
            padding: 8px 18px;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(44,62,80,0.08);
        }

        .btn-delete:hover { background: #bb2d3b; }

        .form-control, .form-select {
            border-radius: 8px;
        }

        .top-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        @media(max-width:768px) {
            .top-buttons { flex-direction: column; gap: 10px; }
        }

        .feedbacks-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px;
        }
    </style>
</head>
<body>

<!-- Modern Top Bar -->
<div class="top-bar">
    <div class="logo">
        <i class="fas fa-star"></i> My Feedbacks
    </div>
    <div class="nav">
        <a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
        <a href="addfeedback.jsp"><i class="fas fa-plus"></i> Add Feedback</a>
    </div>
    <a href="mainpage.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<div class="container">

    <h2>My Feedbacks</h2>

    <% if(successMsg != null){ %>
    <div class="alert alert-success"><%= successMsg %></div>
    <% } %>
    <% if(errorMsg != null){ %>
    <div class="alert alert-danger"><%= errorMsg %></div>
    <% } %>

    <div class="feedbacks-grid" id="feedbacksGrid">
        <% if(feedbacks != null && !feedbacks.isEmpty()){
            int idx = 0;
            for(Map<String,String> fb : feedbacks){ %>
        <div class="feedback-card" style="max-width:100%; margin:0; padding:18px 18px 14px 18px;" id="card-<%= idx %>">
            <div class="feedback-header" style="font-size:1rem;">
                <%= fb.get("firstname") %> <%= fb.get("lastname") %> | Rating: <span id="rating-<%= idx %>"><%= fb.get("rating") %></span>/5
                <button type="button" class="btn" style="background:none; border:none; float:right;" onclick="toggleEdit(<%= idx %>)">
                    <i class="fas fa-pencil-alt"></i>
                </button>
            </div>
            <div class="mb-2" style="font-size:0.97rem;" id="comment-<%= idx %>"><strong>Comment:</strong> <%= fb.get("comment") %></div>
            <div class="text-muted mb-3" style="font-size:0.85rem;">Submitted on: <%= fb.get("created_at") %></div>
            <form action="EditFeedbackServlet" method="post" class="mb-2" id="edit-form-<%= idx %>" style="display:none;">
                <input type="hidden" name="id" value="<%= fb.get("id") %>">
                <textarea name="comment" class="form-control mb-2" rows="2"><%= fb.get("comment") %></textarea>
                <input type="number" name="rating" value="<%= fb.get("rating") %>" min="1" max="5" class="form-control mb-2" required>
                <button type="submit" class="btn btn-edit">Update</button>
                <button type="button" class="btn btn-secondary" onclick="toggleEdit(<%= idx %>)">Cancel</button>
            </form>
            <form action="DeleteFeedbackServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this feedback?');">
                <input type="hidden" name="id" value="<%= fb.get("id") %>">
                <button type="submit" class="btn btn-delete">Delete</button>
            </form>
        </div>
        <% idx++; }} else { %>
        <div class="feedback-card" style="max-width:100%; margin:0; padding:18px 18px 14px 18px;">
            <div class="feedback-header" style="font-size:1rem;">
                Default User | Rating: 5/5
            </div>
            <div class="mb-2" style="font-size:0.97rem;"><strong>Comment:</strong> This is a default feedback. Share your experience with us!</div>
            <div class="text-muted mb-3" style="font-size:0.85rem;">Submitted on: -</div>
        </div>
        <% } %>
    </div>

</div>
<script>
function toggleEdit(idx) {
    var form = document.getElementById('edit-form-' + idx);
    var comment = document.getElementById('comment-' + idx);
    var rating = document.getElementById('rating-' + idx);
    if(form.style.display === 'none') {
        form.style.display = '';
        if(comment) comment.style.display = 'none';
        if(rating) rating.parentElement.style.display = 'none';
    } else {
        form.style.display = 'none';
        if(comment) comment.style.display = '';
        if(rating) rating.parentElement.style.display = '';
    }
}
</script>
</body>
</html>
