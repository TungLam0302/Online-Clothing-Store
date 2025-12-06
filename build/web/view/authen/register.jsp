<%-- 
    Document   : register
    Created on : Jul 9, 2025, 2:11:15 PM
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
    <title>Register - ClotherOnline</title>
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
            padding-top: 30px;
            padding-bottom: 30px;
        }
        .register-container {
            max-width: 600px;
            margin: 0 auto;
            background: #f4f5f7;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 40px;
        }
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .register-header img {
            max-width: 150px;
            margin-bottom: 20px;
        }
        .register-header h2 {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        .register-header p {
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
        .form-label {
            font-weight: 500;
            color: #333;
        }
        .form-text {
            color: #6c757d;
            font-size: 0.85rem;
        }
        .password-strength {
            height: 5px;
            border-radius: 5px;
            margin-top: 5px;
            transition: all 0.3s;
        }
        .social-register {
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
    </style>
</head>
<body>
    <div class="container">
        <div class="register-container">
            <div class="register-header">
                <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="ClotherOnline Logo">
                <h2>Create an Account</h2>
                <p>Join ClotherOnline today</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                <div class="row">
                    <div class="col-12 mb-3">
                        <label for="name" class="form-label">Full Name <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="text" class="form-control" id="name" name="name" value="${name}" placeholder="Enter your full name" required>
                        </div>
                    </div>
                
                    <div class="col-12 mb-3">
                        <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" value="${email}" placeholder="Enter your email" required>
                        </div>
                        <div class="form-text">We'll never share your email with anyone else.</div>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                            <span class="input-group-text" style="cursor: pointer;" onclick="togglePasswordVisibility('password', 'togglePassword')">
                                <i class="fas fa-eye" id="togglePassword"></i>
                            </span>
                        </div>
                        <div class="password-strength" id="passwordStrength"></div>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label for="confirmPassword" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                            <span class="input-group-text" style="cursor: pointer;" onclick="togglePasswordVisibility('confirmPassword', 'toggleConfirmPassword')">
                                <i class="fas fa-eye" id="toggleConfirmPassword"></i>
                            </span>
                        </div>
                        <div class="invalid-feedback" id="passwordMatchError">Passwords do not match.</div>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label for="phone" class="form-label">Phone Number</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-phone"></i></span>
                            <input type="text" class="form-control" id="phone" name="phone" value="${phone}" placeholder="Enter your phone number">
                        </div>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label for="address" class="form-label">Address</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-home"></i></span>
                            <input type="text" class="form-control" id="address" name="address" value="${address}" placeholder="Enter your address">
                        </div>
                    </div>
                </div>
                
                
                <div class="d-grid gap-2 mt-4">
                    <button type="submit" class="btn btn-primary" id="registerBtn">
                        <i class="fas fa-user-plus me-2"></i> Register
                    </button>
                </div>
                
                
                <div class="text-center mt-4">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">Login</a></p>
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
        // Toggle password visibility
        function togglePasswordVisibility(inputId, toggleIconId) {
            const passwordInput = document.getElementById(inputId);
            const toggleIcon = document.getElementById(toggleIconId);
            
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
        
        // Password strength indicator
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strength = document.getElementById('passwordStrength');
            
            if (password.length === 0) {
                strength.style.width = '0%';
                strength.style.backgroundColor = '';
                return;
            }
            
            // Simple password strength calculation
            let strengthValue = 0;
            
            // Length check
            if (password.length > 6) strengthValue += 25;
            if (password.length > 10) strengthValue += 15;
            
            // Character variety checks
            if (/[A-Z]/.test(password)) strengthValue += 15; // Has uppercase
            if (/[a-z]/.test(password)) strengthValue += 15; // Has lowercase
            if (/[0-9]/.test(password)) strengthValue += 15; // Has number
            if (/[^A-Za-z0-9]/.test(password)) strengthValue += 15; // Has special char
            
            strength.style.width = strengthValue + '%';
            
            // Color based on strength
            if (strengthValue < 30) {
                strength.style.backgroundColor = '#ff4d4d'; // Weak (red)
            } else if (strengthValue < 60) {
                strength.style.backgroundColor = '#ffa64d'; // Medium (orange)
            } else if (strengthValue < 80) {
                strength.style.backgroundColor = '#ffff4d'; // Good (yellow)
            } else {
                strength.style.backgroundColor = '#4dff4d'; // Strong (green)
            }
        });
        
        // Confirm password validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            const errorElement = document.getElementById('passwordMatchError');
            
            if (password !== confirmPassword) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });
        
        // Form validation before submit
        document.getElementById('registerForm').addEventListener('submit', function(event) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                event.preventDefault();
                document.getElementById('confirmPassword').classList.add('is-invalid');
            }
        });
    </script>
</body>
</html>
