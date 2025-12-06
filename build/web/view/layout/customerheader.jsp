<%-- 
    Document   : customerheader
    Created on : Jul 9, 2025, 2:10:35 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Header Section -->
<header class="main-header">
    <div class="header-top bg-primary text-white">
        <div class="container">
            <div class="row align-items-center py-2">
                <div class="col-md-6">
                    <span class="me-3"><i class="fas fa-phone-alt"></i> +1-234-567-8900</span>
                    <span><i class="fas fa-envelope"></i> support@clotheronline.com</span>
                </div>
                <div class="col-md-6 text-end">
                    <div class="social-icons">
                        <a href="#" class="text-white me-2"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="text-white me-2"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="text-white me-2"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="text-white"><i class="fab fa-pinterest"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <!-- Mobile Sidebar Toggle Button (visible on small screens) -->
            <button class="btn btn-outline-secondary d-lg-none mobile-sidebar-toggle" id="mobile-sidebar-toggle" type="button">
                <i class="fas fa-filter"></i>
            </button>

            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="ClotherOnline Logo" height="50">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" 
                    aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="mainNavbar">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="${pageContext.request.contextPath}/home">Home</a>
                    </li>

                    <!-- Parent Categories Dropdown -->
                    <c:forEach var="parentCategory" items="${parentCategories}" varStatus="status">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" 
                               id="categoryDropdown${status.index}" data-bs-toggle="dropdown" aria-expanded="false">
                                ${parentCategory.categoryName}
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="categoryDropdown${status.index}">
                                <c:forEach var="subcategory" items="${categories}">
                                    <c:if test="${subcategory.parentCategoryID == parentCategory.categoryID}">
                                        <li>
                                            <a class="dropdown-item" 
                                               href="${pageContext.request.contextPath}/home?category=${subcategory.categoryID}">
                                                ${subcategory.categoryName}
                                            </a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </li>
                    </c:forEach>

                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">All Products</a>
                    </li>
                </ul>

                <div class="d-flex align-items-center">
                    <!-- Cart Button -->
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-dark position-relative me-3">
                        <i class="fas fa-shopping-cart"></i>
                        <c:if test="${not empty sessionScope.cart && not empty sessionScope.cart.items}">
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                ${sessionScope.cart.totalItems}
                            </span>
                        </c:if>
                    </a>

                    <!-- User Authentication -->
                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <!-- User Not Logged In -->
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary me-2">Login</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
                        </c:when>
                        <c:otherwise>
                            <!-- User Logged In -->
                            <div class="dropdown">
                                <button class="btn btn-outline-primary dropdown-toggle" type="button" 
                                        id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user-circle me-1"></i> ${sessionScope.user.name}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                    <!-- Dashboard cho Admin(2) hoặc Manager(3) -->
                                    <c:if test="${sessionScope.user.roleID == 2 or sessionScope.user.roleID == 3}">
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard">
                                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                            </a>
                                        </li>
                                    </c:if>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                            <i class="fas fa-user me-2"></i>My Profile
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/orders">
                                            <i class="fas fa-history me-2"></i>Order History
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>
    </nav>
</header>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<!-- Custom CSS -->
<style>
    nav.navbar > .container {
        background-color: #f4f5f7;
    }
    .main-header {
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        transition: all 0.3s ease;
        background-color: #f4f5f7;
    }

    .main-header.sticky {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1000;
        animation: slideDown 0.3s ease-out;
    }

    @keyframes slideDown {
        from {
            transform: translateY(-100%);
        }
        to {
            transform: translateY(0);
        }
    }

    .navbar-nav .nav-link {
        font-weight: 500;
        color: #333;
        padding: 0.75rem 1rem;
        transition: color 0.3s;
    }

    .navbar-nav .nav-link:hover {
        color: #4e73df;
    }

    .dropdown-menu {
        border: none;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        border-radius: 0.25rem;
        animation: fadeIn 0.3s ease-out;
        margin-top: 0 !important;
    }

    .dropdown-item {
        padding: 0.5rem 1.5rem;
        font-weight: 500;
    }

    .dropdown-item:hover {
        background-color: #f8f9fa;
        color: #4e73df;
    }

    /* Ensure dropdown is visible */
    .dropdown-menu.show {
        display: block !important;
        opacity: 1 !important;
        visibility: visible !important;
    }

    /* Fix for dropdown menu positioning */
    .dropdown {
        position: relative;
    }

    /* Ensure dropdown toggle behavior */
    .dropdown-toggle::after {
        display: inline-block;
        margin-left: .255em;
        vertical-align: .255em;
        content: "";
        border-top: .3em solid;
        border-right: .3em solid transparent;
        border-bottom: 0;
        border-left: .3em solid transparent;
    }

    /* Animation for dropdown menu */
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* Desktop hover dropdown */
    @media (min-width: 992px) {
        .navbar-nav .dropdown:hover .dropdown-menu {
            display: block;
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
    }

    /* Mobile Sidebar Toggle */
    .mobile-sidebar-toggle {
        display: none;
    }

    @media (max-width: 991.98px) {
        .mobile-sidebar-toggle {
            display: block;
            margin-right: 15px;
        }
    }

    .social-icons a {
        font-size: 0.875rem;
        transition: opacity 0.3s;
    }

    .social-icons a:hover {
        opacity: 0.8;
    }

    @media (max-width: 767.98px) {
        .header-top {
            text-align: center;
        }

        .header-top .text-end {
            text-align: center !important;
            margin-top: 0.5rem;
        }
    }
</style>

<!-- Bootstrap JS and dependencies -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Additional JavaScript to ensure dropdowns work properly -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Only use Bootstrap's built-in dropdown functionality without manual initialization
        // which can cause conflicts

        // Add improved dropdown support for touch devices
        document.querySelectorAll('.dropdown-toggle').forEach(function (element) {
            element.addEventListener('click', function (e) {
                // Get parent li element
                const parent = this.parentElement;

                // For debugging
                console.log('Dropdown clicked:', this.textContent.trim());

                if (window.innerWidth < 992) {
                    if (e.target === this || e.target.parentElement === this) {
                        // Check if this dropdown contains a submenu
                        const hasSubmenu = parent.querySelector('.dropdown-menu') !== null;
                        if (hasSubmenu) {
                            e.preventDefault();

                            // Toggle the dropdown menu visibility
                            const dropdownMenu = parent.querySelector('.dropdown-menu');
                            if (dropdownMenu.classList.contains('show')) {
                                dropdownMenu.classList.remove('show');
                            } else {
                                // Close other open dropdowns first
                                document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
                                    if (menu !== dropdownMenu) {
                                        menu.classList.remove('show');
                                    }
                                });

                                dropdownMenu.classList.add('show');
                            }
                        }
                    }
                }
            });
        });

        // Add hover functionality for desktop devices
        if (window.innerWidth >= 992) {
            const dropdownItems = document.querySelectorAll('.navbar-nav .dropdown');

            dropdownItems.forEach(function (item) {
                item.addEventListener('mouseenter', function () {
                    const dropdownMenu = this.querySelector('.dropdown-menu');
                    if (dropdownMenu) {
                        dropdownMenu.classList.add('show');
                    }
                });

                item.addEventListener('mouseleave', function () {
                    const dropdownMenu = this.querySelector('.dropdown-menu');
                    if (dropdownMenu) {
                        dropdownMenu.classList.remove('show');
                    }
                });
            });
        }

        console.log('Enhanced dropdown initialization complete');
    });
</script>

<!-- User dropdown specific script -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const userDropdownToggle = document.getElementById('userDropdown');
        if (userDropdownToggle) {
            // Let Bootstrap handle the dropdown for desktop
            if (window.innerWidth >= 992) {
                // Add hover functionality for desktop
                const userDropdownContainer = userDropdownToggle.parentElement;
                userDropdownContainer.addEventListener('mouseenter', function () {
                    const dropdownMenu = this.querySelector('.dropdown-menu');
                    if (dropdownMenu) {
                        dropdownMenu.classList.add('show');
                    }
                });

                userDropdownContainer.addEventListener('mouseleave', function () {
                    const dropdownMenu = this.querySelector('.dropdown-menu');
                    if (dropdownMenu) {
                        dropdownMenu.classList.remove('show');
                    }
                });
            } else {
                // Add click handling for mobile
                userDropdownToggle.addEventListener('click', function (e) {
                    console.log('User dropdown clicked');

                    // Find the dropdown menu
                    const dropdownMenu = this.nextElementSibling;

                    // Toggle the show class
                    if (dropdownMenu.classList.contains('show')) {
                        dropdownMenu.classList.remove('show');
                    } else {
                        // Close other open dropdowns first
                        document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
                            if (menu !== dropdownMenu) {
                                menu.classList.remove('show');
                            }
                        });

                        dropdownMenu.classList.add('show');
                    }
                });
            }

            // Close when clicking outside (for both mobile and desktop)
            document.addEventListener('click', function (event) {
                if (!event.target.closest('#userDropdown') &&
                        !event.target.closest('.dropdown-menu')) {
                    document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
                        menu.classList.remove('show');
                    });
                }
            });

            console.log('Enhanced user dropdown handler added');
        } else {
            console.log('User dropdown toggle not found');
        }
    });
</script>
