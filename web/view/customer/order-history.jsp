<%-- 
    Document   : order-history
    Created on : Jul 10, 2025, 5:11:55 PM
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
        <title>Order History - ClotherOnline</title>
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
            
            .order-history-container {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
                padding: 30px;
                margin-top: 30px;
                margin-bottom: 30px;
            }
            
            .order-history-header {
                border-bottom: 2px solid #e9ecef;
                padding-bottom: 15px;
                margin-bottom: 20px;
            }
            
            .order-history-header h2 {
                font-weight: 600;
                color: #333;
            }
            
            .order-card {
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                transition: all 0.3s;
            }
            
            .order-card:hover {
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                transform: translateY(-2px);
            }
            
            .order-header {
                display: flex;
                justify-content: space-between;
                border-bottom: 1px solid #e9ecef;
                padding-bottom: 10px;
                margin-bottom: 15px;
            }
            
            .order-number {
                font-weight: 600;
                font-size: 1.1rem;
            }
            
            .status-badge {
                font-size: 0.8rem;
                padding: 5px 12px;
                border-radius: 20px;
                font-weight: 500;
                text-transform: uppercase;
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
            
            .order-detail-link {
                color: #4e73df;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.2s;
            }
            
            .order-detail-link:hover {
                color: #2e59d9;
                text-decoration: underline;
            }
            
            .order-detail-btn {
                background-color: #4e73df;
                border-color: #4e73df;
                color: white;
                font-weight: 500;
                transition: all 0.3s;
            }
            
            .order-detail-btn:hover {
                background-color: #2e59d9;
                border-color: #2e59d9;
                transform: translateY(-2px);
            }
            
            .order-cancel-btn {
                background-color: #dc3545;
                border-color: #dc3545;
                color: white;
                font-weight: 500;
                transition: all 0.3s;
            }
            
            .order-cancel-btn:hover {
                background-color: #c82333;
                border-color: #bd2130;
                transform: translateY(-2px);
            }
            
            .empty-orders {
                text-align: center;
                padding: 40px 0;
            }
            
            .empty-orders i {
                font-size: 5rem;
                color: #dee2e6;
                margin-bottom: 20px;
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
                        <li class="breadcrumb-item active" aria-current="page">Order History</li>
                    </ol>
                </nav>
            </div>
        </section>
        
        <!-- Order History Content -->
        <div class="container order-history-container">
            <div class="order-history-header d-flex justify-content-between align-items-center">
                <h2>Your Order History</h2>
            </div>
            
            <!-- Error message display -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show my-3" role="alert">
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:choose>
                <c:when test="${not empty orders}">
                    <!-- Orders List -->
                    <div class="orders-list">
                        <c:forEach var="order" items="${orders}">
                            <div class="order-card" id="order-${order.orderID}">
                                <div class="order-header">
                                    <span class="order-number">Order #${order.orderID}</span>
                                    <c:choose>
                                        <c:when test="${order.statusID == 1}">
                                            <span class="status-badge status-pending" id="status-${order.orderID}">${order.status.statusName}</span>
                                        </c:when>
                                        <c:when test="${order.statusID == 2}">
                                            <span class="status-badge status-processing" id="status-${order.orderID}">${order.status.statusName}</span>
                                        </c:when>
                                        <c:when test="${order.statusID == 3}">
                                            <span class="status-badge status-shipped" id="status-${order.orderID}">${order.status.statusName}</span>
                                        </c:when>
                                        <c:when test="${order.statusID == 4}">
                                            <span class="status-badge status-delivered" id="status-${order.orderID}">${order.status.statusName}</span>
                                        </c:when>
                                        <c:when test="${order.statusID == 5}">
                                            <span class="status-badge status-cancelled" id="status-${order.orderID}">${order.status.statusName}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge" id="status-${order.orderID}">${order.status.statusName}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <p class="mb-1"><strong>Order Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="MMMM dd, yyyy h:mm a" /></p>
                                        <p class="mb-1"><strong>Total Amount:</strong> $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></p>
                                    </div>
                                    <div class="col-md-6">
                                        <p class="mb-1"><strong>Shipping Address:</strong></p>
                                        <p class="mb-1">${order.shippingAddress}</p>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderID}" class="order-detail-link">
                                        <i class="fas fa-eye me-1"></i>View Details
                                    </a>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderID}" class="btn btn-sm order-detail-btn">
                                            View Details
                                        </a>
                                        <c:if test="${order.statusID == 1}">
                                            <button type="button" class="btn btn-sm order-cancel-btn ms-2 cancel-order-btn" 
                                                    data-bs-toggle="modal" data-bs-target="#cancelModal"
                                                    data-order-id="${order.orderID}">
                                                Cancel Order
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Empty Orders -->
                    <div class="empty-orders">
                        <i class="fas fa-shopping-bag"></i>
                        <h3>No Orders Found</h3>
                        <p class="text-muted mb-4">You haven't placed any orders yet.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg shadow-sm">
                            <i class="fas fa-shopping-bag me-2"></i>Start Shopping
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Cancel Order Confirmation Modal -->
        <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="cancelModalLabel">Cancel Order</h5>
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
        
        <!-- Order History Functionality -->
        <script>
            $(document).ready(function() {
                let orderIdToCancel = null;
                
                // Set the order ID when cancel button is clicked
                $('.cancel-order-btn').on('click', function() {
                    orderIdToCancel = $(this).data('order-id');
                });
                
                // Handle cancel confirmation
                $('#confirmCancelBtn').on('click', function() {
                    if (orderIdToCancel) {
                        cancelOrder(orderIdToCancel);
                    }
                });
                
                // Reset modal state when hidden
                $('#cancelModal').on('hidden.bs.modal', function() {
                    orderIdToCancel = null;
                    $('.modal-backdrop').remove();
                    $('body').removeClass('modal-open');
                    $('body').css('padding-right', '');
                });
                
                // Function to cancel an order via AJAX
                function cancelOrder(orderId) {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/cancel-order',
                        type: 'POST',
                        data: {
                            id: orderId
                        },
                        dataType: 'json',
                        success: function(response) {
                            // Close the modal properly
                            $('#cancelModal').modal('hide');
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
                            $('#cancelModal').modal('hide');
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
