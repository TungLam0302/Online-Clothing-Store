<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        /* Reset and Base Styles */
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Wrapper and Layout */
        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        #sidebar {
            width: 250px;
            background-color: #343a40;
            color: white;
        }

        .content-wrapper {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            width: calc(100% - 250px);
        }

        .main-content {
            flex-grow: 1;
            padding: 20px;
        }

        /* Container and Form Sections */
        .update-product-container {
            max-width: 1000px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border-radius: 8px;
        }

        .form-section {
            background-color: #ffffff;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .form-section-header {
            background-color: #4e73df;
            color: white;
            padding: 10px 15px;
            border-radius: 4px 4px 0 0;
            margin: -20px -20px 20px;
            display: flex;
            align-items: center;
        }

        .form-section-header i {
            margin-right: 10px;
        }

        /* Image Preview */
        .image-preview-container {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }

        .image-preview {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }

        .image-preview:hover {
            transform: scale(1.05);
        }

        /* Form Actions */
        .form-actions {
            position: sticky;
            bottom: 0;
            left: 0;
            right: 0;
            background-color: white;
            padding: 15px;
            box-shadow: 0 -2px 5px rgba(0,0,0,0.1);
            text-align: center;
            z-index: 1000;
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .wrapper {
                flex-direction: column;
            }

            #sidebar {
                width: 100%;
            }

            .content-wrapper {
                width: 100%;
            }

            .update-product-container {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <jsp:include page="../layout/adminSideBar.jsp">
            <jsp:param name="activePage" value="products"/>
        </jsp:include>

        <div class="content-wrapper">
            <jsp:include page="../layout/adminheader.jsp" />

            <main class="main-content">
                <div class="update-product-container">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form id="updateProductForm" action="${pageContext.request.contextPath}/updateProduct" method="post" enctype="multipart/form-data" novalidate>
                        <input type="hidden" name="productId" value="${product.productID}">

                        <div class="form-section">
                            <div class="form-section-header">
                                <i class="fas fa-info-circle"></i>
                                Product Information
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Product Name</label>
                                    <input type="text" class="form-control" id="name" name="name" 
                                           value="${product.productName}" required minlength="3" maxlength="100">
                                    <div class="invalid-feedback">Please enter a valid product name (3-100 characters).</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="price" class="form-label">Price</label>
                                    <input type="number" step="0.01" class="form-control" id="price" name="price" 
                                           value="${product.price}" required min="0" max="1000000">
                                    <div class="invalid-feedback">Please enter a valid price (0-1,000,000).</div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="4" 
                                          maxlength="2000">${product.desciption}</textarea>
                                <div class="invalid-feedback">Description cannot exceed 2000 characters.</div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="brandID" class="form-label">Brand</label>
                                    <select class="form-select" id="brandID" name="brandID" required>
                                        <option value="">Select Brand</option>
                                        <c:forEach var="brand" items="${brands}">
                                            <option value="${brand.brandID}" 
                                                    ${product.brand.brandID == brand.brandID ? 'selected' : ''}>
                                                ${brand.brandName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">Please select a brand.</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="categoryID" class="form-label">Category</label>
                                    <select class="form-select" id="categoryID" name="categoryID" required>
                                        <option value="">Select Category</option>
                                        <c:forEach var="rootCategory" items="${categories}">
                                            <c:if test="${rootCategory.parentCategoryID == null}">
                                                <optgroup label="${rootCategory.categoryName}">
                                                    <c:forEach var="subcategory" items="${categories}">
                                                        <c:if test="${subcategory.parentCategoryID == rootCategory.categoryID}">
                                                            <option value="${subcategory.categoryID}" 
                                                                    ${product.category.categoryID == subcategory.categoryID ? 'selected' : ''}>
                                                                ${subcategory.categoryName} (${rootCategory.categoryName})
                                                            </option>
                                                        </c:if>
                                                    </c:forEach>
                                                </optgroup>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">Please select a category.</div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="status" class="form-label">Product Status</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="1" ${product.status ? 'selected' : ''}>Active</option>
                                        <option value="0" ${!product.status ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <div class="form-section-header">
                                <i class="fas fa-layer-group"></i>
                                Product Sizes and Stock
                            </div>
                            <p class="text-muted mb-3">Manage product sizes and their stock quantities.</p>
                            <div id="sizeStockContainer" class="mb-3">
                                <c:forEach var="size" items="${sizes}">
                                    <div class="row mb-3 size-stock-row">
                                        <div class="col-md-6">
                                            <div class="form-check">
                                                <c:set var="isChecked" value="false"/>
                                                <c:set var="quantity" value="0"/>
                                                <c:forEach var="productItem" items="${productItems}">
                                                    <c:if test="${productItem.size.sizeID == size.sizeID}">
                                                        <c:set var="isChecked" value="true"/>
                                                        <c:set var="quantity" value="${productItem.stockQuantity}"/>
                                                    </c:if>
                                                </c:forEach>
                                                <input class="form-check-input size-select" type="checkbox" 
                                                       id="size${size.sizeID}" 
                                                       name="sizes" 
                                                       value="${size.sizeID}"
                                                       ${quantity > 0 ? 'checked' : ''}>
                                                <label class="form-check-label" for="size${size.sizeID}">
                                                    ${size.sizeName}
                                                </label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <input type="number" 
                                                   class="form-control stock-quantity" 
                                                   name="stock_${size.sizeID}" 
                                                   placeholder="Stock Quantity" 
                                                   min="0" max="10000"
                                                   value="${quantity}"
                                                   >
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="form-section">
                            <div class="form-section-header">
                                <i class="fas fa-image"></i>
                                Product Images
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="thumbnail" class="form-label">Main Product Image (Thumbnail)</label>
                                    <input type="file" class="form-control" id="thumbnail" name="thumbnail" 
                                           accept="image/*" onchange="previewThumbnail(this)">
                                    <div class="image-preview-container mt-3">
                                        <c:if test="${not empty product.thumbnail}">
                                            <div class="thumbnail-preview-wrapper">
                                                <img id="thumbnailPreview" 
                                                     src="${pageContext.request.contextPath}/${product.thumbnail}" 
                                                     class="image-preview">
                                                <span class="remove-thumbnail-btn" onclick="removeThumbnail()">×</span>
                                            </div>
                                            <p class="text-muted">Current thumbnail</p>
                                        </c:if>
                                        <c:if test="${empty product.thumbnail}">
                                            <p class="text-muted">No thumbnail selected</p>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="images" class="form-label">Additional Product Images (Optional)</label>
                                    <input type="file" class="form-control" id="images" name="images" 
                                           accept="image/*" multiple onchange="previewImages(this)">
                                    <div class="mt-3">
                                        <p class="fw-bold mb-2">Current additional images:</p>
                                        <div class="image-preview-container" id="currentImagePreviewContainer">
                                            <c:forEach var="image" items="${images}">
                                                <div class="image-preview-wrapper">
                                                    <img src="${pageContext.request.contextPath}/${image.url}" 
                                                         class="image-preview">
                                                    <input type="checkbox" name="deleteImages" 
                                                           value="${image.url}" class="delete-image-checkbox">
                                                    <span class="remove-image-btn">×</span>
                                                </div>
                                            </c:forEach>
                                            <c:if test="${empty images}">
                                                <p class="text-muted">No additional images</p>
                                            </c:if>
                                        </div>
                                        <p class="fw-bold mb-2 mt-3">New images to upload:</p>
                                        <div class="image-preview-container" id="newImagePreviewContainer">
                                            <p class="text-muted">No new images selected</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <style>
                            .image-preview-wrapper {
                                position: relative;
                                display: inline-block;
                                margin: 5px;
                            }
                            .remove-thumbnail-btn, 
                            .remove-image-btn {
                                position: absolute;
                                top: 0;
                                right: 0;
                                background-color: rgba(255,0,0,0.7);
                                color: white;
                                border-radius: 50%;
                                width: 20px;
                                height: 20px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                cursor: pointer;
                            }
                            .delete-image-checkbox {
                                position: absolute;
                                bottom: 0;
                                left: 0;
                            }
                        </style>

                        <script>
                            function previewThumbnail(input) {
                                const thumbnailPreviewContainer = document.querySelector('.image-preview-container');
                                const currentThumbnailPreview = document.getElementById('thumbnailPreview');
                                
                                if (input.files && input.files[0]) {
                                    const reader = new FileReader();
                                    reader.onload = function(e) {
                                        if (!currentThumbnailPreview) {
                                            const img = document.createElement('img');
                                            img.id = 'thumbnailPreview';
                                            img.className = 'image-preview';
                                            img.src = e.target.result;
                                            
                                            const wrapper = document.createElement('div');
                                            wrapper.className = 'thumbnail-preview-wrapper';
                                            
                                            const removeBtn = document.createElement('span');
                                            removeBtn.className = 'remove-thumbnail-btn';
                                            removeBtn.innerHTML = '×';
                                            removeBtn.onclick = removeThumbnail;
                                            
                                            wrapper.appendChild(img);
                                            wrapper.appendChild(removeBtn);
                                            
                                            thumbnailPreviewContainer.innerHTML = '';
                                            thumbnailPreviewContainer.appendChild(wrapper);
                                        } else {
                                            currentThumbnailPreview.src = e.target.result;
                                        }
                                    };
                                    reader.readAsDataURL(input.files[0]);
                                }
                            }

                            function removeThumbnail() {
                                const thumbnailInput = document.getElementById('thumbnail');
                                const thumbnailPreviewContainer = document.querySelector('.image-preview-container');
                                
                                thumbnailInput.value = ''; // Clear the file input
                                thumbnailPreviewContainer.innerHTML = '<p class="text-muted">No thumbnail selected</p>';
                            }

                            function previewImages(input) {
                                const newImagePreviewContainer = document.getElementById('newImagePreviewContainer');
                                newImagePreviewContainer.innerHTML = ''; // Clear previous previews
                                
                                if (input.files && input.files.length > 0) {
                                    Array.from(input.files).forEach(file => {
                                        const reader = new FileReader();
                                        reader.onload = function(e) {
                                            const wrapper = document.createElement('div');
                                            wrapper.className = 'image-preview-wrapper';
                                            
                                            const img = document.createElement('img');
                                            img.src = e.target.result;
                                            img.className = 'image-preview';
                                            
                                            const removeBtn = document.createElement('span');
                                            removeBtn.className = 'remove-image-btn';
                                            removeBtn.innerHTML = '×';
                                            removeBtn.onclick = function() {
                                                wrapper.remove();
                                                updateFileInput();
                                            };
                                            
                                            wrapper.appendChild(img);
                                            wrapper.appendChild(removeBtn);
                                            
                                            newImagePreviewContainer.appendChild(wrapper);
                                        };
                                        reader.readAsDataURL(file);
                                    });
                                } else {
                                    newImagePreviewContainer.innerHTML = '<p class="text-muted">No new images selected</p>';
                                }
                            }

                            function updateFileInput() {
                                const imagesInput = document.getElementById('images');
                                const newImagePreviewContainer = document.getElementById('newImagePreviewContainer');
                                const remainingImages = newImagePreviewContainer.querySelectorAll('.image-preview-wrapper');
                                
                                if (remainingImages.length === 0) {
                                    imagesInput.value = ''; // Clear input if no images
                                    newImagePreviewContainer.innerHTML = '<p class="text-muted">No new images selected</p>';
                                }
                            }

                            // Add event listener to enable/disable stock input when size checkbox is toggled
                            document.addEventListener('DOMContentLoaded', function() {
                                const sizeCheckboxes = document.querySelectorAll('.size-select');
                                
                                // Function to toggle input field enabled state
                                function toggleInputField(checkbox) {
                                    const sizeID = checkbox.value;
                                    const stockInput = document.querySelector(`input[name="stock_${sizeID}"]`);
                                    if (stockInput) {
                                        stockInput.disabled = !checkbox.checked;
                                        if (checkbox.checked) {
                                            // Ensure there's a valid value when checked
                                            if (stockInput.value === '' || stockInput.value === '0') {
                                                stockInput.value = '1'; // Default to 1 when enabling with no value
                                            }
                                        } else {
                                            stockInput.value = '0'; // Set to 0 when unchecked
                                        }
                                    }
                                }
                                
                                // Add event listeners to all checkboxes
                                sizeCheckboxes.forEach(checkbox => {
                                    // Initialize state
                                    toggleInputField(checkbox);
                                    
                                    // Add change event listener
                                    checkbox.addEventListener('change', function() {
                                        toggleInputField(this);
                                    });
                                });

                                // Add form submit handler to ensure all selected sizes have values
                                document.getElementById('updateProductForm').addEventListener('submit', function(e) {
                                    const selectedCheckboxes = document.querySelectorAll('.size-select:checked');
                                    selectedCheckboxes.forEach(checkbox => {
                                        const sizeID = checkbox.value;
                                        const stockInput = document.querySelector(`input[name="stock_${sizeID}"]`);
                                        if (stockInput && (stockInput.value === '' || isNaN(parseInt(stockInput.value)))) {
                                            stockInput.value = '1'; // Ensure a default value
                                        }
                                    });
                                });
                            });
                        </script>
                        <div>
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i> Update Product
                            </button>
                            <a href="${pageContext.request.contextPath}/productList" class="btn btn-secondary btn-lg ms-3">
                                <i class="fas fa-times me-2"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </main>

            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
</body>
</html>