<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Add Staff</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --bg-color: #1b1b1b;
            --card-bg: #2a2a2a;
            --header-bg: #121212;
            --text-color: #e0e0e0;
            --primary-color: #33b5e5;
            --primary-hover: #2999c4;
            --secondary-color: #6c757d;
            --secondary-hover: #5a6268;
            --border-color: #444;
            --input-bg: #3a3a3a;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
        }

        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 220px;
            background-color: #0f0f0f;
            padding-top: 20px;
            overflow-y: auto;
            z-index: 1030;
        }

        .sidebar a {
            color: #ccc;
            text-decoration: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            transition: background-color 0.3s, color 0.3s;
        }

        .sidebar a:hover, .sidebar a:focus {
            background-color: #2a2a2a;
            color: #fff;
            outline: none;
        }

        .sidebar a.active {
            background-color: var(--primary-color);
            color: #fff;
        }

        .sidebar h4 {
            color: #fff;
            margin-bottom: 1.5rem;
            text-align: center;
            font-weight: 700;
        }

        /* Header Bar */
        .header-bar {
            position: fixed;
            top: 0;
            left: 220px;
            right: 0;
            height: 60px;
            background-color: var(--header-bg);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            border-bottom: 1px solid var(--border-color);
            z-index: 1040;
        }

        .header-bar h5 {
            margin: 0;
            font-weight: 600;
            color: #fff;
        }

        .header-bar a {
            color: var(--text-color);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        .header-bar a:hover {
            color: var(--primary-color);
        }

        /* Main Content */
        .main-content {
            margin-left: 220px;
            margin-top: 70px;
            padding: 2rem;
            flex-grow: 1;
        }

        /* Card & Form Styles */
        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.4);
        }

        .card-header {
            background-color: transparent;
            border-bottom: 1px solid var(--border-color);
            padding: 1.5rem;
        }

        .card-header h2 {
            margin: 0;
            font-weight: 600;
            color: #fff;
        }

        .card-body {
            padding: 2rem;
        }

        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #bbb;
        }

        .form-control, .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--text-color);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-control:focus, .form-select:focus {
            background-color: var(--input-bg);
            border-color: var(--primary-color);
            color: #fff;
            box-shadow: 0 0 0 0.2rem rgba(51, 181, 229, 0.25);
        }

        .form-control::placeholder {
            color: #777;
        }

        /* Button Styles */
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            font-weight: 500;
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            transition: background-color 0.3s, border-color 0.3s;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            border-color: var(--primary-hover);
        }

        /* Responsive */
        @media (max-width: 767.98px) {
            .sidebar { position: relative; width: 100%; height: auto; padding: 10px 0; }
            .header-bar { left: 0; }
            .main-content { margin-left: 0; margin-top: 20px; padding: 1rem; }
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<nav class="sidebar" aria-label="Sidebar Navigation">
    <h4>Support Admin</h4>
    <a href="admindashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
    <a href="ManageTicketsServlet"><i class="fas fa-ticket-alt"></i> Manage Tickets</a>
    <a href="AdminRequestsServlet"><i class="fas fa-plus-circle"></i> Manage request resources</a>
    <a href="listFAQAdmin.jsp"><i class="fas fa-plus-circle"></i> Manage FAQ</a>
    <a href="ViewAllRepliesServlet"><i class="fas fa-hourglass-half"></i> Replied Tickets</a>
    <a href="FeedbackListServlet"><i class="fas fa-check-circle"></i> Feedbacks</a>
    <a href="add-staff.jsp" class="active"><i class="fas fa-users"></i> Add Staffs</a>
    <a href="manage-users"><i class="fas fa-play-circle"></i> Manage Users</a>
   
</nav>

<!-- Header Bar -->
<header class="header-bar">
    <h5><i class="fas fa-user-plus me-2"></i>Add New Staff</h5>
    <a href="admindashboard.jsp"><i class="fas fa-arrow-left me-2"></i>Back to Dashboard</a>
</header>

<!-- Main Content -->
<main class="main-content" role="main">
    <div class="card shadow-lg">
        <div class="card-body">
            <form action="AddStaffServlet" method="post">

                <!-- First Name -->
                <div class="mb-3">
                    <label for="firstName" class="form-label"><i class="fas fa-user me-2"></i>First Name</label>
                    <input type="text" id="firstName" name="firstName" class="form-control" required>
                </div>

                <!-- Last Name -->
                <div class="mb-3">
                    <label for="lastName" class="form-label"><i class="fas fa-user me-2"></i>Last Name</label>
                    <input type="text" id="lastName" name="lastName" class="form-control" required>
                </div>

                <!-- Email -->
                <div class="mb-3">
                    <label for="email" class="form-label"><i class="fas fa-envelope me-2"></i>Email</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>

                <!-- Password -->
                <div class="mb-3">
                    <label for="password" class="form-label"><i class="fas fa-lock me-2"></i>Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required>
                </div>

                <!-- Age -->
                <div class="mb-3">
                    <label for="age" class="form-label"><i class="fas fa-calendar-alt me-2"></i>Age</label>
                    <input type="number" id="age" name="age" class="form-control" min="18" required>
                </div>

                <!-- Gender -->
                <div class="mb-3">
                    <label for="gender" class="form-label"><i class="fas fa-venus-mars me-2"></i>Gender</label>
                    <select id="gender" name="gender" class="form-select" required>
                        <option value="">-- Select Gender --</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <!-- Hidden Role (default Staff) -->
                <input type="hidden" name="role" value="staff">

                <!-- Phone Number -->
                <div class="mb-3">
                    <label for="phoneNumber" class="form-label"><i class="fas fa-phone me-2"></i>Phone Number</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control" pattern="[0-9]{10}" placeholder="Enter 10-digit number" required>
                </div>

                <!-- Hometown -->
                <div class="mb-3">
                    <label for="hometown" class="form-label"><i class="fas fa-home me-2"></i>Hometown</label>
                    <input type="text" id="hometown" name="hometown" class="form-control" required>
                </div>

                <!-- Submit Button -->
                <div class="text-center">
                    <button type="submit" class="btn btn-primary px-4"><i class="fas fa-plus-circle me-2"></i>Add Staff</button>
                </div>
            </form>
        </div>
    </div>
</main>

</body>
</html>