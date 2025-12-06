package controller;

import dao.BrandDAO;
import dao.CategoryDAO;
import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import model.Brand;
import model.Category;
import model.Order;
import model.OrderItem;
import model.Status;
import model.User;

/**
 * Controller for handling order operations
 */
@WebServlet(name = "OrderController", urlPatterns = {
    "/orders",
    "/order-detail",
    "/cancel-order"
})
public class OrderController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // Redirect to login if not logged in
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Load common data for all pages (categories for navbar)
        loadCommonData(request);

        // Handle different paths
        switch (path) {
            case "/orders":
                // Display order history
                showOrderHistory(request, response, user);
                break;
                
            case "/order-detail":
                // Display order details
                showOrderDetail(request, response, user);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                break;
        }
    }
    

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // Redirect to login if not logged in
            if (path.equals("/cancel-order")) {
                // For AJAX requests, return JSON error
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false,\"message\":\"User not logged in\"}");
                out.flush();
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        // Handle different paths
        switch (path) {
            case "/cancel-order":
                // Cancel an order
                cancelOrder(request, response, user);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/orders");
                break;
        }
    }
    
    /**
     * Show order history for a user
     */
    private void showOrderHistory(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getOrdersByUser(user.getUserID());
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/view/customer/order-history.jsp").forward(request, response);
    }
    
    /**
     * Show details for a specific order
     */
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("id");
        
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                // Order not found
                request.setAttribute("errorMessage", "Order not found");
                request.getRequestDispatcher("/view/customer/order-history.jsp").forward(request, response);
                return;
            }
            
            // Security check: Only allow users to view their own orders
            if (order.getUserID() != user.getUserID()) {
                request.setAttribute("errorMessage", "You don't have permission to view this order");
                request.getRequestDispatcher("/view/customer/order-history.jsp").forward(request, response);
                return;
            }
            
            // Get order items separately
            List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);
            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.getRequestDispatcher("/view/customer/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }
    
    /**
     * Cancel an order (AJAX)
     */
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Simple response object without using JSONObject
        StringBuilder jsonResponse = new StringBuilder("{");
        
        String orderIdStr = request.getParameter("id");
        
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            jsonResponse.append("\"success\":false,\"message\":\"Invalid order ID\"}");
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            
            // First check if the order exists and belongs to this user
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                jsonResponse.append("\"success\":false,\"message\":\"Order not found\"}");
                out.print(jsonResponse.toString());
                out.flush();
                return;
            }
            
            // Security check: Only allow users to cancel their own orders
            if (order.getUserID() != user.getUserID()) {
                jsonResponse.append("\"success\":false,\"message\":\"You don't have permission to cancel this order\"}");
                out.print(jsonResponse.toString());
                out.flush();
                return;
            }
            
            // Check if the order can be cancelled (status = 1: Pending)
            if (order.getStatusID() != 1) {
                jsonResponse.append("\"success\":false,\"message\":\"Only pending orders can be cancelled\"}");
                out.print(jsonResponse.toString());
                out.flush();
                return;
            }
            
            // Cancel the order - just update the status to 5 (Cancelled)
            boolean success = orderDAO.updateOrderStatus(orderId, 5);
            
            if (success) {
                // Get the status name
                String statusName = "Cancelled";
                
                jsonResponse.append("\"success\":true,\"message\":\"Order cancelled successfully\",")
                           .append("\"newStatus\":\"").append(statusName).append("\",")
                           .append("\"newStatusId\":5}");
            } else {
                jsonResponse.append("\"success\":false,\"message\":\"Failed to cancel order\"}");
            }
            
            out.print(jsonResponse.toString());
            out.flush();
            
        } catch (NumberFormatException e) {
            jsonResponse.append("\"success\":false,\"message\":\"Invalid order ID format\"}");
            out.print(jsonResponse.toString());
            out.flush();
        }
    }
    
    /**
     * Load common data for the view (categories, brands)
     */
    private void loadCommonData(HttpServletRequest request) {
        // Load categories for navbar
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> allCategories = categoryDAO.getAllCategories();
        List<Category> parentCategories = new ArrayList<>();
        
        // Filter parent categories (parentCategoryID = 0 or null)
        for (Category category : allCategories) {
            Integer parentCategoryID = category.getParentCategoryID();
            if (parentCategoryID == null || parentCategoryID == 0) {
                parentCategories.add(category);
            }
        }
        
        // Load brands
        BrandDAO brandDAO = new BrandDAO();
        List<Brand> brands = brandDAO.getAllBrands();
        
        // Set attributes
        request.setAttribute("categories", allCategories);
        request.setAttribute("parentCategories", parentCategories);
        request.setAttribute("brands", brands);
    }
    
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Order Controller Servlet";
    }
}
