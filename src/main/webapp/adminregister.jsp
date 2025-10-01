<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Register</title>
    <link rel="stylesheet" type="text/css" href="css/register.css">
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container {
            width: 400px; margin: 50px auto; background: #fff; padding: 20px;
            border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 { text-align: center; margin-bottom: 20px; }
        label { display: block; margin-top: 10px; }
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc;
            border-radius: 5px;
        }
        .error-message { color: red; margin: 10px 0; text-align: center; }
        .submit-btn {
            width: 100%; padding: 10px; margin-top: 15px;
            background: #007bff; color: white; border: none;
            border-radius: 5px; cursor: pointer;
        }
        .submit-btn:hover { background: #0056b3; }
    </style>
</head>
<body>
<div class="container">
    <h1>Admin Register</h1>

    <!-- Show error if exists -->
    <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
    <div class="error-message"><%= error %></div>
    <%
        }
    %>

    <!-- Register Form -->
    <form action="AdminRegisterServlet" method="post">
        <label for="firstname">First Name:</label>
        <input type="text" id="firstname" name="firstName" placeholder="Enter first name" required>

        <label for="lastname">Last Name:</label>
        <input type="text" id="lastname" name="lastName" placeholder="Enter last name" required>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" placeholder="Enter email" required>

        <label for="username">Username:</label>
        <input type="text" id="username" name="username" placeholder="Enter username" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" placeholder="Enter password" required>

        <label for="confirmPassword">Confirm Password:</label>
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>

        <input type="submit" value="Register" class="submit-btn">
    </form>

    <!-- Redirect to Login -->
    <form action="adminlogin.jsp" method="get" class="login-form">
        <input type="submit" value="Already have an account? Login" class="submit-btn">
    </form>
</div>
</body>
</html>
