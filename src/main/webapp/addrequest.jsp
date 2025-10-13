<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get logged-in user information from session
    String email = (String) session.getAttribute("email");
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request New Resource</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Full page background */
        body {
            min-height: 100vh;
            background: url('images/library-bg.jpg') no-repeat center center fixed;
            background-size: cover;
            position: relative;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px 0;
        }

        /* Overlay */
        body::before {
            content: '';
            position: absolute;
            top:0; left:0;
            width:100%; height:100%;
            background: rgba(0,0,0,0.6);
            z-index: 0;
        }

        .container {
            position: relative;
            z-index: 1;
            max-width: 700px;
            margin-top: 20px;
            animation: fadeInUp 0.7s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.3);
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            border: none;
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: #fff;
            font-weight: 600;
            font-size: 22px;
            padding: 20px;
            text-align: center;
            position: relative;
        }

        .card-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #27ae60, #2ecc71);
        }

        .card-body {
            padding: 30px;
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .form-label i {
            margin-right: 8px;
            color: #27ae60;
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #ddd;
            padding: 12px 15px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(39, 174, 96, 0.2);
            border-color: #27ae60;
            transform: translateY(-2px);
        }

        .form-control:hover, .form-select:hover {
            border-color: #27ae60;
        }

        .btn-submit {
            background: linear-gradient(90deg, #27ae60 0%, #2ecc71 100%);
            color: #fff;
            font-weight: 600;
            padding: 12px;
            transition: all 0.3s ease;
            border-radius: 10px;
            border: none;
            box-shadow: 0 4px 10px rgba(39, 174, 96, 0.3);
        }

        .btn-submit:hover {
            background: linear-gradient(90deg, #229954 0%, #27ae60 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(39, 174, 96, 0.4);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .btn-back {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 8px 15px;
            border-radius: 30px;
            transition: all 0.3s ease;
            text-decoration: none;
            font-weight: 500;
            z-index: 10;
            backdrop-filter: blur(5px);
        }

        .btn-back:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            transform: translateX(-5px);
        }

        .user-info {
            background: rgba(39, 174, 96, 0.1);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border-left: 4px solid #27ae60;
        }

        .user-info h6 {
            margin: 0;
            color: #2c3e50;
            font-weight: 600;
        }

        .user-info p {
            margin: 5px 0 0 0;
            color: #555;
        }

        .user-info .user-id {
            font-family: 'Courier New', monospace;
            background: rgba(39, 174, 96, 0.2);
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: 600;
        }

        .form-text {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 5px;
        }

        .alert-info {
            background-color: rgba(23, 162, 184, 0.1);
            border-left: 4px solid #17a2b8;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .required-star {
            color: #e74c3c;
            margin-left: 3px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
                max-width: 100%;
            }

            .card-body {
                padding: 20px;
            }

            .btn-back {
                top: 10px;
                left: 10px;
            }
        }
    </style>
</head>
<body>

<a href="dashboard.jsp" class="btn-back">
    <i class="fas fa-arrow-left"></i> Back to Dashboard
</a>

<div class="container">
    <div class="card">
        <div class="card-header">
            <i class="fas fa-book-open me-2"></i> Request New Resource
        </div>
        <div class="card-body">
            <% if (email != null) { %>
            <div class="user-info">
                <h6><i class="fas fa-user-circle me-2"></i> Logged in as</h6>
                <p><%= userName != null ? userName : email %></p>
                <% if (userId != null) { %>
                <p><i class="fas fa-fingerprint me-2"></i> User ID: <span class="user-id"><%= userId %></span></p>
                <% } %>
            </div>
            <% } %>

            <div class="alert-info">
                <i class="fas fa-info-circle me-2"></i>
                Please provide detailed information about the resource you'd like to request. This helps us evaluate your request more effectively.
            </div>

            <form action="RequestResourceServlet" method="post" id="resourceForm">
                <!-- Hidden field for user ID if available -->
                <% if (userId != null) { %>
                <input type="hidden" name="userId" value="<%= userId %>">
                <% } %>

                <div class="mb-3">
                    <label for="title" class="form-label">
                        <i class="fas fa-heading"></i> Resource Title <span class="required-star">*</span>
                    </label>
                    <input type="text" name="title" id="title" class="form-control" required>
                    <div class="form-text">Enter the full title of the resource you're requesting</div>
                </div>

                <div class="mb-3">
                    <label for="author" class="form-label">
                        <i class="fas fa-user-edit"></i> Author <span class="required-star">*</span>
                    </label>
                    <input type="text" name="author" id="author" class="form-control" required>
                    <div class="form-text">Enter the author or creator of the resource</div>
                </div>

                <div class="mb-3">
                    <label for="type" class="form-label">
                        <i class="fas fa-tag"></i> Type <span class="required-star">*</span>
                    </label>
                    <select name="type" id="type" class="form-select" required>
                        <option value="">-- Select Type --</option>
                        <option value="Book">Book</option>
                        <option value="Journal">Journal</option>
                        <option value="Thesis">Thesis</option>
                        <option value="Magazine">Magazine</option>
                        <option value="Research Paper">Research Paper</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="justification" class="form-label">
                        <i class="fas fa-comment-alt"></i> Justification <span class="required-star">*</span>
                    </label>
                    <textarea name="justification" id="justification" class="form-control" rows="4" required></textarea>
                    <div class="form-text">Explain why this resource should be added to our collection</div>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">
                        <i class="fas fa-envelope"></i> Your Email <span class="required-star">*</span>
                    </label>
                    <input type="email" name="email" id="email" class="form-control"
                           value="<%= email != null ? email : "" %>"
                        <%= (email != null) ? "readonly" : "" %> required>
                    <% if (email != null) { %>
                    <div class="form-text">Email is pre-filled from your account</div>
                    <% } %>
                </div>

                <button type="submit" class="btn btn-submit w-100">
                    <i class="fas fa-paper-plane me-2"></i> Submit Request
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Form validation
        const form = document.getElementById('resourceForm');

        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }

            form.classList.add('was-validated');
        });

        // Character counter for justification
        const justification = document.getElementById('justification');
        const maxLength = 500;

        justification.addEventListener('input', function() {
            const remaining = maxLength - this.value.length;
            if (remaining < 0) {
                this.value = this.value.substring(0, maxLength);
            }
        });
    });
</script>

</body>
</html>