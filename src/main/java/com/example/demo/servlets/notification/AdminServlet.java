package com.example.demo.servlets.notification;



import com.example.demo.designpatterns.observer.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String message = req.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            resp.getWriter().println("❌ Please enter a message.");
            return;
        }

        NotificationService.getInstance().notifyAllUsers("Admin: " + message);
        resp.getWriter().println("✅ Message sent to all registered users.");
    }
}
