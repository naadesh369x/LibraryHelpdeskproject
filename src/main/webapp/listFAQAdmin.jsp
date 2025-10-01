<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>FAQs - Admin</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; padding: 20px; }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }

        .top-bar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .btn {
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 8px;
            transition: 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.12);
            font-size: 14px;
            font-weight: 600;
        }

        .btn-add-faq {
            background: #007bff;
            color: #fff;
        }
        .btn-add-faq:hover { background: #0056b3; }

        .btn-dashboard {
            background: #6c757d;
            color: #fff;
        }
        .btn-dashboard:hover { background: #5a6268; }

        .faq-container {
            display: flex;
            flex-wrap: wrap;
            gap: 32px;
            justify-content: center;
            position: relative;
            z-index: 1;
        }

        .faq-card {
            background: #fff;
            border-radius: 50px 50px 50px 10px/50px 50px 10px 50px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.12), 0 1.5px 6px rgba(0,123,255,0.08);
            padding: 28px 24px 20px 24px;
            width: 320px;
            display: flex;
            flex-direction: column;
            gap: 14px;
            position: relative;
            transition: transform 0.2s, box-shadow 0.2s;
            overflow: hidden;
        }

        .faq-card:hover {
            transform: translateY(-6px) scale(1.03);
            box-shadow: 0 16px 32px rgba(0,0,0,0.18), 0 2px 12px rgba(0,123,255,0.12);
        }

        .faq-card img {
            max-width: 100%;
            border-radius: 18px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }

        .faq-card h3 { margin: 0; color: #007bff; font-size: 1.18em; z-index: 1; }
        .faq-card p { margin: 0; color: #555; z-index: 1; font-size: 1em; }

        .faq-card .created { font-size: 12px; color: #888; z-index: 1; }

        .actions {
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
            z-index: 1;
        }

        .actions a {
            text-decoration: none;
            padding: 7px 14px;
            border-radius: 18px;
            color: #fff;
            font-size: 13px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.07);
            transition: background 0.2s, box-shadow 0.2s;
        }

        .edit { background: #28a745; }
        .edit:hover { background: #218838; box-shadow: 0 2px 8px rgba(40,167,69,0.15);}
        .delete { background: #dc3545; }
        .delete:hover { background: #c82333; box-shadow: 0 2px 8px rgba(220,53,69,0.15);}
    </style>
</head>
<body>
<h2>Manage FAQs</h2>

<div class="top-bar">
    <a class="btn btn-dashboard" href="admin-dashboard">🏠  Back to Dashboard</a>
    <a class="btn btn-add-faq" href="addFAQ.jsp">➕ Add FAQ</a>
</div>

<div class="faq-container">
    <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM faq ORDER BY created_at DESC");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("id");
                String question = rs.getString("question");
                String answer = rs.getString("answer");
                String imgPath = rs.getString("image_path");
                Timestamp createdAt = rs.getTimestamp("created_at");
    %>
    <div class="faq-card">
        <h3><%= question %></h3>
        <p><%= answer %></p>
        <% if (imgPath != null) { %>
        <img src="uploads/<%= imgPath %>" alt="FAQ Image"/>
        <% } %>
        <div class="created">Added on: <%= createdAt %></div>
        <div class="actions">
            <a class="edit" href="editFAQForm.jsp?id=<%= id %>">Edit</a>
            <a class="delete" href="DeleteFAQServlet?id=<%= id %>" onclick="return confirm('Are you sure?');">Delete</a>
        </div>
    </div>
    <%
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
</div>

</body>
</html>
