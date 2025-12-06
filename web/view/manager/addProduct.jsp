<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add New Product</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="../layout/adminheader.jsp" />
        <style>
            /* Full-width, full-height layout */
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .content-wrapper {
                display: flex;
                min-height: calc(100vh - 60px); /* Subtract header height */
                background-color: #f4f6f9;
            }
            .main-content {
                flex-grow: 1;
                overflow-y: auto;
                padding: 20px;
                margin-left: 250px; /* Sidebar width */
            }

            /* Page header styling */
            .content-header {
                margin-bottom: 25px;
            }
            .content-header h1 {
                font-size: 28px;
                color: #2c3e50;
                font-weight: 600;
                margin-bottom: 10px;
                padding-bottom: 10px;
                border-bottom: 1px solid #e9ecef;
            }

            /* Form container styling */
            .form-container {
                max-width: 100%;
                background-color: white;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                padding: 30px;
                margin-bottom: 60px; /* Space for fixed action buttons */
            }

            /* Form Sections */
            .form-sections {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-bottom: 20px;
            }

            .form-section {
                background-color: #fff;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                flex: 1 1 400px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
                border: 1px solid #eaeaea;
            }

            .form-section-title {
                font-size: 18px;
                color: #2c3e50;
                font-weight: 600;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 1px solid #e9ecef;
            }

            /* Form Group Styling */
            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #4a5568;
            }

            /* Input Styling */
            .form-control, .form-select {
                width: 100%;
                padding: 12px 15px;
                border-radius: 8px;
                border: 1px solid #cbd5e0;
                background-color: #fff;
                font-size: 15px;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                outline: none;
                border-color: #4299e1;
                box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.2);
            }

            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }

            /* File Upload Styling */
            .file-upload-container {
                position: relative;
                margin-bottom: 15px;
            }

            .file-upload-wrapper {
                position: relative;
                border: 2px dashed #cbd5e0;
                border-radius: 8px;
                padding: 30px 20px;
                text-align: center;
                transition: all 0.3s ease;
                background-color: #f8fafc;
                cursor: pointer;
            }

            .file-upload-wrapper:hover {
                background-color: #edf2f7;
                border-color: #4299e1;
            }

            .file-upload-input {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                opacity: 0;
                cursor: pointer;
            }

            .file-upload-icon {
                font-size: 32px;
                color: #4299e1;
                margin-bottom: 10px;
            }

            .file-upload-text {
                font-size: 14px;
                color: #4a5568;
            }

            .preview-container {
                margin-top: 15px;
            }

            #preview {
                max-width: 200px;
                max-height: 200px;
                display: none;
                margin: 10px auto;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .preview-images {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin-top: 10px;
            }

            .preview-images img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            /* Size and Stock Styling */
            .sizes-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 15px;
            }

            .size-item {
                background-color: #f9fafb;
                border-radius: 8px;
                padding: 15px;
                border: 1px solid #e5e7eb;
            }

            .size-header {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }

            .size-checkbox {
                margin-right: 10px;
            }

            .size-label {
                font-weight: 500;
                margin: 0;
            }

            .stock-input {
                width: 100%;
            }

            /* Action Buttons */
            .form-actions {
                position: fixed;
                bottom: 0;
                left: 250px;
                right: 0;
                background-color: white;
                padding: 15px 20px;
                box-shadow: 0 -4px 10px rgba(0,0,0,0.1);
                z-index: 1050;
                display: flex;
                justify-content: center;
                gap: 15px;
            }

            .btn {
                padding: 12px 25px;
                border-radius: 8px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                min-width: 150px;
                text-align: center;
                display: inline-block;
            }

            .btn-success {
                background-color: #48bb78;
                color: white;
                border: none;
            }

            .btn-success:hover {
                background-color: #38a169;
            }

            .btn-secondary {
                background-color: #a0aec0;
                color: white;
                border: none;
                text-decoration: none;
            }

            .btn-secondary:hover {
                background-color: #718096;
            }

            /* Responsive Adjustments */
            @media (max-width: 1200px) {
                .form-sections {
                    flex-direction: column;
                }
            }

            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                    padding: 15px;
                }

                .form-container {
                    padding: 20px;
                    border-radius: 8px;
                }

                .sizes-container {
                    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                }

                .form-actions {
                    left: 0;
                    padding: 12px 15px;
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                    margin-bottom: 8px;
                }
            }
        </style>
    </head>
    <body>
        <div class="content-wrapper">
            <jsp:include page="../layout/adminSideBar.jsp">
                <jsp:param name="activePage" value="products"/>
            </jsp:include>

            <main class="main-content">
                <section class="content-header">
                    <h1>Add New Product</h1>
                </section>

                <section class="content">


                    <div class="form-container">
                        <form action="addProduct" method="post" enctype="multipart/form-data">

                            <!-- Basic Information Section -->
                            <div class="form-sections">
                                <div class="form-section">
                                    <h3 class="form-section-title">Basic Information</h3>

                                    <div class="form-group">
                                        <label for="name">Product Name</label>
                                        <input type="text" class="form-control" id="name" name="name" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="description">Description</label>
                                        <textarea class="form-control" id="description" name="description" required></textarea>
                                    </div>

                                    <div class="form-group">
                                        <label for="price">Price ($)</label>
                                        <input type="number" class="form-control" id="price" name="price" step="0.01" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="status">Status</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="1">Active</option>
                                            <option value="0">Inactive</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Classification Section -->
                                <div class="form-section">
                                    <h3 class="form-section-title">Classification</h3>

                                    <div class="form-group">
                                        <label for="brand">Brand</label>
                                        <select class="form-select" id="brand" name="brandID">
                                            <c:forEach items="${brands}" var="brand">
                                                <option value="${brand.brandID}">${brand.brandName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="category">Subcategory</label>
                                        <select class="form-select" id="category" name="categoryID">
                                            <option value="">-- Categroy --</option>
                                            <c:forEach items="${categories}" var="category">
                                                <!-- Chỉ render những category có parentCategoryID (>0) -->
                                                <c:if test="${category.parentCategoryID != null && category.parentCategoryID > 0}">
                                                    <option value="${category.categoryID}"
                                                            ${param.categoryID == category.categoryID ? 'selected' : ''}>
                                                        ${category.categoryName}
                                                    </option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                    </div>

                                </div>
                            </div>

                            <!-- Images Section -->
                            <div class="form-section">
                                <h3 class="form-section-title">Product Images</h3>

                                <div class="form-group">
                                    <label for="thumbnail">Main Product Image (Thumbnail)</label>
                                    <div class="file-upload-container">
                                        <div class="file-upload-wrapper">
                                            <input type="file" class="file-upload-input" id="thumbnail" name="thumbnail" accept="image/*" required>
                                            <div class="file-upload-icon">
                                                ⬆️
                                            </div>
                                            <div class="file-upload-text">Click or drag main product image here</div>
                                        </div>
                                        <div class="preview-container">
                                            <img id="preview" src="#" alt="Thumbnail Preview">
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="images">Additional Product Images (Optional)</label>
                                    <div class="file-upload-container">
                                        <div class="file-upload-wrapper">
                                            <input type="file" class="file-upload-input" id="images" name="images" accept="image/*" multiple>
                                            <div class="file-upload-icon">
                                                🖼️
                                            </div>
                                            <div class="file-upload-text">Click or drag additional product images here</div>
                                        </div>
                                        <div class="preview-images" id="preview-images"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Sizes and Stock Section -->
                            <div class="form-section">
                                <h3 class="form-section-title">Sizes and Stock</h3>

                                <div class="sizes-container">
                                    <c:forEach items="${sizes}" var="size">
                                        <div class="size-item">
                                            <div class="size-header">
                                                <input class="size-checkbox" type="checkbox" id="size${size.sizeID}" name="sizes" value="${size.sizeID}">
                                                <label class="size-label" for="size${size.sizeID}">${size.sizeName}</label>
                                            </div>
                                            <input type="number" class="form-control stock-input" name="stock_${size.sizeID}" placeholder="Stock Quantity" min="0">
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div>
                                <button type="submit" class="btn btn-success">Add Product</button>
                                <a href="product" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </section>
            </main>
        </div>

        <script src="${pageContext.request.contextPath}/asset/js/jquery-2.2.3.min.js"></script>
        <script src="${pageContext.request.contextPath}/asset/js/bootstrap2.min.js"></script>
        <script src="${pageContext.request.contextPath}/asset/js/app.min.js"></script>
        <script>
            // Form submission debugging
            document.querySelector('form').addEventListener('submit', function (e) {
                console.log('Form submission triggered');

                // Log form data
                const formData = new FormData(this);
                console.log('Form data being submitted:');
                for (let pair of formData.entries()) {
                    console.log(pair[0] + ': ' + pair[1]);
                }

                // Check required fields
                const name = document.getElementById('name').value;
                const price = document.getElementById('price').value;
                const brand = document.getElementById('brand').value;
                const category = document.getElementById('category').value;
                const thumbnail = document.getElementById('thumbnail').files;

                console.log('Required fields check:');
                console.log('Name: ' + (name ? 'filled' : 'empty'));
                console.log('Price: ' + (price ? 'filled' : 'empty'));
                console.log('Brand: ' + (brand ? 'filled' : 'empty'));
                console.log('Category: ' + (category ? 'filled' : 'empty'));
                console.log('Thumbnail: ' + (thumbnail.length > 0 ? 'selected' : 'not selected'));
            });
        </script>
        <script>
            // Handle thumbnail preview
            document.getElementById('thumbnail').addEventListener('change', function (event) {
                var reader = new FileReader();
                reader.onload = function () {
                    var img = document.getElementById('preview');
                    img.src = reader.result;
                    img.style.display = 'block';

                    // Update file upload text to show selected file name
                    var fileName = event.target.files[0].name;
                    var uploadText = this.parentElement.querySelector('.file-upload-text');
                    if (uploadText) {
                        uploadText.textContent = 'Selected: ' + fileName;
                    }
                };

                if (event.target.files.length > 0) {
                    reader.readAsDataURL(event.target.files[0]);

                    // Update file upload appearance
                    var wrapper = this.closest('.file-upload-wrapper');
                    if (wrapper) {
                        wrapper.style.borderColor = '#48bb78';
                        wrapper.style.backgroundColor = '#f0fff4';
                    }
                }
            });

            // Handle multiple images preview
            document.getElementById('images').addEventListener('change', function (event) {
                var previewContainer = document.getElementById('preview-images');
                previewContainer.innerHTML = '';

                if (event.target.files.length > 0) {
                    // Update file upload text to show count of selected files
                    var fileCount = event.target.files.length;
                    var uploadText = this.parentElement.querySelector('.file-upload-text');
                    if (uploadText) {
                        uploadText.textContent = 'Selected: ' + fileCount + ' image' + (fileCount > 1 ? 's' : '');
                    }

                    // Update file upload appearance
                    var wrapper = this.closest('.file-upload-wrapper');
                    if (wrapper) {
                        wrapper.style.borderColor = '#48bb78';
                        wrapper.style.backgroundColor = '#f0fff4';
                    }

                    // Create preview for each selected file
                    Array.from(event.target.files).forEach(file => {
                        var reader = new FileReader();
                        reader.onload = function () {
                            var img = document.createElement('img');
                            img.src = reader.result;
                            previewContainer.appendChild(img);
                        };
                        reader.readAsDataURL(file);
                    });
                }
            });

            // Size checkbox and stock quantity interaction
            document.querySelectorAll('.size-checkbox').forEach(function (checkbox) {
                checkbox.addEventListener('change', function () {
                    var stockInput = this.closest('.size-item').querySelector('.stock-input');
                    if (this.checked) {
                        stockInput.focus();
                        stockInput.setAttribute('required', 'required');
                    } else {
                        stockInput.removeAttribute('required');
                        stockInput.value = '';
                    }
                });
            });

            // Make the entire file upload area clickable
            document.querySelectorAll('.file-upload-wrapper').forEach(function (wrapper) {
                wrapper.addEventListener('click', function (e) {
                    if (e.target !== this.querySelector('.file-upload-input')) {
                        this.querySelector('.file-upload-input').click();
                    }
                });
            });
        </script>
    </body>
</html>
