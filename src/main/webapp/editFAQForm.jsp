<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    String question = "";
    String answer = "";
    String imgPath = "";

    if (id != null) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM faq WHERE id = ?")) {
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                question = rs.getString("question");
                answer = rs.getString("answer");
                imgPath = rs.getString("image_path");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    } else {
        response.sendRedirect("listFAQAdmin.jsp");
    }
%>
<html>
<head>
    <title>Edit FAQ</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f8;
            margin: 0; padding: 0;
        }
        .container {
            width: 600px;
            margin: 50px auto;
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #34495e;
            margin-bottom: 25px;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #2c3e50;
        }
        input[type="text"], textarea, input[type="file"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
        }
        button {
            margin-top: 20px;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
        }
        .btn-submit {
            background: #2ecc71;
            color: #fff;
        }
        .btn-submit:hover {
            background: #27ae60;
        }
        img {
            margin-top: 10px;
            max-width: 100%;
            border-radius: 10px;
        }
        .back-btn {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 15px;
            background: #3498db;
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
        }
        .back-btn:hover { background: #2980b9; }
    </style>
</head>
<body>
<div class="container">
    <h2>Edit FAQ</h2>
    <form action="EditFAQServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= id %>"/>

        <label>Question:</label>
        <input type="text" name="question" value="<%= question %>" required/>

        <label>Answer:</label>
        <textarea name="answer" rows="4" required><%= answer %></textarea>

        <label>Current Image:</label>
        <% if (imgPath != null && !imgPath.isEmpty()) { %>
        <img src="uploads/<%= imgPath %>" alt="FAQ Image"/>
        <% } else { %>
        <p style="color:#888;">No image uploaded.</p>
        <% } %>

        <label>Change Image (optional):</label>
        <input type="file" name="faqImage" accept="image/*"/>

        <button type="submit" class="btn-submit">Update FAQ</button>
    </form>

    <a href="listFAQAdmin.jsp" class="back-btn">← Back to FAQ List</a>
</div>
</body>
</html>
