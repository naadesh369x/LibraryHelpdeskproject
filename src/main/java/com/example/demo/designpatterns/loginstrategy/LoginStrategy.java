package com.example.demo.designpatterns.loginstrategy;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public interface LoginStrategy {
    void login(HttpServletRequest request, HttpServletResponse response) throws IOException;
}
