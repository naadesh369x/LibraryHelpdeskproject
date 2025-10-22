<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <style>
        /* --- Basic Reset & Global Styles --- */
        *, *::before, *::after {
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            color: #333;
        }

        /* --- Login Container (The Card) --- */
        .login-container {
            background: #ffffff;
            padding: 2rem 3rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        h2 {
            margin-top: 0;
            margin-bottom: 1.5rem;
            color: #333;
            font-weight: 600;
        }

        /* --- Form Elements Styling --- */
        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 0.5rem;
            text-align: left;
            font-weight: 500;
            color: #555;
        }

        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 0.8rem;
            margin-bottom: 1rem;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        /* Focus state for inputs and select */
        input[type="text"]:focus,
        input[type="password"]:focus,
        select:focus {
            outline: none;
            border-color: #2575fc;
            box-shadow: 0 0 0 3px rgba(37, 117, 252, 0.2);
        }

        button {
            width: 100%;
            padding: 0.8rem;
            border: none;
            border-radius: 6px;
            background-color: #2575fc;
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 0.5rem;
        }

        /* Hover state for the button */
        button:hover {
            background-color: #1a5fc4;
        }

        /* --- Error Message Styling --- */
        .error-message {
            color: #d93025;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 0.75rem;
            border-radius: 6px;
            margin-top: 1rem;
            text-align: center;
        }

    </style>
</head>
<body>

<div class="login-container">
    <h2>Multi-Role Login</h2>
    <form action="LoginServletmulti" method="post">
        <label for="role">Role:</label>
        <select name="role" id="role" required>
            <option value="admin">Admin</option>
            <option value="staff">Staff</option>
            <option value="student">Student</option>
        </select>

        <label for="email">Email / Username:</label>
        <input type="text" id="email" name="email" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>

        <button type="submit">Login</button>
    </form>

    <%-- JSP Scriptlet to display the error message --%>
    <% if (request.getParameter("error") != null) { %>
    <p class="error-message">
        <%= request.getParameter("error") %>
    </p>
    <% } %>
</div>

</body>
</html>