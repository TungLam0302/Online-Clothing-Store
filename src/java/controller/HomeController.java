package controller;

import dao.BrandDAO;
import dao.CategoryDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Brand;
import model.Category;
import model.Product;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {
    private static final int PRODUCTS_PER_PAGE = 9;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters
            String categoryParam = request.getParameter("category");
            String searchParam = request.getParameter("search");
            String sortParam = request.getParameter("sort");
            
            // Get page number from request, default to page 1
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    // Invalid page number, use default
                }
            }

            // Initialize DAOs
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            BrandDAO brandDAO = new BrandDAO();

            // Variables for results
            List<Product> products;
            int totalProducts;
            String queryString = "";
            String categoryName = null;
            
            // Calculate offset
            int offset = (currentPage - 1) * PRODUCTS_PER_PAGE;
            
            // Get products based on parameters
            if (categoryParam != null && !categoryParam.isEmpty()) {
                // Get products by category
                int categoryId = Integer.parseInt(categoryParam);
                products = productDAO.getProductsByCategoryWithPagination(categoryId, offset, PRODUCTS_PER_PAGE);
                totalProducts = productDAO.countProductsByCategory(categoryId);
                queryString = "&category=" + categoryParam;
                
                // Get category name for breadcrumb
                Category category = categoryDAO.getCategoryById(categoryId);
                if (category != null) {
                    categoryName = category.getCategoryName();
                }
            } else if (searchParam != null && !searchParam.isEmpty()) {
                // Search products
                products = productDAO.searchProductsWithPagination(searchParam, offset, PRODUCTS_PER_PAGE);
                totalProducts = productDAO.countProductsBySearch(searchParam);
                queryString = "&search=" + searchParam;
            } else {
                // Get all products
                products = productDAO.getProductsWithPagination(offset, PRODUCTS_PER_PAGE);
                totalProducts = productDAO.countTotalProducts();
            }
            
            // Apply sorting if specified
            if (sortParam != null && !sortParam.isEmpty()) {
                queryString += "&sort=" + sortParam;
            }
            
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);
            
            // Ensure currentPage doesn't exceed totalPages
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            // Get categories for sidebar and nav
            List<Category> allCategories = categoryDAO.getAllCategories();
            List<Category> parentCategories = new ArrayList<>();
            
            // Filter parent categories
            for (Category category : allCategories) {
                if (category.getParentCategoryID() == null) {
                    parentCategories.add(category);
                }
            }
            
            // Get brands for filters
            List<Brand> brands = brandDAO.getAllBrands();
            
            // Set attributes for JSP
            request.setAttribute("products", products);
            request.setAttribute("categories", allCategories);
            request.setAttribute("parentCategories", parentCategories);
            request.setAttribute("brands", brands);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("categoryName", categoryName);
            request.setAttribute("queryString", queryString);
            
            // Forward to home page
            request.getRequestDispatcher("/view/customer/home.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving products");
        }
    }
}
