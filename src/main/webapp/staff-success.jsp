<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="alert alert-info shadow-lg">
        <h4><%= request.getAttribute("message") %></h4>
        <a href="add-staff.jsp" class="btn btn-primary mt-3">Add Another Staff</a>
        <a href="admin-dashboard" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</div>

</body>
</html>
