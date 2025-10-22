package com.example.demo.designpatterns.observer;



import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/registerUser")
public class RegisterServletnoti extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");

        if (username == null || username.trim().isEmpty()) {
            resp.getWriter().println(" Username is required!");
            return;
        }

        StudentUser user = new StudentUser(username);
        NotificationService.getInstance().addObserver(user);

        resp.getWriter().println(" User '" + username + "' registered for notifications.");
    }
}
