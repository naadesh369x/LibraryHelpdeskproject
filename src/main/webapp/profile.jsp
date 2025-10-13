<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.example.demo.utils.DBConnection" %>
<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }

    String firstName = "", lastName = "", phoneNumber = "", password = "";
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT * FROM members WHERE email=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    firstName = rs.getString("firstName");
                    lastName = rs.getString("lastName");
                    phoneNumber = rs.getString("phoneNumber");
                    password = rs.getString("password");
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
    <title>My Profile</title>
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
            --darker-color: #212529;
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

        .profile-card {
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

        .profile-header {
            background: linear-gradient(135deg, var(--primary-color), #3f37c9);
            color: var(--white);
            padding: 30px;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
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

        .profile-header h2 {
            font-weight: 700;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .profile-header p {
            opacity: 0.9;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            font-size: 36px;
            color: var(--primary-color);
            font-weight: 700;
        }

        .profile-body {
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

        .form-control:read-only {
            background-color: var(--gray-light);
            cursor: not-allowed;
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

        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #27ae60);
            color: var(--white);
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(46, 204, 113, 0.2);
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color), #c0392b);
            color: var(--white);
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c0392b, #e74c3c);
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(231, 76, 60, 0.2);
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

        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary-color), #5a6268);
            color: var(--white);
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #5a6268, #6c757d);
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(108, 117, 125, 0.2);
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 20px;
        }

        .edit-mode-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--warning-color);
            color: var(--white);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: none;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 42px;
            color: var(--gray-dark);
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .password-toggle:hover {
            color: var(--primary-color);
        }

        .divider {
            height: 1px;
            background: var(--gray-medium);
            margin: 30px 0;
        }

        .profile-info {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .profile-info-text {
            margin-left: 20px;
        }

        .profile-info h3 {
            margin: 0;
            font-weight: 700;
            color: var(--dark-color);
        }

        .profile-info p {
            margin: 5px 0 0;
            color: var(--gray-dark);
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 10px;
            display: none;
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
            .profile-card {
                margin-bottom: 20px;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
            }

            .profile-info {
                flex-direction: column;
                text-align: center;
            }

            .profile-info-text {
                margin-left: 0;
                margin-top: 15px;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <!-- Header Section -->
    <div class="header-section">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-avatar">
                    <%= firstName != null && !firstName.isEmpty() ? firstName.substring(0, 1).toUpperCase() : "U" %>
                </div>
                <h2>My Profile</h2>
                <p>Manage your personal information</p>
            </div>
            <div class="profile-body">
                <div class="profile-info">
                    <div class="profile-avatar" style="width: 100px; height: 100px; font-size: 36px;">
                        <%= firstName != null && !firstName.isEmpty() ? firstName.substring(0, 1).toUpperCase() : "U" %>
                    </div>
                    <div class="profile-info-text">
                        <h3><%= firstName %> <%= lastName %></h3>
                        <p><%= email %></p>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="dashboard.jsp" class="btn btn-dashboard">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                    <a href="DeleteProfileServlet?email=<%= email %>" class="btn btn-danger"
                       onclick="return confirm('Are you sure you want to delete your profile? This cannot be undone.');">
                        <i class="fas fa-trash"></i> Delete Profile
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Content Section -->
    <div class="content-section">
        <!-- Sidebar -->
        <div class="col-lg-2 col-md-12">
            <div class="sidebar">
                <a href="#details" class="sidebar-item active" onclick="showSection('details')">
                    <i class="fas fa-user"></i> Personal Details
                </a>
                <a href="#password" class="sidebar-item" onclick="showSection('password')">
                    <i class="fas fa-lock"></i> Change Password
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-lg-10 col-md-12">
            <!-- Personal Details Section -->
            <div id="details-section" class="profile-card">
                <div class="profile-header">
                    <h2>Personal Details</h2>
                    <p>Update your personal information</p>
                    <div class="edit-mode-indicator" id="detailsEditModeIndicator">
                        <i class="fas fa-edit me-2"></i> Edit Mode
                    </div>
                </div>
                <div class="profile-body">
                    <div id="detailsAlert" class="alert alert-success">
                        <i class="fas fa-check-circle me-2"></i> <span id="detailsAlertMessage">Your details have been updated successfully!</span>
                    </div>

                    <form action="UpdateProfileServlet" method="post" id="detailsForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-user"></i> First Name
                                    </label>
                                    <input type="text" name="firstName" class="form-control" value="<%= firstName %>" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-user"></i> Last Name
                                    </label>
                                    <input type="text" name="lastName" class="form-control" value="<%= lastName %>" readonly>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-phone"></i> Phone Number
                            </label>
                            <input type="text" name="phoneNumber" class="form-control" value="<%= phoneNumber %>" readonly>
                        </div>
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-envelope"></i> Email (cannot change)
                            </label>
                            <input type="email" name="email" class="form-control" value="<%= email %>" readonly>
                        </div>

                        <div class="action-buttons">
                            <div>
                                <button type="button" id="detailsEditBtn" class="btn btn-primary">
                                    <i class="fas fa-pencil-alt"></i> Edit Details
                                </button>
                                <button type="submit" id="detailsSaveBtn" class="btn btn-success" style="display:none;">
                                    <i class="fas fa-save"></i> Save Changes
                                </button>
                                <button type="button" id="detailsCancelBtn" class="btn btn-secondary" style="display:none;">
                                    <i class="fas fa-times"></i> Cancel
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Password Change Section -->
            <div id="password-section" class="profile-card" style="display:none;">
                <div class="profile-header">
                    <h2>Change Password</h2>
                    <p>Update your account password</p>
                    <div class="edit-mode-indicator" id="passwordEditModeIndicator">
                        <i class="fas fa-edit me-2"></i> Edit Mode
                    </div>
                </div>
                <div class="profile-body">
                    <div id="passwordAlert" class="alert alert-success">
                        <i class="fas fa-check-circle me-2"></i> <span id="passwordAlertMessage">Your password has been updated successfully!</span>
                    </div>

                    <form action="UpdatePasswordServlet" method="post" id="passwordForm">
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-lock"></i> Current Password
                            </label>
                            <input type="password" name="currentPassword" class="form-control" readonly>
                            <i class="fas fa-eye password-toggle" id="currentPasswordToggle"></i>
                        </div>
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-lock"></i> New Password
                            </label>
                            <input type="password" name="newPassword" class="form-control" readonly>
                            <i class="fas fa-eye password-toggle" id="newPasswordToggle"></i>
                        </div>
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-lock"></i> Confirm New Password
                            </label>
                            <input type="password" name="confirmPassword" class="form-control" readonly>
                            <i class="fas fa-eye password-toggle" id="confirmPasswordToggle"></i>
                        </div>

                        <div class="action-buttons">
                            <div>
                                <button type="button" id="passwordEditBtn" class="btn btn-primary">
                                    <i class="fas fa-pencil-alt"></i> Change Password
                                </button>
                                <button type="submit" id="passwordSaveBtn" class="btn btn-success" style="display:none;">
                                    <i class="fas fa-save"></i> Update Password
                                </button>
                                <button type="button" id="passwordCancelBtn" class="btn btn-secondary" style="display:none;">
                                    <i class="fas fa-times"></i> Cancel
                                </button>
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
        // Details Form Elements
        const detailsEditBtn = document.getElementById("detailsEditBtn");
        const detailsSaveBtn = document.getElementById("detailsSaveBtn");
        const detailsCancelBtn = document.getElementById("detailsCancelBtn");
        const detailsEditModeIndicator = document.getElementById("detailsEditModeIndicator");
        const detailsInputs = document.querySelectorAll("#detailsForm input:not([name=email])");
        const detailsAlert = document.getElementById("detailsAlert");

        // Password Form Elements
        const passwordEditBtn = document.getElementById("passwordEditBtn");
        const passwordSaveBtn = document.getElementById("passwordSaveBtn");
        const passwordCancelBtn = document.getElementById("passwordCancelBtn");
        const passwordEditModeIndicator = document.getElementById("passwordEditModeIndicator");
        const passwordInputs = document.querySelectorAll("#passwordForm input");
        const passwordAlert = document.getElementById("passwordAlert");

        // Password Toggle Elements
        const currentPasswordToggle = document.getElementById("currentPasswordToggle");
        const newPasswordToggle = document.getElementById("newPasswordToggle");
        const confirmPasswordToggle = document.getElementById("confirmPasswordToggle");
        const currentPasswordField = document.querySelector("input[name='currentPassword']");
        const newPasswordField = document.querySelector("input[name='newPassword']");
        const confirmPasswordField = document.querySelector("input[name='confirmPassword']");

        // Store original values for cancellation
        const originalDetailsValues = {};
        detailsInputs.forEach(input => {
            originalDetailsValues[input.name] = input.value;
        });

        // Toggle password visibility
        currentPasswordToggle.addEventListener('click', function() {
            togglePasswordVisibility(currentPasswordField, this);
        });

        newPasswordToggle.addEventListener('click', function() {
            togglePasswordVisibility(newPasswordField, this);
        });

        confirmPasswordToggle.addEventListener('click', function() {
            togglePasswordVisibility(confirmPasswordField, this);
        });

        function togglePasswordVisibility(field, toggleIcon) {
            if (field.type === 'password') {
                field.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }

        // Enable details edit mode
        detailsEditBtn.addEventListener("click", function() {
            detailsInputs.forEach(input => input.removeAttribute("readonly"));
            detailsSaveBtn.style.display = "inline-flex";
            detailsCancelBtn.style.display = "inline-flex";
            detailsEditBtn.style.display = "none";
            detailsEditModeIndicator.style.display = "block";

            // Focus on first input
            detailsInputs[0].focus();
        });

        // Cancel details edit
        detailsCancelBtn.addEventListener("click", function() {
            // Restore original values
            detailsInputs.forEach(input => {
                input.value = originalDetailsValues[input.name];
                input.setAttribute("readonly", "readonly");
            });

            detailsSaveBtn.style.display = "none";
            detailsCancelBtn.style.display = "none";
            detailsEditBtn.style.display = "inline-flex";
            detailsEditModeIndicator.style.display = "none";
            detailsAlert.style.display = "none";
        });

        // Enable password edit mode
        passwordEditBtn.addEventListener("click", function() {
            passwordInputs.forEach(input => {
                input.removeAttribute("readonly");
                input.value = ""; // Clear password fields for security
            });
            passwordSaveBtn.style.display = "inline-flex";
            passwordCancelBtn.style.display = "inline-flex";
            passwordEditBtn.style.display = "none";
            passwordEditModeIndicator.style.display = "block";

            // Focus on first input
            passwordInputs[0].focus();
        });

        // Cancel password edit
        passwordCancelBtn.addEventListener("click", function() {
            passwordInputs.forEach(input => {
                input.value = "";
                input.setAttribute("readonly", "readonly");
            });

            passwordSaveBtn.style.display = "none";
            passwordCancelBtn.style.display = "none";
            passwordEditBtn.style.display = "inline-flex";
            passwordEditModeIndicator.style.display = "none";
            passwordAlert.style.display = "none";
        });

        // Details form validation
        document.getElementById("detailsForm").addEventListener("submit", function(event) {
            const firstName = document.querySelector("input[name='firstName']").value.trim();
            const lastName = document.querySelector("input[name='lastName']").value.trim();
            const phoneNumber = document.querySelector("input[name='phoneNumber']").value.trim();

            if (!firstName || !lastName || !phoneNumber) {
                event.preventDefault();
                showAlert(detailsAlert, "Please fill in all fields", "danger");
                return;
            }

            if (phoneNumber.length < 10) {
                event.preventDefault();
                showAlert(detailsAlert, "Please enter a valid phone number", "danger");
                return;
            }

            // Show success message
            showAlert(detailsAlert, "Your details have been updated successfully!", "success");
        });

        // Password form validation
        document.getElementById("passwordForm").addEventListener("submit", function(event) {
            const currentPassword = document.querySelector("input[name='currentPassword']").value.trim();
            const newPassword = document.querySelector("input[name='newPassword']").value.trim();
            const confirmPassword = document.querySelector("input[name='confirmPassword']").value.trim();

            if (!currentPassword || !newPassword || !confirmPassword) {
                event.preventDefault();
                showAlert(passwordAlert, "Please fill in all password fields", "danger");
                return;
            }

            if (newPassword.length < 6) {
                event.preventDefault();
                showAlert(passwordAlert, "Password must be at least 6 characters long", "danger");
                return;
            }

            if (newPassword !== confirmPassword) {
                event.preventDefault();
                showAlert(passwordAlert, "New password and confirm password do not match", "danger");
                return;
            }

            // Show success message
            showAlert(passwordAlert, "Your password has been updated successfully!", "success");
        });

        // Helper function to show alerts
        function showAlert(alertElement, message, type) {
            const messageElement = alertElement.querySelector('span');
            messageElement.textContent = message;

            // Update alert class based on type
            alertElement.classList.remove('alert-success', 'alert-danger');
            alertElement.classList.add(`alert-${type}`);

            // Show the alert
            alertElement.style.display = 'block';

            // Auto-hide after 5 seconds
            setTimeout(() => {
                alertElement.style.display = 'none';
            }, 5000);
        }

        // Section switching function
        window.showSection = function(section) {
            // Hide all sections
            document.getElementById('details-section').style.display = 'none';
            document.getElementById('password-section').style.display = 'none';

            // Show selected section
            document.getElementById(section + '-section').style.display = 'block';

            // Update sidebar active state
            document.querySelectorAll('.sidebar-item').forEach(item => {
                item.classList.remove('active');
            });
            document.querySelector(`.sidebar-item[href="#${section}"]`).classList.add('active');
        }
    });
</script>

</body>
</html>