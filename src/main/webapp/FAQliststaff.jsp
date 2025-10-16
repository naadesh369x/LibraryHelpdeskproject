<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>FAQs - Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #1b1b1b;
            color: #fff;
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            margin: 0;
            padding: 2rem;
        }
        .faq-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 24px;
        }
        .faq-card {
            background: #2a2a2a;
            border-radius: 16px;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
            border: 1px solid #333;
        }
        .faq-card h3 {
            margin: 0;
            color: #33b5e5;
            font-size: 1.2em;
            font-weight: 600;
        }
        .faq-card p {
            margin: 0;
            color: #ccc;
            font-size: 1em;
            line-height: 1.5;
        }
        .faq-card img {
            max-width: 100%;
            border-radius: 12px;
            margin-top: 8px;
        }
        .faq-card .created {
            font-size: 12px;
            color: #888;
            margin-top: auto;
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #ccc;
        }
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #555;
        }
    </style>
</head>
<body>

<h1 class="mb-4">Frequently Asked Questions</h1>

<div class="faq-container">
    <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM faq ORDER BY created_at DESC");
             ResultSet rs = ps.executeQuery()) {

            boolean hasFAQ = false;
            while (rs.next()) {
                hasFAQ = true;
                String question = rs.getString("question");
                String answer = rs.getString("answer");
                String imgPath = rs.getString("image_path");
                Timestamp createdAt = rs.getTimestamp("created_at");
    %>
    <div class="faq-card">
        <h3><%= question %></h3>
        <p><%= answer %></p>
        <% if (imgPath != null && !imgPath.isEmpty()) { %>
        <img src="uploads/<%= imgPath %>" alt="FAQ Image"/>
        <% } %>
        <div class="created">Added on: <%= createdAt %></div>
    </div>
    <%
        }
        if (!hasFAQ) {
    %>
    <div class="empty-state">
        <i class="fas fa-question-circle"></i>
        <h3>No FAQs Found</h3>
        <p>No frequently asked questions have been added yet.</p>
    </div>
    <%
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        }
    %>
</div>

</body>
</html>
