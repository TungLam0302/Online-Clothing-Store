<%-- 
    Document   : view-product
    Created on : Jul 10, 2025, 1:15:00 PM
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
        <title>${product.productName} - ClotherOnline</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Swiper Carousel -->
        <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- jQuery for easier debugging -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Custom CSS -->
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f8f9fa;
            }
            
            .breadcrumb-section {
                background-color: #f1f3f9;
                padding: 15px 0;
                margin-bottom: 30px;
            }
            
            /* Product Detail Styling */
            .product-detail {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
                padding: 40px;
                margin-bottom: 40px;
            }
            
            .product-gallery {
                position: relative;
            }
            
            .product-main-img {
                width: 100%;
                height: 500px;
                object-fit: contain;
                border-radius: 8px;
                margin-bottom: 15px;
                background-color: #f8f9fa;
            }
            
            .product-thumbs-swiper {
                height: 80px;
            }
            
            .product-thumb-slide {
                height: 80px;
                width: 80px;
                cursor: pointer;
                opacity: 0.7;
                transition: opacity 0.3s;
            }
            
            .product-thumb-slide.swiper-slide-thumb-active {
                opacity: 1;
                border: 2px solid #4e73df;
            }
            
            .product-thumb-slide img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 4px;
            }
            
            .product-info h1 {
                font-size: 2.2rem;
                font-weight: 700;
                margin-bottom: 15px;
                color: #333;
                line-height: 1.3;
            }
            
            .product-price {
                font-size: 2rem;
                color: #4e73df;
                font-weight: 700;
                margin-bottom: 25px;
                border-bottom: 1px solid #eee;
                padding-bottom: 15px;
            }
            
            .product-meta {
                margin-bottom: 25px;
                background-color: #f9f9f9;
                padding: 15px;
                border-radius: 8px;
            }
            
            .product-meta p {
                margin-bottom: 10px;
                color: #6c757d;
                font-size: 1rem;
            }
            
            .product-meta p:last-child {
                margin-bottom: 0;
            }
            
            .product-meta p span {
                color: #333;
                font-weight: 600;
            }
            
            .size-select {
                margin-bottom: 20px;
            }
            
            .size-btn {
                display: inline-block;
                border: 2px solid #dee2e6;
                padding: 12px 22px;
                margin-right: 12px;
                margin-bottom: 15px;
                border-radius: 6px;
                color: #333;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease-out;
                position: relative;
            }
            
            .size-btn:hover {
                border-color: #4e73df;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            
            .size-btn.active {
                background-color: #4e73df;
                border-color: #4e73df;
                color: white;
                box-shadow: 0 5px 10px rgba(78, 115, 223, 0.4);
                transform: scale(1.1);
            }
            
            .size-btn.active:after {
                content: "✓";
                position: absolute;
                top: -10px;
                right: -10px;
                background: #28a745;
                color: white;
                width: 22px;
                height: 22px;
                font-size: 12px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            .size-btn.disabled {
                background-color: #f8f9fa;
                color: #adb5bd;
                cursor: not-allowed;
                border-color: #dee2e6;
                opacity: 0.7;
            }
            
            .stock-display {
                display: none;
                color: #28a745;
                font-weight: 500;
                margin-top: 10px;
                font-size: 0.9rem;
                animation: fadeIn 0.3s ease-in;
                padding: 8px 12px;
                background: rgba(40, 167, 69, 0.1);
                border-radius: 4px;
                border-left: 3px solid #28a745;
            }
            
            /* Make sure show class works properly */
            .stock-display.show {
                display: block !important;
            }
            
            /* Pulse animation for the Add to Cart button */
            .pulse-once {
                animation: pulseEffect 0.5s 1;
            }
            
            @keyframes pulseEffect {
                0% { transform: scale(1); }
                50% { transform: scale(1.1); }
                100% { transform: scale(1); }
            }
            
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }
            
            /* Cart alert styling */
            #cartAlert {
                display: none;
                margin-top: 20px;
                animation: fadeIn 0.3s;
            }
            
            #cartAlert.show {
                display: block;
            }
            
            .product-actions {
                display: flex;
                margin-bottom: 30px;
                margin-top: 30px;
            }
            
            .product-actions .btn-outline-primary {
                margin-left: 15px;
                height: 50px;
                width: 50px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                transition: all 0.3s;
            }
            
            .product-actions .btn-outline-primary:hover {
                transform: scale(1.1) rotate(5deg);
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            
            .product-description {
                line-height: 1.8;
                background-color: #f9fafb;
                padding: 20px;
                border-radius: 8px;
                border-left: 4px solid #4e73df;
                margin-bottom: 20px;
            }
            
            .product-description h5 {
                font-weight: 600;
                margin-bottom: 15px;
                color: #333;
            }
            
            .product-description p {
                color: #555;
            }
            
            .product-features {
                margin-top: 20px;
            }
            
            .product-features h6 {
                font-weight: 600;
                margin-bottom: 15px;
                color: #333;
            }
            
            .product-features li {
                margin-bottom: 10px;
            }
            
            /* Removed Product Tabs */
            
            /* Related Products */
            .related-products {
                margin-top: 30px;
                padding: 40px 0;
                border-top: 1px solid #eee;
            }
            
            .related-products h3 {
                font-size: 1.8rem;
                font-weight: 600;
                margin-bottom: 30px;
                position: relative;
                padding-bottom: 15px;
                text-align: center;
            }
            
            .related-products h3:after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 3px;
                background-color: #4e73df;
            }
            
            /* Removed stock-info */
            
            /* Đảm bảo thông tin số lượng tồn kho không hiển thị */
            /* Removed stockInfo CSS */
            
            /* Cải thiện style cho phần mô tả sản phẩm */
            .product-description {
                line-height: 1.8;
                background-color: #f9fafb;
                padding: 20px;
                border-radius: 8px;
                border-left: 4px solid #4e73df;
                margin-bottom: 20px;
            }
            
            /* Product card styling for related products */
            .product-card {
                background-color: #fff;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
                transition: transform 0.3s, box-shadow 0.3s;
                height: 100%;
                display: flex;
                flex-direction: column;
            }
            
            .product-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            }
            
            .product-img-container {
                position: relative;
                padding-top: 100%; /* 1:1 Aspect Ratio */
                overflow: hidden;
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
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.2);
                display: flex;
                justify-content: center;
                align-items: center;
                opacity: 0;
                transition: opacity 0.3s;
            }
            
            .product-card:hover .product-card-overlay {
                opacity: 1;
            }
            
            .product-card-overlay a {
                width: 40px;
                height: 40px;
                background: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 5px;
                color: #4e73df;
                transition: all 0.3s;
            }
            
            .product-card-overlay a:hover {
                background: #4e73df;
                color: white;
                transform: scale(1.1);
            }
            
            .product-card-body {
                padding: 15px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
            }
            
            .product-title {
                margin-bottom: 10px;
                font-size: 1rem;
                font-weight: 600;
                line-height: 1.4;
            }
            
            .product-title a {
                color: #333;
                text-decoration: none;
                transition: color 0.2s;
            }
            
            .product-title a:hover {
                color: #4e73df;
            }
            
            /* Add to cart button animation */
            .pulse-once {
                animation: pulse 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) 1;
            }
            
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.05); }
                100% { transform: scale(1); }
            }
            
            #addToCartBtn {
                transition: all 0.3s;
                padding: 12px 30px;
                font-size: 1.1rem;
                border-radius: 8px;
                font-weight: 600;
            }
            
            #addToCartBtn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }
            
            #addToCartBtn:not(:disabled):hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(78, 115, 223, 0.3);
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="../layout/customerheader.jsp"/>
        
        <!-- Breadcrumb Section -->
        <section class="breadcrumb-section">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                        <c:if test="${product.category != null}">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/home?category=${product.category.categoryID}">
                                    ${product.category.categoryName}
                                </a>
                            </li>
                        </c:if>
                        <li class="breadcrumb-item active" aria-current="page">${product.productName}</li>
                    </ol>
                </nav>
            </div>
        </section>
        
        <div class="container mt-4">
            <div class="row">
                <!-- Main Content Column -->
                <div class="col-12">
                    <!-- Product Detail Section -->
                    <section class="product-detail">
                        <div class="row">
                            <!-- Product Gallery -->
                            <div class="col-lg-6 mb-4 mb-lg-0">
                                <div class="product-gallery">
                                    <div class="swiper product-main-swiper mb-3">
                                        <div class="swiper-wrapper">
                                            <c:choose>
                                                <c:when test="${not empty images}">
                                                    <c:forEach var="image" items="${images}">
                                                        <div class="swiper-slide">
                                                            <img src="${pageContext.request.contextPath}/${image.url}" 
                                                                 alt="${product.productName}" class="product-main-img">
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="swiper-slide">
                                                        <img src="${pageContext.request.contextPath}/${product.thumbnail}" 
                                                             alt="${product.productName}" class="product-main-img">
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <!-- Navigation buttons -->
                                        <div class="swiper-button-next"></div>
                                        <div class="swiper-button-prev"></div>
                                    </div>
                                    
                                    <c:if test="${not empty images && images.size() > 1}">
                                        <div class="swiper product-thumbs-swiper">
                                            <div class="swiper-wrapper">
                                                <c:forEach var="image" items="${images}">
                                                    <div class="swiper-slide product-thumb-slide">
                                                        <img src="${pageContext.request.contextPath}/${image.url}" 
                                                             alt="${product.productName}">
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Product Info -->
                            <div class="col-lg-6">
                                <div class="product-info">
                                    <h1>${product.productName}</h1>
                                    <div class="product-price">$${product.price}</div>
                                    
                                    <!-- Di chuyển phần mô tả sản phẩm lên đây -->
                                    <div class="product-description mt-3 mb-4">
                                        <h5>Product Description:</h5>
                                        <p class="mb-3">${product.desciption}</p>
                                        
                                        <div class="product-features mt-4">
                                            <h6>Features:</h6>
                                            <ul class="list-unstyled">
                                                <c:if test="${not empty product.brand}">
                                                    <li><i class="fas fa-check text-success me-2"></i> Brand: <strong>${product.brand.brandName}</strong></li>
                                                </c:if>
                                                <c:if test="${not empty product.category}">
                                                    <li><i class="fas fa-check text-success me-2"></i> Category: <strong>${product.category.categoryName}</strong></li>
                                                </c:if>
                                                <li><i class="fas fa-check text-success me-2"></i> Premium quality material</li>
                                                <li><i class="fas fa-check text-success me-2"></i> Durable and long-lasting</li>
                                            </ul>
                                        </div>
                                    </div>
                                    
                                    <div class="product-meta">
                                        <p>Brand: <span>${product.brand.brandName}</span></p>
                                        <p>Category: <span>${product.category.categoryName}</span></p>
                                        <p>Availability: 
                                            <c:choose>
                                                <c:when test="${product.status}">
                                                    <span class="text-success">In Stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger">Out of Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    
                                    <c:if test="${not empty productItems && product.status}">
                                        <div class="size-select">
                                            <h5 class="mb-3">Select Size:</h5>
                                            <div class="size-options">
                                                <c:forEach var="item" items="${productItems}">
                                                    <c:choose>
                                                        <c:when test="${item.stockQuantity > 0}">
                                                            <span class="size-btn" 
                                                                  data-size-id="${item.size.sizeID}" 
                                                                  data-stock="${item.stockQuantity}">
                                                                ${item.size.sizeName}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="size-btn disabled" title="Out of Stock">
                                                                ${item.size.sizeName}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        
                                        <!-- Stock display -->
                                        <div class="stock-display" id="stockDisplay">
                                            <i class="fas fa-cubes me-2"></i>
                                            <span id="availableStock">0</span> items in stock for this size
                                        </div>
                                        
                                        <script>
                                            // Initialize stock display to ensure it's hidden at first
                                            document.addEventListener('DOMContentLoaded', function() {
                                                const stockDisplay = document.getElementById('stockDisplay');
                                                if (stockDisplay) {
                                                    stockDisplay.style.display = 'none';
                                                }
                                            });
                                        </script>
                                        
                                        <div class="product-actions">
                                            <div id="cartActionContainer">
                                                <input type="hidden" name="productId" id="selectedProductId" value="${product.productID}">
                                                <input type="hidden" name="sizeId" id="selectedSizeId" value="">
                                                <input type="hidden" name="quantity" id="selectedQuantity" value="1">
                                                <button type="button" class="btn btn-primary btn-lg" id="addToCartBtn" disabled>
                                                    <i class="fas fa-shopping-cart me-2"></i>Add to Cart
                                                </button>
                                            </div>
                                            <button class="btn btn-outline-primary">
                                                <i class="far fa-heart"></i>
                                            </button>
                                        </div>
                                        <!-- Cart Notification -->
                                        <div class="alert alert-success alert-dismissible fade" id="cartAlert" role="alert">
                                            <span id="cartMessage"></span>
                                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </section>
                    
                    <!-- Related Products Section -->
                    <section class="related-products">
                        <h3>Related Products</h3>
                        <div class="row">
                            <c:choose>
                                <c:when test="${not empty relatedProducts}">
                                    <c:forEach var="relatedProduct" items="${relatedProducts}">
                                        <div class="col-md-4 col-lg-3 mb-4">
                                            <div class="product-card">
                                                <div class="product-img-container">
                                                    <img src="${pageContext.request.contextPath}/${relatedProduct.thumbnail}" 
                                                         alt="${relatedProduct.productName}" 
                                                         onerror="this.src='${pageContext.request.contextPath}/images/5b428783-f455-46b8-892d-ff862928bb54.jpg'">
                                                    <div class="product-card-overlay">
                                                        <a href="${pageContext.request.contextPath}/product/view?id=${relatedProduct.productID}" title="View Details"><i class="fas fa-eye"></i></a>
                                                    </div>
                                                </div>
                                                <div class="product-card-body">
                                                    <h5 class="product-title">
                                                        <a href="${pageContext.request.contextPath}/product/view?id=${relatedProduct.productID}">${relatedProduct.productName}</a>
                                                    </h5>
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <span class="product-price">$${relatedProduct.price}</span>
                                                        <c:if test="${not empty relatedProduct.brand}">
                                                            <small class="text-muted">${relatedProduct.brand.brandName}</small>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-12">
                                        <p class="text-center">No related products found</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>
                </div>
            </div>
        </div>
        
        <!-- Include Footer -->
        <jsp:include page="../layout/customerfooter.jsp"/>
        
        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Swiper JS -->
        <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
        <!-- Custom Scripts -->
        <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize product gallery
        const mainSwiper = new Swiper('.product-main-swiper', {
            loop: true,
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            }
        });
        
        // Initialize thumbnails swiper
        const thumbsSwiper = new Swiper('.product-thumbs-swiper', {
            slidesPerView: 4,
            spaceBetween: 10,
            watchSlidesProgress: true
        });
        
        // Link the two swipers
        if (mainSwiper && thumbsSwiper) {
            mainSwiper.thumbs = { swiper: thumbsSwiper };
            mainSwiper.thumbs.init();
        }
        
        // Size selection with enhanced visual feedback and debugging
        // Use setTimeout to ensure the DOM is fully loaded
        setTimeout(() => {
            const sizeBtns = document.querySelectorAll('.size-btn:not(.disabled)');
            const selectedSizeInput = document.getElementById('selectedSizeId');
            const addToCartBtn = document.getElementById('addToCartBtn');
            const selectedQuantityInput = document.getElementById('selectedQuantity');
            const stockDisplay = document.getElementById('stockDisplay');
            const availableStockEl = document.getElementById('availableStock');
            
            console.log('Delayed check - Size buttons found:', sizeBtns.length);
            console.log('Delayed check - Stock display element:', stockDisplay);
            
            // Force initialize stock display
            if (stockDisplay) {
                stockDisplay.style.display = 'none';
            }
        }, 100);
        
        // Register click handlers both ways for maximum compatibility
        // Method 1: Using forEach
        sizeBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                console.log('Size button clicked:', this.textContent.trim());
                console.log('Size ID:', this.getAttribute('data-size-id'));
                console.log('Stock quantity:', this.getAttribute('data-stock'));
                
                // Visual feedback - remove active class from all buttons
                sizeBtns.forEach(b => {
                    b.classList.remove('active');
                    b.style.transform = 'scale(1)';
                    b.style.boxShadow = 'none';
                });
                
                // Add active class to clicked button with enhanced animation
                this.classList.add('active');
                
                // Add dramatic pulse animation
                this.style.transform = 'scale(1.2)';
                this.style.boxShadow = '0 8px 15px rgba(78, 115, 223, 0.5)';
                
                // After initial animation, settle to slightly elevated state
                setTimeout(() => {
                    this.style.transform = 'scale(1.1)';
                    this.style.boxShadow = '0 6px 12px rgba(78, 115, 223, 0.4)';
                }, 200);
                
                const sizeId = this.getAttribute('data-size-id');
                const stock = parseInt(this.getAttribute('data-stock'));
                
                // Update hidden input for form submission
                selectedSizeInput.value = sizeId;
                addToCartBtn.disabled = false;
                
                // Show stock information
                availableStockEl.textContent = stock;
                
                // Make sure the stock display is visible
                stockDisplay.style.display = 'block'; // Force display block
                stockDisplay.classList.add('show');
                
                console.log('Stock display updated:', stock);
                console.log('Stock display visibility:', stockDisplay.style.display);
                
                // Add visual feedback on the button too
                addToCartBtn.classList.add('pulse-once');
                setTimeout(() => {
                    addToCartBtn.classList.remove('pulse-once');
                }, 500);
            });
        });
        
        // Method 2: Using document event delegation (more reliable for dynamically loaded content)
        document.addEventListener('click', function(e) {
            // Check if clicked element is a size button
            if (e.target.classList.contains('size-btn') && !e.target.classList.contains('disabled')) {
                console.log('Size button clicked via delegation:', e.target.textContent.trim());
                
                // Get all size buttons
                const allSizeBtns = document.querySelectorAll('.size-btn:not(.disabled)');
                
                // Visual feedback - remove active class from all buttons
                allSizeBtns.forEach(b => {
                    b.classList.remove('active');
                    b.style.transform = 'scale(1)';
                    b.style.boxShadow = 'none';
                });
                
                // Add active class to clicked button with enhanced animation
                e.target.classList.add('active');
                
                // Add dramatic pulse animation
                e.target.style.transform = 'scale(1.2)';
                e.target.style.boxShadow = '0 8px 15px rgba(78, 115, 223, 0.5)';
                
                // After initial animation, settle to slightly elevated state
                setTimeout(() => {
                    e.target.style.transform = 'scale(1.1)';
                    e.target.style.boxShadow = '0 6px 12px rgba(78, 115, 223, 0.4)';
                }, 200);
                
                const sizeId = e.target.getAttribute('data-size-id');
                const stock = parseInt(e.target.getAttribute('data-stock'));
                
                // Update hidden input for form submission
                document.getElementById('selectedSizeId').value = sizeId;
                document.getElementById('addToCartBtn').disabled = false;
                
                // Show stock information
                document.getElementById('availableStock').textContent = stock;
                
                // Make sure the stock display is visible
                const stockDisplay = document.getElementById('stockDisplay');
                stockDisplay.style.display = 'block';
                stockDisplay.classList.add('show');
            }
        });
    });
</script>

<!-- Additional jQuery script for enhanced debugging and functionality -->
<script>
    $(document).ready(function() {
        console.log("jQuery document ready");
        
        // Debug initialization
        console.log("Size buttons found: " + $('.size-btn:not(.disabled)').length);
        console.log("Stock display element exists: " + ($('#stockDisplay').length > 0));
        
        // Force the stock display to be hidden initially
        $('#stockDisplay').hide();
        
        // Add jQuery click handlers as backup to make sure they work
        $('.size-btn:not(.disabled)').on('click', function() {
            const sizeId = $(this).data('size-id');
            const stock = $(this).data('stock');
            
            console.log("jQuery click handler - Size clicked: " + $(this).text().trim());
            console.log("jQuery click handler - Size ID: " + sizeId);
            console.log("jQuery click handler - Stock: " + stock);
            
            // Visual feedback
            $('.size-btn').removeClass('active');
            $(this).addClass('active');
            
            // Update form data
            $('#selectedSizeId').val(sizeId);
            $('#addToCartBtn').prop('disabled', false);
            
            // Show stock information
            $('#availableStock').text(stock);
            $('#stockDisplay').show().addClass('show');
            
            // Enhanced visual effect
            $(this).css({
                'transform': 'scale(1.2)',
                'box-shadow': '0 8px 15px rgba(78, 115, 223, 0.5)'
            });
            
            setTimeout(() => {
                $(this).css({
                    'transform': 'scale(1.1)',
                    'box-shadow': '0 6px 12px rgba(78, 115, 223, 0.4)'
                });
            }, 200);
        });
        
        // Add to Cart button click handler (AJAX)
        $('#addToCartBtn').on('click', function() {
            // Get form data
            const productId = $('#selectedProductId').val();
            const sizeId = $('#selectedSizeId').val();
            const quantity = $('#selectedQuantity').val();
            
            // Validation
            if (!sizeId) {
                alert('Please select a size first');
                return;
            }
            
            // Disable button to prevent multiple clicks
            $(this).prop('disabled', true);
            $(this).html('<i class="fas fa-spinner fa-spin me-2"></i>Adding...');
            
            // AJAX call to add to cart
            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/cart/add',
                data: {
                    productId: productId,
                    sizeId: sizeId,
                    quantity: quantity
                },
                dataType: 'json',
                success: function(response) {
                    // Re-enable button
                    $('#addToCartBtn').prop('disabled', false);
                    $('#addToCartBtn').html('<i class="fas fa-shopping-cart me-2"></i>Add to Cart');
                    
                    if (response.success) {
                        // Show success message
                        $('#cartMessage').text(response.message);
                        $('#cartAlert').addClass('show alert-success').removeClass('alert-danger');
                        
                        // Update cart count in header if present
                        if (response.cartCount) {
                            // Find the cart button and update badge
                            const cartBtn = $('a[href="${pageContext.request.contextPath}/cart"]');
                            const cartBadge = cartBtn.find('.badge');
                            
                            if (cartBadge.length) {
                                cartBadge.text(response.cartCount);
                            } else {
                                cartBtn.append('<span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">' + response.cartCount + '</span>');
                            }
                            
                            // Add pulse animation to cart button
                            cartBtn.addClass('pulse-once');
                            setTimeout(function() {
                                cartBtn.removeClass('pulse-once');
                            }, 500);
                        }
                        
                        // Add pulse animation to cart icon in header
                        $('.fa-shopping-cart').parent().addClass('pulse-once');
                        setTimeout(function() {
                            $('.fa-shopping-cart').parent().removeClass('pulse-once');
                        }, 500);
                    } else {
                        // Show error message
                        $('#cartMessage').text(response.message || 'Failed to add item to cart');
                        $('#cartAlert').addClass('show alert-danger').removeClass('alert-success');
                    }
                    
                    // Auto-dismiss alert after 5 seconds
                    setTimeout(function() {
                        $('#cartAlert').removeClass('show');
                    }, 5000);
                },
                error: function() {
                    // Re-enable button
                    $('#addToCartBtn').prop('disabled', false);
                    $('#addToCartBtn').html('<i class="fas fa-shopping-cart me-2"></i>Add to Cart');
                    
                    // Show error message
                    $('#cartMessage').text('Error connecting to server');
                    $('#cartAlert').addClass('show alert-danger').removeClass('alert-success');
                }
            });
        });
    });
</script>
</body>
</html>