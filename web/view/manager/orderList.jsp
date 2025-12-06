<%-- 
    Document   : orderList
    Created on : Jul 10, 2025, 7:56:28 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Order Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="../layout/adminheader.jsp" />
    </head>
    <body>
        <!-- Check if user is logged in and is manager -->
        <c:if test="${empty sessionScope.user || sessionScope.user.roleID != 3}">
            <c:redirect url="/login" />
        </c:if>
        
        <!-- Include Admin Header -->
        <jsp:include page="../layout/adminheader.jsp"/>
        
        <!-- Include Admin Sidebar -->
        <jsp:include page="../layout/adminSideBar.jsp"/>
        
        <div class="main-content" style="margin-left: 260px; margin-top: 60px; padding: 30px;">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">Order Management</h2>
                        <p class="text-muted mb-0">Manage all customer orders</p>
                    </div>
                    <div>
                        <span class="badge bg-primary fs-6">Total Orders: ${orders.size()}</span>
                    </div>
                </div>
            </div>
            
            <!-- Orders Container -->
            <div class="orders-container">
                <!-- Filter Section -->
                <div class="filter-section">
                    <form method="GET" action="${pageContext.request.contextPath}/manager/orders">
                        <div class="row">
                            <div class="col-md-4">
                                <label for="status" class="form-label">Filter by Status</label>
                                <select name="status" id="status" class="form-select">
                                    <option value="all" ${statusFilter == 'all' || empty statusFilter ? 'selected' : ''}>All Orders</option>
                                    <option value="1" ${statusFilter == '1' ? 'selected' : ''}>Pending</option>
                                    <option value="2" ${statusFilter == '2' ? 'selected' : ''}>Processing</option>
                                    <option value="3" ${statusFilter == '3' ? 'selected' : ''}>Shipped</option>
                                    <option value="4" ${statusFilter == '4' ? 'selected' : ''}>Delivered</option>
                                    <option value="5" ${statusFilter == '5' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="search" class="form-label">Search Orders</label>
                                <input type="text" name="search" id="search" class="form-control" 
                                       placeholder="Order ID or Address" value="${searchTerm}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">&nbsp;</label>
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search me-1"></i>Filter
                                    </button>
                                    <a href="${pageContext.request.contextPath}/manager/orders" class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh me-1"></i>Reset
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                
                <!-- Orders Table -->
                <c:choose>
                    <c:when test="${not empty orders}">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Order Date</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Shipping Address</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr id="order-row-${order.orderID}">
                                            <td><strong>#${order.orderID}</strong></td>
                                            <td>${order.user.name}</td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm" /></td>
                                            <td>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></td>
                                            <td>
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
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.shippingAddress.length() > 30}">
                                                        ${order.shippingAddress.substring(0, 30)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${order.shippingAddress}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/manager/order-detail?id=${order.orderID}" 
                                                   class="btn btn-sm btn-info btn-action">
                                                    <i class="fas fa-eye"></i> View
                                                </a>
                                                <c:if test="${order.statusID != 5}">
                                                    <button type="button" class="btn btn-sm btn-warning btn-action update-status-btn" 
                                                            data-bs-toggle="modal" data-bs-target="#updateStatusModal"
                                                            data-order-id="${order.orderID}"
                                                            data-current-status="${order.statusID}">
                                                        <i class="fas fa-edit"></i> Update
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-orders">
                            <i class="fas fa-inbox"></i>
                            <h4>No Orders Found</h4>
                            <p>No orders match your current filter criteria.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Update Status Modal -->
        <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateStatusModalLabel">Update Order Status</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="updateStatusForm">
                            <div class="mb-3">
                                <label for="newStatus" class="form-label">New Status</label>
                                <select class="form-select" id="newStatus" required>
                                    <option value="">Select Status...</option>
                                    <option value="1">Pending</option>
                                    <option value="2">Processing</option>
                                    <option value="3">Shipped</option>
                                    <option value="4">Delivered</option>
                                    <option value="5">Cancelled</option>
                                </select>
                            </div>
                            <input type="hidden" id="orderIdToUpdate" value="">
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
        
        <!-- Order Management Functionality -->
        <script>
            $(document).ready(function() {
                let orderIdToUpdate = null;
                
                // Set the order ID when update button is clicked
                $('.update-status-btn').on('click', function() {
                    orderIdToUpdate = $(this).data('order-id');
                    const currentStatus = $(this).data('current-status');
                    
                    // Reset form
                    $('#newStatus').val('');
                    $('#orderIdToUpdate').val(orderIdToUpdate);
                    
                    // Set modal title
                    $('#updateStatusModalLabel').text('Update Order #' + orderIdToUpdate + ' Status');
                });
                
                // Handle status update confirmation
                $('#confirmUpdateBtn').on('click', function() {
                    const newStatus = $('#newStatus').val();
                    
                    if (!newStatus) {
                        alert('Please select a new status');
                        return;
                    }
                    
                    if (orderIdToUpdate) {
                        updateOrderStatus(orderIdToUpdate, newStatus);
                    }
                });
                
                // Reset modal state when hidden
                $('#updateStatusModal').on('hidden.bs.modal', function() {
                    orderIdToUpdate = null;
                    $('#newStatus').val('');
                    $('.modal-backdrop').remove();
                    $('body').removeClass('modal-open');
                    $('body').css('padding-right', '');
                });
                
                // Function to update order status via AJAX
                function updateOrderStatus(orderId, newStatus) {
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
