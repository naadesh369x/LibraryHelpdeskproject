package com.example.demo.designpatterns.observer;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/userNotifications")
public class UserNotificationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();

        List<String> notifications = NotificationService.getInstance().getNotifications();

        out.println("<html><head><title>User Notifications</title></head><body>");
        out.println("<h2>📢 Notifications from Admin</h2>");

        if (notifications.isEmpty()) {
            out.println("<p>No notifications yet.</p>");
        } else {
            out.println("<ul>");
            for (String note : notifications) {
                out.println("<li>" + note + "</li>");
            }
            out.println("</ul>");
        }

        out.println("<a href='admin.html'>Back to Admin</a>");
        out.println("</body></html>");
    }
}
