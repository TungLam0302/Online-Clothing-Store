<%-- 
    Document   : dashboard
    Created on : Jul 10, 2025, 9:12:16 PM
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
        <title>Dashboard - ClotherOnline</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8f9fa;
                padding-top: 60px;
                margin-left: 260px;
            }
            
            .main-content {
                margin-left: 260px;
                margin-top: 60px;
                padding: 30px;
            }
            
            .page-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }
            
            .stats-card {
                background: white;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: none;
            }
            
            .stats-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            }
            
            .stats-icon {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                color: white;
                margin-bottom: 15px;
            }
            
            .stats-icon.orders {
                background: linear-gradient(45deg, #ff6b6b, #ee5a24);
            }
            
            .stats-icon.users {
                background: linear-gradient(45deg, #4ecdc4, #44a08d);
            }
            
            .stats-icon.products {
                background: linear-gradient(45deg, #45b7d1, #3742fa);
            }
            
            .stats-icon.revenue {
                background: linear-gradient(45deg, #96ceb4, #2dd4bf);
            }
            
            .stats-number {
                font-size: 2.5rem;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 5px;
            }
            
            .stats-label {
                color: #7f8c8d;
                font-size: 0.9rem;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .chart-container {
                background: white;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            }
            
            .chart-wrapper {
                height: 400px;
                position: relative;
            }
            
            .btn-group .btn {
                font-size: 0.875rem;
                padding: 0.375rem 0.75rem;
            }
            
            .btn-group .btn.active {
                background-color: #4e73df;
                border-color: #4e73df;
                color: white;
            }
            
            .chart-title {
                color: #2c3e50;
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
            }
            
            .chart-title i {
                margin-right: 10px;
                color: #3498db;
            }
            
            .revenue-section {
                background: white;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            }
            
            .revenue-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #ecf0f1;
            }
            
            .revenue-item:last-child {
                border-bottom: none;
            }
            
            .revenue-label {
                color: #7f8c8d;
                font-weight: 500;
            }
            
            .revenue-amount {
                font-size: 1.2rem;
                font-weight: 600;
                color: #27ae60;
            }
            
            .order-status-card {
                background: white;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            }
            
            .status-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 0;
            }
            
            .status-label {
                color: #7f8c8d;
                font-weight: 500;
            }
            
            .status-number {
                font-size: 1.1rem;
                font-weight: 600;
                color: #2c3e50;
            }
            
            .alert {
                border-radius: 15px;
                margin-bottom: 20px;
                border: none;
            }
            
            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                    padding: 15px;
                }
                
                .stats-number {
                    font-size: 2rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Check if user is logged in and has admin/manager role -->
        <c:if test="${empty sessionScope.user || (sessionScope.user.roleID != 2 && sessionScope.user.roleID != 3)}">
            <c:redirect url="/login" />
        </c:if>
        
        <!-- Include Admin Header -->
        <jsp:include page="../layout/adminheader.jsp"/>
        
        <!-- Include Admin Sidebar -->
        <jsp:include page="../layout/adminSideBar.jsp"/>
        
        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="mb-2">Dashboard</h1>
                        <p class="mb-0 opacity-75">Welcome back, ${sessionScope.user.name}! Here's what's happening with your business.</p>
                    </div>
                    <div>
                        <i class="fas fa-chart-line fa-3x opacity-50"></i>
                    </div>
                </div>
            </div>
            
            <!-- Error Alert -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <!-- Statistics Cards -->
            <div class="row">
                <div class="col-xl-3 col-md-6">
                    <div class="stats-card">
                        <div class="stats-icon orders">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="stats-number">
                            <fmt:formatNumber value="${totalOrders}" type="number" />
                        </div>
                        <div class="stats-label">Total Orders</div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6">
                    <div class="stats-card">
                        <div class="stats-icon users">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stats-number">
                            <fmt:formatNumber value="${totalUsers}" type="number" />
                        </div>
                        <div class="stats-label">Total Users</div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6">
                    <div class="stats-card">
                        <div class="stats-icon products">
                            <i class="fas fa-box"></i>
                        </div>
                        <div class="stats-number">
                            <fmt:formatNumber value="${totalProducts}" type="number" />
                        </div>
                        <div class="stats-label">Total Products</div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6">
                    <div class="stats-card">
                        <div class="stats-icon revenue">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stats-number">
                            <fmt:formatNumber value="${revenueToday}" type="currency" currencySymbol="$" />
                        </div>
                        <div class="stats-label">Today's Revenue</div>
                    </div>
                </div>
            </div>
            
            <!-- Revenue and Chart Section -->
            <div class="row">
                <div class="col-xl-8">
                    <!-- Chart Tabs -->
                    <div class="chart-container">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3 class="chart-title mb-0">
                                <i class="fas fa-chart-area"></i>
                                Revenue Analytics
                            </h3>
                            <!-- Chart Type Buttons -->
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-sm btn-outline-primary active" onclick="showChart('daily')">7 Days</button>
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="showChart('monthly')">12 Months</button>
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="showChart('quarterly')">4 Quarters</button>
                            </div>
                        </div>
                        
                        <!-- Daily Chart -->
                        <div id="dailyChart" class="chart-wrapper">
                            <canvas id="revenueChart" height="100"></canvas>
                        </div>
                        
                        <!-- Monthly Chart -->
                        <div id="monthlyChart" class="chart-wrapper" style="display: none;">
                            <canvas id="monthlyRevenueChart" height="100"></canvas>
                        </div>
                        
                        <!-- Quarterly Chart -->
                        <div id="quarterlyChart" class="chart-wrapper" style="display: none;">
                            <canvas id="quarterlyRevenueChart" height="100"></canvas>
                        </div>
                    </div>
                </div>
                
                <div class="col-xl-4">
                    <!-- Revenue Summary -->
                    <div class="revenue-section">
                        <h3 class="chart-title">
                            <i class="fas fa-money-bill-wave"></i>
                            Revenue Summary
                        </h3>
                        <div class="revenue-item">
                            <span class="revenue-label">Today</span>
                            <span class="revenue-amount">
                                <fmt:formatNumber value="${revenueToday}" type="currency" currencySymbol="$" />
                            </span>
                        </div>
                        <div class="revenue-item">
                            <span class="revenue-label">This Week</span>
                            <span class="revenue-amount">
                                <fmt:formatNumber value="${revenueThisWeek}" type="currency" currencySymbol="$" />
                            </span>
                        </div>
                        <div class="revenue-item">
                            <span class="revenue-label">This Month</span>
                            <span class="revenue-amount">
                                <fmt:formatNumber value="${revenueThisMonth}" type="currency" currencySymbol="$" />
                            </span>
                        </div>
                        <div class="revenue-item">
                            <span class="revenue-label">This Quarter</span>
                            <span class="revenue-amount">
                                <fmt:formatNumber value="${revenueThisQuarter}" type="currency" currencySymbol="$" />
                            </span>
                        </div>
                        <div class="revenue-item">
                            <span class="revenue-label">This Year</span>
                            <span class="revenue-amount">
                                <fmt:formatNumber value="${revenueThisYear}" type="currency" currencySymbol="$" />
                            </span>
                        </div>
                    </div>
                    
                    <!-- Order Status -->
                    <div class="order-status-card">
                        <h3 class="chart-title">
                            <i class="fas fa-clipboard-list"></i>
                            Order Status
                        </h3>
                        <div class="status-item">
                            <span class="status-label">Pending Orders</span>
                            <span class="status-number">
                                <fmt:formatNumber value="${pendingOrders}" type="number" />
                            </span>
                        </div>
                        <div class="status-item">
                            <span class="status-label">Delivered Orders</span>
                            <span class="status-number">
                                <fmt:formatNumber value="${completedOrders}" type="number" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Include Footer -->
        <jsp:include page="../layout/footer.jsp"/>
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Initialize Bootstrap dropdowns -->
        <script>
            // Initialize Bootstrap dropdowns after DOM is loaded
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize all dropdowns
                var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
                var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
                    return new bootstrap.Dropdown(dropdownToggleEl);
                });
            });
        </script>
        
        <!-- Chart.js Configuration -->
        <script>
            // Global chart variables
            let dailyChart, monthlyChart, quarterlyChart;
            
            // Data from server
            const dailyRevenueData = [
                <c:forEach var="revenue" items="${last7DaysRevenue}" varStatus="status">
                    ${revenue}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            const dailyLabels = [
                <c:forEach var="label" items="${last7DaysLabels}" varStatus="status">
                    '${label}'<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            const monthlyRevenueData = [
                <c:forEach var="revenue" items="${last12MonthsRevenue}" varStatus="status">
                    ${revenue}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            const monthlyLabels = [
                <c:forEach var="label" items="${last12MonthsLabels}" varStatus="status">
                    '${label}'<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            const quarterlyRevenueData = [
                <c:forEach var="revenue" items="${last4QuartersRevenue}" varStatus="status">
                    ${revenue}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            const quarterlyLabels = [
                <c:forEach var="label" items="${last4QuartersLabels}" varStatus="status">
                    '${label}'<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            // Chart options
            const chartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        labels: {
                            font: {
                                size: 12,
                                family: 'Inter'
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: 'white',
                        bodyColor: 'white',
                        borderColor: 'rgb(75, 192, 192)',
                        borderWidth: 1,
                        callbacks: {
                            label: function(context) {
                                return 'Revenue: $' + context.parsed.y.toLocaleString();
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            },
                            font: {
                                size: 11,
                                family: 'Inter'
                            }
                        },
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)'
                        }
                    },
                    x: {
                        ticks: {
                            font: {
                                size: 11,
                                family: 'Inter'
                            }
                        },
                        grid: {
                            display: false
                        }
                    }
                }
            };
            
            // Initialize charts when DOM is loaded
            document.addEventListener('DOMContentLoaded', function() {
                initializeCharts();
            });
            
            function initializeCharts() {
                // Daily Revenue Chart
                const dailyCtx = document.getElementById('revenueChart').getContext('2d');
                dailyChart = new Chart(dailyCtx, {
                    type: 'line',
                    data: {
                        labels: dailyLabels,
                        datasets: [{
                            label: 'Daily Revenue ($)',
                            data: dailyRevenueData,
                            borderColor: 'rgb(75, 192, 192)',
                            backgroundColor: 'rgba(75, 192, 192, 0.1)',
                            borderWidth: 3,
                            fill: true,
                            tension: 0.4,
                            pointBackgroundColor: 'rgb(75, 192, 192)',
                            pointBorderColor: '#fff',
                            pointBorderWidth: 2,
                            pointRadius: 6
                        }]
                    },
                    options: chartOptions
                });
                
                // Monthly Revenue Chart
                const monthlyCtx = document.getElementById('monthlyRevenueChart').getContext('2d');
                monthlyChart = new Chart(monthlyCtx, {
                    type: 'bar',
                    data: {
                        labels: monthlyLabels,
                        datasets: [{
                            label: 'Monthly Revenue ($)',
                            data: monthlyRevenueData,
                            backgroundColor: 'rgba(54, 162, 235, 0.6)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 2,
                            borderRadius: 4,
                            borderSkipped: false
                        }]
                    },
                    options: chartOptions
                });
                
                // Quarterly Revenue Chart
                const quarterlyCtx = document.getElementById('quarterlyRevenueChart').getContext('2d');
                quarterlyChart = new Chart(quarterlyCtx, {
                    type: 'doughnut',
                    data: {
                        labels: quarterlyLabels,
                        datasets: [{
                            label: 'Quarterly Revenue ($)',
                            data: quarterlyRevenueData,
                            backgroundColor: [
                                'rgba(255, 99, 132, 0.6)',
                                'rgba(54, 162, 235, 0.6)',
                                'rgba(255, 205, 86, 0.6)',
                                'rgba(75, 192, 192, 0.6)'
                            ],
                            borderColor: [
                                'rgba(255, 99, 132, 1)',
                                'rgba(54, 162, 235, 1)',
                                'rgba(255, 205, 86, 1)',
                                'rgba(75, 192, 192, 1)'
                            ],
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: true,
                                position: 'bottom',
                                labels: {
                                    font: {
                                        size: 12,
                                        family: 'Inter'
                                    }
                                }
                            },
                            tooltip: {
                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                titleColor: 'white',
                                bodyColor: 'white',
                                callbacks: {
                                    label: function(context) {
                                        return context.label + ': $' + context.parsed.toLocaleString();
                                    }
                                }
                            }
                        }
                    }
                });
            }
            
            // Function to switch between charts
            function showChart(type) {
                // Hide all charts
                document.getElementById('dailyChart').style.display = 'none';
                document.getElementById('monthlyChart').style.display = 'none';
                document.getElementById('quarterlyChart').style.display = 'none';
                
                // Remove active class from all buttons
                document.querySelectorAll('.btn-group .btn').forEach(btn => {
                    btn.classList.remove('active');
                });
                
                // Show selected chart and set active button
                if (type === 'daily') {
                    document.getElementById('dailyChart').style.display = 'block';
                    event.target.classList.add('active');
                } else if (type === 'monthly') {
                    document.getElementById('monthlyChart').style.display = 'block';
                    event.target.classList.add('active');
                } else if (type === 'quarterly') {
                    document.getElementById('quarterlyChart').style.display = 'block';
                    event.target.classList.add('active');
                }
            }
        </script>
    </body>
</html>
