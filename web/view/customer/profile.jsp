<%-- 
    Document   : profile
    Created on : Jul 10, 2025, 3:15:46 PM
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
        <title>My Profile - ClotherOnline</title>
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
            
            .profile-container {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
                padding: 30px;
                margin-top: 30px;
                margin-bottom: 30px;
            }
            
            .profile-header {
                text-align: center;
                margin-bottom: 30px;
                position: relative;
                padding-bottom: 20px;
            }
            
            .profile-header:after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 3px;
                background-color: #4e73df;
            }
            
            .profile-avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                margin: 0 auto 20px;
                background-color: #4e73df;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 3rem;
                font-weight: 600;
                box-shadow: 0 5px 15px rgba(78, 115, 223, 0.3);
            }
            
            .nav-tabs {
                border-bottom: 2px solid #e9ecef;
                margin-bottom: 25px;
            }
            
            .nav-tabs .nav-link {
                border: none;
                color: #6c757d;
                font-weight: 500;
                padding: 12px 20px;
                margin-bottom: -2px;
                transition: all 0.3s;
            }
            
            .nav-tabs .nav-link.active {
                color: #4e73df;
                border-bottom: 2px solid #4e73df;
            }
            
            .nav-tabs .nav-link:hover:not(.active) {
                color: #4e73df;
                border-bottom: 2px solid transparent;
            }
            
            .form-label {
                font-weight: 500;
                margin-bottom: 8px;
                color: #495057;
            }
            
            .btn-primary {
                background-color: #4e73df;
                border-color: #4e73df;
                padding: 10px 25px;
                font-weight: 500;
            }
            
            .btn-primary:hover {
                background-color: #3756a4;
                border-color: #3756a4;
            }
            
            .btn-outline-secondary {
                color: #6c757d;
                border-color: #ced4da;
                padding: 10px 25px;
                font-weight: 500;
            }
            
            .btn-outline-secondary:hover {
                background-color: #f8f9fa;
                color: #495057;
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
                        <li class="breadcrumb-item active" aria-current="page">My Profile</li>
                    </ol>
                </nav>
            </div>
        </section>
        
        <!-- Profile Content -->
        <div class="container profile-container">
            <div class="profile-header">
                <div class="profile-avatar">
                    ${sessionScope.user.name.charAt(0)}
                </div>
                <h2 class="mb-1">${sessionScope.user.name}</h2>
                <p class="text-muted mb-0">${sessionScope.user.email}</p>
            </div>
            
            <!-- Display success/error messages if any -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <!-- Profile Tabs -->
            <ul class="nav nav-tabs" id="profileTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="account-tab" data-bs-toggle="tab" data-bs-target="#account" type="button" role="tab" aria-controls="account" aria-selected="true">
                        <i class="fas fa-user me-2"></i>Account Details
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="security-tab" data-bs-toggle="tab" data-bs-target="#security" type="button" role="tab" aria-controls="security" aria-selected="false">
                        <i class="fas fa-shield-alt me-2"></i>Password & Security
                    </button>
                </li>
            </ul>
            
            <!-- Tab Contents -->
            <div class="tab-content" id="profileTabsContent">
                <!-- Account Details Tab -->
                <div class="tab-pane fade show active" id="account" role="tabpanel" aria-labelledby="account-tab">
                    <h4 class="mb-4">Personal Information</h4>
                    <form action="${pageContext.request.contextPath}/profile/update" method="post" id="profileForm">
                        <div class="row mb-3">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <label for="name" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="name" name="name" value="${sessionScope.user.name}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" value="${sessionScope.user.email}" readonly>
                                <small class="form-text text-muted">Email cannot be changed</small>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <label for="phone" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${sessionScope.user.phone}" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="address" class="form-label">Shipping Address</label>
                            <textarea class="form-control" id="address" name="address" rows="3" required>${sessionScope.user.address}</textarea>
                        </div>
                        <div class="d-flex justify-content-end">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary me-2">Cancel</a>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
                
                <!-- Security Tab -->
                <div class="tab-pane fade" id="security" role="tabpanel" aria-labelledby="security-tab">
                    <h4 class="mb-4">Password & Security</h4>
                    
                    <form action="${pageContext.request.contextPath}/profile/changePassword" method="post" id="passwordForm">
                        <div class="mb-3">
                            <label for="currentPassword" class="form-label">Current Password</label>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <label for="newPassword" class="form-label">New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                <small id="passwordStrength" class="form-text"></small>
                            </div>
                            <div class="col-md-6">
                                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                <small id="passwordMatch" class="form-text"></small>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary me-2">Cancel</a>
                            <button type="submit" class="btn btn-primary" id="changePasswordBtn">Change Password</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Include Footer -->
        <jsp:include page="../layout/customerfooter.jsp"/>
        
        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Form Validation and Interactivity -->
        <script>
            
            // Tab Management from URL
            document.addEventListener('DOMContentLoaded', function() {
                // Check for URL parameters to activate specific tab
                const urlParams = new URLSearchParams(window.location.search);
                const tab = urlParams.get('tab');
                
                if (tab) {
                    const triggerEl = document.querySelector('#profileTabs button[data-bs-target="#' + tab + '"]');
                    if (triggerEl) {
                        const tabInstance = new bootstrap.Tab(triggerEl);
                        tabInstance.show();
                    }
                }
                
                // Password Strength Checker
                const newPassword = document.getElementById('newPassword');
                const confirmPassword = document.getElementById('confirmPassword');
                const passwordStrength = document.getElementById('passwordStrength');
                const passwordMatch = document.getElementById('passwordMatch');
                const changePasswordBtn = document.getElementById('changePasswordBtn');
                
                newPassword.addEventListener('input', function() {
                    const value = this.value;
                    
                    // Check password strength
                    if (value.length < 8) {
                        passwordStrength.textContent = 'Password should be at least 8 characters long';
                        passwordStrength.className = 'form-text text-danger';
                    } else if (!/[A-Z]/.test(value)) {
                        passwordStrength.textContent = 'Password should contain at least one uppercase letter';
                        passwordStrength.className = 'form-text text-warning';
                    } else if (!/[a-z]/.test(value)) {
                        passwordStrength.textContent = 'Password should contain at least one lowercase letter';
                        passwordStrength.className = 'form-text text-warning';
                    } else if (!/[0-9]/.test(value)) {
                        passwordStrength.textContent = 'Password should contain at least one number';
                        passwordStrength.className = 'form-text text-warning';
                    } else {
                        passwordStrength.textContent = 'Strong password';
                        passwordStrength.className = 'form-text text-success';
                    }
                    
                    // Check if passwords match
                    checkPasswordsMatch();
                });
                
                confirmPassword.addEventListener('input', checkPasswordsMatch);
                
                function checkPasswordsMatch() {
                    if (confirmPassword.value && newPassword.value !== confirmPassword.value) {
                        passwordMatch.textContent = 'Passwords do not match';
                        passwordMatch.className = 'form-text text-danger';
                        changePasswordBtn.disabled = true;
                    } else if (confirmPassword.value) {
                        passwordMatch.textContent = 'Passwords match';
                        passwordMatch.className = 'form-text text-success';
                        changePasswordBtn.disabled = false;
                    } else {
                        passwordMatch.textContent = '';
                        changePasswordBtn.disabled = false;
                    }
                }
                
                // Auto-dismiss alerts after 5 seconds
                setTimeout(function() {
                    const alerts = document.querySelectorAll('.alert');
                    alerts.forEach(function(alert) {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    });
                }, 5000);
            });
        </script>
    </body>
</html>
