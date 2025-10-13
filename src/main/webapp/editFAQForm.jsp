<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // CORRECTED: Get 'faqid' from the request parameter
    String faqIdParam = request.getParameter("faqid");
    String question = "";
    String answer = "";
    String imgPath = "";

    if (faqIdParam != null) {
        try (Connection con = DBConnection.getConnection();
             // CORRECTED: Updated SQL to use 'faqid'
             PreparedStatement ps = con.prepareStatement("SELECT * FROM faq WHERE faqid = ?")) {
            ps.setInt(1, Integer.parseInt(faqIdParam));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                question = rs.getString("question");
                answer = rs.getString("answer");
                imgPath = rs.getString("image_path");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    } else {
        response.sendRedirect("listFAQAdmin.jsp");
        return; // Stop further processing
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Edit FAQ - Library Help Desk</title>
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
            display: flex;
            justify-content: center;
        }

        /* Form Container */
        .faq-container {
            max-width: 700px;
            width: 100%;
            background: var(--card-bg);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.3);
            position: relative;
            border: 1px solid var(--border-color);
        }

        h2 {
            text-align: center;
            color: var(--text-color);
            margin-bottom: 30px;
            font-weight: 600;
        }

        .form-label {
            font-weight: 500;
            color: var(--muted-text);
            margin-bottom: 0.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
            color: #888;
            font-size: 0.875rem;
        }

        /* Image Display & Preview */
        .current-image-container, .image-preview {
            margin-top: 10px;
            border-radius: 8px;
            overflow: hidden;
            max-height: 200px;
        }
        .current-image-container img, .image-preview img {
            width: 100%;
            height: auto;
            display: block;
        }
        .image-preview {
            display: none;
        }

        /* Button Styling */
        .btn-submit {
            margin-top: 20px;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            padding: 12px;
            border-radius: 8px;
            background: linear-gradient(90deg, var(--primary-color), #5dade2);
            border: none;
            color: white;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit:hover {
            background: linear-gradient(90deg, #2999c4, var(--primary-color));
            box-shadow: 0 4px 12px rgba(51, 181, 229, 0.3);
            transform: translateY(-2px);
        }

        .btn-back {
            position: absolute;
            top: 20px;
            left: 20px;
            text-decoration: none;
            padding: 8px 16px;
            background-color: var(--muted-text);
            color: white;
            border-radius: 8px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-back:hover {
            background-color: #b3b3b3;
            transform: translateY(-2px);
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
        .alert-success { background-color: rgba(0, 200, 81, 0.2); border: 1px solid var(--success-color); color: var(--success-color); }
        .alert-danger { background-color: rgba(255, 68, 68, 0.2); border: 1px solid var(--danger-color); color: var(--danger-color); }

        /* Character Counter */
        .char-counter { font-size: 0.8rem; color: var(--muted-text); text-align: right; margin-top: 5px; }

        /* Responsive */
        @media (max-width: 767.98px) {
            .sidebar { position: relative; width: 100%; height: auto; padding: 10px 0; }
            .header-bar { left: 0; }
            .main-content { margin-left: 0; margin-top: 20px; padding: 1rem; }
            .faq-container { padding: 30px 20px; }
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
    <a href="listFAQAdmin.jsp"><i class="fas fa-question-circle"></i> Manage FAQ</a>
    <a href="ViewAllRepliesServlet"><i class="fas fa-hourglass-half"></i> Replied Tickets</a>
    <a href="FeedbackListServlet"><i class="fas fa-check-circle"></i> Feedbacks</a>
    <a href="add-staff.jsp"><i class="fas fa-users"></i> Add Staffs</a>
    <a href="manage-users"><i class="fas fa-play-circle"></i> Manage Users</a>
    <a href="profile.jsp"><i class="fas fa-cog"></i> Profile Settings</a>
</nav>

<!-- Header Bar -->
<header class="header-bar">
    <h5><i class="fas fa-edit me-2"></i>Edit FAQ</h5>
    <a href="listFAQAdmin.jsp"><i class="fas fa-arrow-left me-2"></i>Back to FAQs</a>
</header>

<!-- Main Content -->
<main class="main-content" role="main">
    <div class="faq-container">
        <a href="javascript:history.back()" class="btn-back">
            <i class="fas fa-arrow-left"></i> Go Back
        </a>

        <h2>Edit FAQ</h2>

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

        <form action="EditFAQServlet" method="post" enctype="multipart/form-data" id="editFaqForm">
            <!-- CORRECTED: Hidden input now uses 'faqid' -->
            <input type="hidden" name="faqid" value="<%= faqIdParam %>"/>

            <!-- Question -->
            <div class="mb-3">
                <label for="question" class="form-label">
                    Question:
                    <span class="text-danger">*</span>
                </label>
                <input type="text" id="question" name="question" class="form-control"
                       value="<%= question %>" required maxlength="200">
                <div class="char-counter">
                    <span id="questionCharCount"><%= question.length() %></span>/200
                </div>
            </div>

            <!-- Answer -->
            <div class="mb-3">
                <label for="answer" class="form-label">
                    Answer:
                    <span class="text-danger">*</span>
                </label>
                <textarea id="answer" name="answer" rows="5" class="form-control"
                          required maxlength="1000"><%= answer %></textarea>
                <div class="char-counter">
                    <span id="answerCharCount"><%= answer.length() %></span>/1000
                </div>
            </div>

            <!-- Current Image -->
            <div class="mb-3">
                <label class="form-label">Current Image:</label>
                <% if (imgPath != null && !imgPath.isEmpty()) { %>
                <div class="current-image-container">
                    <img src="uploads/<%= imgPath %>" alt="Current FAQ Image"/>
                </div>
                <% } else { %>
                <p class="form-text">No image currently uploaded.</p>
                <% } %>
            </div>

            <!-- New Image -->
            <div class="mb-3">
                <label for="faqImage" class="form-label">Change Image (optional):</label>
                <input type="file" id="faqImage" name="faqImage" class="form-control" accept="image/*">
                <div class="form-text">Supported formats: JPG, PNG, GIF. Max size: 5MB.</div>

                <!-- Image Preview -->
                <div id="imagePreview" class="image-preview">
                    <img id="previewImg" src="" alt="New image preview">
                </div>
            </div>

            <button type="submit" class="btn-submit" id="submitBtn">
                <i class="fas fa-save"></i> Update FAQ
            </button>
        </form>
    </div>
</main>

<script>
    // Character counter for question field
    const questionField = document.getElementById('question');
    const questionCharCount = document.getElementById('questionCharCount');
    questionField.addEventListener('input', function() {
        questionCharCount.textContent = this.value.length;
    });

    // Character counter for answer field
    const answerField = document.getElementById('answer');
    const answerCharCount = document.getElementById('answerCharCount');
    answerField.addEventListener('input', function() {
        answerCharCount.textContent = this.value.length;
    });

    // Image preview functionality
    const faqImage = document.getElementById('faqImage');
    const imagePreview = document.getElementById('imagePreview');
    const previewImg = document.getElementById('previewImg');

    faqImage.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImg.src = e.target.result;
                imagePreview.style.display = 'block';
            };
            reader.readAsDataURL(this.files[0]);
        } else {
            imagePreview.style.display = 'none';
        }
    });

    // Form validation and loading state
    const editFaqForm = document.getElementById('editFaqForm');
    const submitBtn = document.getElementById('submitBtn');

    editFaqForm.addEventListener('submit', function(e) {
        if (questionField.value.trim() === '') {
            e.preventDefault();
            alert('Please enter a question.');
            questionField.focus();
            return;
        }
        if (answerField.value.trim() === '') {
            e.preventDefault();
            alert('Please provide an answer.');
            answerField.focus();
            return;
        }

        // Show loading state
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
    });
</script>

</body>
</html>