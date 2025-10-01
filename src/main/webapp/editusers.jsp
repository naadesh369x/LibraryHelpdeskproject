<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit User</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow-sm">
        <div class="card-header">
            <h4>Edit User</h4>
        </div>
        <div class="card-body">
            <%
                Map<String, String> user = (Map<String, String>) request.getAttribute("user");
                if(user != null) {
                    String userType = user.get("userType");
            %>
            <form method="post" action="EditUserServlet">
                <input type="hidden" name="id" value="<%= user.get("id") %>">
                <input type="hidden" name="userType" value="<%= userType %>">

                <div class="mb-3">
                    <label class="form-label">First Name</label>
                    <input type="text" name="firstName" class="form-control"
                           value="<%= user.get("firstName") %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Last Name</label>
                    <input type="text" name="lastName" class="form-control"
                           value="<%= user.get("lastName") %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control"
                           value="<%= user.get("email") %>" readonly>
                    <small class="text-muted">Email cannot be changed</small>
                </div>

                <div class="mb-3">
                    <label class="form-label">Phone Number</label>
                    <input type="text" name="phone" class="form-control"
                           value="<%= user.get("phone") != null ? user.get("phone") : "" %>">
                </div>

                <!-- Always allow password change -->
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current password">
                </div>

                <!-- Hidden role field (role not editable) -->
                <input type="hidden" name="role" value="<%= user.get("role") %>">

                <button type="submit" class="btn btn-primary">Update</button>
                <a href="manage-users" class="btn btn-secondary">Cancel</a>
            </form>
            <% } else { %>
            <div class="alert alert-danger">User not found!</div>
            <a href="manage-users" class="btn btn-secondary">Back</a>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>
