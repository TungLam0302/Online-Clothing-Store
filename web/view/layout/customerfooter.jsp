<%-- 
    Document   : customerfooter
    Created on : Jul 9, 2025, 10:15:00 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Footer -->
<footer class="footer bg-dark text-white pt-5 pb-3">
    <div class="container">
        <div class="row">
            <!-- Company Info -->
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase mb-4">Clother Online</h5>
                <p>Your one-stop destination for trendy fashion and clothing. We bring you the latest styles at affordable prices.</p>
                <div class="mt-3">
                    <a href="#" class="text-white me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-white"><i class="fab fa-pinterest"></i></a>
                </div>
            </div>
            
            <!-- Quick Links -->
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase mb-4">Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/home" class="footer-link">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/product" class="footer-link">Shop All</a></li>
                    <li><a href="#" class="footer-link">New Arrivals</a></li>
                    <li><a href="#" class="footer-link">Featured Products</a></li>
                    <li><a href="#" class="footer-link">Sale Items</a></li>
                </ul>
            </div>
            
            <!-- Customer Service -->
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase mb-4">Customer Service</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="footer-link">Contact Us</a></li>
                    <li><a href="#" class="footer-link">FAQs</a></li>
                    <li><a href="#" class="footer-link">Shipping & Returns</a></li>
                    <li><a href="#" class="footer-link">Size Guide</a></li>
                    <li><a href="#" class="footer-link">Track Order</a></li>
                </ul>
            </div>
            
            <!-- Newsletter -->
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase mb-4">Newsletter</h5>
                <p>Subscribe to our newsletter for exclusive updates and offers.</p>
                <div class="input-group mb-3">
                    <input type="email" class="form-control" placeholder="Your Email" aria-label="Your Email">
                    <button class="btn btn-primary" type="button">Subscribe</button>
                </div>
                <p class="small text-muted">By subscribing, you agree to our Privacy Policy.</p>
            </div>
        </div>
        
        <hr class="my-4 bg-light">
        
        <!-- Bottom Footer -->
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start">
                <p class="mb-0">&copy; 2025 Clother Online. All rights reserved.</p>
            </div>
            <div class="col-md-6 text-center text-md-end mt-3 mt-md-0">
                <img src="https://via.placeholder.com/40x25" alt="Visa" class="payment-icon">
                <img src="https://via.placeholder.com/40x25" alt="MasterCard" class="payment-icon">
                <img src="https://via.placeholder.com/40x25" alt="PayPal" class="payment-icon">
                <img src="https://via.placeholder.com/40x25" alt="American Express" class="payment-icon">
            </div>
        </div>
    </div>
</footer>

<style>
    .footer {
        margin-top: 50px;
    }
    
    .footer h5 {
        font-weight: 600;
        position: relative;
        padding-bottom: 10px;
    }
    
    .footer h5::after {
        content: '';
        position: absolute;
        left: 0;
        bottom: 0;
        width: 40px;
        height: 2px;
        background-color: #4e73df;
    }
    
    .footer-link {
        color: #adb5bd;
        text-decoration: none;
        display: block;
        margin-bottom: 8px;
        transition: color 0.3s;
    }
    
    .footer-link:hover {
        color: #fff;
    }
    
    .payment-icon {
        margin-left: 5px;
        height: 25px;
        width: auto;
    }
</style>
