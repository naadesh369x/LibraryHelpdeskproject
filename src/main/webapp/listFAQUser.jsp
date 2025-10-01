<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>FAQs</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(120deg, #f3f7fa 60%, #e9e3fc 100%);
            margin: 0;
            padding: 0;
        }
        .site-header {
            width: 100%;
            background: linear-gradient(90deg, #5c2ef0 70%, #7c4dff 100%);
            color: #fff;
            box-shadow: 0 4px 18px rgba(92,46,240,0.08);
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 70px;
            position: relative;
        }
        .site-logo {
            font-size: 1.5em;
            font-weight: 700;
            letter-spacing: 1px;
            margin-left: 40px;
        }
        .site-nav {
            margin-right: 40px;
        }
        .site-nav a {
            color: #fff;
            text-decoration: none;
            font-weight: 500;
            margin-left: 24px;
            padding: 8px 16px;
            border-radius: 8px;
            transition: background 0.2s;
        }
        .site-nav a:hover, .back-btn:hover {
            background: rgba(255,255,255,0.12);
        }
        .faq-section {
            max-width: 900px;
            margin: 40px auto 40px auto;
            padding: 0 16px;
        }
        h2 {
            text-align: center;
            color: #5c2ef0;
            font-size: 2em;
            letter-spacing: 1px;
            margin-bottom: 32px;
            font-weight: 700;
        }
        .faq-bubble {
            background: linear-gradient(135deg, #ede7f6 80%, #fff 100%);
            border-radius: 32px;
            box-shadow: 0 4px 18px rgba(92,46,240,0.10);
            padding: 0;
            margin: 0 auto 24px auto;
            width: 100%;
            max-width: 700px;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .faq-bubble:hover {
            box-shadow: 0 8px 32px rgba(92,46,240,0.18);
            transform: translateY(-2px) scale(1.01);
        }
        .accordion {
            background: transparent;
            color: #5c2ef0;
            cursor: pointer;
            padding: 20px 28px 20px 28px;
            width: 100%;
            border: none;
            text-align: left;
            outline: none;
            font-size: 1.15em;
            border-radius: 32px 32px 0 0;
            font-weight: 600;
            transition: background 0.3s, color 0.3s;
            box-shadow: none;
            position: relative;
        }
        .accordion:hover, .accordion.active {
            background: linear-gradient(90deg, #d1c4e9 60%, #ede7f6 100%);
            color: #3d1e9a;
        }
        .accordion:after {
            content: '\002B';
            color: #7c4dff;
            float: right;
            font-size: 1.3em;
            margin-left: 10px;
            transition: transform 0.3s;
        }
        .accordion.active:after {
            content: "\2212";
            transform: rotate(180deg);
        }
        .panel {
            padding: 0 28px 18px 28px;
            display: none;
            background: transparent;
            border-radius: 0 0 32px 32px;
            width: 100%;
            margin: 0;
            font-size: 1.05em;
            color: #444;
            box-shadow: none;
        }
        .panel p {
            margin: 10px 0 0 0;
            background: #fffde7;
            border-radius: 12px;
            padding: 10px 16px;
            box-shadow: 0 1px 4px rgba(255,193,7,0.07);
            font-size: 1em;
        }
        .back-btn {
            position: absolute;
            top: 16px;
            left: 30px;
            text-decoration: none;
            padding: 8px 15px;
            background-color: #6c757d;
            color: white;
            border-radius: 8px;
            transition: background 0.3s;
            font-weight: 500;
        }
    </style>
</head>
<body>
<!-- Back to Dashboard Button -->
<a href="dashboard.jsp" class="back-btn" style="position:absolute;top:20px;left:30px;text-decoration:none;padding:8px 15px;background-color:#6c757d;color:white;border-radius:8px;transition:background 0.3s;">⬅ Back to Dashboard</a>
<h2>Frequently Asked Questions (FAQ)</h2>

<%
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement("SELECT * FROM faq ORDER BY created_at ASC");
         ResultSet rs = ps.executeQuery()) {

        int count = 1;
        while (rs.next()) {
            String question = rs.getString("question");
            String answer = rs.getString("answer");
%>
<div class="faq-bubble">
    <button class="accordion"><%= count++ %>. <%= question %></button>
    <div class="panel">
        <p><%= answer %></p>
    </div>
</div>
<%
        }
    } catch (Exception e) {
        out.println("Error loading FAQs: " + e.getMessage());
    }
%>

<script>
    var acc = document.getElementsByClassName("accordion");
    for (var i = 0; i < acc.length; i++) {
        acc[i].addEventListener("click", function() {
            this.classList.toggle("active");
            var panel = this.nextElementSibling;
            if (panel.style.display === "block") {
                panel.style.display = "none";
            } else {
                panel.style.display = "block";
            }
        });
    }
</script>

</body>
</html>
