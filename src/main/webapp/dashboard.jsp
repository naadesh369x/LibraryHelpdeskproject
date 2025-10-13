<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession session1 = request.getSession(false);
    String email = (session1 != null) ? (String) session1.getAttribute("email") : null;
    String firstName = (session1 != null) ? (String) session1.getAttribute("firstName") : null;

    if (email == null) {
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Library Help Desk</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --info-color: #36b9cc;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --light-color: #f8f9fc;
            --dark-color: #5a5c69;
            --darker-color: #2c3e50;
            --white: #ffffff;
            --gray-100: #f8f9fa;
            --gray-200: #e9ecef;
            --gray-300: #dee2e6;
            --gray-400: #ced4da;
            --gray-500: #adb5bd;
            --gray-600: #6c757d;
            --gray-700: #495057;
            --gray-800: #343a40;
            --gray-900: #212529;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            color: var(--dark-color);
        }

        /* Modern Top Bar */
        .top-bar {
            background: var(--white);
            color: var(--dark-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 32px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
        }
        .top-bar.scrolled {
            padding: 10px 32px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }
        .top-bar .logo {
            display: flex;
            align-items: center;
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .top-bar .logo i {
            margin-right: 10px;
            font-size: 2rem;
            color: var(--primary-color);
        }
        .top-bar .nav-icons {
            display: flex;
            gap: 8px;
        }
        .top-bar .nav-icons a {
            color: var(--dark-color);
            font-size: 1.1rem;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 10px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }
        .top-bar .nav-icons a:hover {
            background: var(--primary-color);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(78, 115, 223, 0.3);
        }
        .top-bar .user-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .top-bar .user-section .user-email {
            font-weight: 600;
            font-size: 1rem;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .top-bar .user-section .user-email i {
            color: var(--primary-color);
        }
        .top-bar .logout-btn {
            background: var(--danger-color);
            color: var(--white);
            border: none;
            border-radius: 10px;
            padding: 10px 16px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            font-weight: 500;
        }
        .top-bar .logout-btn:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(231, 74, 59, 0.3);
        }

        /* Main Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px;
        }

        /* Welcome Section */
        .welcome-section {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            padding: 40px;
            text-align: center;
            margin-bottom: 40px;
            animation: fadeInUp 0.6s ease-out;
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
        .welcome-section h2 {
            font-size: 2.5rem;
            color: var(--dark-color);
            margin-bottom: 15px;
            font-weight: 700;
        }
        .welcome-section p {
            font-size: 1.2rem;
            color: var(--secondary-color);
            margin-bottom: 30px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }
        .action-btn {
            padding: 12px 24px;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            color: var(--white);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.2);
        }
        .action-btn.primary {
            background: linear-gradient(135deg, var(--primary-color), #2e59d9);
        }
        .action-btn.warning {
            background: linear-gradient(135deg, var(--warning-color), #f4b619);
        }
        .action-btn.success {
            background: linear-gradient(135deg, var(--success-color), #17a673);
        }

        /* Books Section */
        .books-section {
            background: var(--white);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            animation: fadeInUp 1s ease-out;
            animation-fill-mode: both;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .section-header h3 {
            font-size: 2rem;
            color: var(--dark-color);
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-header h3 i {
            color: var(--primary-color);
        }
        .view-all-btn {
            background: var(--primary-color);
            color: var(--white);
            border: none;
            border-radius: 50px;
            padding: 10px 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .view-all-btn:hover {
            background: #2e59d9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(78, 115, 223, 0.3);
        }
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 25px;
        }
        .book-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
            border: 1px solid var(--gray-200);
        }
        .book-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }
        .book-card .book-cover {
            height: 250px;
            overflow: hidden;
            position: relative;
        }
        .book-card .book-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .book-card:hover .book-cover img {
            transform: scale(1.05);
        }
        .book-card .book-category {
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--primary-color);
            color: var(--white);
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .book-card .book-info {
            padding: 20px;
        }
        .book-card .book-title {
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--dark-color);
            margin-bottom: 8px;
            line-height: 1.3;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .book-card .book-author {
            font-size: 0.9rem;
            color: var(--secondary-color);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .book-card .book-author i {
            color: var(--primary-color);
        }
        .book-card .book-actions {
            display: flex;
            justify-content: space-between;
        }
        .book-card .book-actions .btn {
            padding: 8px 12px;
            border-radius: 8px;
            border: none;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .book-card .book-actions .btn-primary {
            background: var(--primary-color);
            color: var(--white);
        }
        .book-card .book-actions .btn-primary:hover {
            background: #2e59d9;
        }
        .book-card .book-actions .btn-outline {
            background: transparent;
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
        }
        .book-card .book-actions .btn-outline:hover {
            background: var(--primary-color);
            color: var(--white);
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            animation: fadeIn 0.3s ease;
        }
        .modal.show {
            display: block;
        }
        .modal-content {
            background-color: var(--white);
            margin: 5% auto;
            padding: 0;
            border-radius: 20px;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            animation: slideIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes slideIn {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), #2e59d9);
            color: var(--white);
            padding: 20px 30px;
            border-radius: 20px 20px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-header h2 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
        }
        .close {
            color: var(--white);
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        .close:hover {
            transform: rotate(90deg);
        }
        .modal-body {
            padding: 30px;
        }
        .book-detail-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        .book-detail-cover {
            text-align: center;
        }
        .book-detail-cover img {
            width: 100%;
            max-width: 300px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .book-detail-info h3 {
            color: var(--dark-color);
            font-size: 1.8rem;
            margin-bottom: 15px;
            font-weight: 700;
        }
        .book-detail-info .meta-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }
        .book-detail-info .meta-item i {
            color: var(--primary-color);
            width: 20px;
            text-align: center;
        }
        .book-detail-info .meta-label {
            font-weight: 600;
            color: var(--dark-color);
            min-width: 100px;
        }
        .book-detail-info .meta-value {
            color: var(--secondary-color);
        }
        .book-detail-info .description {
            color: var(--dark-color);
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .book-detail-info .rating {
            display: flex;
            gap: 5px;
            margin-bottom: 20px;
        }
        .book-detail-info .rating i {
            color: var(--warning-color);
        }
        .book-detail-info .availability {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        .book-detail-info .available {
            background: var(--success-color);
            color: var(--white);
        }
        .book-detail-info .unavailable {
            background: var(--danger-color);
            color: var(--white);
        }
        .modal-footer {
            padding: 20px 30px;
            background: var(--gray-100);
            border-radius: 0 0 20px 20px;
            display: flex;
            justify-content: center;
        }
        .modal-footer .btn {
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .modal-footer .btn-primary {
            background: var(--primary-color);
            color: var(--white);
        }
        .modal-footer .btn-primary:hover {
            background: #2e59d9;
        }
        .modal-footer .btn-secondary {
            background: var(--secondary-color);
            color: var(--white);
        }
        .modal-footer .btn-secondary:hover {
            background: var(--gray-700);
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 30px 20px;
            color: var(--gray-600);
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .top-bar .nav-icons {
                display: none;
            }
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            .section-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            .book-detail-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            .welcome-section {
                padding: 30px 20px;
            }
            .welcome-section h2 {
                font-size: 2rem;
            }
            .books-section {
                padding: 30px 20px;
            }
            .books-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 15px;
            }
            .modal-content {
                width: 95%;
                margin: 10% auto;
            }
        }

        @media (max-width: 576px) {
            .books-grid {
                grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            }
        }
    </style>
</head>
<body>

<!-- Modern Top Bar -->
<div class="top-bar" id="topBar">
    <div class="logo">
        <i class="fas fa-book-reader"></i> Library Desk
    </div>
    <div class="nav-icons">
        <a href="myTickets.jsp" title="My Tickets">
            <i class="fas fa-ticket-alt"></i> My Tickets
        </a>
        <a href="myfeedbacks.jsp" title="My Reviews">
            <i class="fas fa-star"></i> My Reviews
        </a>
        <a href="listFAQUser.jsp" title="FAQ">
            <i class="fas fa-question-circle"></i> FAQ
        </a>
        <a href="ViewRequestServlet" title="My Requests">
            <i class="fas fa-clipboard-list"></i> My Requests
        </a>
        <a href="profile.jsp" title="My Profile">
            <i class="fas fa-user-cog"></i> My Profile
        </a>
    </div>
    <div class="user-section">
        <span class="user-email">
            <i class="fas fa-user-circle"></i> <%= firstName %>
        </span>
        <a href="mainpage.jsp" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</div>

<div class="container">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <h2>Hello, <%= firstName %>! 👋</h2>
        <p>Welcome back to your library dashboard. How can we help you today?</p>
        <div class="action-buttons">
            <a href="submitTicket.jsp" class="action-btn primary">
                <i class="fas fa-paper-plane"></i> Submit a Ticket
            </a>
            <a href="FeedbackListServlet" class="action-btn warning">
                <i class="fas fa-star"></i> See Reviews
            </a>
            <a href="addrequest.jsp" class="action-btn success">
                <i class="fas fa-plus-circle"></i> Add a Request
            </a>
        </div>
    </div>

    <!-- Books Section -->
    <div class="books-section">
        <div class="section-header">
            <h3><i class="fas fa-book"></i> Available Books</h3>
            <a href="#" class="view-all-btn">
                View All <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="books-grid">
            <!-- Book Cards -->
            <div class="book-card">
                <div class="book-cover">
                    <img src="https://images.unsplash.com/photo-1532012197267-da84d127e2d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80" alt="Clean Code">
                    <div class="book-category">Programming</div>
                </div>
                <div class="book-info">
                    <div class="book-title">Clean Code: A Handbook of Agile Software Craftsmanship</div>
                    <div class="book-author">
                        <i class="fas fa-user"></i> Robert C. Martin
                    </div>
                    <div class="book-actions">
                        <button class="btn btn-primary" onclick="showBookDetails('Clean Code', 'Robert C. Martin', 'Programming', 'https://images.unsplash.com/photo-1532012197267-da84d127e2d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80')">
                            <i class="fas fa-book-open"></i> Details
                        </button>
                        <a href="#" class="btn btn-outline">
                            <i class="fas fa-bookmark"></i> Save
                        </a>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-cover">
                    <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80" alt="Effective Java">
                    <div class="book-category">Java</div>
                </div>
                <div class="book-info">
                    <div class="book-title">Effective Java</div>
                    <div class="book-author">
                        <i class="fas fa-user"></i> Joshua Bloch
                    </div>
                    <div class="book-actions">
                        <button class="btn btn-primary" onclick="showBookDetails('Effective Java', 'Joshua Bloch', 'Java', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80')">
                            <i class="fas fa-book-open"></i> Details
                        </button>
                        <a href="#" class="btn btn-outline">
                            <i class="fas fa-bookmark"></i> Save
                        </a>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-cover">
                    <img src="https://images.unsplash.com/photo-1544947950-f507427a377e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80" alt="Design Patterns">
                    <div class="book-category">Software Design</div>
                </div>
                <div class="book-info">
                    <div class="book-title">Design Patterns: Elements of Reusable Object-Oriented Software</div>
                    <div class="book-author">
                        <i class="fas fa-user"></i> Erich Gamma
                    </div>
                    <div class="book-actions">
                        <button class="btn btn-primary" onclick="showBookDetails('Design Patterns', 'Erich Gamma', 'Software Design', 'https://images.unsplash.com/photo-1544947950-f507427a377e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80')">
                            <i class="fas fa-book-open"></i> Details
                        </button>
                        <a href="#" class="btn btn-outline">
                            <i class="fas fa-bookmark"></i> Save
                        </a>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-cover">
                    <img src="https://images.unsplash.com/photo-1589998059171-988d887df646?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80" alt="The Pragmatic Programmer">
                    <div class="book-category">Programming</div>
                </div>
                <div class="book-info">
                    <div class="book-title">The Pragmatic Programmer: Your Journey to Mastery</div>
                    <div class="book-author">
                        <i class="fas fa-user"></i> Andrew Hunt
                    </div>
                    <div class="book-actions">
                        <button class="btn btn-primary" onclick="showBookDetails('The Pragmatic Programmer', 'Andrew Hunt', 'Programming', 'https://images.unsplash.com/photo-1589998059171-988d887df646?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80')">
                            <i class="fas fa-book-open"></i> Details
                        </button>
                        <a href="#" class="btn btn-outline">
                            <i class="fas fa-bookmark"></i> Save
                        </a>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-cover">
                    <img src="https://images.unsplash.com/photo-1568667256549-094345857637?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80" alt="Java Concurrency">
                    <div class="book-category">Java</div>
                </div>
                <div class="book-info">
                    <div class="book-title">Java Concurrency in Practice</div>
                    <div class="book-author">
                        <i class="fas fa-user"></i> Brian Goetz
                    </div>
                    <div class="book-actions">
                        <button class="btn btn-primary" onclick="showBookDetails('Java Concurrency in Practice', 'Brian Goetz', 'Java', 'https://images.unsplash.com/photo-1568667256549-094345857637?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80')">
                            <i class="fas fa-book-open"></i> Details
                        </button>
                        <a href="#" class="btn btn-outline">
                            <i class="fas fa-bookmark"></i> Save
                        </a>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-cover">
                    <img src="https://images.unsplash.com/photo-1553729459-efe14ef6055d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80" alt="Head First Java">
                    <div class="book-category">Java</div>
                </div>
                <div class="book-info">
                    <div class="book-title">Head First Java: A Brain-Friendly Guide</div>
                    <div class="book-author">
                        <i class="fas fa-user"></i> Kathy Sierra
                    </div>
                    <div class="book-actions">
                        <button class="btn btn-primary" onclick="showBookDetails('Head First Java', 'Kathy Sierra', 'Java', 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80')">
                            <i class="fas fa-book-open"></i> Details
                        </button>
                        <a href="#" class="btn btn-outline">
                            <i class="fas fa-bookmark"></i> Save
                        </a>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-cover">
                    <img src="https://images.unsplash.com/photo-1532012197267-da84d127e2d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80" alt="Introduction to Algorithms">
                    <div class="book-category">Algorithms</div>
                </div>
                <div class="book-info">
                    <div class="book-title">Introduction to Algorithms</div>
                    <div class="book-author">
                        <i class="fas fa-user"></i> Thomas H. Cormen
                    </div>
                    <div class="book-actions">
                        <button class="btn btn-primary" onclick="showBookDetails('Introduction to Algorithms', 'Thomas H. Cormen', 'Algorithms', 'https://images.unsplash.com/photo-1532012197267-da84d127e2d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80')">
                            <i class="fas fa-book-open"></i> Details
                        </button>
                        <a href="#" class="btn btn-outline">
                            <i class="fas fa-bookmark"></i> Save
                        </a>
                    </div>
                </div>
            </div>
            <div class="book-card">
                <div class="book-cover">
                    <img src="https://images.unsplash.com/photo-1544947950-f507427a377e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80" alt="Refactoring">
                    <div class="book-category">Software Design</div>
                </div>
                <div class="book-info">
                    <div class="book-title">Refactoring: Improving the Design of Existing Code</div>
                    <div class="book-author">
                        <i class="fas fa-user"></i> Martin Fowler
                    </div>
                    <div class="book-actions">
                        <button class="btn btn-primary" onclick="showBookDetails('Refactoring', 'Martin Fowler', 'Software Design', 'https://images.unsplash.com/photo-1544947950-f507427a377e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80')">
                            <i class="fas fa-book-open"></i> Details
                        </button>
                        <a href="#" class="btn btn-outline">
                            <i class="fas fa-bookmark"></i> Save
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    &copy; 2025 Library Help Desk. All Rights Reserved.
</div>

<!-- Book Details Modal -->
<div id="bookModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalBookTitle">Book Details</h2>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <div class="book-detail-grid">
                <div class="book-detail-cover">
                    <img id="modalBookCover" src="" alt="Book Cover">
                </div>
                <div class="book-detail-info">
                    <div class="meta-item">
                        <i class="fas fa-user"></i>
                        <span class="meta-label">Author:</span>
                        <span class="meta-value" id="modalBookAuthor"></span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-tag"></i>
                        <span class="meta-label">Category:</span>
                        <span class="meta-value" id="modalBookCategory"></span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-calendar"></i>
                        <span class="meta-label">Published:</span>
                        <span class="meta-value">2023</span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-barcode"></i>
                        <span class="meta-label">ISBN:</span>
                        <span class="meta-value">978-0132350884</span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-file-alt"></i>
                        <span class="meta-label">Pages:</span>
                        <span class="meta-value">464</span>
                    </div>
                    <div class="rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star-half-alt"></i>
                        <span style="margin-left: 10px; color: var(--secondary-color);">4.5 (2,345 reviews)</span>
                    </div>
                    <div class="description">
                        <h4>Description</h4>
                        <p id="modalBookDescription">This book is a comprehensive guide to writing clean, maintainable, and efficient code. It provides practical advice and best practices for software development.</p>
                    </div>
                    <div class="availability available">
                        <i class="fas fa-check-circle"></i> Available Now
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeModal()">
                <i class="fas fa-times"></i> Close
            </button>
        </div>
    </div>
</div>

<script>
    // Book details data
    const bookDetails = {
        'Clean Code': {
            description: 'Even bad code can function. But if code isn\'t clean, it can bring a development organization to its knees. Every year, countless hours and significant resources are lost because of poorly written code. But it doesn\'t have to be that way.',
            published: '2008',
            isbn: '978-0132350884',
            pages: '464'
        },
        'Effective Java': {
            description: 'Are you looking for a deeper understanding of the Java programming language so that you can write code that is clearer, more correct, more robust, and more reusable? Look no further!',
            published: '2018',
            isbn: '978-0134685991',
            pages: '416'
        },
        'Design Patterns': {
            description: 'Design Patterns: Elements of Reusable Object-Oriented Software is a software engineering book describing software design patterns. The book\'s authors are Erich Gamma, Richard Helm, Ralph Johnson and John Vlissides.',
            published: '1994',
            isbn: '978-0201633610',
            pages: '395'
        },
        'The Pragmatic Programmer': {
            description: 'Written as a series of self-contained sections and filled with classic and fresh anecdotes, thoughtful examples, and interesting analogies, The Pragmatic Programmer illustrates the best approaches and major pitfalls of many different aspects of software development.',
            published: '2019',
            isbn: '978-0135957059',
            pages: '352'
        },
        'Java Concurrency in Practice': {
            description: 'This book covers the concepts and techniques of concurrent programming in Java, including thread safety, performance optimization, and advanced concurrency utilities.',
            published: '2006',
            isbn: '978-0321349606',
            pages: '432'
        },
        'Head First Java': {
            description: 'Head First Java is a complete learning experience in Java and object-oriented programming. With this book, you\'ll learn the Java language with a unique method that goes beyond syntax and how-to manuals.',
            published: '2005',
            isbn: '978-0596009205',
            pages: '688'
        },
        'Introduction to Algorithms': {
            description: 'Introduction to Algorithms uniquely combines rigor and comprehensiveness. The book covers a broad range of algorithms in depth, yet makes their design and analysis accessible to all levels of readers.',
            published: '2009',
            isbn: '978-0262033848',
            pages: '1312'
        },
        'Refactoring': {
            description: 'Refactoring is about improving the design of existing code. It provides a catalog of refactorings that you can use to improve the design of your software, making it easier to understand and modify.',
            published: '2018',
            isbn: '978-0134757599',
            pages: '431'
        }
    };

    // Show book details modal
    function showBookDetails(title, author, category, coverImage) {
        const modal = document.getElementById('bookModal');
        const details = bookDetails[title] || {
            description: 'This is an excellent book that provides valuable insights and knowledge in the field of ' + category + '.',
            published: '2023',
            isbn: '978-0123456789',
            pages: '400'
        };

        document.getElementById('modalBookTitle').textContent = title;
        document.getElementById('modalBookAuthor').textContent = author;
        document.getElementById('modalBookCategory').textContent = category;
        document.getElementById('modalBookCover').src = coverImage;
        document.getElementById('modalBookDescription').textContent = details.description;

        // Update meta information
        const metaItems = modal.querySelectorAll('.meta-value');
        metaItems[2].textContent = details.published; // Published date
        metaItems[3].textContent = details.isbn; // ISBN
        metaItems[4].textContent = details.pages; // Pages

        modal.classList.add('show');
    }

    // Close modal
    function closeModal() {
        const modal = document.getElementById('bookModal');
        modal.classList.remove('show');
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('bookModal');
        if (event.target == modal) {
            closeModal();
        }
    }

    // Sticky navigation bar effect
    window.addEventListener('scroll', function() {
        const topBar = document.getElementById('topBar');
        if (window.scrollY > 50) {
            topBar.classList.add('scrolled');
        } else {
            topBar.classList.remove('scrolled');
        }
    });
</script>

</body>
</html>