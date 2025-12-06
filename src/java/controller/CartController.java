package controller;

import dao.BrandDAO;
import dao.CartDAO;
import dao.CategoryDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import model.Brand;
import model.Cart;
import model.Category;
import model.User;

/**
 * Controller for handling cart operations
 */
@WebServlet(name = "CartController", urlPatterns = {
    "/cart",
    "/cart/add",
    "/cart/update",
    "/cart/remove"
})
public class CartController extends HttpServlet {

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

        // View cart page
        if (path.equals("/cart")) {
            viewCart(request, response);
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

        // Handle different cart operations
        if (path.equals("/cart/add")) {
            addToCart(request, response);
        } else if (path.equals("/cart/update")) {
            updateCartItem(request, response);
        } else if (path.equals("/cart/remove")) {
            removeCartItem(request, response);
        }
    }

    /**
     * Handle adding a product to the cart
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // User is not logged in, return error
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Please login to add items to cart\"}");
            out.flush();
            return;
        }

        // Get parameters
        String productIdParam = request.getParameter("productId");
        String sizeIdParam = request.getParameter("sizeId");
        String quantityParam = request.getParameter("quantity");

        // Validate parameters
        if (productIdParam == null || sizeIdParam == null) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Invalid parameters\"}");
            out.flush();
            return;
        }

        try {
            int productId = Integer.parseInt(productIdParam);
            int sizeId = Integer.parseInt(sizeIdParam);
            int quantity = 1; // Default quantity

            if (quantityParam != null && !quantityParam.trim().isEmpty()) {
                quantity = Integer.parseInt(quantityParam);
            }

            // Get ProductItemID from ProductID and SizeID
            CartDAO cartDAO = new CartDAO();
            int productItemId = cartDAO.getProductItemID(productId, sizeId);

            if (productItemId == -1) {
                // ProductItem not found
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Product with selected size not available\"}");
                out.flush();
                return;
            }

            // Add to cart
            boolean success = cartDAO.addToCart(user.getUserID(), productItemId, quantity);

            // Return JSON response
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();

            if (success) {
                // Get updated cart count
                int cartCount = cartDAO.getCartItemCount(user.getUserID());
                out.print("{\"success\": true, \"message\": \"Product added to cart successfully\", \"cartCount\": " + cartCount + "}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to add product to cart\"}");
            }

            out.flush();

        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Invalid parameters format\"}");
            out.flush();
        }
    }

    /**
     * View cart page
     */
    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // Redirect to login if not logged in
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get cart items for the user
            CartDAO cartDAO = new CartDAO();
            List<Cart> cartItems = cartDAO.getCartItems(user.getUserID());
            CategoryDAO categoryDAO = new CategoryDAO();
            BrandDAO brandDAO = new BrandDAO();
            // Set cart items to request
            request.setAttribute("cartItems", cartItems);
            List<Category> allCategories = categoryDAO.getAllCategories();
            List<Category> parentCategories = new ArrayList<>();

            // Filter parent categories
            for (Category category : allCategories) {
                if (category.getParentCategoryID() == null) {
                    parentCategories.add(category);
                }
            }
            List<Brand> brands = brandDAO.getAllBrands();
            request.setAttribute("categories", allCategories);
            request.setAttribute("parentCategories", parentCategories);
            request.setAttribute("brands", brands);
            // Forward to cart page
            request.getRequestDispatcher("/view/customer/cart.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in viewCart method: " + e.getMessage());
            e.printStackTrace();

            // Set error message and forward to cart page with empty list
            request.setAttribute("errorMessage", "Failed to load cart items: " + e.getMessage());
            request.setAttribute("cartItems", new ArrayList<Cart>());
            request.getRequestDispatcher("/view/customer/cart.jsp").forward(request, response);
        }
    }

    /**
     * Update cart item quantity
     */
    private void updateCartItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (user == null) {
            out.print("{\"success\": false, \"message\": \"Please login to update cart\"}");
            out.flush();
            return;
        }

        // Get parameters
        String cartIdParam = request.getParameter("cartId");
        String quantityParam = request.getParameter("quantity");

        // Validate parameters
        if (cartIdParam == null || quantityParam == null) {
            out.print("{\"success\": false, \"message\": \"Invalid parameters\"}");
            out.flush();
            return;
        }

        try {
            int cartId = Integer.parseInt(cartIdParam);
            int quantity = Integer.parseInt(quantityParam);

            if (quantity <= 0) {
                out.print("{\"success\": false, \"message\": \"Quantity must be greater than 0\", \"currentQuantity\": 1}");
                out.flush();
                return;
            }

            // Update cart item quantity
            CartDAO cartDAO = new CartDAO();
            CartDAO.CartUpdateResponse updateResponse = cartDAO.updateCartItemQuantity(cartId, quantity);

            if (updateResponse.isSuccess()) {
                out.print("{\"success\": true, \"message\": \"" + updateResponse.getMessage() + "\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"" + updateResponse.getMessage() + "\", \"currentQuantity\": " + updateResponse.getCurrentQuantity() + "}");
            }

            out.flush();
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid parameters format\"}");
            out.flush();
        }
    }

    /**
     * Remove cart item
     */
    private void removeCartItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (user == null) {
            out.print("{\"success\": false, \"message\": \"Please login to remove items\"}");
            out.flush();
            return;
        }

        // Get parameters
        String cartIdParam = request.getParameter("cartId");

        // Validate parameters
        if (cartIdParam == null) {
            out.print("{\"success\": false, \"message\": \"Invalid parameters\"}");
            out.flush();
            return;
        }

        try {
            int cartId = Integer.parseInt(cartIdParam);

            // Remove cart item
            CartDAO cartDAO = new CartDAO();
            boolean success = cartDAO.removeCartItem(cartId);

            if (success) {
                // Get updated cart count
                int cartCount = cartDAO.getCartItemCount(user.getUserID());
                out.print("{\"success\": true, \"message\": \"Item removed successfully\", \"cartCount\": " + cartCount + "}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to remove item\"}");
            }

            out.flush();
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid parameters format\"}");
            out.flush();
        }
    }

    // The clearCart method has been removed as requested
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Cart Controller";
    }
}
