package com.streamflix.controller;

import com.streamflix.dao.PaymentDAO;
import com.streamflix.dao.PaymentDAOImpl;
import com.streamflix.model.Payment;
import com.streamflix.model.Subscription;
import com.streamflix.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Servlet for handling payment and subscription operations
 */
public class PaymentServlet extends HttpServlet {

    private PaymentDAO paymentDAO;
    
    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/view";
        }
        
        switch (action) {
            case "/view":
                viewPaymentHistory(request, response);
                break;
            case "/subscription":
                viewSubscription(request, response);
                break;
            case "/plans":
                viewPlans(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/payment/view");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/payment/view");
            return;
        }
        
        switch (action) {
            case "/process":
                processPayment(request, response);
                break;
            case "/subscribe":
                subscribe(request, response);
                break;
            case "/cancel":
                cancelSubscription(request, response);
                break;
            case "/update":
                updatePaymentMethod(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/payment/view");
                break;
        }
    }
    
    /**
     * View payment history
     */
    private void viewPaymentHistory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            List<Payment> payments = paymentDAO.findByUserId(user.getUserId());
            
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/payment-history.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * View current subscription
     */
    private void viewSubscription(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            // This method needs to be implemented in PaymentDAO
            // For now, we'll use a placeholder
            Subscription subscription = null; // paymentDAO.getCurrentSubscription(user.getUserId());
            
            request.setAttribute("subscription", subscription);
            request.getRequestDispatcher("/subscription.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * View available subscription plans
     */
    private void viewPlans(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This method needs to be implemented in PaymentDAO
        // For now, we'll use a placeholder
        List<Subscription> plans = null; // paymentDAO.getAvailablePlans();
        
        request.setAttribute("plans", plans);
        request.getRequestDispatcher("/subscription-plans.jsp").forward(request, response);
    }
    
    /**
     * Process a payment
     */
    private void processPayment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String paymentMethod = request.getParameter("paymentMethod");
            String cardNumber = request.getParameter("cardNumber");
            String expiryDate = request.getParameter("expiryDate");
            String cvv = request.getParameter("cvv");
            double amount = Double.parseDouble(request.getParameter("amount"));
            
            // Create a new Payment object
            Payment payment = new Payment();
            payment.setSubscriptionId(0); // This should be set to the actual subscription ID
            payment.setAmount(amount);
            payment.setPaymentDate(new Date());
            payment.setPaymentMethod(paymentMethod);
            payment.setTransactionId(UUID.randomUUID().toString());
            payment.setStatus("COMPLETED");
            payment.setBillingAddress(request.getParameter("billingAddress"));
            
            // Only store the last 4 digits of the card for security
            if (cardNumber != null && cardNumber.length() >= 4) {
                payment.setCardLastFour(cardNumber.substring(cardNumber.length() - 4));
            }
            
            // Save the payment
            Payment savedPayment = paymentDAO.save(payment);
            boolean success = (savedPayment != null);
            
            if (success) {
                request.setAttribute("payment", savedPayment);
                request.setAttribute("message", "Payment processed successfully");
                request.getRequestDispatcher("/payment-confirmation.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Payment processing failed");
                request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Subscribe to a plan
     */
    private void subscribe(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            int planId = Integer.parseInt(request.getParameter("planId"));
            
            // This method needs to be implemented in PaymentDAO
            // For now, we'll use a placeholder
            boolean success = false; // paymentDAO.subscribe(user.getUserId(), planId);
            
            if (success) {
                request.setAttribute("message", "Subscription successful");
                request.getRequestDispatcher("/subscription-confirmation.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Subscription failed");
                request.getRequestDispatcher("/subscription-plans.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Cancel subscription
     */
    private void cancelSubscription(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            
            // This method needs to be implemented in PaymentDAO
            // For now, we'll use a placeholder
            boolean success = false; // paymentDAO.cancelSubscription(user.getUserId());
            
            if (success) {
                request.setAttribute("message", "Subscription cancelled successfully");
                request.getRequestDispatcher("/subscription-cancelled.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to cancel subscription");
                request.getRequestDispatcher("/subscription.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Update payment method
     */
    private void updatePaymentMethod(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String paymentMethod = request.getParameter("paymentMethod");
            String cardNumber = request.getParameter("cardNumber");
            String expiryDate = request.getParameter("expiryDate");
            String cvv = request.getParameter("cvv");
            
            // This functionality would typically update a user's stored payment method
            // For now, we'll just create a placeholder result
            boolean success = false;
            
            if (success) {
                request.setAttribute("message", "Payment method updated successfully");
                request.getRequestDispatcher("/payment-method-updated.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to update payment method");
                request.getRequestDispatcher("/update-payment-method.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}