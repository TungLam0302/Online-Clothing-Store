<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ClotherOnline - Admin Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    
    <!-- Ensure Bootstrap JS is always loaded -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom Admin Styles -->
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            flex-direction: column;
            overflow-y: auto; /* Allow vertical scrolling */
        }
        .admin-header {
            background-color: #1e2a36;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-bottom: 1px solid #2c3e50;
            padding: 0.5rem 1rem;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1030;
            height: 60px;
        }
        .navbar-brand img {
            max-height: 50px;
            object-fit: contain;
            border-radius: 5px;
        }
        .content-wrapper {
            display: flex;
            min-height: calc(100vh - 60px); /* Subtract header height */
            margin-top: 60px;
            padding-bottom: 60px; /* Space for footer */
        }
        .sidebar {
            position: fixed;
            top: 60px; /* Align with header */
            bottom: 0;
            left: 0;
            z-index: 1040;
            width: 250px;
            padding-top: 20px;
            overflow-y: auto;
            transition: all 0.3s;
            background-color: #1e2a36 !important;
        }
        .main-content {
            flex-grow: 1;
            margin-left: 250px;
            padding: 20px;
            width: calc(100% - 250px);
            position: relative;
            z-index: 1;
            overflow-y: auto;
            padding-bottom: 100px; /* Extra space for form buttons */
        }
        .footer {
            position: fixed;
            bottom: 0;
            left: 250px;
            right: 0;
            z-index: 1020;
            height: 50px;
        }
        /* Ensure form submit buttons are visible and not overlapping */
        .main-content .mb-4 {
            position: fixed;
            bottom: 0;
            left: 250px;
            right: 0;
            background-color: white;
            padding: 10px 20px;
            z-index: 1050; /* Higher z-index to ensure visibility */
            box-shadow: 0 -2px 4px rgba(0,0,0,0.1);
        }
        @media (max-width: 767.98px) {
            .sidebar, .main-content, .footer, .main-content .mb-4 {
                left: 0;
                width: 100%;
            }
            .content-wrapper {
                flex-direction: column;
            }
        }
        .nav-link {
            color: #ffffff !important;
            transition: all 0.3s ease;
        }
        .nav-link:hover {
            color: #e0e0e0 !important;
        }
/*        .dropdown-menu {
            border: none;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-radius: 8px;
            min-width: 200px;
            display: none;
        }
        
        .dropdown-menu.show {
            display: block;
        }*/
        
        .dropdown-item {
            padding: 10px 20px;
            transition: all 0.3s ease;
        }
        
        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #495057;
        }
        
        .dropdown-item:active {
            background-color: #e9ecef;
        }
        
        .dropdown-toggle::after {
            margin-left: 0.5em;
        }
        
        .dropdown-toggle:focus {
            box-shadow: none;
        }
        
        .navbar-light .navbar-brand {
            color: #ffffff;
        }
    </style>
</head>
<body>
    <!-- Top Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light admin-header">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/dashboard">
                <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="ClotherOnline Logo" class="me-3">
                <span class="fw-bold">ClotherOnline Admin</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="adminNavbar">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="adminUserDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-2"></i> ${sessionScope.user.name}
                            <c:if test="${sessionScope.user.roleID == 2}">
                                <span class="badge bg-danger ms-1">Admin</span>
                            </c:if>
                            <c:if test="${sessionScope.user.roleID == 3}">
                                <span class="badge bg-primary ms-1">Manager</span>
                            </c:if>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="adminUserDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/"><i class="fas fa-home me-2"></i> Home</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fas fa-user me-2"></i> Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- JavaScript for dropdown functionality -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Ensure dropdown works with Bootstrap
            const dropdownElementList = document.querySelectorAll('.dropdown-toggle');
            const dropdownList = [...dropdownElementList].map(dropdownToggleEl => new bootstrap.Dropdown(dropdownToggleEl));
            
            // Fallback dropdown functionality if Bootstrap fails
            if (typeof bootstrap === 'undefined') {
                const dropdownToggles = document.querySelectorAll('.dropdown-toggle');
                dropdownToggles.forEach(toggle => {
                    toggle.addEventListener('click', function(e) {
                        e.preventDefault();
                        const dropdownMenu = this.nextElementSibling;
                        dropdownMenu.classList.toggle('show');
                    });
                });
                
                // Close dropdown when clicking outside
                document.addEventListener('click', function(e) {
                    dropdownToggles.forEach(toggle => {
                        const dropdownMenu = toggle.nextElementSibling;
                        if (!toggle.contains(e.target) && !dropdownMenu.contains(e.target)) {
                            dropdownMenu.classList.remove('show');
                        }
                    });
                });
            }
        });
    </script>
</body>
</html>
