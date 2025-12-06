<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Sidebar -->
<div class="sidebar">
    <!-- Search Box -->
    <div class="search-box mb-4">
        <form action="${pageContext.request.contextPath}/home" method="get">
            <div class="input-group">
                <input type="text" class="form-control" placeholder="Search products..." 
                       name="search" value="${param.search}">
                <button class="btn btn-primary" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </form>
    </div>

    <!-- Categories -->
    <div class="categories-box">
        <h5 class="sidebar-title">Categories</h5>
        <ul class="categories-list">
            <c:forEach var="parentCategory" items="${parentCategories}">
                <li class="parent-category">
                    <a class="parent-category-link" href="#category${parentCategory.categoryID}" 
                       role="button" aria-expanded="false">
                        ${parentCategory.categoryName}
                        <i class="fas fa-chevron-down float-end category-chevron"></i>
                    </a>
                    <div class="collapse subcategories" id="category${parentCategory.categoryID}">
                        <ul class="subcategories-list">
                            <c:forEach var="subcategory" items="${categories}">
                                <c:if test="${subcategory.parentCategoryID == parentCategory.categoryID}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/home?category=${subcategory.categoryID}" 
                                           class="subcategory-link ${param.category == subcategory.categoryID ? 'active' : ''}">
                                            ${subcategory.categoryName}
                                        </a>
                                    </li>
                                </c:if>
                            </c:forEach>
                        </ul>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </div>

    <!-- Brand Filter -->
    <div class="filter-box mt-4">
        <h5 class="sidebar-title">Brands</h5>
        <div class="brands-list">
            <form action="${pageContext.request.contextPath}/home" method="get">
                <input type="hidden" name="category" value="${param.category}">
                <input type="hidden" name="search" value="${param.search}">

                <c:forEach var="brand" items="${brands}">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="${brand.brandID}" 
                               id="brand${brand.brandID}" name="brand" 
                               <c:forEach items="${paramValues.brand}" var="checkedBrand">
                                   <c:if test="${checkedBrand == brand.brandID}">checked</c:if>
                               </c:forEach> >
                        <label class="form-check-label" for="brand${brand.brandID}">
                            ${brand.brandName}
                        </label>
                    </div>
                </c:forEach>

                <button type="submit" class="btn btn-primary btn-sm w-100 mt-3">Apply Filters</button>
            </form>
        </div>
    </div>
</div>

<style>
    .sidebar {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 0 15px rgba(0,0,0,0.05);
        padding: 20px;
        height: 100%;
        margin-bottom: 30px;
    }
    .sidebar-title {
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 15px;
        color: #333;
        position: relative;
        padding-bottom: 10px;
    }
    .sidebar-title::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 50px;
        height: 2px;
        background-color: #4e73df;
    }
    .categories-list {
        list-style-type: none;
        padding-left: 0;
        margin-bottom: 0;
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
        color: #4e73df;
        text-decoration: none;
    }
    .subcategories {
        margin-top: 5px;
        overflow: hidden;
        transition: max-height 0.3s ease;
    }
    .subcategories.show {
        /* max-height không cần đặt nếu bạn dùng class .show của Bootstrap */
    }
    .subcategories-list {
        list-style-type: none;
        padding-left: 15px;
        margin: 0;
    }
    .subcategory-link {
        display: block;
        padding: 6px 0;
        color: #6c757d;
        text-decoration: none;
        font-size: 0.9rem;
        transition: color 0.3s;
    }
    .subcategory-link:hover,
    .subcategory-link.active {
        color: #4e73df;
        text-decoration: none;
    }
    .category-chevron {
        transition: transform 0.3s ease;
    }
    .filter-box {
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 15px;
    }
    .brands-list {
        max-height: 200px;
        overflow-y: auto;
    }
    .form-check {
        margin-bottom: 8px;
    }
    .form-check-input:checked {
        background-color: #4e73df;
        border-color: #4e73df;
    }
    @media (max-width: 991.98px) {
        .sidebar {
            margin-bottom: 30px;
        }
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const categoryLinks = document.querySelectorAll('.parent-category-link');

        categoryLinks.forEach(link => {
            link.addEventListener('click', function (e) {
                e.preventDefault();

                const targetId = this.getAttribute('href').substring(1);
                const targetEl = document.getElementById(targetId);
                const chevronIcon = this.querySelector('.category-chevron');

                // Chỉ toggle class 'show'
                const isNowShown = targetEl.classList.toggle('show');
                this.setAttribute('aria-expanded', isNowShown);
                chevronIcon.style.transform = isNowShown
                        ? 'rotate(180deg)'
                        : 'rotate(0deg)';
            });
        });

        // Nếu đã có active subcategory, mở parent ngay khi load
        const activeSub = document.querySelector('.subcategory-link.active');
        if (activeSub) {
            const parentCollapse = activeSub.closest('.subcategories');
            if (parentCollapse) {
                parentCollapse.classList.add('show');
                const parentLink = document.querySelector(`[href="#${parentCollapse.id}"]`);
                parentLink.setAttribute('aria-expanded', 'true');
                const chevron = parentLink.querySelector('.category-chevron');
                chevron.style.transform = 'rotate(180deg)';
            }
        }
    });
</script>
