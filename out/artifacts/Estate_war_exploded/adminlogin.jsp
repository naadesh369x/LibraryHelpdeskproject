<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <link rel="stylesheet" href="css/style.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f1f1;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-container {
            background: white;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            width: 350px;
        }
        .login-container h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }
        .login-container input[type="email"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 12px 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .login-container button {
            width: 100%;
            padding: 12px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        .login-container button:hover {
            background: #0056b3;
        }
        .error-msg {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Admin Login</h2>

    <% String error = request.getParameter("error"); %>
    <% if (error != null) { %>
    <p class="error-msg"><%= error %></p>
    <% } %>

    <form action="admin-login" method="post">
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="password" placeholder="Password" required />
        <button type="submit">Login</button>
    </form>
</div>
</body>
</html>
