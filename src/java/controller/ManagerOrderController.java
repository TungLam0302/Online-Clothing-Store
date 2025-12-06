package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import dao.CategoryDAO;
import dao.BrandDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.OrderItem;
import model.Category;
import model.Brand;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Manager Order Controller - Handles order management for managers
 */
@WebServlet(name = "ManagerOrderController", urlPatterns = {
    "/manager/orders",
    "/manager/order-detail",
    "/manager/update-order-status"
})
public class ManagerOrderController extends HttpServlet {

    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private BrandDAO brandDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a manager
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || user.getRoleID() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            loadCommonData(request);
            
            switch (path) {
                case "/manager/orders":
                    showOrderList(request, response);
                    break;
                case "/manager/order-detail":
                    showOrderDetail(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a manager
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || user.getRoleID() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            if ("/manager/update-order-status".equals(path)) {
                updateOrderStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Show all orders for manager
     */
    private void showOrderList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String searchTerm = request.getParameter("search");
        
        // Get all orders
        List<Order> orders = orderDAO.getAllOrders();
        
        // Apply filters if provided
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
            int statusId = Integer.parseInt(statusFilter);
            orders = orders.stream()
                    .filter(order -> order.getStatusID() == statusId)
                    .collect(java.util.stream.Collectors.toList());
        }
        
        if (searchTerm != null && !searchTerm.isEmpty()) {
            orders = orders.stream()
                    .filter(order -> String.valueOf(order.getOrderID()).contains(searchTerm) ||
                                   order.getShippingAddress().toLowerCase().contains(searchTerm.toLowerCase()))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        request.setAttribute("orders", orders);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchTerm", searchTerm);
        
        request.getRequestDispatcher("/view/manager/orderList.jsp").forward(request, response);
    }

    /**
     * Show order detail for manager
     */
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/orders");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // Get order details
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                request.setAttribute("errorMessage", "Order not found");
                request.getRequestDispatcher("/view/manager/orderList.jsp").forward(request, response);
                return;
            }
            
            // Get order items
            List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);
            
            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            
            request.getRequestDispatcher("/view/manager/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/orders");
        }
    }

    /**
     * Update order status
     */
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            String orderIdStr = request.getParameter("orderId");
            String newStatusStr = request.getParameter("newStatus");
            
            if (orderIdStr == null || newStatusStr == null) {
                out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            int newStatus = Integer.parseInt(newStatusStr);
            
            // Validate status (1: Pending, 2: Processing, 3: Shipped, 4: Delivered, 5: Cancelled)
            if (newStatus < 1 || newStatus > 5) {
                out.print("{\"success\": false, \"message\": \"Invalid status\"}");
                return;
            }
            
            // Update order status
            boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
            
            if (success) {
                // Get status name
                String statusName = getStatusName(newStatus);
                out.print("{\"success\": true, \"message\": \"Order status updated successfully\", \"statusName\": \"" + statusName + "\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update order status\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid parameters\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"An error occurred: " + e.getMessage() + "\"}");
        }
    }

    /**
     * Get status name by ID
     */
    private String getStatusName(int statusId) {
        switch (statusId) {
            case 1: return "Pending";
            case 2: return "Processing";
            case 3: return "Shipped";
            case 4: return "Delivered";
            case 5: return "Cancelled";
            default: return "Unknown";
        }
    }

    /**
     * Load common data for all pages
     */
    private void loadCommonData(HttpServletRequest request) {
        try {
            List<Category> categories = categoryDAO.getAllCategories();
            List<Brand> brands = brandDAO.getAllBrands();
            
            request.setAttribute("categories", categories);
            request.setAttribute("brands", brands);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
