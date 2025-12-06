<%-- 
    Document   : accountList
    Created on : Jul 9, 2025, 2:11:56 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Account Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8f9fa;
                padding-top: 60px;
                margin-left: 260px;
            }
            
            .main-content {
                margin-left: 260px;
                margin-top: 60px;
                padding: 30px;
            }
            
            .page-header {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }
            
            .content-card {
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 30px;
            }
            
            .btn-primary {
                background-color: #4e73df;
                border-color: #4e73df;
            }
            
            .btn-primary:hover {
                background-color: #375a7f;
                border-color: #375a7f;
            }
            
            .table th {
                background-color: #f8f9fa;
                border-top: none;
                font-weight: 600;
                color: #5a5c69;
            }
            
            .table td {
                vertical-align: middle;
            }
            
            .badge {
                font-size: 0.75rem;
                padding: 0.5rem 0.75rem;
            }
            
            .empty-users {
                text-align: center;
                padding: 50px 0;
                color: #6c757d;
            }
            
            .empty-users i {
                font-size: 4rem;
                margin-bottom: 20px;
            }
            
            .alert {
                border-radius: 10px;
                margin-bottom: 20px;
            }
            
            .role-badge {
                font-size: 0.8rem;
                padding: 0.4rem 0.8rem;
                border-radius: 20px;
            }
            
            .role-customer {
                background-color: #e3f2fd;
                color: #1976d2;
            }
            
            .role-admin {
                background-color: #ffebee;
                color: #d32f2f;
            }
            
            .role-manager {
                background-color: #f3e5f5;
                color: #7b1fa2;
            }
        </style>
    </head>
    <body>
        <!-- Check if user is logged in and is admin -->
        <c:if test="${empty sessionScope.user || sessionScope.user.roleID != 2}">
            <c:redirect url="/login" />
        </c:if>
        
        <!-- Include Admin Header -->
        <jsp:include page="../layout/adminheader.jsp"/>
        
        <!-- Include Admin Sidebar -->
        <jsp:include page="../layout/adminSideBar.jsp"/>
        
        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">User Management</h2>
                        <p class="text-muted mb-0">Manage all user accounts and permissions</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/users?action=add" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add New User
                    </a>
                </div>
            </div>
            
            <!-- Alerts -->
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <!-- Users Table -->
            <div class="content-card">
                <c:choose>
                    <c:when test="${not empty users}">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Phone</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>${user.userID}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-user-circle text-muted me-2"></i>
                                                    <div>
                                                        <div class="fw-medium">${user.name}</div>
                                                        <c:if test="${not empty user.address}">
                                                            <small class="text-muted">${user.address}</small>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${user.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty user.phone}">
                                                        ${user.phone}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.roleID == 1}">
                                                        <span class="role-badge role-customer">Customer</span>
                                                    </c:when>
                                                    <c:when test="${user.roleID == 2}">
                                                        <span class="role-badge role-admin">Admin</span>
                                                    </c:when>
                                                    <c:when test="${user.roleID == 3}">
                                                        <span class="role-badge role-manager">Manager</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="role-badge">${user.role.roleName}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.status}">
                                                        <span class="badge bg-success">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.userID}" 
                                                       class="btn btn-sm btn-outline-primary" title="Edit">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <c:if test="${user.userID != sessionScope.user.userID}">
                                                        <button type="button" class="btn btn-sm btn-outline-danger delete-user-btn" 
                                                                title="Delete" 
                                                                data-user-id="${user.userID}" 
                                                                data-user-name="${user.name}">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-users">
                            <i class="fas fa-users text-muted"></i>
                            <h4>No Users Found</h4>
                            <p>No users have been created yet.</p>
                            <a href="${pageContext.request.contextPath}/admin/users?action=add" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Add First User
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Delete User Modal -->
        <div class="modal fade" id="deleteUserModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete user <strong id="deleteUserName"></strong>?</p>
                        <p class="text-muted">This action will deactivate the user account. It cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="deleteUserLink" class="btn btn-danger">Delete User</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Include Footer -->
        <jsp:include page="../layout/footer.jsp"/>
        
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
        
        <script>
            // Add event listeners to delete buttons
            document.addEventListener('DOMContentLoaded', function() {
                const deleteButtons = document.querySelectorAll('.delete-user-btn');
                deleteButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        const userId = this.getAttribute('data-user-id');
                        const userName = this.getAttribute('data-user-name');
                        deleteUser(userId, userName);
                    });
                });
            });
            
            function deleteUser(userId, userName) {
                document.getElementById('deleteUserName').textContent = userName;
                document.getElementById('deleteUserLink').href = 
                    '${pageContext.request.contextPath}/admin/users?action=delete&id=' + userId;
                
                var modal = new bootstrap.Modal(document.getElementById('deleteUserModal'));
                modal.show();
            }
        </script>
    </body>
</html>
