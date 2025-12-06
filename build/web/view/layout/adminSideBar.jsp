<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Sidebar -->
<div class="sidebar" style="background-color: #2c3e50;">
    <div class="sidebar-content">

        
        <ul class="nav flex-column">
            <!-- Dashboard - Available to both Admin and Manager -->
            <c:if test="${sessionScope.user.roleID == 2 || sessionScope.user.roleID == 3}">
                <li class="nav-item">
                    <a class="nav-link ${param.activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                    </a>
                </li>
            </c:if>
            
            <!-- Admin Only Section -->
            <c:if test="${sessionScope.user.roleID == 2}">
                <li class="nav-item mt-3">
                    <div class="sidebar-heading px-3 py-1 text-uppercase fs-7 text-light opacity-75">
                        <span>Admin Controls</span>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activePage == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users?action=list">
                        <i class="fas fa-users-cog me-2"></i> User Management
                    </a>
                </li>
            </c:if>
            
            <!-- Content Management - Available to both Admin and Manager -->
            <c:if test="${sessionScope.user.roleID == 3}">
                <li class="nav-item mt-3">
                    <div class="sidebar-heading px-3 py-1 text-uppercase fs-7 text-light opacity-75">
                        <span>Content</span>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activePage == 'products' ? 'active' : ''}" href="${pageContext.request.contextPath}/product?action=list">
                        <i class="fas fa-tshirt me-2"></i> Products
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activePage == 'brands' ? 'active' : ''}" href="${pageContext.request.contextPath}/brand?action=list">
                        <i class="fas fa-tags me-2"></i> Brands
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activePage == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/category?action=list">
                        <i class="fas fa-layer-group me-2"></i> Categories
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activePage == 'sizes' ? 'active' : ''}" href="${pageContext.request.contextPath}/size?action=list">
                        <i class="fas fa-ruler me-2"></i> Sizes
                    </a>
                </li>
            </c:if>
            
            <!-- Sales Management - Available to both Admin and Manager -->
            <c:if test="${sessionScope.user.roleID == 3}">
                <li class="nav-item mt-3">
                    <div class="sidebar-heading px-3 py-1 text-uppercase fs-7 text-light opacity-75">
                        <span>Sales</span>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activePage == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/manager/orders">
                        <i class="fas fa-shopping-cart me-2"></i> Orders
                    </a>
                </li>
            </c:if>
        </ul>
    </div>
</div>

<style>
    body, html {
        height: 100%;
        margin: 0;
        padding: 0;
        overflow-x: hidden;
    }
    .sidebar {
        position: fixed;
        top: 59px;
        bottom: 0;
        left: 0;
        z-index: 1040;
        width: 260px;
        padding-top: 0;
        overflow-y: auto;
        transition: all 0.3s;
        background-color: #1e2a36 !important;
    }
    .sidebar-content {
        height: 100%;
    }
    .sidebar .nav-link {
        color: rgba(255,255,255,0.7) !important;
        padding: 10px 15px;
        transition: all 0.3s ease;
        border-left: 3px solid transparent;
    }
    .sidebar .nav-link:hover {
        color: white !important;
        background-color: rgba(255,255,255,0.1);
        transform: translateX(5px);
    }
    .sidebar .nav-link.active {
        color: white !important;
        background-color: rgba(255,255,255,0.1);
        border-left: 3px solid #4e73df;
        font-weight: bold;
    }
    .sidebar .nav-link i {
        margin-right: 10px;
        width: 20px;
        text-align: center;
    }
    .sidebar-heading {
        font-size: 0.75rem;
        letter-spacing: 1px;
    }
    .user-info {
        background-color: rgba(0, 0, 0, 0.15);
    }
    .fs-7 {
        font-size: 0.8rem;
    }
    @media (max-width: 767.98px) {
        .sidebar {
            width: 100%;
            height: auto;
            position: static;
            top: 0;
            padding-top: 0;
        }
    }
</style>
