<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
            width: 400px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .message {
            text-align: center;
            color: red;
            margin-bottom: 15px;
        }
        form input, form select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        form button {
            width: 100%;
            padding: 10px;
            background: #28a745;
            border: none;
            color: #fff;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
        }
        form button:hover {
            background: #218838;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>User Registration</h2>

    <% String message = (String) request.getAttribute("message");
        if (message != null) { %>
    <div class="message"><%= message %></div>
    <% } %>

    <form action="RegisterServlet" method="post">
        <input type="text" name="firstName" placeholder="First Name" required>
        <input type="text" name="lastName" placeholder="Last Name" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="number" name="age" placeholder="Age" required>
        <input type="text" name="phoneNumber" placeholder="Telephone" required>
        <input type="text" name="hometown" placeholder="Hometown" required>

        <select name="gender" required>
            <option value="">Select Gender</option>
            <option value="Male">Male</option>
            <option value="Female">Female</option>
            <option value="Other">Other</option>
        </select>

        <input type="password" name="password" placeholder="Password" required>
        <input type="password" name="confirmPassword" placeholder="Confirm Password" required>

        <!-- Hidden role field (optional, default is Member in servlet) -->
        <input type="hidden" name="role" value="Member">

        <button type="submit">Register</button>
    </form>
</div>
</body>
</html>
