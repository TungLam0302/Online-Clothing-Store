<%-- 
    Document   : cart
    Created on : Jul 10, 2025, 3:50:19 PM
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
        <title>Shopping Cart - ClotherOnline</title>
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
            
            .cart-container {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
                padding: 30px;
                margin-top: 30px;
                margin-bottom: 30px;
            }
            
            .cart-header {
                border-bottom: 2px solid #e9ecef;
                padding-bottom: 15px;
                margin-bottom: 20px;
            }
            
            .cart-header h2 {
                font-weight: 600;
                color: #333;
            }
            
            .cart-item {
                border-bottom: 1px solid #eee;
                padding: 20px 0;
                position: relative;
            }
            
            .cart-item:last-child {
                border-bottom: none;
            }
            
            .product-image {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 5px;
            }
            
            .product-info h5 {
                font-weight: 600;
                margin-bottom: 8px;
                font-size: 1.1rem;
            }
            
            .product-info .text-muted {
                font-size: 0.9rem;
            }
            
            .product-price {
                font-weight: 600;
                color: #4e73df;
                font-size: 1.1rem;
            }
            
            .quantity-control {
                display: flex;
                align-items: center;
                border: 1px solid #dee2e6;
                border-radius: 5px;
                overflow: hidden;
                width: fit-content;
            }
            
            .quantity-control button {
                background-color: #f8f9fa;
                border: none;
                width: 30px;
                height: 30px;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            
            .quantity-control button:hover {
                background-color: #e9ecef;
            }
            
            .quantity-control input {
                width: 50px;
                text-align: center;
                border: none;
                border-left: 1px solid #dee2e6;
                border-right: 1px solid #dee2e6;
                font-weight: 500;
            }
            
            .cart-summary {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 20px;
                position: sticky;
                top: 20px;
            }
            
            .cart-summary h4 {
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
            
            .btn-checkout {
                background-color: #4e73df;
                border-color: #4e73df;
                color: white;
                font-weight: 600;
                padding: 14px 0;
                margin-top: 20px;
                transition: all 0.3s;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                position: relative;
                overflow: hidden;
            }
            
            .btn-checkout:hover {
                background-color: #3756a4;
                border-color: #3756a4;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(78, 115, 223, 0.3);
            }
            
            .btn-checkout:active {
                transform: translateY(0);
            }
            
            .btn-checkout:disabled {
                background-color: #a9b6dd;
                border-color: #a9b6dd;
                transform: none;
                box-shadow: none;
            }
            
            .btn-continue {
                background-color: #ffffff;
                border: 2px solid #4e73df;
                color: #4e73df;
                font-weight: 600;
                padding: 12px 0;
                margin-top: 15px;
                transition: all 0.3s;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .btn-continue:hover {
                background-color: #eef1ff;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(78, 115, 223, 0.2);
            }
            
            .btn-continue:active {
                transform: translateY(0);
            }
            
            .empty-cart {
                text-align: center;
                padding: 40px 0;
            }
            
            .empty-cart i {
                font-size: 5rem;
                color: #dee2e6;
                margin-bottom: 20px;
            }
            
            .breadcrumb-section {
                background-color: #f1f3f9;
                padding: 15px 0;
                margin-bottom: 30px;
            }
            
            .remove-item {
                color: #dc3545;
                cursor: pointer;
                font-size: 0.9rem;
                display: inline-block;
                margin-top: 10px;
            }
            
            .remove-item:hover {
                text-decoration: underline;
            }
            
            .form-check-input {
                width: 20px;
                height: 20px;
                margin-top: 40px;
                cursor: pointer;
            }
            
            /* Animation for quantity changes */
            .price-update {
                animation: flash 1s;
            }
            
            @keyframes flash {
                0% { background-color: #ffee99; }
                100% { background-color: transparent; }
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
                        <li class="breadcrumb-item active" aria-current="page">Shopping Cart</li>
                    </ol>
                </nav>
            </div>
        </section>
        
        <!-- Cart Content -->
        <div class="container cart-container">
            <div class="cart-header d-flex justify-content-between align-items-center">
                <h2>Your Shopping Cart</h2>
                
            </div>
            
            <!-- Error message display -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show my-3" role="alert">
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:choose>
                <c:when test="${not empty cartItems}">
                    <div class="row">
                        <!-- Cart Items -->
                        <div class="col-lg-8">
                            <div class="cart-items">
                                <!-- Select All Checkbox -->
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="selectAll">
                                        <label class="form-check-label ms-2" for="selectAll">Select All Items</label>
                                    </div>
                                    <span class="text-muted small">* Changes are saved automatically</span>
                                </div>
                                
                                <!-- Cart Item List -->
                                <c:forEach var="item" items="${cartItems}">
                                    <div class="cart-item row">
                                        <div class="col-auto">
                                            <div class="form-check">
                                                <input type="checkbox" class="form-check-input item-checkbox" 
                                                       data-id="${item.cartID}" data-price="${item.productItem.product.price}"
                                                       ${item.productItem.stockQuantity <= 0 ? 'disabled' : ''}>
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <img src="${pageContext.request.contextPath}/${item.productItem.product.thumbnail}" 
                                                 alt="${item.productItem.product.productName}" 
                                                 class="product-image"
                                                 onerror="this.src='${pageContext.request.contextPath}/images/5b428783-f455-46b8-892d-ff862928bb54.jpg'">
                                        </div>
                                        <div class="col product-info">
                                            <h5>${item.productItem.product.productName}</h5>
                                            <p class="text-muted">Size: ${item.productItem.size.sizeName}</p>
                                            <p class="product-price">$${item.productItem.product.price}</p>
                                            <div class="mt-2 d-flex align-items-center">
                                                <div class="quantity-control">
                                                    <button type="button" class="decrease-btn" data-id="${item.cartID}">-</button>
                                                    <input type="text" class="quantity-input" value="${item.quantity}" 
                                                           min="1" max="${item.productItem.stockQuantity}" data-id="${item.cartID}" readonly>
                                                    <button type="button" class="increase-btn" data-id="${item.cartID}" 
                                                           data-max="${item.productItem.stockQuantity}">+</button>
                                                </div>
                                                <span class="text-muted ms-3 small">
                                                    <c:choose>
                                                        <c:when test="${item.productItem.stockQuantity <= 0}">
                                                            <span class="text-danger fw-bold">Hết hàng</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${item.productItem.stockQuantity} items available
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <a class="remove-item" data-id="${item.cartID}">
                                                <i class="fas fa-trash-alt me-1"></i>Remove
                                            </a>
                                        </div>
                                        <div class="col-md-2 text-end">
                                            <div class="item-total mt-2" data-id="${item.cartID}">
                                                Total: $<span>${item.quantity * item.productItem.product.price}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        
                        <!-- Cart Summary -->
                        <div class="col-lg-4">
                            <div class="cart-summary">
                                <h4>Order Summary</h4>
                                <div class="summary-item">
                                    <span>Selected Items</span>
                                    <span id="selectedCount">0</span>
                                </div>
                                <div class="summary-item">
                                    <span>Subtotal</span>
                                    <span id="subtotal">$0.00</span>
                                </div>
                                <div class="summary-item">
                                    <span>Shipping</span>
                                    <span>Free</span>
                                </div>
                                <div class="summary-total">
                                    <span>Total</span>
                                    <span id="total">$0.00</span>
                                </div>
                                <button class="btn btn-checkout w-100 btn-lg shadow-sm" id="checkoutBtn" disabled>
                                    <i class="fas fa-lock me-2"></i> Proceed to Checkout
                                </button>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-continue w-100 mt-3 btn-lg shadow-sm">
                                    <i class="fas fa-arrow-left me-2"></i> Continue Shopping
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Empty Cart -->
                    <div class="empty-cart">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>Your cart is empty</h3>
                        <p class="text-muted mb-4">Looks like you haven't added any products to your cart yet.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg shadow-sm">
                            <i class="fas fa-shopping-bag me-2"></i>Start Shopping
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Include Footer -->
        <jsp:include page="../layout/customerfooter.jsp"/>
        
        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        
        <!-- Cart Functionality -->
        <script>
            $(document).ready(function() {
                // Initialize cart totals
                updateCartTotals();
                
                // Select All checkbox
                $("#selectAll").on('change', function() {
                    let isChecked = $(this).prop('checked');
                    $('.item-checkbox:not(:disabled)').prop('checked', isChecked);
                    updateCartTotals();
                    
                    // Enable/disable checkout button
                    $('#checkoutBtn').prop('disabled', !isChecked && $('.item-checkbox:checked').length === 0);
                });
                
                // Individual checkboxes
                $(document).on('change', '.item-checkbox', function() {
                    updateCartTotals();
                    
                    // Update "Select All" state - only consider non-disabled checkboxes
                    let allEnabled = $('.item-checkbox:not(:disabled)').length;
                    let allChecked = $('.item-checkbox:checked').length;
                    $('#selectAll').prop('checked', allEnabled > 0 && allChecked === allEnabled);
                    
                    // Enable/disable checkout button
                    $('#checkoutBtn').prop('disabled', $('.item-checkbox:checked').length === 0);
                });
                
                // Quantity decrease button
                $(document).on('click', '.decrease-btn', function() {
                    const cartId = $(this).data('id');
                    const inputField = $(this).next('.quantity-input');
                    let currentValue = parseInt(inputField.val());
                    
                    if (currentValue > 1) {
                        currentValue -= 1;
                        inputField.val(currentValue);
                        updateCartItemQuantity(cartId, currentValue);
                    }
                });
                
                // Quantity increase button
                $(document).on('click', '.increase-btn', function() {
                    const cartId = $(this).data('id');
                    const maxStock = $(this).data('max');
                    const inputField = $(this).prev('.quantity-input');
                    let currentValue = parseInt(inputField.val());
                    
                    if (currentValue < maxStock) {
                        currentValue += 1;
                        inputField.val(currentValue);
                        updateCartItemQuantity(cartId, currentValue);
                    } else {
                        alert("Sorry, only " + maxStock + " items available in stock.");
                    }
                });
                
                // Remove item
                $(document).on('click', '.remove-item', function() {
                    const cartId = $(this).data('id');
                    if (confirm("Are you sure you want to remove this item from your cart?")) {
                        removeCartItem(cartId);
                    }
                });
                
                // Clear cart functionality removed as requested
                
                // Function to update cart totals
                function updateCartTotals() {
                    let selectedCount = 0;
                    let subtotal = 0;
                    
                    $('.item-checkbox:checked').each(function() {
                        const cartId = $(this).data('id');
                        const quantity = parseInt($('.quantity-input[data-id="' + cartId + '"]').val());
                        const price = parseFloat($(this).data('price'));
                        
                        selectedCount += quantity;
                        subtotal += price * quantity;
                    });
                    
                    $('#selectedCount').text(selectedCount);
                    $('#subtotal').text('$' + subtotal.toFixed(2));
                    $('#total').text('$' + subtotal.toFixed(2));
                    
                    // Enable/disable checkout button
                    $('#checkoutBtn').prop('disabled', selectedCount === 0);
                }
                
                // Function to update cart item quantity
                function updateCartItemQuantity(cartId, quantity) {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/cart/update',
                        type: 'POST',
                        data: {
                            cartId: cartId,
                            quantity: quantity
                        },
                        dataType: 'json',
                        success: function(response) {
                            if (response.success) {
                                // Update item total
                                const price = parseFloat($('.item-checkbox[data-id="' + cartId + '"]').data('price'));
                                const total = price * quantity;
                                const totalElement = $('.item-total[data-id="' + cartId + '"] span');
                                
                                totalElement.text(total.toFixed(2));
                                $('.item-total[data-id="' + cartId + '"]').addClass('price-update');
                                
                                // Remove animation class after 1 second
                                setTimeout(function() {
                                    $('.item-total[data-id="' + cartId + '"]').removeClass('price-update');
                                }, 1000);
                                
                                // Update cart totals
                                updateCartTotals();
                            } else {
                                alert(response.message || "Failed to update quantity");
                                
                                // Set the input value to the maximum available
                                if (response.currentQuantity) {
                                    $('.quantity-input[data-id="' + cartId + '"]').val(response.currentQuantity);
                                    
                                    // Also update the data-max attribute of the increase button
                                    $('.increase-btn[data-id="' + cartId + '"]').data('max', response.currentQuantity);
                                    
                                    // Update the availability text
                                    const availableText = $('.quantity-control[data-id="' + cartId + '"]').siblings('.text-muted');
                                    if (availableText.length) {
                                        availableText.text(response.currentQuantity + ' items available');
                                    }
                                    
                                    // Recalculate item total with the corrected quantity
                                    const price = parseFloat($('.item-checkbox[data-id="' + cartId + '"]').data('price'));
                                    const total = price * response.currentQuantity;
                                    const totalElement = $('.item-total[data-id="' + cartId + '"] span');
                                    totalElement.text(total.toFixed(2));
                                    
                                    // Update cart totals
                                    updateCartTotals();
                                }
                            }
                        },
                        error: function() {
                            alert("Error connecting to server");
                        }
                    });
                }
                
                // Function to remove a cart item
                function removeCartItem(cartId) {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/cart/remove',
                        type: 'POST',
                        data: {
                            cartId: cartId
                        },
                        dataType: 'json',
                        success: function(response) {
                            if (response.success) {
                                // Remove the item from DOM
                                $('.item-checkbox[data-id="' + cartId + '"]').closest('.cart-item').fadeOut(300, function() {
                                    $(this).remove();
                                    
                                    // Update cart totals
                                    updateCartTotals();
                                    
                                    // If no items left, reload page to show empty cart
                                    if ($('.cart-item').length === 0) {
                                        window.location.reload();
                                    }
                                });
                                
                                // Update header cart count
                                updateHeaderCartCount(response.cartCount);
                            } else {
                                alert(response.message || "Failed to remove item");
                            }
                        },
                        error: function() {
                            alert("Error connecting to server");
                        }
                    });
                }
                
                // Function to clear the entire cart has been removed as requested
                
                // Function to update the cart count in the header
                function updateHeaderCartCount(count) {
                    const cartBtn = $('a[href="${pageContext.request.contextPath}/cart"]');
                    const cartBadge = cartBtn.find('.badge');
                    
                    if (cartBadge.length) {
                        if (count > 0) {
                            cartBadge.text(count);
                        } else {
                            cartBadge.remove();
                        }
                    } else if (count > 0) {
                        cartBtn.append('<span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">' + count + '</span>');
                    }
                }
                
                // Checkout button
                $('#checkoutBtn').on('click', function() {
                    const selectedIds = [];
                    
                    $('.item-checkbox:checked').each(function() {
                        selectedIds.push($(this).data('id'));
                    });
                    
                    if (selectedIds.length > 0) {
                        window.location.href = '${pageContext.request.contextPath}/checkout?items=' + selectedIds.join(',');
                    } else {
                        alert("Please select at least one item to checkout");
                    }
                });
            });
        </script>
    </body>
</html>
