<%@ page import="java.sql.*, com.example.demo.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>FAQs</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f3f7fa 0%, #e9e3fc 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        .site-header {
            width: 100%;
            background: linear-gradient(135deg, #5c2ef0 0%, #7c4dff 100%);
            color: #fff;
            box-shadow: 0 8px 30px rgba(92,46,240,0.2);
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 80px;
            position: sticky;
            top: 0;
            z-index: 1000;
            animation: slideDown 0.6s ease-out;
            backdrop-filter: blur(10px);
        }

        @keyframes slideDown {
            from {
                transform: translateY(-100%);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .site-logo {
            font-size: 1.8em;
            font-weight: 700;
            letter-spacing: 1px;
            margin-left: 40px;
            display: flex;
            align-items: center;
        }

        .site-logo i {
            margin-right: 12px;
            font-size: 1.3em;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .site-nav {
            margin-right: 40px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .site-nav a {
            color: #fff;
            text-decoration: none;
            font-weight: 500;
            padding: 12px 24px;
            border-radius: 30px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
        }

        .site-nav a::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.15);
            transition: left 0.4s ease;
        }

        .site-nav a:hover::before {
            left: 0;
        }

        .site-nav a:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .site-nav a i {
            margin-right: 8px;
        }

        .faq-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 50px 20px;
            min-height: calc(100vh - 80px);
        }

        .faq-header {
            text-align: center;
            margin-bottom: 50px;
            animation: fadeInUp 0.7s ease-out;
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

        h2 {
            color: #5c2ef0;
            font-size: 2.8em;
            letter-spacing: 1px;
            margin-bottom: 16px;
            font-weight: 700;
            position: relative;
            display: inline-block;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: -12px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, #5c2ef0, #7c4dff);
            border-radius: 2px;
        }

        .faq-subtitle {
            color: #666;
            font-size: 1.2em;
            margin-top: 25px;
            font-weight: 400;
        }

        .search-container {
            margin: 0 auto 50px;
            max-width: 650px;
            position: relative;
            animation: fadeInUp 0.8s ease-out;
        }

        .search-input {
            width: 100%;
            padding: 18px 60px 18px 25px;
            border: none;
            border-radius: 50px;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 8px 25px rgba(92, 46, 240, 0.15);
            font-size: 1.1em;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            box-shadow: 0 10px 30px rgba(92, 46, 240, 0.25);
            background: rgba(255, 255, 255, 0.95);
            transform: translateY(-2px);
        }

        .search-icon {
            position: absolute;
            right: 25px;
            top: 50%;
            transform: translateY(-50%);
            color: #7c4dff;
            font-size: 1.2em;
        }

        .faq-list {
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .faq-bubble {
            background: linear-gradient(135deg, #ede7f6 0%, #fff 100%);
            border-radius: 24px;
            box-shadow: 0 8px 25px rgba(92,46,240,0.12);
            margin-bottom: 25px;
            width: 100%;
            max-width: 700px;
            transition: all 0.4s ease;
            overflow: hidden;
            animation: fadeInUp 1s ease-out;
            position: relative;
            display: flex;
            flex-direction: column;
        }

        .faq-bubble::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 6px;
            height: 100%;
            background: linear-gradient(180deg, #5c2ef0, #7c4dff);
            border-radius: 24px 0 0 24px;
        }

        .faq-bubble:hover {
            box-shadow: 0 12px 40px rgba(92,46,240,0.2);
            transform: translateY(-5px);
        }

        .accordion {
            background: transparent;
            color: #5c2ef0;
            cursor: pointer;
            padding: 25px 35px;
            width: 100%;
            border: none;
            text-align: left;
            outline: none;
            font-size: 1.2em;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }

        .accordion:hover {
            background: linear-gradient(90deg, rgba(209, 196, 233, 0.3), rgba(237, 231, 246, 0.3));
            color: #3d1e9a;
        }

        .accordion.active {
            background: linear-gradient(90deg, rgba(209, 196, 233, 0.5), rgba(237, 231, 246, 0.5));
            color: #3d1e9a;
        }

        .accordion-question {
            display: flex;
            align-items: center;
            flex: 1;
        }

        .question-number {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #5c2ef0, #7c4dff);
            color: white;
            border-radius: 50%;
            margin-right: 18px;
            font-size: 1em;
            box-shadow: 0 4px 10px rgba(92, 46, 240, 0.3);
            flex-shrink: 0;
        }

        .question-text {
            flex: 1;
            padding-right: 20px;
        }

        .accordion-icon {
            transition: transform 0.3s ease;
            color: #7c4dff;
            font-size: 1.3em;
            flex-shrink: 0;
        }

        .accordion.active .accordion-icon {
            transform: rotate(180deg);
        }

        .panel {
            padding: 0 35px 25px;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.5s ease, padding 0.5s ease;
            background: transparent;
        }

        .panel.show {
            max-height: 500px;
            padding: 0 35px 25px;
        }

        .panel p {
            margin: 15px 0 0 0;
            background: #fffde7;
            border-radius: 16px;
            padding: 18px 25px;
            box-shadow: 0 4px 15px rgba(255,193,7,0.15);
            font-size: 1.05em;
            line-height: 1.7;
            border-left: 5px solid #7c4dff;
            position: relative;
        }

        .panel p::before {
            content: '"';
            position: absolute;
            top: 5px;
            left: 10px;
            font-size: 2em;
            color: rgba(124, 77, 255, 0.2);
        }

        .back-btn {
            position: absolute;
            top: 25px;
            left: 30px;
            text-decoration: none;
            padding: 12px 24px;
            background-color: rgba(108, 117, 125, 0.8);
            color: white;
            border-radius: 30px;
            transition: all 0.3s ease;
            font-weight: 500;
            display: flex;
            align-items: center;
            z-index: 100;
            backdrop-filter: blur(5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .back-btn i {
            margin-right: 10px;
        }

        .back-btn:hover {
            background-color: rgba(108, 117, 125, 1);
            transform: translateX(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        .no-results {
            text-align: center;
            padding: 50px;
            color: #666;
            font-size: 1.2em;
            display: none;
            animation: fadeInUp 0.5s ease-out;
        }

        .no-results i {
            font-size: 3.5em;
            color: #7c4dff;
            margin-bottom: 20px;
        }

        .stats-container {
            display: flex;
            justify-content: center;
            margin-bottom: 40px;
            gap: 30px;
            animation: fadeInUp 0.9s ease-out;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.7);
            border-radius: 16px;
            padding: 15px 25px;
            box-shadow: 0 5px 15px rgba(92, 46, 240, 0.1);
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(92, 46, 240, 0.15);
        }

        .stat-icon {
            font-size: 1.5em;
            color: #7c4dff;
            margin-right: 12px;
        }

        .stat-value {
            font-size: 1.3em;
            font-weight: 700;
            color: #5c2ef0;
        }

        .stat-label {
            font-size: 0.9em;
            color: #666;
        }

        @media (max-width: 768px) {
            .site-header {
                padding: 0 20px;
                height: 70px;
            }

            .site-logo {
                margin-left: 20px;
                font-size: 1.5em;
            }

            .site-nav {
                margin-right: 20px;
            }

            h2 {
                font-size: 2.2em;
            }

            .faq-container {
                padding: 40px 15px;
            }

            .back-btn {
                top: 15px;
                left: 15px;
                padding: 10px 18px;
            }

            .stats-container {
                flex-direction: column;
                align-items: center;
                gap: 15px;
            }

            .stat-card {
                width: 80%;
            }

            .accordion {
                padding: 20px 25px;
                font-size: 1.1em;
            }

            .question-number {
                width: 32px;
                height: 32px;
                font-size: 0.9em;
            }
        }
    </style>
</head>
<body>
<!-- Back to Dashboard Button -->
<a href="dashboard.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>

<header class="site-header">
    <div class="site-logo">
        <i class="fas fa-question-circle"></i>
        Help Center
    </div>
    <nav class="site-nav">
        <a href="dashboard.jsp"><i class="fas fa-home"></i> Home</a>
    </nav>
</header>

<div class="faq-container">
    <div class="faq-header">
        <h2>Frequently Asked Questions</h2>
        <p class="faq-subtitle">Find answers to common questions about our services</p>
    </div>

    <div class="stats-container">
        <div class="stat-card">
            <i class="fas fa-question stat-icon"></i>
            <div>
                <div class="stat-value" id="totalQuestions">0</div>
                <div class="stat-label">Total Questions</div>
            </div>
        </div>
        <div class="stat-card">
            <i class="fas fa-clock stat-icon"></i>
            <div>
                <div class="stat-value">24/7</div>
                <div class="stat-label">Support</div>
            </div>
        </div>
    </div>

    <div class="search-container">
        <input type="text" class="search-input" id="searchInput" placeholder="Search for questions...">
        <i class="fas fa-search search-icon"></i>
    </div>

    <div class="no-results" id="noResults">
        <i class="fas fa-search"></i>
        <p>No results found. Try a different search term.</p>
    </div>

    <div class="faq-list" id="faqList">
        <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT question, answer FROM faq ORDER BY created_at ASC");
                 ResultSet rs = ps.executeQuery()) {

                int count = 1;
                while (rs.next()) {
                    String question = rs.getString("question");
                    String answer = rs.getString("answer");
        %>
        <div class="faq-bubble">
            <button class="accordion">
                <div class="accordion-question">
                    <span class="question-number"><%= count %></span>
                    <span class="question-text"><%= question %></span>
                </div>
                <i class="fas fa-chevron-down accordion-icon"></i>
            </button>
            <div class="panel">
                <p><%= answer %></p>
            </div>
        </div>
        <%
                    count++;
                }
            } catch (Exception e) {
                out.println("Error loading FAQs: " + e.getMessage());
            }
        %>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Set total questions count
        const totalQuestions = document.querySelectorAll('.faq-bubble').length;
        document.getElementById('totalQuestions').textContent = totalQuestions;

        // Accordion functionality
        const accordions = document.querySelectorAll('.accordion');

        accordions.forEach(accordion => {
            accordion.addEventListener('click', function() {
                this.classList.toggle('active');
                const panel = this.nextElementSibling;
                panel.classList.toggle('show');

                // Close other accordions
                accordions.forEach(otherAccordion => {
                    if (otherAccordion !== accordion && otherAccordion.classList.contains('active')) {
                        otherAccordion.classList.remove('active');
                        otherAccordion.nextElementSibling.classList.remove('show');
                    }
                });
            });
        });

        // Search functionality
        const searchInput = document.getElementById('searchInput');
        const faqBubbles = document.querySelectorAll('.faq-bubble');
        const noResults = document.getElementById('noResults');

        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            let hasResults = false;

            faqBubbles.forEach(bubble => {
                const question = bubble.querySelector('.question-text').textContent.toLowerCase();
                const answer = bubble.querySelector('.panel p').textContent.toLowerCase();

                if (question.includes(searchTerm) || answer.includes(searchTerm)) {
                    bubble.style.display = 'flex';
                    hasResults = true;
                } else {
                    bubble.style.display = 'none';
                }
            });

            noResults.style.display = hasResults ? 'none' : 'block';
        });
    });
</script>
</body>
</html>