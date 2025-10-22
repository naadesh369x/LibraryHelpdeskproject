<%@ page import="com.example.demo.designpatterns.observer.NotificationService" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Get all notifications from the service
    NotificationService service = NotificationService.getInstance();
    List<String> notifications = service.getNotifications();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Notifications</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4F46E5;
            --primary-hover: #4338CA;
            --secondary-color: #F3F4F6;
            --text-primary: #1F2937;
            --text-secondary: #6B7280;
            --border-color: #E5E7EB;
            --success-color: #10B981;
            --warning-color: #F59E0B;
            --danger-color: #EF4444;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--text-primary);
            line-height: 1.6;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .notification-card {
            background: white;
            border-radius: 16px;
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-color), #6366F1);
            padding: 24px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-title {
            color: white;
            font-size: 24px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-title i {
            font-size: 28px;
        }

        .notification-count {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
        }

        .card-body {
            padding: 30px;
        }

        .notification-list {
            list-style: none;
        }

        .notification-item {
            display: flex;
            align-items: flex-start;
            padding: 16px 20px;
            margin-bottom: 12px;
            background: var(--secondary-color);
            border-radius: 12px;
            border-left: 4px solid var(--primary-color);
            transition: all 0.3s ease;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateX(-10px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .notification-item:hover {
            transform: translateX(5px);
            box-shadow: var(--shadow-md);
            background: #F9FAFB;
        }

        .notification-icon {
            margin-right: 16px;
            width: 40px;
            height: 40px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            flex-shrink: 0;
        }

        .notification-content {
            flex: 1;
        }

        .notification-message {
            font-size: 16px;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .notification-time {
            font-size: 13px;
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-secondary);
        }

        .empty-icon {
            font-size: 64px;
            color: #D1D5DB;
            margin-bottom: 16px;
        }

        .empty-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-primary);
        }

        .empty-description {
            font-size: 16px;
            max-width: 400px;
            margin: 0 auto;
        }

        .card-footer {
            padding: 20px 30px;
            background: var(--secondary-color);
            display: flex;
            justify-content: center;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .btn:active {
            transform: translateY(0);
        }

        .filter-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 12px;
        }

        .filter-tab {
            padding: 8px 16px;
            background: transparent;
            border: none;
            border-radius: 8px 8px 0 0;
            font-size: 14px;
            font-weight: 500;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .filter-tab.active {
            background: white;
            color: var(--primary-color);
            box-shadow: var(--shadow-sm);
        }

        .filter-tab:hover:not(.active) {
            color: var(--text-primary);
        }

        @media (max-width: 640px) {
            .container {
                padding: 20px 15px;
            }

            .card-header {
                padding: 20px;
            }

            .card-title {
                font-size: 20px;
            }

            .card-body {
                padding: 20px;
            }

            .notification-item {
                padding: 14px 16px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="notification-card">
        <div class="card-header">
            <h2 class="card-title">
                <i class="fas fa-bell"></i>
                Notifications
            </h2>
            <div class="notification-count">
                <%= notifications != null ? notifications.size() : 0 %> messages
            </div>
        </div>

        <div class="card-body">
            <div class="filter-tabs">
                <button class="filter-tab active">All</button>
                <button class="filter-tab">Unread</button>
                <button class="filter-tab">Important</button>
            </div>

            <%
                if (notifications == null || notifications.isEmpty()) {
            %>
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-inbox"></i>
                </div>
                <div class="empty-title">No notifications yet</div>
                <div class="empty-description">
                    You're all caught up! We'll notify you when there's something new.
                </div>
            </div>
            <%
            } else {
            %>
            <ul class="notification-list">
                <% for (String message : notifications) { %>
                <li class="notification-item">
                    <div class="notification-icon">
                        <i class="fas fa-info-circle"></i>
                    </div>
                    <div class="notification-content">
                        <div class="notification-message"><%= message %></div>
                        <div class="notification-time">
                            <i class="far fa-clock"></i>
                            Just now
                        </div>
                    </div>
                </li>
                <% } %>
            </ul>
            <%
                }
            %>
        </div>

        <div class="card-footer">
            <a href="dashboard.jsp" class="btn">
                <i class="fas fa-arrow-left"></i>
                Back to dashboard
            </a>
        </div>
    </div>
</div>

<script>
    // Add interactive functionality for filter tabs
    document.addEventListener('DOMContentLoaded', function() {
        const filterTabs = document.querySelectorAll('.filter-tab');

        filterTabs.forEach(tab => {
            tab.addEventListener('click', function() {
                // Remove active class from all tabs
                filterTabs.forEach(t => t.classList.remove('active'));
                // Add active class to clicked tab
                this.classList.add('active');

                // In a real application, you would filter the notifications here
                // For demo purposes, we're just updating the UI
            });
        });

        // Add click animation to notification items
        const notificationItems = document.querySelectorAll('.notification-item');
        notificationItems.forEach(item => {
            item.addEventListener('click', function() {
                this.style.animation = 'none';
                setTimeout(() => {
                    this.style.animation = 'pulse 0.3s ease';
                }, 10);
            });
        });
    });

    // Add pulse animation
    const style = document.createElement('style');
    style.textContent = `
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(0.98); }
            100% { transform: scale(1); }
        }
    `;
    document.head.appendChild(style);
</script>
</body>
</html>