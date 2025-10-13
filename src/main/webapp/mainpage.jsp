<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Help Desk Portal</title>
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
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body, html {
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            scroll-behavior: smooth;
            background: #181a20;
            color: #fff;
            overflow-x: hidden;
        }

        a { text-decoration: none; color: inherit; }

        /* Background Video */
        #bg-video {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            object-fit: cover;
            z-index: -2;
        }
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0,0,0,0.5);
            z-index: -1;
        }

        /* Top Navigation Bar */
        .top-bar {
            background: rgba(44,62,80,0.95);
            backdrop-filter: blur(10px);
            color: #fff;
            padding: 14px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
        }
        .top-bar.scrolled {
            padding: 10px 32px;
            background: rgba(44,62,80,0.98);
        }
        .top-bar .left h2 {
            margin: 0;
            font-size: 26px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
        }
        .top-bar .left h2 i {
            color: var(--success-color);
        }
        .top-bar .right a {
            margin-left: 18px;
            padding: 8px 16px;
            border-radius: 8px;
            background: var(--primary-color);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .top-bar .right a:hover {
            background: #2e59d9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .top-bar .right a.login-btn {
            background: var(--success-color);
        }
        .top-bar .right a.login-btn:hover {
            background: #17a673;
        }

        /* Sections */
        section {
            padding: 100px 50px;
            min-height: 100vh;
            position: relative;
        }

        /* Hero Section */
        .hero {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
        }
        .hero h1 {
            font-size: 56px;
            margin-bottom: 24px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
            font-weight: 700;
            animation: fadeInUp 0.8s ease-out;
        }
        .hero p {
            font-size: 22px;
            margin-bottom: 40px;
            color: #e0e0e0;
            max-width: 700px;
            animation: fadeInUp 0.8s ease-out 0.2s;
            animation-fill-mode: both;
        }
        .hero .get-started-btn {
            padding: 16px 36px;
            font-size: 20px;
            background: linear-gradient(90deg, var(--success-color) 0%, #17a673 100%);
            color: #fff;
            border-radius: 50px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(28, 200, 138, 0.3);
            transition: all 0.3s ease;
            animation: fadeInUp 0.8s ease-out 0.4s;
            animation-fill-mode: both;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        .hero .get-started-btn:hover {
            background: linear-gradient(90deg, #17a673 0%, #13855c 100%);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(28, 200, 138, 0.4);
        }

        /* Enhanced Image Slideshow */
        .slideshow-container {
            position: relative;
            max-width: 1200px;
            margin: 60px auto 0;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(0,0,0,0.4);
            animation: fadeInUp 0.8s ease-out 0.6s;
            animation-fill-mode: both;
        }
        .slide {
            display: none;
            position: relative;
            animation: slideIn 0.8s ease-out;
        }
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(100px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        .slide.active {
            display: block;
        }
        .slide img {
            width: 100%;
            height: 500px;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .slide:hover img {
            transform: scale(1.03);
        }
        .slide-caption {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.8) 0%, rgba(0,0,0,0) 100%);
            color: white;
            padding: 40px 20px 20px;
            text-align: center;
        }
        .slide-caption h3 {
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .slide-caption p {
            font-size: 18px;
            margin: 0;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }
        .prev, .next {
            cursor: pointer;
            position: absolute;
            top: 50%;
            width: auto;
            padding: 20px;
            margin-top: -22px;
            color: white;
            font-weight: bold;
            font-size: 24px;
            transition: all 0.3s ease;
            border-radius: 0 3px 3px 0;
            user-select: none;
            background-color: rgba(0,0,0,0.5);
            z-index: 10;
        }
        .prev:hover, .next:hover {
            background-color: rgba(0,0,0,0.8);
            transform: scale(1.1);
        }
        .next {
            right: 0;
            border-radius: 3px 0 0 3px;
        }
        .dots-container {
            text-align: center;
            margin-top: 20px;
        }
        .dot {
            cursor: pointer;
            height: 15px;
            width: 15px;
            margin: 0 8px;
            background-color: rgba(255,255,255,0.5);
            border-radius: 50%;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .active, .dot:hover {
            background-color: white;
            transform: scale(1.2);
        }
        .slideshow-controls {
            position: absolute;
            bottom: 20px;
            right: 20px;
            display: flex;
            gap: 10px;
            z-index: 10;
        }
        .control-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        .control-btn:hover {
            background: rgba(255,255,255,0.4);
            transform: scale(1.1);
        }

        /* About Section */
        #about {
            background: linear-gradient(135deg, #1f2229 0%, #2a2d38 100%);
            position: relative;
        }
        #about h2 {
            font-size: 42px;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 700;
            position: relative;
        }
        #about h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--success-color);
            border-radius: 2px;
        }
        #about .about-content {
            display: flex;
            align-items: center;
            gap: 50px;
            max-width: 1200px;
            margin: 0 auto;
        }
        #about .about-text {
            flex: 1;
        }
        #about .about-text p {
            font-size: 20px;
            line-height: 1.6;
            color: #e0e0e0;
            margin-bottom: 20px;
        }
        #about .about-image {
            flex: 1;
            max-width: 500px;
            position: relative;
            overflow: hidden;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        #about .about-image img {
            width: 100%;
            display: block;
            transition: transform 0.5s ease;
        }
        #about .about-image:hover img {
            transform: scale(1.05);
        }

        /* Services Section */
        #services {
            background: linear-gradient(135deg, #252832 0%, #1f2229 100%);
        }
        #services h2 {
            font-size: 42px;
            margin-bottom: 50px;
            text-align: center;
            font-weight: 700;
            position: relative;
        }
        #services h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--info-color);
            border-radius: 2px;
        }
        .service-cards {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
            margin-top: 40px;
        }
        .card {
            background: rgba(51, 56, 70, 0.8);
            backdrop-filter: blur(10px);
            padding: 40px 30px;
            border-radius: 15px;
            flex: 1 1 300px;
            max-width: 350px;
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
            position: relative;
            overflow: hidden;
        }
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--info-color), var(--primary-color));
        }
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.4);
            background: rgba(51, 56, 70, 0.95);
        }
        .card i {
            font-size: 48px;
            margin-bottom: 20px;
            color: var(--info-color);
            transition: all 0.3s ease;
        }
        .card:hover i {
            transform: scale(1.1);
            color: var(--primary-color);
        }
        .card h3 {
            font-size: 24px;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .card p {
            font-size: 16px;
            color: #ccc;
            line-height: 1.5;
        }

        /* Gallery Section */
        #gallery {
            background: linear-gradient(135deg, #1f2229 0%, #2a2d38 100%);
            padding: 80px 50px;
        }
        #gallery h2 {
            font-size: 42px;
            margin-bottom: 50px;
            text-align: center;
            font-weight: 700;
            position: relative;
        }
        #gallery h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--warning-color);
            border-radius: 2px;
        }
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .gallery-item {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            height: 250px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }
        .gallery-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.4);
        }
        .gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .gallery-item:hover img {
            transform: scale(1.05);
        }
        .gallery-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.8) 0%, rgba(0,0,0,0) 100%);
            color: white;
            padding: 20px;
            transform: translateY(100%);
            transition: transform 0.3s ease;
        }
        .gallery-item:hover .gallery-overlay {
            transform: translateY(0);
        }
        .gallery-overlay h3 {
            font-size: 18px;
            margin-bottom: 5px;
        }
        .gallery-overlay p {
            font-size: 14px;
            margin: 0;
            opacity: 0.8;
        }

        /* Contact Section */
        #contact {
            background: linear-gradient(135deg, #1f2229 0%, #2a2d38 100%);
            text-align: center;
        }
        #contact h2 {
            font-size: 42px;
            margin-bottom: 20px;
            font-weight: 700;
            position: relative;
        }
        #contact h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--warning-color);
            border-radius: 2px;
        }
        #contact p {
            font-size: 20px;
            margin-bottom: 40px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }
        #contact .contact-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 14px 32px;
            background: var(--warning-color);
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(246, 194, 62, 0.3);
        }
        #contact .contact-btn:hover {
            background: #f4b619;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(246, 194, 62, 0.4);
        }

        /* Footer */
        footer {
            background: #11151a;
            text-align: center;
            padding: 40px 20px;
            font-size: 16px;
            color: #888;
        }
        .footer-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }
        .social-links {
            display: flex;
            gap: 15px;
        }
        .social-links a {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255,255,255,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        .social-links a:hover {
            background: var(--primary-color);
            transform: translateY(-3px);
        }

        /* Animations */
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

        /* Responsive Design */
        @media (max-width: 992px) {
            .hero h1 { font-size: 48px; }
            #about .about-content {
                flex-direction: column;
                gap: 30px;
            }
        }

        @media (max-width: 768px) {
            section { padding: 80px 30px; }
            .hero h1 { font-size: 40px; }
            .hero p { font-size: 18px; }
            .slideshow-container { margin: 40px 20px 0; }
            .slide img { height: 350px; }
            .footer-content {
                flex-direction: column;
                gap: 20px;
            }
            .top-bar .right a {
                margin-left: 10px;
                padding: 6px 12px;
                font-size: 14px;
            }
        }

        @media (max-width: 576px) {
            .hero h1 { font-size: 32px; }
            .hero .get-started-btn { padding: 12px 24px; font-size: 18px; }
            .slide img { height: 250px; }
            .card { padding: 30px 20px; }
        }
    </style>
</head>
<body>

<!-- Background Video -->
<video autoplay muted loop id="bg-video">
    <source src="https://assets.mixkit.co/videos/preview/mixkit-library-with-bookshelves-and-people-reading-3978-large.mp4" type="video/mp4">
    Your browser does not support HTML5 video.
</video>
<div class="overlay"></div>

<!-- Top navigation bar -->
<div class="top-bar" id="topBar">
    <div class="left"><h2><i class="fas fa-book-reader"></i> Library Help Desk</h2></div>
    <div class="right">
        <a href="#hero">Home</a>
        <a href="#about">About</a>
        <a href="#services">Services</a>
        <a href="#gallery">Gallery</a>
        <a href="#contact">Contact</a>
        <a href="login.jsp" class="login-btn"><i class="fas fa-user"></i> Login</a>
    </div>
</div>

<!-- Hero Section -->
<section id="hero" class="hero">
    <h1>Welcome to the Library Help Desk</h1>
    <p>Manage support requests, FAQs, and library services efficiently.</p>
    <a href="login.jsp" class="get-started-btn"><i class="fas fa-play-circle"></i> Get Started</a>

    <!-- Enhanced Image Slideshow -->
    <div class="slideshow-container">
        <div class="slide active">
            <img src="https://images.unsplash.com/photo-1568667256549-094345857637?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1200&q=80" alt="Digital Library Resources">
            <div class="slide-caption">
                <h3>Digital Library Resources</h3>
                <p>Access thousands of digital books, journals, and multimedia resources from anywhere</p>
            </div>
        </div>
        <div class="slide">
            <img src="https://images.unsplash.com/photo-1589998059171-988d887df646?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1200&q=80" alt="Modern Library Space">
            <div class="slide-caption">
                <h3>Modern Library Spaces</h3>
                <p>State-of-the-art facilities designed for optimal learning and collaboration</p>
            </div>
        </div>
        <div class="slide">
            <img src="https://images.unsplash.com/photo-1553729459-efe14ef6055d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1200&q=80" alt="Expert Library Staff">
            <div class="slide-caption">
                <h3>Expert Library Staff</h3>
                <p>Knowledgeable librarians ready to assist with your research needs</p>
            </div>
        </div>
        <div class="slide">
            <img src="https://images.unsplash.com/photo-1521587760476-6c12a2b040da?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1200&q=80" alt="Library Technology">
            <div class="slide-caption">
                <h3>Advanced Library Technology</h3>
                <p>Cutting-edge technology solutions for efficient library management</p>
            </div>
        </div>
        <div class="slide">
            <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1200&q=80" alt="Community Events">
            <div class="slide-caption">
                <h3>Community Events</h3>
                <p>Engaging workshops, seminars, and events for library members</p>
            </div>
        </div>

        <!-- Navigation buttons -->
        <a class="prev" onclick="plusSlides(-1)">&#10094;</a>
        <a class="next" onclick="plusSlides(1)">&#10095;</a>

        <!-- Control buttons -->
        <div class="slideshow-controls">
            <button class="control-btn" onclick="toggleSlideshow()" id="playPauseBtn">
                <i class="fas fa-pause"></i>
            </button>
            <button class="control-btn" onclick="toggleFullscreen()">
                <i class="fas fa-expand"></i>
            </button>
        </div>
    </div>

    <!-- Dots indicators -->
    <div class="dots-container">
        <span class="dot active" onclick="currentSlide(1)"></span>
        <span class="dot" onclick="currentSlide(2)"></span>
        <span class="dot" onclick="currentSlide(3)"></span>
        <span class="dot" onclick="currentSlide(4)"></span>
        <span class="dot" onclick="currentSlide(5)"></span>
    </div>
</section>

<!-- About Section -->
<section id="about">
    <h2>About Us</h2>
    <div class="about-content">
        <div class="about-text">
            <p>Library Help Desk is your one-stop solution for all library services. From managing requests to answering FAQs, we ensure smooth support for members, staff, and administrators.</p>
            <p>Our platform is designed to streamline library operations, making it easier for users to access resources, request assistance, and stay informed about library events and services.</p>
            <p>With a user-friendly interface and powerful features, we're committed to enhancing the library experience for everyone.</p>
        </div>
        <div class="about-image">
            <img src="https://images.unsplash.com/photo-1481627834876-b7833e8f5570?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80" alt="Library Help Desk">
        </div>
    </div>
</section>

<!-- Services Section -->
<section id="services">
    <h2>Our Services</h2>
    <div class="service-cards">
        <div class="card">
            <i class="fas fa-question-circle"></i>
            <h3>FAQs</h3>
            <p>Access frequently asked questions and find answers quickly. Our comprehensive FAQ section covers all aspects of library services.</p>
        </div>
        <div class="card">
            <i class="fas fa-headset"></i>
            <h3>Support</h3>
            <p>Submit and track support tickets for any library-related issues. Our dedicated support team ensures timely resolution of your concerns.</p>
        </div>
        <div class="card">
            <i class="fas fa-book"></i>
            <h3>Library Management</h3>
            <p>Efficiently manage book requests, returns, and inventory. Our system simplifies the entire library management process.</p>
        </div>
    </div>
    <!-- React App Placeholder -->
    <div id="react-root" style="margin-top:60px;">
        <!-- React will mount here -->
    </div>
</section>

<!-- Gallery Section -->
<section id="gallery">
    <h2>Library Gallery</h2>
    <div class="gallery-grid">
        <div class="gallery-item">
            <img src="https://images.unsplash.com/photo-1532012197267-da84d127e2d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80" alt="Reading Area">
            <div class="gallery-overlay">
                <h3>Quiet Reading Areas</h3>
                <p>Peaceful spaces for focused study</p>
            </div>
        </div>
        <div class="gallery-item">
            <img src="https://images.unsplash.com/photo-1600188965925-7ac49bba219c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80" alt="Computer Lab">
            <div class="gallery-overlay">
                <h3>Digital Resources</h3>
                <p>Access to computers and online databases</p>
            </div>
        </div>
        <div class="gallery-item">
            <img src="https://images.unsplash.com/photo-1498243691581-b145c3f54a5a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80" alt="Book Collection">
            <div class="gallery-overlay">
                <h3>Extensive Collection</h3>
                <p>Thousands of books across all genres</p>
            </div>
        </div>
        <div class="gallery-item">
            <img src="https://images.unsplash.com/photo-1568667256549-094345857637?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80" alt="Study Rooms">
            <div class="gallery-overlay">
                <h3>Group Study Rooms</h3>
                <p>Collaborative spaces for team projects</p>
            </div>
        </div>
        <div class="gallery-item">
            <img src="https://images.unsplash.com/photo-1554658893-2e63c446c7fd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80" alt="Children's Section">
            <div class="gallery-overlay">
                <h3>Children's Section</h3>
                <p>Engaging space for young readers</p>
            </div>
        </div>
        <div class="gallery-item">
            <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80" alt="Periodicals">
            <div class="gallery-overlay">
                <h3>Periodicals Section</h3>
                <p>Latest newspapers and magazines</p>
            </div>
        </div>
    </div>
</section>

<!-- Contact Section -->
<section id="contact">
    <h2>Contact Us</h2>
    <p>Have questions or need assistance? Reach out to us anytime. We're here to help with any library-related inquiries.</p>
    <a href="contact.jsp" class="contact-btn"><i class="fas fa-envelope"></i> Get in Touch</a>
</section>

<!-- Footer -->
<footer>
    <div class="footer-content">
        <div>&copy; 2025 Library Help Desk. All rights reserved.</div>
        <div class="social-links">
            <a href="#"><i class="fab fa-facebook-f"></i></a>
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-linkedin-in"></i></a>
        </div>
    </div>
</footer>

<!-- Add React and Babel CDN for future integration -->
<script src="https://unpkg.com/react@18/umd/react.development.js" crossorigin></script>
<script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js" crossorigin></script>
<script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>

<script>
    // Enhanced Slideshow functionality
    let slideIndex = 1;
    let slideshowInterval;
    let isPlaying = true;

    // Initialize slideshow
    showSlides(slideIndex);
    startSlideshow();

    function plusSlides(n) {
        showSlides(slideIndex += n);
        resetSlideshowTimer();
    }

    function currentSlide(n) {
        showSlides(slideIndex = n);
        resetSlideshowTimer();
    }

    function showSlides(n) {
        let i;
        let slides = document.getElementsByClassName("slide");
        let dots = document.getElementsByClassName("dot");

        if (slides.length === 0) return;

        if (n > slides.length) {slideIndex = 1}
        if (n < 1) {slideIndex = slides.length}

        // Hide all slides
        for (i = 0; i < slides.length; i++) {
            slides[i].classList.remove("active");
        }

        // Remove active class from all dots
        for (i = 0; i < dots.length; i++) {
            dots[i].classList.remove("active");
        }

        // Show current slide
        slides[slideIndex-1].classList.add("active");
        dots[slideIndex-1].classList.add("active");
    }

    function startSlideshow() {
        slideshowInterval = setInterval(function() {
            slideIndex++;
            showSlides(slideIndex);
        }, 5000);
    }

    function stopSlideshow() {
        clearInterval(slideshowInterval);
    }

    function resetSlideshowTimer() {
        if (isPlaying) {
            stopSlideshow();
            startSlideshow();
        }
    }

    function toggleSlideshow() {
        const playPauseBtn = document.getElementById("playPauseBtn");
        const icon = playPauseBtn.querySelector("i");

        if (isPlaying) {
            stopSlideshow();
            icon.classList.remove("fa-pause");
            icon.classList.add("fa-play");
        } else {
            startSlideshow();
            icon.classList.remove("fa-play");
            icon.classList.add("fa-pause");
        }

        isPlaying = !isPlaying;
    }

    function toggleFullscreen() {
        const slideshowContainer = document.querySelector(".slideshow-container");

        if (!document.fullscreenElement) {
            slideshowContainer.requestFullscreen().catch(err => {
                console.log(`Error attempting to enable fullscreen: ${err.message}`);
            });
        } else {
            document.exitFullscreen();
        }
    }

    // Keyboard navigation
    document.addEventListener('keydown', function(e) {
        if (e.key === 'ArrowLeft') {
            plusSlides(-1);
        } else if (e.key === 'ArrowRight') {
            plusSlides(1);
        } else if (e.key === ' ') {
            e.preventDefault();
            toggleSlideshow();
        }
    });

    // Touch/swipe support for mobile
    let touchStartX = 0;
    let touchEndX = 0;

    const slideshowContainer = document.querySelector(".slideshow-container");

    slideshowContainer.addEventListener('touchstart', function(e) {
        touchStartX = e.changedTouches[0].screenX;
    });

    slideshowContainer.addEventListener('touchend', function(e) {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    });

    function handleSwipe() {
        if (touchEndX < touchStartX - 50) {
            plusSlides(1); // Swipe left, next slide
        }
        if (touchEndX > touchStartX + 50) {
            plusSlides(-1); // Swipe right, previous slide
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

    // React component
    const { useState, useEffect } = React;

    function InteractiveFeature() {
        const [count, setCount] = useState(0);
        const [message, setMessage] = useState('');

        useEffect(() => {
            const messages = [
                "Discover our comprehensive library resources",
                "Get instant answers to your questions",
                "Connect with our expert library staff",
                "Access digital resources from anywhere",
                "Join our community of lifelong learners"
            ];

            const interval = setInterval(() => {
                setMessage(messages[count % messages.length]);
                setCount(count + 1);
            }, 3000);

            return () => clearInterval(interval);
        }, [count]);

        return (
            <div style={{
                background: "linear-gradient(135deg, rgba(78, 115, 223, 0.9) 0%, rgba(46, 89, 217, 0.9) 100%)",
                borderRadius: "15px",
                padding: "40px",
                color: "#fff",
                boxShadow: "0 10px 30px rgba(0,0,0,0.2)",
                textAlign: "center",
                margin: "0 auto",
                maxWidth: "600px",
                backdropFilter: "blur(10px)"
            }}>
                <h2 style={{marginBottom: "20px", fontSize: "28px"}}>🚀 Interactive Experience</h2>
                <p style={{fontSize: "18px", lineHeight: "1.6", marginBottom: "25px"}}>{message}</p>
                <div style={{display: "flex", justifyContent: "center", gap: "15px"}}>
                    <button
                        style={{
                            background: "rgba(255,255,255,0.2)",
                            border: "1px solid rgba(255,255,255,0.3)",
                            color: "#fff",
                            padding: "10px 20px",
                            borderRadius: "30px",
                            cursor: "pointer",
                            transition: "all 0.3s ease"
                        }}
                        onClick={() => setCount(count + 1)}
                    >
                        Next Message
                    </button>
                    <a
                        href="login.jsp"
                        style={{
                            background: "var(--success-color)",
                            border: "none",
                            color: "#fff",
                            padding: "10px 20px",
                            borderRadius: "30px",
                            cursor: "pointer",
                            transition: "all 0.3s ease",
                            textDecoration: "none",
                            display: "inline-block"
                        }}
                    >
                        Get Started
                    </a>
                </div>
            </div>
        );
    }

    ReactDOM.render(<InteractiveFeature />, document.getElementById('react-root'));
</script>
</body>
</html>