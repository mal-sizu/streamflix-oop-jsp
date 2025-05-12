<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing & Payment - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/billing.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">Billing & Payment</h1>
            
            <div class="billing-container">
                <div class="billing-sidebar">
                    <ul class="billing-nav">
                        <li class="active"><a href="#payment-methods">Payment Methods</a></li>
                        <li><a href="#billing-history">Billing History</a></li>
                        <li><a href="#subscription-details">Subscription Details</a></li>
                    </ul>
                </div>
                
                <div class="billing-content">
                    <section id="payment-methods" class="billing-section">
                        <h2>Payment Methods</h2>
                        
                        <c:if test="${empty paymentMethods}">
                            <div class="empty-state">
                                <p>You don't have any payment methods saved.</p>
                                <button class="btn btn-primary" id="addPaymentBtn">Add Payment Method</button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty paymentMethods}">
                            <div class="payment-methods-list">
                                <c:forEach var="method" items="${paymentMethods}">
                                    <div class="payment-method-card ${method.isDefault ? 'default' : ''}">
                                        <div class="payment-method-info">
                                            <div class="payment-method-type">
                                                <c:choose>
                                                    <c:when test="${method.type eq 'CREDIT_CARD'}">
                                                        <i class="fas fa-credit-card"></i>
                                                    </c:when>
                                                    <c:when test="${method.type eq 'PAYPAL'}">
                                                        <i class="fab fa-paypal"></i>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                            
                                            <div class="payment-method-details">
                                                <h3>${method.name}</h3>
                                                <p>${method.maskedNumber}</p>
                                                <p>Expires: ${method.expiryMonth}/${method.expiryYear}</p>
                                                
                                                <c:if test="${method.isDefault}">
                                                    <span class="default-badge">Default</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <div class="payment-method-actions">
                                            <button class="btn btn-sm btn-edit" onclick="editPaymentMethod(${method.id})">Edit</button>
                                            <c:if test="${not method.isDefault}">
                                                <button class="btn btn-sm btn-default" onclick="setDefaultPaymentMethod(${method.id})">Set as Default</button>
                                            </c:if>
                                            <button class="btn btn-sm btn-delete" onclick="deletePaymentMethod(${method.id})">Delete</button>
                                        </div>
                                    </div>
                                </c:forEach>
                                
                                <button class="btn btn-primary" id="addPaymentBtn">Add Payment Method</button>
                            </div>
                        </c:if>
                    </section>
                    
                    <section id="billing-history" class="billing-section">
                        <h2>Billing History</h2>
                        
                        <c:if test="${empty billingHistory}">
                            <div class="empty-state">
                                <p>No billing history available.</p>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty billingHistory}">
                            <div class="billing-history-table">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Description</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th>Invoice</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="transaction" items="${billingHistory}">
                                            <tr>
                                                <td><fmt:formatDate value="${transaction.date}" pattern="MMM dd, yyyy" /></td>
                                                <td>${transaction.description}</td>
                                                <td>$${transaction.amount}</td>
                                                <td>
                                                    <span class="status-badge status-${transaction.status.toLowerCase()}">
                                                        ${transaction.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/payment/invoice?id=${transaction.id}" class="btn btn-sm btn-invoice">
                                                        <i class="fas fa-file-invoice"></i> View
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </section>
                    
                    <section id="subscription-details" class="billing-section">
                        <h2>Subscription Details</h2>
                        
                        <div class="subscription-info">
                            <div class="subscription-plan">
                                <h3>Current Plan: ${subscription.planName}</h3>
                                <p class="subscription-price">$${subscription.price} / ${subscription.billingCycle}</p>
                                <p>Next billing date: <fmt:formatDate value="${subscription.nextBillingDate}" pattern="MMMM dd, yyyy" /></p>
                                
                                <div class="subscription-actions">
                                    <a href="${pageContext.request.contextPath}/subscription.jsp" class="btn btn-secondary">Change Plan</a>
                                    <button class="btn btn-danger" onclick="cancelSubscription()">Cancel Subscription</button>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Add Payment Method Modal -->
    <div id="paymentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Add Payment Method</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <form id="paymentForm" action="${pageContext.request.contextPath}/payment/add" method="post">
                    <div class="form-group">
                        <label for="paymentType">Payment Type</label>
                        <select id="paymentType" name="paymentType" class="form-control">
                            <option value="CREDIT_CARD">Credit Card</option>
                            <option value="PAYPAL">PayPal</option>
                        </select>
                    </div>
                    
                    <div id="creditCardFields">
                        <div class="form-group">
                            <label for="cardName">Name on Card</label>
                            <input type="text" id="cardName" name="cardName" class="form-control">
                        </div>
                        
                        <div class="form-group">
                            <label for="cardNumber">Card Number</label>
                            <input type="text" id="cardNumber" name="cardNumber" class="form-control">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="expiryDate">Expiry Date</label>
                                <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" class="form-control">
                            </div>
                            
                            <div class="form-group col-6">
                                <label for="cvv">CVV</label>
                                <input type="text" id="cvv" name="cvv" class="form-control">
                            </div>
                        </div>
                    </div>
                    
                    <div id="paypalFields" style="display: none;">
                        <div class="form-group">
                            <label for="paypalEmail">PayPal Email</label>
                            <input type="email" id="paypalEmail" name="paypalEmail" class="form-control">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="setDefault" checked> Set as default payment method
                        </label>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Save Payment Method</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/billing.js"></script>
</body>
</html>