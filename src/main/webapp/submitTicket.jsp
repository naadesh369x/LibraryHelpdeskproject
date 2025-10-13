<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%
    // Check if user is logged in
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }

    // Get user details from database
    String firstName = "", lastName = "", phoneNumber = "";
    int userId = 0;

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT * FROM members WHERE email=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    userId = rs.getInt("userId");
                    firstName = rs.getString("firstName");
                    lastName = rs.getString("lastName");
                    phoneNumber = rs.getString("phoneNumber");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Ticket</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #6c757d;
            --success-color: #2ecc71;
            --info-color: #3498db;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --white: #ffffff;
            --gray-light: #f1f3f5;
            --gray-medium: #dee2e6;
            --gray-dark: #6c757d;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background-color: #f5f7fb;
            color: var(--dark-color);
            position: relative;
        }

        .container-fluid {
            position: relative;
            z-index: 1;
            width: 100%;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .header-section {
            padding: 40px 20px;
            text-align: center;
        }

        .content-section {
            flex: 1;
            display: flex;
            flex-wrap: wrap;
            padding: 0 20px 40px;
        }

        .ticket-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
            border: 1px solid var(--gray-medium);
            margin-bottom: 30px;
            height: 100%;
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

        .ticket-header {
            background: linear-gradient(135deg, var(--primary-color), #3f37c9);
            color: var(--white);
            padding: 30px;
            position: relative;
            overflow: hidden;
        }

        .ticket-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            transform: translate(50%, -50%);
        }

        .ticket-header h2 {
            font-weight: 700;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .ticket-header p {
            opacity: 0.9;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .ticket-body {
            padding: 40px 30px;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .form-label i {
            margin-right: 8px;
            color: var(--primary-color);
            width: 20px;
            text-align: center;
        }

        .form-control {
            border: 1px solid var(--gray-medium);
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: var(--white);
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(67, 97, 238, 0.25);
        }

        .form-select {
            border: 1px solid var(--gray-medium);
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: var(--white);
        }

        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(67, 97, 238, 0.25);
        }

        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 16px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), #3f37c9);
            color: var(--white);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #3f37c9, #4361ee);
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(67, 97, 238, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary-color), #5a6268);
            color: var(--white);
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #5a6268, #6c757d);
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(108, 117, 125, 0.2);
        }

        .btn-dashboard {
            background: linear-gradient(135deg, var(--info-color), #2980b9);
            color: var(--white);
        }

        .btn-dashboard:hover {
            background: linear-gradient(135deg, #2980b9, #3498db);
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(52, 152, 219, 0.2);
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 20px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 10px;
        }

        .alert-success {
            background-color: rgba(46, 204, 113, 0.1);
            color: var(--success-color);
            border: 1px solid var(--success-color);
        }

        .alert-danger {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger-color);
            border: 1px solid var(--danger-color);
        }

        .sidebar {
            background: var(--white);
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid var(--gray-medium);
        }

        .sidebar-item {
            display: block;
            padding: 12px 15px;
            margin-bottom: 10px;
            border-radius: 10px;
            color: var(--dark-color);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .sidebar-item:hover {
            background: var(--gray-light);
            transform: translateX(5px);
        }

        .sidebar-item.active {
            background: var(--primary-color);
            color: var(--white);
        }

        .sidebar-item i {
            margin-right: 10px;
        }

        .ticket-info {
            background-color: var(--gray-light);
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .ticket-info h5 {
            color: var(--primary-color);
            margin-bottom: 10px;
        }

        @media (max-width: 992px) {
            .content-section {
                flex-direction: column;
            }

            .sidebar {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
            }

            .sidebar-item {
                margin: 5px;
                flex: 0 0 auto;
            }
        }

        @media (max-width: 768px) {
            .ticket-card {
                margin-bottom: 20px;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <!-- Header Section -->
    <div class="header-section">
        <div class="ticket-card">
            <div class="ticket-header">
                <h2>Submit a Ticket</h2>
                <p>Get help from our support team</p>
            </div>
            <div class="ticket-body">
                <div class="ticket-info">
                    <h5><i class="fas fa-info-circle me-2"></i>Submitting as:</h5>
                    <p><strong>Name:</strong> <%= firstName %> <%= lastName %></p>
                    <p><strong>Email:</strong> <%= email %></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Content Section -->
    <div class="content-section">
        <!-- Sidebar -->
        <div class="col-lg-2 col-md-12">
            <div class="sidebar">
                <a href="dashboard.jsp" class="sidebar-item">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="submitTicket.jsp" class="sidebar-item active">
                    <i class="fas fa-plus-circle"></i> Submit Ticket
                </a>
                <a href="myTickets.jsp" class="sidebar-item">
                    <i class="fas fa-ticket-alt"></i> My Tickets
                </a>
                <a href="profile.jsp" class="sidebar-item">
                    <i class="fas fa-user"></i> My Profile
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-lg-10 col-md-12">
            <div class="ticket-card">
                <div class="ticket-header">
                    <h2>Ticket Details</h2>
                    <p>Please provide as much detail as possible</p>
                </div>
                <div class="ticket-body">
                    <%-- Display error message if exists --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <form action="submitTicket" method="post" id="ticketForm">
                        <input type="hidden" name="userId" value="<%= userId %>">
                        <input type="hidden" name="email" value="<%= email %>">

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-user"></i> Full Name
                                    </label>
                                    <input type="text" name="username" class="form-control"
                                           value="<%= firstName + " " + lastName %>" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-tag"></i> Category
                                    </label>
                                    <select name="category" class="form-select" required>
                                        <option value="">Select a category</option>
                                        <option value="Technical Issue">Technical Issue</option>
                                        <option value="Account Problem">Account Problem</option>
                                        <option value="Billing Question">Billing Question</option>
                                        <option value="Feature Request">Feature Request</option>
                                        <option value="Bug Report">Bug Report</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-phone"></i> Mobile Number
                            </label>
                            <input type="tel" name="mobile" class="form-control"
                                   value="<%= phoneNumber %>" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-comment-alt"></i> Description
                            </label>
                            <textarea name="description" class="form-control" rows="5"
                                      placeholder="Please describe your issue in detail..." required></textarea>
                        </div>

                        <div class="action-buttons">
                            <div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane"></i> Submit Ticket
                                </button>
                                <a href="myTickets.jsp" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                            <div>
                                <a href="dashboard.jsp" class="btn btn-dashboard">
                                    <i class="fas fa-home"></i> Dashboard
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Form validation
        document.getElementById("ticketForm").addEventListener("submit", function(event) {
            const category = document.querySelector("select[name='category']").value;
            const description = document.querySelector("textarea[name='description']").value.trim();
            const mobile = document.querySelector("input[name='mobile']").value.trim();

            if (!category) {
                event.preventDefault();
                alert("Please select a category for your ticket");
                return;
            }

            if (description.length < 10) {
                event.preventDefault();
                alert("Please provide a more detailed description (at least 10 characters)");
                return;
            }

            if (mobile.length < 10) {
                event.preventDefault();
                alert("Please enter a valid mobile number");
                return;
            }
        });
    });
</script>

</body>
</html>