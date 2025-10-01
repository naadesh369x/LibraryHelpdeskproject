<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { width: 400px; margin: 50px auto; background: #fff; padding: 20px;
            border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; margin-bottom: 20px; }
        label { display: block; margin-top: 10px; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 5px; }
        .error-message { color: red; margin: 10px 0; text-align: center; }
        .submit-btn { width: 100%; padding: 10px; margin-top: 15px;
            background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .submit-btn:hover { background: #0056b3; }
    </style>
</head>
<body>
<div class="container">
    <h1>Staff Login</h1>

    <!-- Show error if exists -->
    <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
    <div class="error-message"><%= error %></div>
    <%
        }
    %>

    <!-- Login Form -->
    <form action="StaffLoginServlet" method="post">
        <label for="email">Email:</label>
        <input type="text" id="email" name="email" placeholder="Enter your email" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" placeholder="Enter your password" required>

        <input type="submit" value="Login" class="submit-btn">
    </form>

    <!-- Redirect to Register -->


    </form>
</div>
</body>
</html>
