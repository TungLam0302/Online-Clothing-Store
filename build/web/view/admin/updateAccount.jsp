<%-- 
    Document   : updateAccount
    Created on : Jul 9, 2025, 2:12:08 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Update Account</title>
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
            
            .form-label {
                font-weight: 500;
                color: #5a5c69;
            }
            
            .form-control:focus {
                border-color: #4e73df;
                box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
            }
            
            .alert {
                border-radius: 10px;
                margin-bottom: 20px;
            }
            
            .required {
                color: #e74c3c;
            }
            
            .info-section {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
            }
            
            .info-section h6 {
                margin-bottom: 10px;
                color: #5a5c69;
            }
            
            .info-item {
                margin-bottom: 8px;
            }
            
            .info-item strong {
                color: #2c3e50;
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
                        <h2 class="mb-1">Update User</h2>
                        <p class="text-muted mb-0">Edit user account information</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Users
                    </a>
                </div>
            </div>
            
            <!-- Alerts -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <!-- Update User Form -->
            <div class="content-card">
                <c:if test="${not empty user}">
                    <!-- Current User Info -->
                    <div class="info-section">
                        <h6><i class="fas fa-info-circle me-2"></i>Current User Information</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <strong>User ID:</strong> ${user.userID}
                                </div>
                                <div class="info-item">
                                    <strong>Current Role:</strong> ${user.role.roleName}
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <strong>Account Status:</strong> 
                                    <c:choose>
                                        <c:when test="${user.status}">
                                            <span class="badge bg-success">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <form action="${pageContext.request.contextPath}/admin/users" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="userID" value="${user.userID}">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="name" class="form-label">Full Name <span class="required">*</span></label>
                                    <input type="text" class="form-control" id="name" name="name" 
                                           value="${user.name}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email <span class="required">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${user.email}" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Phone</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="${user.phone}">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="roleID" class="form-label">Role <span class="required">*</span></label>
                                    <select class="form-select" id="roleID" name="roleID" required>
                                        <c:forEach var="role" items="${roles}">
                                            <option value="${role.id}" 
                                                    ${user.roleID == role.id ? 'selected' : ''}>
                                                ${role.roleName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="address" class="form-label">Address</label>
                            <textarea class="form-control" id="address" name="address" rows="3">${user.address}</textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Account Status</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="status" name="status" 
                                       ${user.status ? 'checked' : ''}>
                                <label class="form-check-label" for="status">
                                    Active Account
                                </label>
                            </div>
                            <div class="form-text">Uncheck to deactivate the account</div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                                Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Update User
                            </button>
                        </div>
                    </form>
                </c:if>
                
                <c:if test="${empty user}">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        User not found or invalid user ID provided.
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Users
                    </a>
                </c:if>
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
            // Form validation
            document.addEventListener('DOMContentLoaded', function() {
                const form = document.querySelector('form');
                const roleSelect = document.getElementById('roleID');
                const currentUserID = <c:out value="${sessionScope.user.userID}"/>;
                const editingUserID = <c:out value="${user.userID}"/>;
                
                // Prevent admin from changing their own role
                if (currentUserID === editingUserID) {
                    roleSelect.addEventListener('change', function() {
                        if (this.value !== '2') {
                            alert('You cannot change your own role!');
                            this.value = '2';
                        }
                    });
                }
                
                form.addEventListener('submit', function(e) {
                    // Additional validation can be added here
                    if (currentUserID === editingUserID && roleSelect.value !== '2') {
                        e.preventDefault();
                        alert('You cannot change your own role!');
                        roleSelect.value = '2';
                        return false;
                    }
                });
            });
        </script>
    </body>
</html>
