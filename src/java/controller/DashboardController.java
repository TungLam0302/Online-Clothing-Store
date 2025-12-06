package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import dao.UserDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Dashboard Controller for Admin and Manager
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {
    
    private OrderDAO orderDAO;
    private UserDAO userDAO;
    private ProductDAO productDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
        userDAO = new UserDAO();
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and has admin/manager role
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || (currentUser.getRoleID() != 2 && currentUser.getRoleID() != 3)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get dashboard statistics
            Map<String, Object> dashboardData = getDashboardData();
            
            // Set attributes for JSP
            request.setAttribute("totalOrders", dashboardData.get("totalOrders"));
            request.setAttribute("totalUsers", dashboardData.get("totalUsers"));
            request.setAttribute("totalProducts", dashboardData.get("totalProducts"));
            request.setAttribute("revenueToday", dashboardData.get("revenueToday"));
            request.setAttribute("revenueThisWeek", dashboardData.get("revenueThisWeek"));
            request.setAttribute("revenueThisMonth", dashboardData.get("revenueThisMonth"));
            request.setAttribute("revenueThisQuarter", dashboardData.get("revenueThisQuarter"));
            request.setAttribute("revenueThisYear", dashboardData.get("revenueThisYear"));
            request.setAttribute("revenueLastMonth", dashboardData.get("revenueLastMonth"));
            request.setAttribute("revenueLastYear", dashboardData.get("revenueLastYear"));
            request.setAttribute("last7DaysRevenue", dashboardData.get("last7DaysRevenue"));
            request.setAttribute("last7DaysLabels", dashboardData.get("last7DaysLabels"));
            request.setAttribute("last12MonthsRevenue", dashboardData.get("last12MonthsRevenue"));
            request.setAttribute("last12MonthsLabels", dashboardData.get("last12MonthsLabels"));
            request.setAttribute("last4QuartersRevenue", dashboardData.get("last4QuartersRevenue"));
            request.setAttribute("last4QuartersLabels", dashboardData.get("last4QuartersLabels"));
            request.setAttribute("pendingOrders", dashboardData.get("pendingOrders"));
            request.setAttribute("completedOrders", dashboardData.get("completedOrders"));
            request.setAttribute("activePage", "dashboard");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/dashboard.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard data: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/dashboard.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * Get all dashboard statistics
     */
    private Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();
        
        try {
            // Get basic counts
            data.put("totalOrders", orderDAO.getTotalOrderCount());
            data.put("totalUsers", userDAO.getTotalUserCount());
            data.put("totalProducts", productDAO.getTotalProductCount());
            
            // Get revenue statistics
            data.put("revenueToday", orderDAO.getRevenueByDate(LocalDate.now()));
            data.put("revenueThisWeek", orderDAO.getRevenueThisWeek());
            data.put("revenueThisMonth", orderDAO.getRevenueThisMonth());
            
            // Get current year, quarter, month, week
            LocalDate now = LocalDate.now();
            int currentYear = now.getYear();
            int currentMonth = now.getMonthValue();
            int currentQuarter = (currentMonth - 1) / 3 + 1;
            
            // Calculate week of year
            java.time.temporal.WeekFields weekFields = java.time.temporal.WeekFields.of(java.util.Locale.getDefault());
            int currentWeek = now.get(weekFields.weekOfWeekBasedYear());
            
            // Get additional revenue statistics
            data.put("revenueThisQuarter", orderDAO.getRevenueByQuarter(currentYear, currentQuarter));
            data.put("revenueThisYear", orderDAO.getRevenueByYear(currentYear));
            data.put("revenueLastMonth", orderDAO.getRevenueByMonth(currentYear, Math.max(1, currentMonth - 1)));
            data.put("revenueLastYear", orderDAO.getRevenueByYear(currentYear - 1));
            
            // Get last 7 days revenue data for chart
            List<Double> last7DaysRevenue = new ArrayList<>();
            List<String> last7DaysLabels = new ArrayList<>();
            
            for (int i = 6; i >= 0; i--) {
                LocalDate date = LocalDate.now().minusDays(i);
                BigDecimal revenue = orderDAO.getRevenueByDate(date);
                // Convert BigDecimal to Double for JavaScript
                last7DaysRevenue.add(revenue != null ? revenue.doubleValue() : 0.0);
                last7DaysLabels.add(date.format(DateTimeFormatter.ofPattern("dd/MM")));
            }
            
            data.put("last7DaysRevenue", last7DaysRevenue);
            data.put("last7DaysLabels", last7DaysLabels);
            
            // Get last 12 months revenue data for monthly chart
            List<Double> last12MonthsRevenue = new ArrayList<>();
            List<String> last12MonthsLabels = new ArrayList<>();
            
            for (int i = 11; i >= 0; i--) {
                LocalDate monthDate = now.minusMonths(i);
                BigDecimal revenue = orderDAO.getRevenueByMonth(monthDate.getYear(), monthDate.getMonthValue());
                last12MonthsRevenue.add(revenue != null ? revenue.doubleValue() : 0.0);
                last12MonthsLabels.add(monthDate.format(DateTimeFormatter.ofPattern("MM/yyyy")));
            }
            
            data.put("last12MonthsRevenue", last12MonthsRevenue);
            data.put("last12MonthsLabels", last12MonthsLabels);
            
            // Get last 4 quarters revenue data
            List<Double> last4QuartersRevenue = new ArrayList<>();
            List<String> last4QuartersLabels = new ArrayList<>();
            
            for (int i = 3; i >= 0; i--) {
                LocalDate quarterDate = now.minusMonths(i * 3);
                int year = quarterDate.getYear();
                int quarter = (quarterDate.getMonthValue() - 1) / 3 + 1;
                BigDecimal revenue = orderDAO.getRevenueByQuarter(year, quarter);
                last4QuartersRevenue.add(revenue != null ? revenue.doubleValue() : 0.0);
                last4QuartersLabels.add("Q" + quarter + "/" + year);
            }
            
            data.put("last4QuartersRevenue", last4QuartersRevenue);
            data.put("last4QuartersLabels", last4QuartersLabels);
            
            // Get order status counts
            data.put("pendingOrders", orderDAO.getOrderCountByStatus("Pending"));
            data.put("completedOrders", orderDAO.getOrderCountByStatus("Delivered"));
            
        } catch (Exception e) {
            e.printStackTrace();
            // Set default values in case of error
            data.put("totalOrders", 0);
            data.put("totalUsers", 0);
            data.put("totalProducts", 0);
            data.put("revenueToday", BigDecimal.ZERO);
            data.put("revenueThisWeek", BigDecimal.ZERO);
            data.put("revenueThisMonth", BigDecimal.ZERO);
            data.put("revenueThisQuarter", BigDecimal.ZERO);
            data.put("revenueThisYear", BigDecimal.ZERO);
            data.put("revenueLastMonth", BigDecimal.ZERO);
            data.put("revenueLastYear", BigDecimal.ZERO);
            data.put("last7DaysRevenue", new ArrayList<>());
            data.put("last7DaysLabels", new ArrayList<>());
            data.put("last12MonthsRevenue", new ArrayList<>());
            data.put("last12MonthsLabels", new ArrayList<>());
            data.put("last4QuartersRevenue", new ArrayList<>());
            data.put("last4QuartersLabels", new ArrayList<>());
            data.put("pendingOrders", 0);
            data.put("completedOrders", 0);
        }
        
        return data;
    }
}
