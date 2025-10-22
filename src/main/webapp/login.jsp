<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Background Image */
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: url('images/library-bg.jpg') no-repeat center center fixed;
            background-size: cover;
        }

        /* Overlay for better contrast */
        body::before {
            content: '';
            position: absolute;
            top:0; left:0;
            width:100%; height:100%;
            background: rgba(0,0,0,0.5);
            z-index: 0;
        }

        .login-container {
            position: relative;
            display: flex;
            width: 900px;
            max-width: 100%;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 12px 30px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.95); /* Slight transparency */
            z-index: 1;
        }

        /* Left Panel */
        .login-left {
            flex: 1;
            background: url('images/library-side.jpg') no-repeat center center;
            background-size: cover;
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px;
            position: relative;
        }
        .login-left::before {
            content: '';
            position: absolute;
            top:0; left:0;
            width:100%; height:100%;
            background: rgba(0,0,0,0.45);
        }
        .login-left-content {
            position: relative;
            text-align: center;
        }
        .login-left h2 {
            font-size: 36px;
            margin-bottom: 20px;
            color: #27ae60;
        }
        .login-left p {
            font-size: 18px;
        }

        /* Right Panel */
        .login-right {
            flex: 1;
            padding: 50px 30px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: #fff;
            border-radius: 0 0 0 0;
        }

        .login-right h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #27ae60;
        }

        .login-type-selector {
            margin-bottom: 25px;
            text-align: center;
        }

        .login-type-selector label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }

        .login-type-select {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background-color: #fff;
            font-size: 16px;
            color: #333;
            cursor: pointer;
            transition: border-color 0.3s;
        }

        .login-type-select:focus {
            outline: none;
            border-color: #27ae60;
            box-shadow: 0 0 0 2px rgba(39, 174, 96, 0.2);
        }

        .form-control {
            border-radius: 8px;
            padding-left: 40px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
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

        .btn-primary {
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
        .btn-primary:hover {
            background-color: #1e8449;
        }

        .text-center a {
            color: #27ae60;
            font-weight: 500;
        }
        .text-center a:hover { text-decoration: underline; }

        .alert {
            border-radius: 10px;
            padding: 12px 20px;
            margin-bottom: 20px;
        }

        @media (max-width: 900px) {
            .login-container {
                flex-direction: column;
            }
            .login-left {
                height: 200px;
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <!-- Left Panel -->
    <div class="login-left">
        <div class="login-left-content">
            <h2>Welcome Back!</h2>
            <p>Access library services, manage your requests, and stay connected.</p>
        </div>
    </div>

    <!-- Right Panel -->
    <div class="login-right">
        <h2><i class="fas fa-book-reader"></i> Student Login</h2>

        <div class="login-type-selector">
            <label for="loginType">Login as:</label>
            <select id="loginType" class="login-type-select">
                <option value="student" selected>Student</option>
                <option value="staff">Staff</option>
                <option value="admin">Admin</option>
            </select>
        </div>

        <% String success = request.getParameter("success");
            if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
        <% } %>

        <% String error = request.getParameter("error");
            if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form action="LoginServlet" method="post">
            <div class="input-icon">
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" class="form-control" placeholder="Email" required>
            </div>
            <div class="input-icon">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" class="form-control" placeholder="Password" required>
            </div>
            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-primary">Login</button>
            </div>
        </form>

        <div class="text-center">
            <p>Don't have an account? <a href="register.jsp">Register here</a></p>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const loginTypeSelect = document.getElementById('loginType');
        const loginTitle = document.querySelector('.login-right h2');
        const loginForm = document.querySelector('form');

        loginTypeSelect.addEventListener('change', function() {
            const selectedType = this.value;

            // Update the login title based on selection
            switch(selectedType) {
                case 'admin':
                    loginTitle.innerHTML = '<i class="fas fa-user-shield"></i> Admin Login';

                    window.location.href = 'adminlogin.jsp';
                    break;
                case 'staff':
                    loginTitle.innerHTML = '<i class="fas fa-user-tie"></i> Staff Login';

                    window.location.href = 'stafflogin.jsp';
                    break;
                default:
                    loginTitle.innerHTML = '<i class="fas fa-book-reader"></i> Student Login';

                    break;
            }
        });
    });
</script>

</body>
</html>