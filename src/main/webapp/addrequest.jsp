<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get logged-in user email from session (if available)
    String email = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Request New Resource</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #74ebd5, #ACB6E5);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            max-width: 600px;
            margin-top: 60px;
        }
        .card {
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .card-header {
            background: #2c3e50;
            color: #fff;
            font-weight: 600;
            font-size: 18px;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
        }
        .btn-submit {
            background: #27ae60;
            color: #fff;
            font-weight: 500;
        }
        .btn-submit:hover {
            background: #1e8449;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="card">
        <div class="card-header">Request New Resource</div>
        <div class="card-body">
            <form action="RequestResourceServlet" method="post">

                <div class="mb-3">
                    <label for="title" class="form-label">Resource Title</label>
                    <input type="text" name="title" id="title" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label for="author" class="form-label">Author</label>
                    <input type="text" name="author" id="author" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label for="type" class="form-label">Type</label>
                    <select name="type" id="type" class="form-select" required>
                        <option value="">-- Select Type --</option>
                        <option value="Book">Book</option>
                        <option value="Journal">Journal</option>
                        <option value="Thesis">Thesis</option>
                        <option value="Magazine">Magazine</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="justification" class="form-label">Justification</label>
                    <textarea name="justification" id="justification" class="form-control" rows="4" required></textarea>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Your Email</label>
                    <input type="email" name="email" id="email" class="form-control" value="<%= email != null ? email : "" %>" <%= (email != null) ? "readonly" : "" %> required>
                </div>

                <button type="submit" class="btn btn-submit w-100">Submit Request</button>
            </form>
        </div>
    </div>
</div>

</body>
</html>
