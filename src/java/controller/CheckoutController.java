package controller;

import dao.BrandDAO;
import dao.CartDAO;
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
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import model.Brand;
import model.Cart;
import model.Category;
import model.User;

/**
 * Controller for handling checkout operations
 */
@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout", "/placeorder"})
public class CheckoutController extends HttpServlet {

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

        // View checkout page
        if (path.equals("/checkout")) {
            showCheckoutPage(request, response);
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

        // Place order
        if (path.equals("/placeorder")) {
            placeOrder(request, response);
        }
    }

    /**
     * Show checkout page with selected cart items
     */
    private void showCheckoutPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // Redirect to login if not logged in
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get selected cart items
        String itemsParam = request.getParameter("items");
        if (itemsParam == null || itemsParam.trim().isEmpty()) {
            // No items selected, redirect back to cart
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            // Parse selected cart item IDs
            List<Integer> selectedItemIds = Arrays.stream(itemsParam.split(","))
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());

            // Get cart items for the user
            CartDAO cartDAO = new CartDAO();
            List<Cart> allCartItems = cartDAO.getCartItems(user.getUserID());

            // Filter selected items
            List<Cart> selectedItems = allCartItems.stream()
                    .filter(item -> selectedItemIds.contains(item.getCartID()))
                    .collect(Collectors.toList());

            // Calculate order total
            double orderTotal = 0;
            for (Cart item : selectedItems) {
                double price = Double.parseDouble(item.getProductItem().getProduct().getPrice());
                orderTotal += price * item.getQuantity();
            }

            // Load categories and brands for the header/footer
            CategoryDAO categoryDAO = new CategoryDAO();
            BrandDAO brandDAO = new BrandDAO();
            
            List<Category> allCategories = categoryDAO.getAllCategories();
            List<Category> parentCategories = new ArrayList<>();

            // Filter parent categories
            for (Category category : allCategories) {
                if (category.getParentCategoryID() == null) {
                    parentCategories.add(category);
                }
            }
            
            List<Brand> brands = brandDAO.getAllBrands();
            
            // Set attributes
            request.setAttribute("selectedItems", selectedItems);
            request.setAttribute("orderTotal", orderTotal);
            request.setAttribute("categories", allCategories);
            request.setAttribute("parentCategories", parentCategories);
            request.setAttribute("brands", brands);
            request.setAttribute("selectedItemIds", itemsParam); // Keep the original string for the form
            
            // Forward to checkout page
            request.getRequestDispatcher("/view/customer/checkout.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in showCheckoutPage method: " + e.getMessage());
            e.printStackTrace();
            
            // Set error message and redirect to cart
            request.getSession().setAttribute("errorMessage", "Failed to load checkout: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    /**
     * Place an order with selected cart items
     */
    private void placeOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (user == null) {
            out.print("{\"success\": false, \"message\": \"Please login to place an order\"}");
            out.flush();
            return;
        }

        // Get parameters
        String selectedItemsParam = request.getParameter("selectedItems");
        String shippingAddress = request.getParameter("shippingAddress");
        String orderTotalParam = request.getParameter("orderTotal");
        
        // Validate parameters
        if (selectedItemsParam == null || orderTotalParam == null || shippingAddress == null || shippingAddress.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Invalid parameters\"}");
            out.flush();
            return;
        }

        try {
            // Parse selected cart item IDs
            List<Integer> selectedItemIds = Arrays.stream(selectedItemsParam.split(","))
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
            
            double orderTotal = Double.parseDouble(orderTotalParam);

            // Get selected cart items
            CartDAO cartDAO = new CartDAO();
            List<Cart> allCartItems = cartDAO.getCartItems(user.getUserID());
            
            // Filter selected items
            List<Cart> selectedItems = allCartItems.stream()
                    .filter(item -> selectedItemIds.contains(item.getCartID()))
                    .collect(Collectors.toList());

            if (selectedItems.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"No items selected for checkout\"}");
                out.flush();
                return;
            }

            // Create order
            OrderDAO orderDAO = new OrderDAO();
            int orderId = orderDAO.createOrder(user.getUserID(), orderTotal, shippingAddress);

            if (orderId == -1) {
                out.print("{\"success\": false, \"message\": \"Failed to create order\"}");
                out.flush();
                return;
            }

            // Add order items
            boolean itemsAdded = orderDAO.addOrderItems(orderId, selectedItems);

            if (!itemsAdded) {
                out.print("{\"success\": false, \"message\": \"Failed to add order items\"}");
                out.flush();
                return;
            }

            // Remove ordered items from cart
            orderDAO.removeOrderedCartItems(user.getUserID(), selectedItemIds);

            // Success
            out.print("{\"success\": true, \"message\": \"Order placed successfully\", \"orderId\": " + orderId + "}");
            out.flush();
            
            // Store success message in session for redirect
            session.setAttribute("orderSuccessMessage", "Order #" + orderId + " placed successfully!");
            session.setAttribute("orderId", orderId);

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid parameter format\"}");
            out.flush();
        } catch (Exception e) {
            System.out.println("Error in placeOrder method: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error processing order: " + e.getMessage() + "\"}");
            out.flush();
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Checkout Controller";
    }
}
