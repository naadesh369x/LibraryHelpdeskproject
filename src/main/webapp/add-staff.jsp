<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card { border-radius: 12px; }
        .back-btn {
            position: absolute;
            top: 20px;
            left: 30px;
            text-decoration: none;
            padding: 8px 15px;
            background-color: #6c757d;
            color: white;
            border-radius: 8px;
            transition: background 0.3s;
        }
        .back-btn:hover { background-color: #5a6268; color: #fff; }
        .form-title { text-align: center; margin-bottom: 20px; color: #2c3e50; font-weight: bold; }
    </style>
</head>
<body>

<div class="container mt-5 position-relative">
    <!-- Back to Dashboard Button -->
    <a href="AdminDashboard.jsp" class="back-btn">← Back to Dashboard</a>

    <div class="card shadow-lg p-4">
        <h2 class="form-title">Add Staff</h2>
        <form action="AddStaffServlet" method="post">

            <!-- First Name -->
            <div class="mb-3">
                <label class="form-label">First Name</label>
                <input type="text" name="firstName" class="form-control" required>
            </div>

            <!-- Last Name -->
            <div class="mb-3">
                <label class="form-label">Last Name</label>
                <input type="text" name="lastName" class="form-control" required>
            </div>

            <!-- Email -->
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" required>
            </div>

            <!-- Password -->
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" placeholder="Enter password" required>
            </div>

            <!-- Age -->
            <div class="mb-3">
                <label class="form-label">Age</label>
                <input type="number" name="age" class="form-control" min="18" required>
            </div>

            <!-- Gender -->
            <div class="mb-3">
                <label class="form-label">Gender</label>
                <select name="gender" class="form-select" required>
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
                <label class="form-label">Phone Number</label>
                <input type="tel" name="phoneNumber" class="form-control" pattern="[0-9]{10}" placeholder="Enter 10-digit number" required>
            </div>

            <!-- Hometown -->
            <div class="mb-3">
                <label class="form-label">Hometown</label>
                <input type="text" name="hometown" class="form-control" required>
            </div>

            <!-- Submit Button -->
            <div class="text-center">
                <button type="submit" class="btn btn-primary px-4">Add Staff</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
