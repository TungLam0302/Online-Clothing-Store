<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <jsp:include page="../layout/adminheader.jsp" />
    <div class="content-wrapper">
        <jsp:include page="../layout/adminSideBar.jsp">
            <jsp:param name="activePage" value="products"/>
        </jsp:include>
        
        <main class="main-content">
            <div class="container-fluid px-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center border-bottom mb-3 pt-2 pb-2">
                    <h1 class="h2"><i class="fas fa-tshirt me-2"></i>Product Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="addProduct" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Add New Product
                        </a>
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>

                <div class="card border-0 shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4">ID</th>
                                        <th>Thumbnail</th>
                                        <th>Name</th>
                                        <th>Brand</th>
                                        <th>Category</th>
                                        <th>Price</th>
                                        <th>Status</th>
                                        <th class="text-end pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty products}">
                                            <c:forEach var="product" items="${products}">
                                                <tr>
                                                    <td class="ps-4">${product.productID}</td>
                                                    <td>
                                                        <c:if test="${not empty product.thumbnail}">
                                                            <img src="${pageContext.request.contextPath}/${product.thumbnail}" 
                                                                 alt="${product.productName}" 
                                                                 style="max-width: 80px; max-height: 80px; object-fit: cover;">
                                                        </c:if>
                                                    </td>
                                                    <td>${product.productName}</td>
                                                    <td>${product.brand.brandName}</td>
                                                    <td>${product.category.categoryName}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${product.status ? 'bg-success' : 'bg-danger'}">
                                                            ${product.status ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td class="text-end pe-4">
                                                        <div class="d-flex justify-content-end">
                                                            <a href="updateProduct?id=${product.productID}" 
                                                               class="btn btn-outline-primary btn-sm me-2">
                                                                <i class="fas fa-edit me-1"></i>Edit
                                                            </a>
                                                            <button class="btn btn-outline-danger btn-sm" 
                                                                    onclick="confirmDelete('${product.productID}')">
                                                                <i class="fas fa-trash me-1"></i>Delete
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8" class="text-center py-4">
                                                    <p class="text-muted mb-0">No products found. Add a new product to get started.</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <script>
        function confirmDelete(productId) {
            if (confirm('Are you sure you want to delete this product? This will mark the product as inactive.')) {
                window.location.href = '${pageContext.request.contextPath}/product?action=delete&id=' + productId;
            }
        }
    </script>
</body>
</html> 