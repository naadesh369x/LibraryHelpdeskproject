<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login</title>
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
            color: #3498db;
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
            margin-bottom: 30px;
            color: #3498db;
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
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
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
            color: #3498db;
        }

        .btn-primary {
            width: 100%;
            padding: 12px;
            background: linear-gradient(90deg,#3498db 60%,#5dade2 100%);
            border: none;
            color: #fff;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-primary:hover {
            background-color: #2980b9;
        }

        .text-center a {
            color: #3498db;
            font-weight: 500;
        }
        .text-center a:hover { text-decoration: underline; }

        .alert {
            border-radius: 10px;
            padding: 12px 20px;
            margin-bottom: 20px;
        }

        .error-message {
            color: #e74c3c;
            margin: 10px 0;
            text-align: center;
            padding: 10px;
            background-color: #fadbd8;
            border-radius: 8px;
            border: 1px solid #e74c3c;
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
            <h2>Staff Portal</h2>
            <p>Access administrative tools, manage resources, and oversee library operations.</p>
        </div>
    </div>

    <!-- Right Panel -->
    <div class="login-right">
        <h2><i class="fas fa-user-tie"></i> Staff Login</h2>

        <div class="login-type-selector">
            <label for="loginType">Login as:</label>
            <select id="loginType" class="login-type-select">
                <option value="student">Student</option>
                <option value="staff" selected>Staff</option>
                <option value="admin">Admin</option>
            </select>
        </div>

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
            <div class="input-icon">
                <i class="fas fa-envelope"></i>
                <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>

            <div class="input-icon">
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-primary">Login</button>
            </div>
        </form>

        <div class="text-center">

        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const loginTypeSelect = document.getElementById('loginType');

        loginTypeSelect.addEventListener('change', function() {
            const selectedType = this.value;

            // Redirect based on selection
            switch(selectedType) {
                case 'admin':
                    window.location.href = 'adminlogin.jsp';
                    break;
                case 'student':
                    window.location.href = 'login.jsp';
                    break;
                // Staff is the current page, no action needed
            }
        });
    });
</script>

</body>
</html>