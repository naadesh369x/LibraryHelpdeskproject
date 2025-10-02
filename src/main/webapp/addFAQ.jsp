<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add FAQ - Library Help Desk</title>

    <!-- Bootstrap for alignment & responsiveness -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(120deg, #f0f4f8, #d9e2ec);
            margin: 0;
            padding: 0;
        }
        .faq-container {
            max-width: 700px;
            margin: 60px auto;
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
            position: relative;
        }
        h2 {
            text-align: center;
            color: #34495e;
            margin-bottom: 30px;
            font-weight: 700;
        }
        label {
            font-weight: 600;
            color: #2c3e50;
            margin-top: 15px;
        }
        input[type="text"], textarea, input[type="file"] {
            border-radius: 10px;
            background: #f8fafc;
            border: 1px solid #dee2e6;
        }
        input[type="text"]:focus, textarea:focus {
            border-color: #007bff;
            background: #f1f9ff;
            box-shadow: 0 0 6px rgba(0,123,255,0.2);
        }
        .btn-submit {
            margin-top: 20px;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            padding: 12px;
            border-radius: 12px;
            background: linear-gradient(90deg, #43e97b, #38f9d7);
            border: none;
            color: white;
            transition: 0.3s;
        }
        .btn-submit:hover {
            background: linear-gradient(90deg, #38f9d7, #43e97b);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            text-decoration: none;
            padding: 8px 16px;
            background-color: #6c757d;
            color: white;
            border-radius: 8px;
            transition: background 0.3s;
        }
        .back-btn:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

<div class="faq-container">
    //back to dashboard
    <a href="javascript:history.back()" class="btn btn-secondary btn-sm text-white m-2">⬅ Go Back</a>

    <h2>Add FAQ</h2>

    <form action="AddFAQServlet" method="post" enctype="multipart/form-data">
        <!-- Question -->
        <div class="mb-3">
            <label>Question:</label>
            <input type="text" name="question" class="form-control" required>
        </div>

       //answer
        <div class="mb-3">
            <label>Answer:</label>
            <textarea name="answer" rows="3" class="form-control" required></textarea>
        </div>


        <div class="mb-3">
            <label>Attach Image (optional):</label>
            <input type="file" name="faqImage" class="form-control" accept="image/*">
        </div>


        <button type="submit" class="btn-submit">✅ Publish FAQ</button>
    </form>
</div>

</body>
</html>
