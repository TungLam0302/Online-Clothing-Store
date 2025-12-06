

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ClotherOnline - Your Fashion Destination</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Custom CSS -->
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f9f9f9;
                color: #333;
            }
            
            /* Header Styles */
            .main-header {
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                background-color: #fff;
            }
            
            .header-top {
                font-size: 0.9rem;
                padding: 8px 0;
            }
            
            .navbar-brand img {
                max-height: 40px;
                width: auto;
            }
            
            /* Section Titles */
            .section-title {
                font-size: 1.8rem;
                font-weight: 600;
                color: #333;
                margin-bottom: 25px;
                position: relative;
                padding-bottom: 15px;
            }
            
            .section-title::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 60px;
                height: 3px;
                background-color: #6c7ae0;
            }
            
            /* Featured Categories */
            .category-card {
                position: relative;
                overflow: hidden;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                transition: transform 0.3s, box-shadow 0.3s;
                margin-bottom: 20px;
                height: 200px;
            }
            
            .category-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 30px rgba(0,0,0,0.15);
            }
            
            .category-img-container {
                position: relative;
                height: 100%;
                width: 100%;
            }
            
            .category-img-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s;
            }
            
            .category-card:hover .category-img-container img {
                transform: scale(1.1);
            }
            
            .category-overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                text-align: center;
                padding: 20px;
                color: white;
            }
            
            .category-overlay h3 {
                font-size: 1.4rem;
                font-weight: 600;
                margin-bottom: 15px;
                text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
            }
            
            /* Sidebar Styles */
            .sidebar {
                background-color: white;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 30px;
                box-shadow: 0 0 15px rgba(0,0,0,0.05);
                position: sticky;
                top: 20px;
            }
            
            .sidebar-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 15px;
                position: relative;
                padding-bottom: 10px;
            }
            
            .sidebar-title::after {
                content: '';
                position: absolute;
                left: 0;
                bottom: 0;
                width: 50px;
                height: 2px;
                background-color: #6c7ae0;
            }
            
            .categories-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            
            .parent-category {
                margin-bottom: 10px;
            }
            
            .parent-category-link {
                display: block;
                padding: 8px 0;
                color: #333;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
            }
            
            .parent-category-link:hover,
            .parent-category-link:focus {
                color: #6c7ae0;
            }
            
            .subcategories {
                list-style: none;
                padding-left: 15px;
            }
            
            .subcategory-link {
                display: block;
                padding: 6px 0;
                color: #666;
                text-decoration: none;
                transition: color 0.3s;
            }
            
            .subcategory-link:hover,
            .subcategory-link.active {
                color: #6c7ae0;
            }
            
            .search-box {
                margin-bottom: 25px;
            }
            
            .search-box .form-control {
                border-radius: 20px 0 0 20px;
                border: 1px solid #ddd;
                height: 40px;
                box-shadow: none;
            }
            
            .search-box .btn {
                border-radius: 0 20px 20px 0;
                background-color: #6c7ae0;
                border-color: #6c7ae0;
                height: 40px;
            }
            
            /* Product Card */
            .product-card {
                border: none;
                border-radius: 10px;
                overflow: hidden;
                transition: transform 0.3s, box-shadow 0.3s;
                margin-bottom: 30px;
                background-color: white;
                box-shadow: 0 0 15px rgba(0,0,0,0.05);
                height: 100%;
                display: flex;
                flex-direction: column;
            }
            
            .product-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 25px rgba(0,0,0,0.1);
            }
            
            .product-img-container {
                position: relative;
                overflow: hidden;
                padding-top: 100%; /* Square aspect ratio */
                background-color: #f8f9fa;
            }
            
            .product-img-container img {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s;
            }
            
            .product-card:hover .product-img-container img {
                transform: scale(1.05);
            }
            
            .product-card-overlay {
                position: absolute;
                bottom: -50px;
                left: 0;
                right: 0;
                background-color: rgba(255, 255, 255, 0.9);
                display: flex;
                justify-content: center;
                padding: 10px 0;
                transition: bottom 0.3s;
                z-index: 2;
            }
            
            .product-card:hover .product-card-overlay {
                bottom: 0;
            }
            
            .product-card-overlay a {
                margin: 0 8px;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                background-color: #6c7ae0;
                transition: background-color 0.3s, transform 0.3s;
            }
            
            .product-card-overlay a:hover {
                background-color: #5a68d5;
                transform: scale(1.1);
            }
            
            .product-card-body {
                padding: 20px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }
            
            .product-title {
                font-size: 15px;
                font-weight: 500;
                margin-bottom: 10px;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                color: #333;
                height: 42px; /* Fixed height for title to maintain card alignment */
            }
            
            .product-title a {
                color: #333;
                text-decoration: none;
            }
            
            .product-title a:hover {
                color: #6c7ae0;
            }
            
            .product-price {
                color: #6c7ae0;
                font-weight: 600;
                font-size: 18px;
                margin-top: 8px;
            }
            
            /* Pagination */
            .pagination {
                margin-top: 30px;
            }
            
            .page-link {
                color: #6c7ae0;
                border-color: #e9ecef;
                margin: 0 3px;
                border-radius: 5px;
            }
            
            .page-link:hover {
                color: white;
                background-color: #6c7ae0;
                border-color: #6c7ae0;
            }
            
            .page-item.active .page-link {
                background-color: #6c7ae0;
                border-color: #6c7ae0;
            }
            
            /* Breadcrumb */
            .breadcrumb-section {
                background-color: #f1f3f9;
                padding: 15px 0;
                margin-bottom: 30px;
            }
            
            /* Responsive Adjustments */
            @media (max-width: 991.98px) {
                .hero-section {
                    padding: 80px 0;
                    margin-bottom: 20px;
                }
                
                .hero-section h1 {
                    font-size: 2.5rem;
                }
                
                .product-card {
                    margin-bottom: 20px;
                }
            }
            
            /* Carousel/Slider Styles */
            #mainCarousel {
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                border-radius: 10px;
                overflow: hidden;
            }
            
            .carousel-inner {
                border-radius: 10px;
            }
            
            .carousel-item {
                height: 500px;
            }
            
            .carousel-item img {
                object-fit: cover;
                height: 100%;
                filter: brightness(0.8);
            }
            
            .carousel-caption {
                bottom: 100px;
                background-color: rgba(0, 0, 0, 0.4);
                padding: 20px;
                border-radius: 10px;
                max-width: 600px;
                margin: 0 auto;
            }
            
            .carousel-caption h2 {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 15px;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            }
            
            .carousel-caption p {
                font-size: 1.2rem;
                margin-bottom: 20px;
                text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
            }
            
            .carousel-indicators {
                margin-bottom: 30px;
            }
            
            .carousel-indicators button {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                margin: 0 5px;
            }
            
            .carousel-control-prev,
            .carousel-control-next {
                width: 5%;
                opacity: 0.7;
            }
            
            .carousel-control-prev:hover,
            .carousel-control-next:hover {
                opacity: 1;
            }
            
            @media (max-width: 768px) {
                .carousel-item {
                    height: 300px;
                }
                
                .carousel-caption {
                    bottom: 40px;
                    padding: 15px;
                }
                
                .carousel-caption h2 {
                    font-size: 1.8rem;
                }
                
                .carousel-caption p {
                    font-size: 1rem;
                    margin-bottom: 10px;
                }
                
                .carousel-indicators {
                    margin-bottom: 10px;
                }
            }
            
            /* Product Results Info */
            .product-results-info {
                margin-bottom: 20px;
                font-size: 0.9rem;
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="../layout/customerheader.jsp"/>
        
        <!-- Image Slider/Carousel -->
        <div class="container-fluid p-0 mb-4">
            <div id="mainCarousel" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="0" class="active"></button>
                    <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="1"></button>
                    <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="2"></button>
                    <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="3"></button>
                </div>
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="${pageContext.request.contextPath}/images/slider1.jpg" class="d-block w-100" alt="Fashion Collection">
                        <div class="carousel-caption">
                            <h2>Summer Collection</h2>
                            <p>Discover our latest arrivals for the summer season</p>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-light">Shop Now</a>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/images/slider2.jpg" class="d-block w-100" alt="New Arrivals">
                        <div class="carousel-caption">
                            <h2>New Arrivals</h2>
                            <p>Be the first to get our newest styles</p>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-light">Explore</a>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/images/slider3.jpg" class="d-block w-100" alt="Premium Collection">
                        <div class="carousel-caption">
                            <h2>Premium Collection</h2>
                            <p>Luxury styles for the discerning customer</p>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-light">View Collection</a>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/images/slider4.jpg" class="d-block w-100" alt="Special Offers">
                        <div class="carousel-caption">
                            <h2>Special Offers</h2>
                            <p>Limited time discounts on selected items</p>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-light">Shop Sale</a>
                        </div>
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="container mt-4">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-lg-3">
                    <jsp:include page="../layout/customerSidebar.jsp" />
                </div>
                
                <!-- Main Content Area -->
                <div class="col-lg-9">
                    
                    
                    <!-- Breadcrumb (Only for category/search pages) -->
                    <c:if test="${not empty param.category || not empty param.search}">
                        <nav aria-label="breadcrumb" class="mb-4">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                                <c:choose>
                                    <c:when test="${not empty param.category && not empty categoryName}">
                                        <li class="breadcrumb-item active" aria-current="page">${categoryName}</li>
                                    </c:when>
                                    <c:when test="${not empty param.search}">
                                        <li class="breadcrumb-item active" aria-current="page">Search results for: ${param.search}</li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="breadcrumb-item active" aria-current="page">All Products</li>
                                    </c:otherwise>
                                </c:choose>
                            </ol>
                        </nav>
                    </c:if>
                    
                    <!-- Product Results Info -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="product-results-info">
                            <c:choose>
                                <c:when test="${not empty totalProducts}">
                                    Showing ${(currentPage-1)*9 + 1} - ${(currentPage-1)*9 + products.size()} of ${totalProducts} products
                                </c:when>
                                <c:otherwise>
                                    Showing ${products.size()} products
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Product Grid -->
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                        <c:forEach var="product" items="${products}">
                            <div class="col">
                                <div class="product-card">
                                    <div class="product-img-container">
                                        <img src="${pageContext.request.contextPath}/${product.thumbnail}" alt="${product.productName}" onerror="this.src='${pageContext.request.contextPath}/images/5b428783-f455-46b8-892d-ff862928bb54.jpg'">
                                        <div class="product-card-overlay">
                                            <a href="${pageContext.request.contextPath}/product/view?id=${product.productID}" title="View Details"><i class="fas fa-eye"></i></a>
                                        </div>
                                    </div>
                                    <div class="product-card-body">
                                        <h5 class="product-title">
                                            <a href="${pageContext.request.contextPath}/product/view?id=${product.productID}">${product.productName}</a>
                                        </h5>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="product-price">$${product.price}</span>
                                            <c:if test="${not empty product.brand}">
                                                <small class="text-muted">${product.brand.brandName}</small>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <c:if test="${empty products}">
                            <div class="col-12 text-center py-5">
                                <i class="fas fa-search fa-4x text-muted mb-3"></i>
                                <h4>No products found</h4>
                                <p class="text-muted">Try adjusting your search or filter to find what you're looking for.</p>
                            </div>
                        </c:if>
                    </div>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" class="mt-5">
                            <ul class="pagination justify-content-center">
                                <!-- Previous Page Link -->
                                <c:choose>
                                    <c:when test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="${pageContext.request.contextPath}/home?page=${currentPage - 1}${queryString}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item disabled">
                                            <span class="page-link"><i class="fas fa-chevron-left"></i></span>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Page Number Links -->
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <li class="page-item active">
                                                <span class="page-link">${i}</span>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/home?page=${i}${queryString}">${i}</a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <!-- Next Page Link -->
                                <c:choose>
                                    <c:when test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="${pageContext.request.contextPath}/home?page=${currentPage + 1}${queryString}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item disabled">
                                            <span class="page-link"><i class="fas fa-chevron-right"></i></span>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
        
        <!-- Include Footer -->
        <jsp:include page="../layout/customerfooter.jsp"/>
        
        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Custom Scripts -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize carousel with auto-slide
                const mainCarousel = document.getElementById('mainCarousel');
                if (mainCarousel) {
                    const carousel = new bootstrap.Carousel(mainCarousel, {
                        interval: 5000,  // Change slides every 5 seconds
                        wrap: true,      // Continuously cycle
                        keyboard: true,  // React to keyboard events
                        pause: 'hover'   // Pause on mouse hover
                    });
                }
                
                // Initialize sidebar category accordions
                const categoryLinks = document.querySelectorAll('.parent-category-link');
                
                // Check if URL has category parameter to auto-expand the relevant parent category
                const urlParams = new URLSearchParams(window.location.search);
                const categoryParam = urlParams.get('category');
                
                if (categoryParam) {
                    // Find the subcategory and its parent
                    const activeSubcategory = document.querySelector(`.subcategory-link[href$="category=${categoryParam}"]`);
                    
                    if (activeSubcategory) {
                        // Mark subcategory as active
                        activeSubcategory.classList.add('active');
                        
                        // Expand parent category
                        const parentCollapseElement = activeSubcategory.closest('.collapse');
                        if (parentCollapseElement) {
                            const bsCollapse = new bootstrap.Collapse(parentCollapseElement, {
                                toggle: false
                            });
                            bsCollapse.show();
                            
                            // Update parent category chevron icon
                            const parentLink = document.querySelector(`[href="#${parentCollapseElement.id}"]`);
                            if (parentLink) {
                                const icon = parentLink.querySelector('i');
                                icon.classList.remove('fa-chevron-down');
                                icon.classList.add('fa-chevron-up');
                            }
                        }
                    }
                }
                
                // Toggle chevron icon on category expand/collapse
                categoryLinks.forEach(link => {
                    link.addEventListener('click', function() {
                        const icon = this.querySelector('i');
                        if (icon.classList.contains('fa-chevron-down')) {
                            icon.classList.remove('fa-chevron-down');
                            icon.classList.add('fa-chevron-up');
                        } else {
                            icon.classList.remove('fa-chevron-up');
                            icon.classList.add('fa-chevron-down');
                        }
                    });
                });
            });
        </script>
    </body>
</html>
