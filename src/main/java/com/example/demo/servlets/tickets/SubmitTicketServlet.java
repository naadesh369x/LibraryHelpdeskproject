package com.example.demo.servlets.tickets;

import com.example.demo.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/submitTicket")
public class SubmitTicketServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String username = request.getParameter("username");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String userIdParam = request.getParameter("userId");

        int userId = 0;
        if (userIdParam != null && !userIdParam.isEmpty()) {
            try {
                userId = Integer.parseInt(userIdParam);
            } catch (NumberFormatException e) {
                userId = 0;
            }
        }

        try (Connection conn = DBConnection.getConnection()) {

            // Create tickets table if not exists with foreign key constraint
            String createTableSQL = """
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='tickets' AND xtype='U')
                CREATE TABLE tickets (
                    ticketId INT IDENTITY(1,1) PRIMARY KEY,
                    userId INT NOT NULL,
                    username NVARCHAR(50) NOT NULL,
                    category NVARCHAR(50) NOT NULL,
                    description NVARCHAR(MAX) NOT NULL,
                    email NVARCHAR(100),
                    mobile NVARCHAR(15),
                    status NVARCHAR(20) DEFAULT 'New',
                    created_at DATETIME DEFAULT GETDATE(),
                    CONSTRAINT FK_tickets_members FOREIGN KEY (userId) REFERENCES members(userId)
                )
            """;
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSQL);
            }

            // Validate that userId exists in members table
            if (userId > 0) {
                String validateUserSQL = "SELECT COUNT(*) FROM members WHERE userId = ?";
                try (PreparedStatement validatePs = conn.prepareStatement(validateUserSQL)) {
                    validatePs.setInt(1, userId);
                    try (ResultSet rs = validatePs.executeQuery()) {
                        if (rs.next() && rs.getInt(1) == 0) {
                            request.setAttribute("error", "Invalid user ID. Please select a valid user.");
                            RequestDispatcher dispatcher = request.getRequestDispatcher("submitTicket.jsp");
                            dispatcher.forward(request, response);
                            return;
                        }
                    }
                }
            } else {
                // If userId is 0, try to find user by email
                if (email != null && !email.isEmpty()) {
                    String findUserSQL = "SELECT userId FROM members WHERE email = ?";
                    try (PreparedStatement findPs = conn.prepareStatement(findUserSQL)) {
                        findPs.setString(1, email);
                        try (ResultSet rs = findPs.executeQuery()) {
                            if (rs.next()) {
                                userId = rs.getInt("userId");
                            } else {
                                request.setAttribute("error", "User not found. Please check your email.");
                                RequestDispatcher dispatcher = request.getRequestDispatcher("submitTicket.jsp");
                                dispatcher.forward(request, response);
                                return;
                            }
                        }
                    }
                } else {
                    request.setAttribute("error", "User identification missing. Please provide user ID or email.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("submitTicket.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            }

            // Insert ticket data
            String insertSQL = "INSERT INTO tickets (userId, username, category, description, email, mobile) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
                ps.setInt(1, userId);
                ps.setString(2, username);
                ps.setString(3, category);
                ps.setString(4, description);
                ps.setString(5, email);
                ps.setString(6, mobile);

                ps.executeUpdate();
            }

            // Set success message and redirect
            HttpSession session = request.getSession();
            session.setAttribute("ticketSuccess", "Ticket submitted successfully!");
            response.sendRedirect("myTickets.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error submitting ticket: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("submitTicket.jsp");
            dispatcher.forward(request, response);
        }
    }
}