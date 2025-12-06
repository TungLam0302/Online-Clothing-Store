<%-- 
    Document   : order-detail
    Created on : Jul 10, 2025, 5:12:10 PM
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
        <title>Order Detail #${order.orderID} - ClotherOnline</title>
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
            
            .order-detail-container {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
                padding: 30px;
                margin-top: 30px;
                margin-bottom: 30px;
            }
            
            .order-detail-header {
                border-bottom: 2px solid #e9ecef;
                padding-bottom: 15px;
                margin-bottom: 20px;
            }
            
            .order-detail-header h2 {
                font-weight: 600;
                color: #333;
                display: flex;
                align-items: center;
            }
            
            .status-badge {
                font-size: 0.85rem;
                padding: 5px 12px;
                border-radius: 20px;
                font-weight: 500;
                text-transform: uppercase;
                margin-left: 15px;
            }
            
            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }
            
            .status-processing {
                background-color: #d1ecf1;
                color: #0c5460;
            }
            
            .status-shipped {
                background-color: #d4edda;
                color: #155724;
            }
            
            .status-delivered {
                background-color: #d4edda;
                color: #155724;
            }
            
            .status-cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }
            
            .order-section {
                margin-bottom: 25px;
            }
            
            .order-section-title {
                font-weight: 600;
                margin-bottom: 15px;
                font-size: 1.2rem;
                color: #333;
                border-bottom: 1px solid #e9ecef;
                padding-bottom: 8px;
            }
            
            .info-card {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .order-item {
                border-bottom: 1px solid #e9ecef;
                padding: 15px 0;
            }
            
            .order-item:last-child {
                border-bottom: none;
            }
            
            .product-image {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 5px;
            }
            
            .product-name {
                font-weight: 500;
                margin-bottom: 5px;
            }
            
            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                font-size: 0.95rem;
            }
            
            .summary-total {
                display: flex;
                justify-content: space-between;
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px solid #e9ecef;
                font-weight: 600;
                font-size: 1.1rem;
            }
            
            .back-btn {
                background-color: #4e73df;
                border-color: #4e73df;
                color: white;
                font-weight: 500;
                transition: all 0.3s;
            }
            
            .back-btn:hover {
                background-color: #2e59d9;
                border-color: #2e59d9;
                transform: translateY(-2px);
            }
            
            .cancel-btn {
                background-color: #dc3545;
                border-color: #dc3545;
                color: white;
                font-weight: 500;
                transition: all 0.3s;
            }
            
            .cancel-btn:hover {
                background-color: #c82333;
                border-color: #bd2130;
                transform: translateY(-2px);
            }
            
            .breadcrumb-section {
                background-color: #f1f3f9;
                padding: 15px 0;
                margin-bottom: 30px;
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
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/orders">Order History</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Order #${order.orderID}</li>
                    </ol>
                </nav>
            </div>
        </section>
        
        <!-- Order Detail Content -->
        <div class="container order-detail-container">
            <div class="order-detail-header d-flex justify-content-between align-items-center">
                <h2>
                    Order #${order.orderID}
                    <c:choose>
                        <c:when test="${order.statusID == 1}">
                            <span class="status-badge status-pending" id="order-status">${order.status.statusName}</span>
                        </c:when>
                        <c:when test="${order.statusID == 2}">
                            <span class="status-badge status-processing" id="order-status">${order.status.statusName}</span>
                        </c:when>
                        <c:when test="${order.statusID == 3}">
                            <span class="status-badge status-shipped" id="order-status">${order.status.statusName}</span>
                        </c:when>
                        <c:when test="${order.statusID == 4}">
                            <span class="status-badge status-delivered" id="order-status">${order.status.statusName}</span>
                        </c:when>
                        <c:when test="${order.statusID == 5}">
                            <span class="status-badge status-cancelled" id="order-status">${order.status.statusName}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge" id="order-status">${order.status.statusName}</span>
                        </c:otherwise>
                    </c:choose>
                </h2>
                <div>
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-primary me-2">
                        <i class="fas fa-arrow-left me-1"></i> Back to Orders
                    </a>
                    <c:if test="${order.statusID == 1}">
                        <button type="button" class="btn cancel-btn" data-bs-toggle="modal" data-bs-target="#cancelOrderModal">
                            <i class="fas fa-times me-1"></i> Cancel Order
                        </button>
                    </c:if>
                </div>
            </div>
            
            <!-- Order Information -->
            <div class="row">
                <div class="col-md-6">
                    <div class="order-section">
                        <h3 class="order-section-title">Order Information</h3>
                        <div class="info-card">
                            <p class="mb-2"><strong>Order Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="MMMM dd, yyyy h:mm a" /></p>
                            <p class="mb-2"><strong>Order Status:</strong> ${order.status.statusName}</p>
                            <p class="mb-0"><strong>Order Total:</strong> $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="order-section">
                        <h3 class="order-section-title">Shipping Information</h3>
                        <div class="info-card">
                            <p class="mb-0"><strong>Shipping Address:</strong> ${order.shippingAddress}</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Order Items -->
            <div class="order-section">
                <h3 class="order-section-title">Order Items</h3>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th style="width: 100px">Product</th>
                                <th>Description</th>
                                <th>Size</th>
                                <th class="text-center">Price</th>
                                <th class="text-center">Quantity</th>
                                <th class="text-end">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${orderItems}">
                                <tr>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/${item.productItem.product.thumbnail}" 
                                             alt="${item.productItem.product.productName}"
                                             class="product-image"
                                             onerror="this.src='${pageContext.request.contextPath}/images/5b428783-f455-46b8-892d-ff862928bb54.jpg'">
                                    </td>
                                    <td>
                                        <h5 class="product-name">${item.productItem.product.productName}</h5>
                                        <p class="text-muted mb-0">Brand: ${item.productItem.product.brand.brandName}</p>
                                    </td>
                                    <td>${item.productItem.size.sizeName}</td>
                                    <td class="text-center">$<fmt:formatNumber value="${item.price}" pattern="#,##0.00" /></td>
                                    <td class="text-center">${item.quantity}</td>
                                    <td class="text-end">$<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Order Summary -->
            <div class="row">
                <div class="col-md-6"></div>
                <div class="col-md-6">
                    <div class="order-section">
                        <h3 class="order-section-title">Order Summary</h3>
                        <div class="info-card">
                            <div class="summary-item">
                                <span>Subtotal</span>
                                <span>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></span>
                            </div>
                            <div class="summary-item">
                                <span>Shipping</span>
                                <span>Free</span>
                            </div>
                            <div class="summary-item">
                                <span>Tax</span>
                                <span>$0.00</span>
                            </div>
                            <div class="summary-total">
                                <span>Total</span>
                                <span>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="d-flex justify-content-between mt-4">
                <a href="${pageContext.request.contextPath}/orders" class="btn back-btn">
                    <i class="fas fa-arrow-left me-1"></i> Back to Orders
                </a>
                <c:if test="${order.statusID == 1}">
                    <button type="button" class="btn cancel-btn" data-bs-toggle="modal" data-bs-target="#cancelOrderModal">
                        <i class="fas fa-times me-1"></i> Cancel Order
                    </button>
                </c:if>
            </div>
        </div>
        
        <!-- Cancel Order Confirmation Modal -->
        <div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="cancelOrderModalLabel">Cancel Order #${order.orderID}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to cancel this order? This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No, Keep Order</button>
                        <button type="button" class="btn btn-danger" id="confirmCancelBtn">Yes, Cancel Order</button>
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
        
        <!-- Order Detail Functionality -->
        <script>
            $(document).ready(function() {
                // Handle cancel confirmation
                $('#confirmCancelBtn').on('click', function() {
                    cancelOrder();
                });
                
                // Reset modal state when hidden
                $('#cancelOrderModal').on('hidden.bs.modal', function() {
                    $('.modal-backdrop').remove();
                    $('body').removeClass('modal-open');
                    $('body').css('padding-right', '');
                });
                
                // Function to cancel an order via AJAX
                function cancelOrder() {
                    const orderId = "${order.orderID}";
                    
                    $.ajax({
                        url: '${pageContext.request.contextPath}/cancel-order',
                        type: 'POST',
                        data: {
                            id: orderId
                        },
                        dataType: 'json',
                        success: function(response) {
                            // Close the modal properly
                            $('#cancelOrderModal').modal('hide');
                            $('.modal-backdrop').remove();
                            $('body').removeClass('modal-open');
                            $('body').css('padding-right', '');
                            
                            if (response.success) {
                                // Reload the page to show updated order status
                                location.reload();
                            } else {
                                // Show error message only if there's an actual error
                                alert(response.message || 'Failed to cancel order');
                            }
                        },
                        error: function() {
                            // Close the modal properly
                            $('#cancelOrderModal').modal('hide');
                            $('.modal-backdrop').remove();
                            $('body').removeClass('modal-open');
                            $('body').css('padding-right', '');
                            alert('Error connecting to server');
                        }
                    });
                }
            });
        </script>
    </body>
</html>