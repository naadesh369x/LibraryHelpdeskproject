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
<html>
<head>
    <title>User Dashboard - Library Help Desk</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #c9d6ff, #e2e2e2);
        }

        /* Modern Top Bar */
        .top-bar {
            background: #23272f;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            height: 64px;
            box-shadow: 0 2px 8px rgba(44,62,80,0.08);
        }
        .top-bar .logo {
            display: flex;
            align-items: center;
            font-size: 1.5rem;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .top-bar .logo i {
            margin-right: 10px;
            font-size: 2rem;
            color: #3498db;
        }
        .top-bar .nav-icons {
            display: flex;
            gap: 28px;
        }
        .top-bar .nav-icons a {
            color: #fff;
            font-size: 1.2rem;
            text-decoration: none;
            padding: 8px 12px;
            border-radius: 8px;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 7px;
        }
        .top-bar .nav-icons a:hover {
            background: #3498db;
            color: #fff;
        }
        .top-bar .user-section {
            display: flex;
            align-items: center;
            gap: 18px;
        }
        .top-bar .user-section .user-email {
            font-weight: 500;
            font-size: 1rem;
            color: #bdc3c7;
        }
        .top-bar .logout-btn {
            background: #e74c3c;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 7px;
            text-decoration: none;
        }
        .top-bar .logout-btn:hover {
            background: #c0392b;
        }

        /* Dashboard Content */
        .dashboard {
            padding: 30px;
        }

        .dashboard h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            text-align: center;
        }

        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
        }

        .book-card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            padding: 15px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .book-card img {
            max-width: 100%;
            border-radius: 10px;
            height: 220px;
            object-fit: cover;
            margin-bottom: 10px;
            transition: transform 0.3s;
        }

        .book-card img:hover {
            transform: scale(1.05);
        }

        .book-title {
            font-weight: bold;
            font-size: 16px;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .book-author {
            font-size: 14px;
            color: #7f8c8d;
            margin-bottom: 8px;
        }

        .book-category {
            font-size: 13px;
            color: #95a5a6;
            margin-bottom: 8px;
        }

        /* Footer for Info */
        .footer {
            text-align: center;
            padding: 20px;
            margin-top: 40px;
            color: #7f8c8d;
            font-size: 14px;
        }
    </style>
</head>
<body>

<!-- Modern Top Bar -->
<div class="top-bar">
    <div class="logo">
        <i class="fas fa-book-reader"></i> Library Desk
    </div>
    <div class="nav-icons">
        <a href="myTickets.jsp" title=" My Tickets">
            <i class="fas fa-ticket-alt"></i>  My Tickets
        </a>
        <a href="myfeedbacks.jsp" title=" My Reviews">
            <i class="fas fa-star"></i>  My Reviews
        </a>
        <a href="listFAQUser.jsp" title="FAQ">
            <i class="fas fa-question-circle"></i> FAQ
        </a>
        <a href="ViewRequestServlet" title="My Requests">
            <i class="fas fa-clipboard-list"></i> My Requests
        </a>
        <a href="profile.jsp" title=" My Profile">
            <i class="fas fa-user-cog"></i>  My Profile
        </a>
    </div>
    <div class="user-section">
        <span class="user-email">
            <i class="fas fa-user"></i> <%= firstName %> (<%= email %>)
        </span>
        <a href="mainpage.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</div>

<!-- Greeting and Actions -->
<div style="max-width: 700px; margin: 40px auto 0 auto; background: #fff; border-radius: 18px; box-shadow: 0 4px 18px rgba(44,62,80,0.07); padding: 32px 28px 24px 28px; text-align: center;">
    <h2 style="margin-bottom: 10px; color: #23272f;">Hello, <%= firstName %>!</h2>
    <p style="font-size: 1.15rem; color: #34495e; margin-bottom: 24px;">How can I help you?</p>
    <div style="display: flex; justify-content: center; gap: 24px;">
        <a href="submitTicket.jsp" style="background: #3498db; color: #fff; border-radius: 8px; padding: 12px 28px; font-size: 1rem; text-decoration: none; box-shadow: 0 2px 8px rgba(44,62,80,0.08); transition: background 0.2s;">
            <i class="fas fa-paper-plane"></i> Submit a Ticket
        </a>
        <a href="FeedbackListServlet" style="background: #f1c40f; color: #23272f; border-radius: 8px; padding: 12px 28px; font-size: 1rem; text-decoration: none; box-shadow: 0 2px 8px rgba(44,62,80,0.08); transition: background 0.2s;">
            <i class="fas fa-star"></i> See Reviews
        </a>
        <a href="addrequest.jsp" style="background: #27ae60; color: #fff; border-radius: 8px; padding: 12px 28px; font-size: 1rem; text-decoration: none; box-shadow: 0 2px 8px rgba(44,62,80,0.08); transition: background 0.2s;">
            <i class="fas fa-plus-circle"></i>  Add a Request
        </a>
    </div>
</div>

<!-- Dashboard Content -->
<div class="dashboard">
    <h3>📚 Available Books</h3>
    <div class="books-grid">
        <!-- Book Cards -->
        <div class="book-card">
            <img src="images/book1.jpg" alt="Clean Code">
            <div class="book-title">Clean Code</div>
            <div class="book-author">Robert C. Martin</div>
            <div class="book-category">Programming</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Effective Java">
            <div class="book-title">Effective Java</div>
            <div class="book-author">Joshua Bloch</div>
            <div class="book-category">Programming</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Design Patterns">
            <div class="book-title">Design Patterns</div>
            <div class="book-author">Erich Gamma</div>
            <div class="book-category">Software Design</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="The Pragmatic Programmer">
            <div class="book-title">The Pragmatic Programmer</div>
            <div class="book-author">Andrew Hunt</div>
            <div class="book-category">Programming</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Java Concurrency">
            <div class="book-title">Java Concurrency</div>
            <div class="book-author">Brian Goetz</div>
            <div class="book-category">Java</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Head First Java">
            <div class="book-title">Head First Java</div>
            <div class="book-author">Kathy Sierra</div>
            <div class="book-category">Java</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Introduction to Algorithms">
            <div class="book-title">Intro to Algorithms</div>
            <div class="book-author">Cormen</div>
            <div class="book-category">Algorithms</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Refactoring">
            <div class="book-title">Refactoring</div>
            <div class="book-author">Martin Fowler</div>
            <div class="book-category">Software Design</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Code Complete">
            <div class="book-title">Code Complete</div>
            <div class="book-author">Steve McConnell</div>
            <div class="book-category">Programming</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Clean Architecture">
            <div class="book-title">Clean Architecture</div>
            <div class="book-author">Robert C. Martin</div>
            <div class="book-category">Software Design</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Algorithms Unlocked">
            <div class="book-title">Algorithms Unlocked</div>
            <div class="book-author">Thomas H. Cormen</div>
            <div class="book-category">Algorithms</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="You Don't Know JS">
            <div class="book-title">You Don't Know JS</div>
            <div class="book-author">Kyle Simpson</div>
            <div class="book-category">JavaScript</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="The Art of Computer Programming">
            <div class="book-title">The Art of Computer Programming</div>
            <div class="book-author">Donald Knuth</div>
            <div class="book-category">Programming</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Structure and Interpretation of Computer Programs">
            <div class="book-title">SICP</div>
            <div class="book-author">Harold Abelson</div>
            <div class="book-category">Programming</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Python Crash Course">
            <div class="book-title">Python Crash Course</div>
            <div class="book-author">Eric Matthes</div>
            <div class="book-category">Python</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Fluent Python">
            <div class="book-title">Fluent Python</div>
            <div class="book-author">Luciano Ramalho</div>
            <div class="book-category">Python</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Pro Git">
            <div class="book-title">Pro Git</div>
            <div class="book-author">Scott Chacon</div>
            <div class="book-category">Git</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Cracking the Coding Interview">
            <div class="book-title">Cracking the Coding Interview</div>
            <div class="book-author">Gayle Laakmann McDowell</div>
            <div class="book-category">Interview</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Spring in Action">
            <div class="book-title">Spring in Action</div>
            <div class="book-author">Craig Walls</div>
            <div class="book-category">Java</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="JavaScript: The Good Parts">
            <div class="book-title">JavaScript: The Good Parts</div>
            <div class="book-author">Douglas Crockford</div>
            <div class="book-category">JavaScript</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Test Driven Development">
            <div class="book-title">Test Driven Development</div>
            <div class="book-author">Kent Beck</div>
            <div class="book-category">Software Design</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Continuous Delivery">
            <div class="book-title">Continuous Delivery</div>
            <div class="book-author">Jez Humble</div>
            <div class="book-category">DevOps</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="The Mythical Man-Month">
            <div class="book-title">The Mythical Man-Month</div>
            <div class="book-author">Frederick P. Brooks Jr.</div>
            <div class="book-category">Software Engineering</div>
        </div>
        <div class="book-card">
            <img src="images/book1.jpg" alt="Refactoring UI">
            <div class="book-title">Refactoring UI</div>
            <div class="book-author">Adam Wathan</div>
            <div class="book-category">UI/UX</div>
        </div>


    </div>
</div>

<!-- Footer -->
<div class="footer">
    &copy; 2025 Library Help Desk. All Rights Reserved.
</div>

</body>
</html>
