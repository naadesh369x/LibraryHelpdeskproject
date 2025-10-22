package com.example.demo.servlets;

import com.example.demo.designpatterns.loginstrategy.AdminLoginStrategy;
import com.example.demo.designpatterns.loginstrategy.LoginContext;
import com.example.demo.designpatterns.loginstrategy.StaffLoginStrategy;
import com.example.demo.designpatterns.loginstrategy.StudentLoginStrategy;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/LoginServletmulti")
public class LoginServletmulti extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        LoginContext context = new LoginContext();

        switch (role.toLowerCase()) {
            case "admin" -> context.setStrategy(new AdminLoginStrategy());
            case "staff" -> context.setStrategy(new StaffLoginStrategy());
            case "student" -> context.setStrategy(new StudentLoginStrategy());
            default -> {
                response.sendRedirect("login.jsp?error=Invalid+role");
                return;
            }
        }

        context.executeStrategy(request, response);
    }
}
