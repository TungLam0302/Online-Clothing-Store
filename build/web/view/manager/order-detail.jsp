<%-- 
    Document   : order-detail
    Created on : Jul 10, 2025, 7:56:41 PM
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
        <title>Order Detail #${order.orderID} - Manager - ClotherOnline</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f8f9fa;
                color: #333;
            }
            
            .main-content {
                padding: 30px;
            }
            
            .page-header {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
                padding: 30px;
                margin-bottom: 30px;
            }
            
            .order-detail-container {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
                padding: 30px;
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
                background-color: #6c757d;
                border-color: #6c757d;
                color: white;
                font-weight: 500;
                transition: all 0.3s;
            }
            
            .back-btn:hover {
                background-color: #5a6268;
                border-color: #5a6268;
                transform: translateY(-2px);
            }
            
            .update-status-btn {
                background-color: #ffc107;
                border-color: #ffc107;
                color: #212529;
                font-weight: 500;
                transition: all 0.3s;
            }
            
            .update-status-btn:hover {
                background-color: #e0a800;
                border-color: #d39e00;
                transform: translateY(-2px);
            }
        </style>
    </head>
    <body>
        <!-- Check if user is logged in and is manager -->
        <c:if test="${empty sessionScope.user || sessionScope.user.roleID != 3}">
            <c:redirect url="/login" />
        </c:if>
        
        <!-- Include Admin Header -->
        <jsp:include page="../layout/adminheader.jsp"/>
        <jsp:include page="../layout/adminSideBar.jsp"/>
        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header"style="margin-top: 60px; padding: 30px;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">
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
                        <p class="text-muted mb-0">Customer: ${order.user.name}</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/manager/orders" class="btn btn-outline-secondary me-2">
                            <i class="fas fa-arrow-left me-1"></i> Back to Orders
                        </a>
                        <c:if test="${order.statusID != 5}">
                            <button type="button" class="btn update-status-btn" data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                                <i class="fas fa-edit me-1"></i> Update Status
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <!-- Order Detail Content -->
            <div class="order-detail-container">
                <!-- Order Information -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="order-section">
                            <h3 class="order-section-title">Order Information</h3>
                            <div class="info-card">
                                <p class="mb-2"><strong>Order ID:</strong> #${order.orderID}</p>
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
                                <p class="mb-0"><strong>Shipping Address:</strong><br>${order.shippingAddress}</p>
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
                    <a href="${pageContext.request.contextPath}/manager/orders" class="btn back-btn">
                        <i class="fas fa-arrow-left me-1"></i> Back to Orders
                    </a>
                    <c:if test="${order.statusID != 5}">
                        <button type="button" class="btn update-status-btn" data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                            <i class="fas fa-edit me-1"></i> Update Status
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
        
        <!-- Update Status Modal -->
        <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateStatusModalLabel">Update Order #${order.orderID} Status</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="updateStatusForm">
                            <div class="mb-3">
                                <label for="newStatus" class="form-label">New Status</label>
                                <select class="form-select" id="newStatus" required>
                                    <option value="">Select Status...</option>
                                    <option value="1" ${order.statusID == 1 ? 'selected' : ''}>Pending</option>
                                    <option value="2" ${order.statusID == 2 ? 'selected' : ''}>Processing</option>
                                    <option value="3" ${order.statusID == 3 ? 'selected' : ''}>Shipped</option>
                                    <option value="4" ${order.statusID == 4 ? 'selected' : ''}>Delivered</option>
                                    <option value="5" ${order.statusID == 5 ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Current Status</label>
                                <p class="form-control-plaintext">${order.status.statusName}</p>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="confirmUpdateBtn">Update Status</button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Include Admin Footer -->
        <jsp:include page="../layout/footer.jsp"/>
        
        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        
        <!-- Initialize Bootstrap dropdowns -->
        <script>
            // Initialize Bootstrap dropdowns after DOM is loaded
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize all dropdowns
                var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
                var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
                    return new bootstrap.Dropdown(dropdownToggleEl);
                });
            });
        </script>
        
        <!-- Order Detail Functionality -->
        <script>
            $(document).ready(function() {
                // Handle status update confirmation
                $('#confirmUpdateBtn').on('click', function() {
                    const newStatus = $('#newStatus').val();
                    
                    if (!newStatus) {
                        alert('Please select a new status');
                        return;
                    }
                    
                    updateOrderStatus(newStatus);
                });
                
                // Reset modal state when hidden
                $('#updateStatusModal').on('hidden.bs.modal', function() {
                    $('.modal-backdrop').remove();
                    $('body').removeClass('modal-open');
                    $('body').css('padding-right', '');
                });
                
                // Function to update order status via AJAX
                function updateOrderStatus(newStatus) {
                    const orderId = "${order.orderID}";
                    
                    $.ajax({
                        url: '${pageContext.request.contextPath}/manager/update-order-status',
                        type: 'POST',
                        data: {
                            orderId: orderId,
                            newStatus: newStatus
                        },
                        dataType: 'json',
                        success: function(response) {
                            // Close the modal properly
                            $('#updateStatusModal').modal('hide');
                            $('.modal-backdrop').remove();
                            $('body').removeClass('modal-open');
                            $('body').css('padding-right', '');
                            
                            if (response.success) {
                                // Reload page to show updated status
                                location.reload();
                            } else {
                                alert(response.message || 'Failed to update order status');
                            }
                        },
                        error: function() {
                            // Close the modal properly
                            $('#updateStatusModal').modal('hide');
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
