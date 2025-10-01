<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }

    // Fetch user details from members table
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
    <title>My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f5f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .container { max-width: 700px; margin-top: 50px; }
        .card { border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .card-header { background: #2c3e50; color: #fff; font-weight: 600; }
        .btn-edit { background: #3498db; color: #fff; }
        .btn-edit:hover { background: #2980b9; }
        .btn-save { background: #27ae60; color: #fff; }
        .btn-save:hover { background: #1e8449; }
        .btn-delete { background: #e74c3c; color: #fff; }
        .btn-delete:hover { background: #c0392b; }
        .btn-dashboard { background: #6c5ce7; color: #fff; }
        .btn-dashboard:hover { background: #4834d4; }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span>My Profile</span>
            <div>
                <!-- Back to Dashboard button -->
                <a href="dashboard.jsp" class="btn btn-sm btn-dashboard me-2">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <button id="editBtn" type="button" class="btn btn-sm btn-edit">
                    <i class="fas fa-pencil-alt"></i> Edit
                </button>
            </div>
        </div>
        <div class="card-body">
            <form action="UpdateProfileServlet" method="post" id="profileForm">
                <div class="mb-3">
                    <label class="form-label">First Name</label>
                    <input type="text" name="firstName" class="form-control" value="<%= firstName %>" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Last Name</label>
                    <input type="text" name="lastName" class="form-control" value="<%= lastName %>" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Phone Number</label>
                    <input type="text" name="phoneNumber" class="form-control" value="<%= phoneNumber %>" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email (cannot change)</label>
                    <input type="email" name="email" class="form-control" value="<%= email %>" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" value="<%= password %>" readonly>
                </div>

                <div class="d-flex justify-content-between">
                    <button type="submit" id="saveBtn" class="btn btn-save" style="display:none;">Save Changes</button>
                    <a href="DeleteProfileServlet?email=<%= email %>" class="btn btn-delete"
                       onclick="return confirm('Are you sure you want to delete your profile? This cannot be undone.');">
                        Delete Profile
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    const editBtn = document.getElementById("editBtn");
    const saveBtn = document.getElementById("saveBtn");
    const inputs = document.querySelectorAll("#profileForm input:not([name=email])");

    editBtn.addEventListener("click", () => {
        inputs.forEach(input => input.removeAttribute("readonly"));
        saveBtn.style.display = "inline-block";
        editBtn.style.display = "none";
    });
</script>

</body>
</html>
