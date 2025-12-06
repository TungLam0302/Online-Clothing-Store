package controller;

import dao.BrandDAO;
import dao.CategoryDAO;
import dao.ProductDAO;
import model.Product;
import model.ProductItem;
import model.Image;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.Brand;
import model.Category;

@WebServlet(name = "ViewProductController", urlPatterns = {"/product/view"})
public class ViewProductController extends HttpServlet {
    private ProductDAO productDAO;

    public void init() {
        productDAO = new ProductDAO();
    }

    /**
     * Handles the HTTP GET method to display product details
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            BrandDAO brandDAO = new BrandDAO();
        try {
            // Get product ID from request
            int productId = Integer.parseInt(request.getParameter("id"));
            
            // Get product details
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }
            
            // Get product images
            List<Image> images = productDAO.getProductImages(productId);
            
            // Get product sizes and stock quantities
            List<ProductItem> productItems = productDAO.getProductSizeAndQuantity(productId);
            
            // Get related products by category (limit to 4)
            List<Product> relatedProducts = productDAO.getProductsByCategory(product.getCategory().getCategoryID());
            // Filter out the current product and limit to 4 items
            relatedProducts = relatedProducts.stream()
                .filter(p -> p.getProductID() != productId)
                .limit(4)
                .collect(java.util.stream.Collectors.toList());
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
            // Set attributes for JSP
            request.setAttribute("product", product);
            request.setAttribute("images", images);
            request.setAttribute("productItems", productItems);
            request.setAttribute("relatedProducts", relatedProducts);
            
            // Forward to product detail page
            request.getRequestDispatcher("/view/customer/view-product.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving product details");
        }
    }
}
