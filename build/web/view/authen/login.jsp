<%-- 
    Document   : login
    Created on : Jul 9, 2025, 2:11:11 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - ClotherOnline</title>
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
            padding-top: 50px;
        }
        .login-container {
            max-width: 500px;
            margin: 0 auto;
            background: #f4f5f7;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 40px;
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header img {
            max-width: 150px;
            margin-bottom: 20px;
        }
        .login-header h2 {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        .login-header p {
            color: #6c757d;
        }
        .form-control:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.25rem rgba(78,115,223,0.25);
        }
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
            padding: 10px;
            font-weight: 600;
        }
        .btn-primary:hover {
            background-color: #3756a4;
            border-color: #3756a4;
        }
        .social-login {
            margin-top: 20px;
        }
        .social-btn {
            width: 100%;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 12px;
            border-radius: 5px;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s;
        }
        .social-btn i {
            margin-right: 10px;
            font-size: 18px;
        }
        .facebook-btn {
            background-color: #3b5998;
        }
        .facebook-btn:hover {
            background-color: #2d4373;
            color: #fff;
        }
        .google-btn {
            background-color: #dd4b39;
        }
        .google-btn:hover {
            background-color: #c23321;
            color: #fff;
        }
        .divider {
            text-align: center;
            position: relative;
            margin: 25px 0;
        }
        .divider span {
            background-color: #fff;
            padding: 0 15px;
            position: relative;
            z-index: 1;
            color: #6c757d;
        }
        .divider:after {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            width: 100%;
            height: 1px;
            background-color: #dee2e6;
            transform: translateY(-50%);
        }
        .alert-floating {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            animation: fadeInDown 0.5s;
        }
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <div class="login-header">
                <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="ClotherOnline Logo">
                <h2>Welcome Back</h2>
                <p>Please login to your account</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty param.logout}">
                <div class="alert alert-success" role="alert">
                    <i class="fas fa-check-circle me-2"></i> You have been successfully logged out.
                </div>
            </c:if>
            
            <c:if test="${not empty sessionScope.registerSuccess}">
                <div class="alert alert-success alert-floating" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${sessionScope.registerSuccess}
                </div>
                <c:remove var="registerSuccess" scope="session" />
            </c:if>
            
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                        <input type="email" class="form-control" id="email" name="email" 
                               value="${email}" placeholder="Enter your email" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <div class="d-flex justify-content-between">
                        <label for="password" class="form-label">Password</label>
                        <a href="#" class="text-decoration-none small">Forgot Password?</a>
                    </div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" class="form-control" id="password" name="password" 
                              value="${password}" placeholder="Enter your password" required>
                        <span class="input-group-text" style="cursor: pointer;" onclick="togglePasswordVisibility()">
                            <i class="fas fa-eye" id="togglePassword"></i>
                        </span>
                    </div>
                </div>
                
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe" ${remember} >
                    <label class="form-check-label" for="rememberMe">Remember me</label>
                </div>
                
                <div class="d-grid gap-2 mt-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt me-2"></i> Login
                    </button>
                </div>
                
                <div class="text-center mt-4">
                    <p>Don't have an account? <a href="${pageContext.request.contextPath}/register" class="text-decoration-none">Register</a></p>
                    <p><a href="${pageContext.request.contextPath}/home" class="text-decoration-none">
                        <i class="fas fa-arrow-left me-2"></i>Back to Home
                    </a></p>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-dismiss alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert-floating');
                alerts.forEach(function(alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        });
        
        // Toggle password visibility
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('togglePassword');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>
