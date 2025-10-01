<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get last visited page (if stored in session)
    String lastPage = (String) session.getAttribute("lastPage");
    if (lastPage == null || lastPage.isEmpty()) {
        lastPage = "admindashboard.jsp"; // default fallback
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Success</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .card {
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .btn-back {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="card bg-white">
    <h2 class="text-success">✅ Action Successful!</h2>
    <p>Your request was completed successfully.</p>
    <a href="javascript:history.back()" class="btn btn-secondary btn-sm text-white m-2">⬅ Go Back</a>
</div>

</body>
</html>
