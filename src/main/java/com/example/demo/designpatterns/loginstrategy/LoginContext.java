package com.example.demo.designpatterns.loginstrategy;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class LoginContext {
    private LoginStrategy strategy;

    public void setStrategy(LoginStrategy strategy) {
        this.strategy = strategy;
    }

    public void executeStrategy(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (strategy != null) {
            strategy.login(request, response);
        } else {
            response.sendRedirect("login.jsp?error=No+Login+Strategy+Selected");
        }
    }
}
