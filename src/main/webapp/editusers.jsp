<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>


    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">


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
            flex-direction: column;
        }

        /* Header Bar */
        .header-bar {
            background-color: var(--header-bg);
            padding: 1rem 2rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-bar h4 {
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

        /* Main Container */
        .main-container {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.4);
            width: 100%;
            max-width: 600px;
        }

        .card-header {
            background-color: transparent;
            border-bottom: 1px solid var(--border-color);
            padding: 1.5rem;
        }

        .card-header h4 {
            margin: 0;
            font-weight: 600;
            color: #fff;
        }

        .card-body {
            padding: 2rem;
        }

        /* Form Styles */
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #bbb;
        }

        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--text-color);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-control:focus {
            background-color: var(--input-bg);
            border-color: var(--primary-color);
            color: #fff;
            box-shadow: 0 0 0 0.2rem rgba(51, 181, 229, 0.25);
        }

        .form-control::placeholder {
            color: #777;
        }

        .form-text {
            color: #999;
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

        .btn-secondary {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            font-weight: 500;
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            transition: background-color 0.3s, border-color 0.3s;
        }

        .btn-secondary:hover {
            background-color: var(--secondary-hover);
            border-color: var(--secondary-hover);
        }

        .alert-danger {
            background-color: #8b0000;
            border-color: #660000;
            color: #fff;
        }

    </style>
</head>
<body>

<!-- Header Bar -->
<header class="header-bar">
    <h4><i class="fas fa-user-edit me-2"></i>Edit User</h4>
    <a href="manage-users"><i class="fas fa-arrow-left me-2"></i>Back to Users</a>
</header>

<!-- Main Content -->
<main class="main-container">
    <div class="card shadow-sm">
        <div class="card-body">
            <%
                Map<String, String> user = (Map<String, String>) request.getAttribute("user");
                if(user != null) {
                    String userType = user.get("userType");
                    String idValue = "Staff".equalsIgnoreCase(userType) ? user.get("staffid") : user.get("userid");
                    // DYNAMICALLY SET THE NAME OF THE ID INPUT FIELD
                    String idFieldName = "Staff".equalsIgnoreCase(userType) ? "staffid" : "userid";
            %>
            <form method="post" action="EditUserServlet">
                <!-- Pass the correct ID and userType -->
                <input type="hidden" name="<%= idFieldName %>" value="<%= idValue %>">
                <input type="hidden" name="userType" value="<%= userType %>">

                <div class="mb-3">
                    <label for="firstName" class="form-label">First Name</label>
                    <input type="text" id="firstName" name="firstName" class="form-control"
                           value="<%= user.get("firstName") %>" required>
                </div>

                <div class="mb-3">
                    <label for="lastName" class="form-label">Last Name</label>
                    <input type="text" id="lastName" name="lastName" class="form-control"
                           value="<%= user.get("lastName") %>" required>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-control"
                           value="<%= user.get("email") %>" readonly>
                    <div class="form-text">Email cannot be changed.</div>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control"
                           value="<%= user.get("phone") != null ? user.get("phone") : "" %>">
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">New Password</label>
                    <input type="password" id="password" name="password" class="form-control"
                           placeholder="Leave blank to keep current password">
                </div>

                <!-- Hidden role field, if needed -->
                <input type="hidden" name="role" value="<%= user.get("role") %>">

                <div class="d-flex gap-2 justify-content-end">
                    <a href="manage-users" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>Update User</button>
                </div>
            </form>
            <% } else { %>
            <div class="alert alert-danger text-center" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>User not found!
            </div>
            <div class="text-center mt-3">
                <a href="manage-users" class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Back to Users</a>
            </div>
            <% } %>
        </div>
    </div>
</main>

</body>
</html>