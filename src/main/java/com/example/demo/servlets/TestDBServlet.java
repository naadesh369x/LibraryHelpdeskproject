package com.example.demo.servlets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/testdb")
public class TestDBServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain");
        try (Connection conn = DBConnection.getConnection()){
            response.getWriter().println(" Database connected successfully!");
            response.getWriter().println("Path: " + getServletContext().getRealPath("/WEB-INF/data/helpdesk.db"));
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}
