<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>FAQs - Admin</title>
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
            --sidebar-bg: #0f0f0f;
            --card-bg: #2a2a2a;
            --header-bg: #121212;
            --text-color: #fff;
            --muted-text: #ccc;
            --primary-color: #33b5e5;
            --border-color: #333;
            --input-bg: #3a3a3a;
            --success-color: #00c851;
            --danger-color: #ff4444;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            margin: 0;
        }

        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 220px;
            background-color: var(--sidebar-bg);
            padding-top: 20px;
            overflow-y: auto;
            z-index: 1030;
        }
        .sidebar a {
            color: var(--muted-text);
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
            color: var(--text-color);
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

        /* Header */
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
        }

        /* Alert Styling */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background-color: rgba(0, 200, 81, 0.2);
            border: 1px solid var(--success-color);
            color: var(--success-color);
        }

        .alert-danger {
            background-color: rgba(255, 68, 68, 0.2);
            border: 1px solid var(--danger-color);
            color: var(--danger-color);
        }

        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--text-color);
        }

        .btn {
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 8px;
            transition: 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.12);
            font-size: 14px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-add-faq {
            background: var(--primary-color);
            color: #fff;
        }
        .btn-add-faq:hover {
            background: #2999c4;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(51, 181, 229, 0.3);
        }

        /* FAQ Container */
        .faq-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 24px;
            position: relative;
            z-index: 1;
        }

        /* FAQ Cards */
        .faq-card {
            background: linear-gradient(135deg, var(--card-bg) 0%, #333 100%);
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
            position: relative;
            transition: transform 0.3s, box-shadow 0.3s;
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        .faq-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), #8e44ad);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }

        .faq-card:hover::before {
            transform: scaleX(1);
        }

        .faq-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 32px rgba(0,0,0,0.3);
        }

        .faq-card h3 {
            margin: 0;
            color: var(--primary-color);
            font-size: 1.2em;
            z-index: 1;
            font-weight: 600;
        }

        .faq-card p {
            margin: 0;
            color: var(--muted-text);
            z-index: 1;
            font-size: 1em;
            line-height: 1.5;
        }

        .faq-card img {
            max-width: 100%;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            margin-top: 8px;
        }

        .faq-card .created {
            font-size: 12px;
            color: #888;
            z-index: 1;
            margin-top: auto;
        }

        .actions {
            margin-top: 16px;
            display: flex;
            justify-content: space-between;
            z-index: 1;
        }

        .actions a {
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 20px;
            color: #fff;
            font-size: 13px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .edit {
            background: var(--success-color);
        }
        .edit:hover {
            background: #00a846;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 200, 81, 0.3);
        }

        .delete {
            background: var(--danger-color);
        }
        .delete:hover {
            background: #dd3333;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 68, 68, 0.3);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--muted-text);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border-color);
        }

        /* Responsive */
        @media (max-width: 767.98px) {
            .sidebar { position: relative; width: 100%; height: auto; padding: 10px 0; }
            .header-bar { left: 0; }
            .main-content { margin-left: 0; margin-top: 20px; padding: 1rem; }

            .page-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .faq-container {
                grid-template-columns: 1fr;
            }
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
    <a href="listFAQAdmin.jsp" class="active"><i class="fas fa-question-circle"></i> Manage FAQ</a>
    <a href="ViewAllRepliesServlet"><i class="fas fa-hourglass-half"></i> Replied Tickets</a>
    <a href="FeedbackListServlet"><i class="fas fa-check-circle"></i> Feedbacks</a>
    <a href="add-staff.jsp"><i class="fas fa-users"></i> Add Staffs</a>
    <a href="manage-users"><i class="fas fa-play-circle"></i> Manage Users</a>
    <a href="profile.jsp"><i class="fas fa-cog"></i> Profile Settings</a>
</nav>

<!-- Header Bar -->
<header class="header-bar">
    <h5><i class="fas fa-question-circle me-2"></i>Manage FAQs</h5>
    <a href="admindashboard.jsp"><i class="fas fa-arrow-left me-2"></i>Back to Dashboard</a>
</header>

<!-- Main Content -->
<main class="main-content" role="main">
    <div class="page-header">
        <h1 class="page-title">Frequently Asked Questions</h1>
        <a class="btn btn-add-faq" href="addFAQ.jsp">
            <i class="fas fa-plus-circle"></i> Add New FAQ
        </a>
    </div>

    <!-- Display Success/Error Messages -->
    <%
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        if (success != null) {
    %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>
        <%= success %>
    </div>
    <%
        session.removeAttribute("success");
    } else if (error != null) {
    %>
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle"></i>
        <%= error %>
    </div>
    <%
            session.removeAttribute("error");
        }
    %>

    <div class="faq-container">
        <%
            // CORRECTED: Removed the JOIN and reverted to a simple query
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM faq ORDER BY created_at DESC");
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    // CORRECTED: Using 'faqid' as the primary key column
                    int id = rs.getInt("faqid");
                    String question = rs.getString("question");
                    String answer = rs.getString("answer");
                    String imgPath = rs.getString("image_path");
                    Timestamp createdAt = rs.getTimestamp("created_at");
        %>
        <div class="faq-card">
            <h3><%= question %></h3>
            <p><%= answer %></p>
            <% if (imgPath != null && !imgPath.isEmpty()) { %>
            <img src="uploads/<%= imgPath %>" alt="FAQ Image"/>
            <% } %>
            <div class="created">Added on: <%= createdAt %></div>
            <div class="actions">
                <a class="edit" href="editFAQForm.jsp?faqid=<%= id %>">
                    <i class="fas fa-edit"></i> Edit
                </a>
                <a class="delete" href="DeleteFAQServlet?faqid=<%= id %>" onclick="return confirm('Are you sure you want to delete this FAQ?');">
                    <i class="fas fa-trash"></i> Delete
                </a>
            </div>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            }
        %>
    </div>

    <!-- Check if there are any FAQs -->
    <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM faq");
             ResultSet rs = ps.executeQuery()) {

            rs.next();
            int count = rs.getInt(1);
            if (count == 0) {
    %>
    <div class="empty-state">
        <i class="fas fa-question-circle"></i>
        <h3>No FAQs Found</h3>
        <p>Start by adding your first FAQ to help users with common questions.</p>
        <a class="btn btn-add-faq" href="addFAQ.jsp">
            <i class="fas fa-plus-circle"></i> Add Your First FAQ
        </a>
    </div>
    <%
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error checking FAQ count: " + e.getMessage() + "</div>");
        }
    %>
</main>

</body>
</html>