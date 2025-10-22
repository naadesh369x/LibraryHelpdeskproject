<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Notification Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }

        .card {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 40px 50px;
            width: 400px;
            text-align: center;
            color: #fff;
            animation: fadeIn 1s ease-in-out;
        }

        h2 {
            font-weight: 600;
            margin-bottom: 25px;
            font-size: 26px;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        label {
            text-align: left;
            font-size: 14px;
            color: #e0e0e0;
        }

        input[type="text"] {
            padding: 12px 15px;
            border-radius: 10px;
            border: none;
            outline: none;
            background: rgba(255, 255, 255, 0.25);
            color: #fff;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        input[type="text"]::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        input[type="text"]:focus {
            background: rgba(255, 255, 255, 0.4);
            box-shadow: 0 0 8px rgba(255,255,255,0.5);
        }

        button {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            border: none;
            color: #fff;
            padding: 12px;
            border-radius: 10px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
        }

        button:hover {
            transform: scale(1.05);
            box-shadow: 0 0 10px rgba(72, 239, 128, 0.7);
        }

        .link-container {
            margin-top: 25px;
        }

        a {
            text-decoration: none;
            color: #fff;
            font-weight: 500;
            transition: opacity 0.3s ease;
        }

        a:hover {
            opacity: 0.8;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<div class="card">
    <h2>📢 Admin Notification Panel</h2>

    <form action="admin" method="post">
        <label for="message">Enter Message:</label>
        <input type="text" id="message" name="message" placeholder="Type your message..." required>
        <button type="submit">Send Notification</button>
    </form>

    <div class="link-container">
        <a href="userNotifications.jsp">🔔 View User Notifications</a>
    </div>
</div>

</body>
</html>
