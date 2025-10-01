<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Real Estate Portal</title>
    <link rel="stylesheet" href="css/user-dashboard.css"> <!-- Assuming shared CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .top-bar {
            background-color: #2c3e50;
            color: white;
            padding: 10px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .top-bar .left h2 {
            margin: 0;
            font-size: 24px;
        }

        .top-bar .right a {
            margin-left: 15px;
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 5px;
            background-color: #3498db;
            transition: background-color 0.3s ease;
        }

        .top-bar .right a:hover {
            background-color: #2980b9;
        }

        .main-content {
            text-align: center;
            margin-top: 120px;
        }

        .main-content h1 {
            font-size: 42px;
            color: #2c3e50;
        }

        .main-content p {
            font-size: 18px;
            color: #555;
        }

        .main-content a.get-started-btn {
            margin-top: 30px;
            display: inline-block;
            padding: 12px 25px;
            font-size: 18px;
            background-color: #27ae60;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .main-content a.get-started-btn:hover {
            background-color: #1e8449;
        }
    </style>
</head>
<body>


<div class="main-content">
    <h1>Welcome to Your Property Destination</h1>
    <p>Browse listings, find your dream home, or list your property with ease.</p>
    <a href="admindashboard.jsp" class="get-started-btn"><i class="fas fa-play-circle"></i> Get Started</a>
</div>

</body>
</html>
