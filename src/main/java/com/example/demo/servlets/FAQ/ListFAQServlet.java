package com.example.demo.servlets.FAQ;



import com.example.demo.models.FAQ;
import com.example.demo.service.FAQService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

public class ListFAQServlet extends HttpServlet {
    private FAQService faqService = new FAQService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<FAQ> faqs = faqService.getAllFAQs();
        request.setAttribute("faqList", faqs);
        RequestDispatcher rd = request.getRequestDispatcher("faq.jsp");
        rd.forward(request, response);
    }
}
