<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Library Help Desk - FAQ</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; margin: 20px; }
        h1 { color: #333; }
        form { background: #fff; padding: 20px; border-radius: 10px; width: 500px; margin-bottom: 30px; }
        input, textarea { width: 100%; padding: 8px; margin: 8px 0; border-radius: 5px; border: 1px solid #ccc; }
        button { padding: 10px 15px; border: none; background: #007BFF; color: white; border-radius: 5px; cursor: pointer; }
        button:hover { background: #0056b3; }
        .faq-item { background: #fff; padding: 15px; border-radius: 10px; margin-bottom: 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .faq-item img { max-width: 150px; margin-top: 10px; border-radius: 5px; }
    </style>
</head>
<body>
<h1>Library Help Desk - FAQ</h1>

<!-- Admin form (your servlet should check session role before showing this) -->
<form action="AddFAQServlet" method="post" enctype="multipart/form-data">
    <h3>Add New FAQ</h3>
    <label>Question:</label>
    <input type="text" name="question" required />

    <label>Answer:</label>
    <textarea name="answer" rows="4" required></textarea>

    <label>Attach Image (optional):</label>
    <input type="file" name="faqImage" accept="image/*" />

    <button type="submit">Publish FAQ</button>
</form>

<h2>Frequently Asked Questions</h2>

<!-- FAQ list (Servlet will forward FAQ data here) -->
<div class="faq-item">
    <strong>Q: Example Question?</strong>
    <p>A: Example answer text for FAQ.</p>
    <img src="uploads/sample.jpg" alt="FAQ Image" />
</div>

<!-- Repeat FAQ items dynamically from servlet -->
</body>
</html>
