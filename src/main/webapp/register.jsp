<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(to right, #2c3e50, #3498db);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .card {
            background: #fff; /* White box */
            color: #333; /* Dark text for readability */
            padding: 40px 30px;
            border-radius: 15px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 450px;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.3);
        }

        .card h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #27ae60;
        }

        .form-control {
            background: #f8f9fa;
            border: 1px solid #ccc;
            color: #333;
            border-radius: 8px;
            padding-left: 40px;
            margin-bottom: 15px;
        }
        .form-control:focus {
            background: #fff;
            box-shadow: 0 0 0 2px #27ae60;
            color: #333;
        }

        .input-icon {
            position: relative;
        }
        .input-icon i {
            position: absolute;
            top: 50%;
            left: 12px;
            transform: translateY(-50%);
            color: #27ae60;
        }

        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(90deg,#27ae60 60%,#2ecc71 100%);
            border: none;
            color: #fff;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }
        button:hover {
            background-color: #1e8449;
        }

        .message {
            text-align: center;
            margin-bottom: 15px;
        }

        .text-center a {
            color: #27ae60;
            font-weight: 500;
        }
        .text-center a:hover {
            text-decoration: underline;
        }

        @media (max-width: 500px) {
            .card {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
<div class="card">
    <h2><i class="fas fa-user-plus"></i> Register</h2>

    <% String message = (String) request.getAttribute("message");
        if (message != null) { %>
    <div class="alert alert-warning message"><%= message %></div>
    <% } %>

    <form action="RegisterServlet" method="post">
        <div class="input-icon">
            <i class="fas fa-user"></i>
            <input type="text" name="firstName" class="form-control" placeholder="First Name" required>
        </div>
        <div class="input-icon">
            <i class="fas fa-user"></i>
            <input type="text" name="lastName" class="form-control" placeholder="Last Name" required>
        </div>
        <div class="input-icon">
            <i class="fas fa-envelope"></i>
            <input type="email" name="email" class="form-control" placeholder="Email" required>
        </div>
        <div class="input-icon">
            <i class="fas fa-calendar"></i>
            <input type="number" name="age" class="form-control" placeholder="Age" required>
        </div>
        <div class="input-icon">
            <i class="fas fa-phone"></i>
            <input type="text" name="phoneNumber" class="form-control" placeholder="Telephone" required>
        </div>
        <div class="input-icon">
            <i class="fas fa-home"></i>
            <input type="text" name="hometown" class="form-control" placeholder="Hometown" required>
        </div>
        <div class="input-icon">
            <i class="fas fa-venus-mars"></i>
            <select name="gender" class="form-control" required>
                <option value="">Select Gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>
        </div>
        <div class="input-icon">
            <i class="fas fa-lock"></i>
            <input type="password" name="password" class="form-control" placeholder="Password" required>
        </div>
        <div class="input-icon">
            <i class="fas fa-lock"></i>
            <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm Password" required>
        </div>

        <input type="hidden" name="role" value="Member">

        <button type="submit">Register</button>
    </form>

    <div class="text-center mt-3">
        <p>Already have an account? <a href="login.jsp">Login here</a></p>
    </div>
</div>
</body>
</html>
