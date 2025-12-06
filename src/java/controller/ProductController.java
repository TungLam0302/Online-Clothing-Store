package controller;

import dao.ProductDAO;
import dao.BrandDAO;
import dao.CategoryDAO;
import model.Product;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "ProductController", urlPatterns = {"/product"})
public class ProductController extends HttpServlet {
    private ProductDAO productDAO;
    private BrandDAO brandDAO;
    private CategoryDAO categoryDAO;

    public void init() {
        productDAO = new ProductDAO();
        brandDAO = new BrandDAO();
        categoryDAO = new CategoryDAO();
    }

    /**
     * Handles the HTTP GET method to display list of products
     * This controller only focuses on listing products
     * Other actions like add, update, view details are handled by separate controllers
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleID() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action") == null ? "" : request.getParameter("action");
        switch (action) {
            case "delete" :
                int id = Integer.parseInt(request.getParameter("id"));
                productDAO.deleteProduct(id);
                break;
        }
        // List all products (with pagination)
        listProducts(request, response);
    }

    /**
     * Lists all products with pagination
     * This is the main functionality of this controller
     */
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Handle pagination
            int page = 1;
            int pageSize = 50;
            
            // Get page parameter if available
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    // Invalid page parameter, use default
                }
            }
            
            // Get products for current page
            List<Product> products = productDAO.getAllProductForManage(page, pageSize);
            int totalProducts = productDAO.getTotalProductsForManager();
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            
            // Set attributes for JSP
            request.setAttribute("products", products);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("brands", brandDAO.getAllBrands());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            
            // Forward to product list page
            request.getRequestDispatcher("/view/manager/productList.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving product list");
        }
    }

}
