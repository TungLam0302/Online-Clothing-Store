<%-- 
    Document   : checkout
    Created on : Jul 10, 2025, 4:57:25 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Checkout - ClotherOnline</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f8f9fa;
                color: #333;
            }
            
            .checkout-container {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
                padding: 30px;
                margin-top: 30px;
                margin-bottom: 30px;
            }
            
            .checkout-header {
                border-bottom: 2px solid #e9ecef;
                padding-bottom: 15px;
                margin-bottom: 20px;
            }
            
            .checkout-header h2 {
                font-weight: 600;
                color: #333;
            }
            
            .section-title {
                font-weight: 600;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 1px solid #e9ecef;
            }
            
            .product-image {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 5px;
            }
            
            .checkout-item {
                padding: 15px 0;
                border-bottom: 1px solid #eee;
            }
            
            .checkout-item:last-child {
                border-bottom: none;
            }
            
            .customer-info {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
            }
            
            .customer-info p {
                margin-bottom: 10px;
            }
            
            .customer-info strong {
                display: inline-block;
                width: 100px;
            }
            
            .order-summary {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 20px;
                position: sticky;
                top: 20px;
            }
            
            .order-summary h4 {
                font-weight: 600;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 1px solid #dee2e6;
            }
            
            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                font-size: 0.95rem;
            }
            
            .summary-total {
                font-weight: 600;
                font-size: 1.1rem;
                border-top: 1px solid #dee2e6;
                padding-top: 15px;
                margin-top: 15px;
            }
            
            .btn-place-order {
                background-color: #4e73df;
                border-color: #4e73df;
                color: white;
                font-weight: 600;
                padding: 14px 0;
                margin-top: 20px;
                transition: all 0.3s;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .btn-place-order:hover {
                background-color: #3756a4;
                border-color: #3756a4;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(78, 115, 223, 0.3);
            }
            
            .btn-place-order:active {
                transform: translateY(0);
            }
            
            .btn-back-to-cart {
                background-color: #ffffff;
                border: 2px solid #4e73df;
                color: #4e73df;
                font-weight: 600;
                padding: 12px 0;
                margin-top: 15px;
                transition: all 0.3s;
            }
            
            .btn-back-to-cart:hover {
                background-color: #eef1ff;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(78, 115, 223, 0.2);
            }
            
            .breadcrumb-section {
                background-color: #f1f3f9;
                padding: 15px 0;
                margin-bottom: 30px;
            }
            
            .shipping-address {
                margin-top: 20px;
            }
            
            /* Order success modal */
            .success-icon {
                font-size: 5rem;
                color: #28a745;
                margin-bottom: 20px;
            }
            
            .modal-content {
                border-radius: 15px;
                border: none;
            }
            
            .modal-header {
                border-bottom: none;
                padding-bottom: 0;
            }
            
            .modal-body {
                text-align: center;
                padding: 30px;
            }
            
            .modal-footer {
                border-top: none;
                justify-content: center;
            }
            
            .btn-continue-shopping {
                background-color: #4e73df;
                color: white;
                font-weight: 500;
                border-radius: 5px;
                padding: 10px 20px;
                transition: all 0.3s;
            }
            
            .btn-continue-shopping:hover {
                background-color: #3756a4;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(78, 115, 223, 0.3);
            }
        </style>
    </head>
    <body>
        <!-- Check if user is logged in, redirect to login if not -->
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="/login" />
        </c:if>
        
        <!-- Include Header -->
        <jsp:include page="../layout/customerheader.jsp"/>
        
        <!-- Breadcrumb Section -->
        <section class="breadcrumb-section">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart">Shopping Cart</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Checkout</li>
                    </ol>
                </nav>
            </div>
        </section>
        
        <!-- Checkout Content -->
        <div class="container checkout-container">
            <div class="checkout-header">
                <h2>Checkout</h2>
            </div>
            
            <!-- Error message display -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show my-3" role="alert">
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <div class="row">
                <!-- Checkout Details -->
                <div class="col-lg-8">
                    <!-- Customer Information Section -->
                    <h3 class="section-title">Customer Information</h3>
                    <div class="customer-info">
                        <p><strong>Name:</strong> ${sessionScope.user.name}</p>
                        <p><strong>Email:</strong> ${sessionScope.user.email}</p>
                        <p><strong>Phone:</strong> ${sessionScope.user.phone}</p>
                        <p><strong>Address:</strong> ${sessionScope.user.address}</p>
                    </div>
                    
                    <!-- Shipping Address Section (allow customer to input different shipping address) -->
                    <h3 class="section-title">Shipping Address</h3>
                    <div class="shipping-address">
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="useDefaultAddress" checked>
                            <label class="form-check-label" for="useDefaultAddress">
                                Use my default address
                            </label>
                        </div>
                        <div class="form-floating mb-3 mt-3" id="shippingAddressField" style="display: none;">
                            <textarea class="form-control" id="shippingAddress" style="height: 100px;">${sessionScope.user.address}</textarea>
                            <label for="shippingAddress">Shipping Address</label>
                        </div>
                    </div>
                    
                    <!-- Order Items Section -->
                    <h3 class="section-title mt-4">Order Items</h3>
                    <div class="checkout-items">
                        <c:forEach var="item" items="${selectedItems}">
                            <div class="checkout-item row align-items-center">
                                <div class="col-auto">
                                    <img src="${pageContext.request.contextPath}/${item.productItem.product.thumbnail}" 
                                         alt="${item.productItem.product.productName}" 
                                         class="product-image"
                                         onerror="this.src='${pageContext.request.contextPath}/images/5b428783-f455-46b8-892d-ff862928bb54.jpg'">
                                </div>
                                <div class="col">
                                    <h5 class="mb-1">${item.productItem.product.productName}</h5>
                                    <p class="text-muted small mb-1">Size: ${item.productItem.size.sizeName}</p>
                                    <p class="text-muted small mb-0">Price: $${item.productItem.product.price}</p>
                                </div>
                                <div class="col-auto">
                                    <span class="badge bg-secondary">Qty: ${item.quantity}</span>
                                </div>
                                <div class="col-2 text-end">
                                    <p class="fw-bold mb-0">$${item.quantity * Double.parseDouble(item.productItem.product.price)}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Order Summary -->
                <div class="col-lg-4">
                    <div class="order-summary">
                        <h4>Order Summary</h4>
                        <div class="summary-item">
                            <span>Total Items</span>
                            <span>${selectedItems.size()}</span>
                        </div>
                        <div class="summary-item">
                            <span>Subtotal</span>
                            <span>$<fmt:formatNumber value="${orderTotal}" pattern="#0.00" /></span>
                        </div>
                        <div class="summary-item">
                            <span>Shipping</span>
                            <span>Free</span>
                        </div>
                        <div class="summary-total">
                            <span>Total</span>
                            <span>$<fmt:formatNumber value="${orderTotal}" pattern="#0.00" /></span>
                        </div>
                        <button class="btn btn-place-order w-100 btn-lg shadow-sm" id="placeOrderBtn">
                            <i class="fas fa-check-circle me-2"></i> Place Order
                        </button>
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-back-to-cart w-100 mt-3">
                            <i class="fas fa-arrow-left me-2"></i> Back to Cart
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Order Success Modal -->
        <div class="modal fade" id="orderSuccessModal" tabindex="-1" aria-labelledby="orderSuccessModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <i class="fas fa-check-circle success-icon"></i>
                        <h3 class="mb-4">Order Placed Successfully!</h3>
                        <p class="text-muted mb-1">Your order has been placed successfully.</p>
                        <p class="text-muted mb-4">Order ID: <span id="orderId"></span></p>
                    </div>
                    <div class="modal-footer">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-continue-shopping">
                            Continue Shopping
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Include Footer -->
        <jsp:include page="../layout/customerfooter.jsp"/>
        
        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        
        <!-- Checkout Functionality -->
        <script>
            $(document).ready(function() {
                // Handle shipping address toggle
                $('#useDefaultAddress').on('change', function() {
                    if ($(this).is(':checked')) {
                        $('#shippingAddressField').slideUp();
                    } else {
                        $('#shippingAddressField').slideDown();
                    }
                });
                
                // Place order button
                $('#placeOrderBtn').on('click', function() {
                    const shippingAddress = $('#useDefaultAddress').is(':checked') 
                        ? '${sessionScope.user.address}' 
                        : $('#shippingAddress').val();
                        
                    if (!shippingAddress.trim()) {
                        alert('Please enter a valid shipping address');
                        return;
                    }
                    
                    // Show loading state
                    const $btn = $(this);
                    const originalText = $btn.html();
                    $btn.html('<i class="fas fa-spinner fa-spin me-2"></i> Processing...');
                    $btn.prop('disabled', true);
                    
                    // Send AJAX request to place order
                    $.ajax({
                        url: '${pageContext.request.contextPath}/placeorder',
                        type: 'POST',
                        data: {
                            selectedItems: '${selectedItemIds}',
                            shippingAddress: shippingAddress,
                            orderTotal: '${orderTotal}'
                        },
                        dataType: 'json',
                        success: function(response) {
                            // Reset button
                            $btn.html(originalText);
                            $btn.prop('disabled', false);
                            
                            if (response.success) {
                                // Show success modal
                                $('#orderId').text(response.orderId);
                                const modal = new bootstrap.Modal(document.getElementById('orderSuccessModal'));
                                modal.show();
                                
                                // Update header cart count (if needed)
                                updateHeaderCartCount();
                            } else {
                                alert(response.message || "Failed to place order");
                            }
                        },
                        error: function() {
                            // Reset button
                            $btn.html(originalText);
                            $btn.prop('disabled', false);
                            
                            alert("Error connecting to server");
                        }
                    });
                });
                
                // Function to update the cart count in the header (optional)
                function updateHeaderCartCount() {
                    // This is just an optional function, we may update it if needed
                    // Or it can be implemented by reloading the header
                }
                
                // Auto redirect after successful order (optional)
                $('#orderSuccessModal').on('hidden.bs.modal', function () {
                    window.location.href = '${pageContext.request.contextPath}/home';
                });
            });
        </script>
    </body>
</html>
