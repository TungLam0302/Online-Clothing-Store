<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<footer class="footer bg-white text-center py-3">
    <div class="container-fluid">
        <span class="text-muted">
            © 2024 ClotherOnline Admin Panel. All rights reserved.
        </span>
    </div>
</footer>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<style>
    .footer {
        border-top: 1px solid #e9ecef;
        box-shadow: 0 -2px 4px rgba(0,0,0,0.05);
        font-size: 0.875rem;
        position: fixed;
        left: 250px;
        bottom: 0;
        width: calc(100% - 250px);
        z-index: 1020;
        background-color: white;
        padding: 10px 0;
        height: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    @media (max-width: 767.98px) {
        .footer {
            left: 0;
            width: 100%;
        }
    }
</style>
