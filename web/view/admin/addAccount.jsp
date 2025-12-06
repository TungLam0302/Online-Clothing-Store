<%-- 
    Document   : addAccount
    Created on : Jul 9, 2025, 2:12:01 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add New User - ClotherOnline</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        
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
                        <h2 class="mb-1">Add New User</h2>
                        <p class="text-muted mb-0">Create a new user account</p>
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
            
            <!-- Add User Form -->
            <div class="content-card">
                <form action="${pageContext.request.contextPath}/admin/users" method="post">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="name" class="form-label">Full Name <span class="required">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${param.name}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email <span class="required">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${param.email}" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="password" class="form-label">Password <span class="required">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" 
                                       minlength="6" required>
                                <div class="form-text">Minimum 6 characters</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="phone" class="form-label">Phone</label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${param.phone}">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="3">${param.address}</textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="roleID" class="form-label">Role <span class="required">*</span></label>
                                <select class="form-select" id="roleID" name="roleID" required>
                                    <option value="">Select Role</option>
                                    <c:forEach var="role" items="${roles}">
                                        <option value="${role.id}" 
                                                ${param.roleID == role.id ? 'selected' : ''}>
                                            ${role.roleName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Account Status</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="status" name="status" 
                                           ${param.status != null ? 'checked' : ''}>
                                    <label class="form-check-label" for="status">
                                        Active Account
                                    </label>
                                </div>
                                <div class="form-text">Check to activate the account immediately</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Create User
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Include Footer -->
        <jsp:include page="../layout/footer.jsp"/>
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
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
                const passwordInput = document.getElementById('password');
                
                form.addEventListener('submit', function(e) {
                    let isValid = true;
                    
                    // Check password length
                    if (passwordInput.value.length < 6) {
                        e.preventDefault();
                        alert('Password must be at least 6 characters long');
                        passwordInput.focus();
                        isValid = false;
                    }
                    
                    return isValid;
                });
            });
        </script>
    </body>
</html>
