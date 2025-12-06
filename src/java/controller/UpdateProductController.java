package controller;

import dao.ProductDAO;
import dao.BrandDAO;
import dao.CategoryDAO;
import dao.SizeDAO;
import model.Product;
import model.Brand;
import model.Category;
import model.Size;
import model.Image;
import model.ProductItem;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import java.util.Set;
import java.util.HashSet;
import java.util.stream.Collectors;
import java.util.Map;
import java.util.Arrays;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.User;

@MultipartConfig
@WebServlet(name = "UpdateProductController", urlPatterns = {"/updateProduct"})
public class UpdateProductController extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "D:\\Code\\PRJ\\Project\\PRJ_ClotherOnline\\web\\images";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleID() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            // Get product ID from request
            int productId = Integer.parseInt(request.getParameter("id"));
            
            // Initialize DAOs
            ProductDAO productDAO = new ProductDAO();
            BrandDAO brandDAO = new BrandDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            SizeDAO sizeDAO = new SizeDAO();
            
            // Get product details
            Product existingProduct = productDAO.getProductById(productId);
            if (existingProduct == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }
            
            // Get product images
            List<Image> images = productDAO.getProductImages(productId);
            
            // Get product items (sizes and stock), including those with 0 quantity
            List<ProductItem> productItems = productDAO.getAllProductItems(productId);
            
            // Get all brands, categories, and sizes for dropdowns
            List<Brand> brands = brandDAO.getAllBrands();
            List<Category> categories = categoryDAO.getAllCategories();
            List<Size> sizes = sizeDAO.getAllSizes();
            
            // Set attributes for JSP
            request.setAttribute("product", existingProduct);
            request.setAttribute("images", images);
            request.setAttribute("productItems", productItems);
            request.setAttribute("brands", brands);
            request.setAttribute("categories", categories);
            request.setAttribute("sizes", sizes);
            
            // Check for error messages in session
            String errorMessage = (String) request.getSession().getAttribute("errorMessage");
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                request.getSession().removeAttribute("errorMessage"); // Clear the message after use
            }
            
            // Forward to update form
            request.getRequestDispatcher("/view/manager/updateProduct.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving product details");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleID() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        ProductDAO productDAO = new ProductDAO();
        try {
            int productID = Integer.parseInt(request.getParameter("productId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String price = request.getParameter("price");
            boolean status = "1".equals(request.getParameter("status"));
            int brandID = Integer.parseInt(request.getParameter("brandID"));
            int categoryID = Integer.parseInt(request.getParameter("categoryID"));

            // Get existing product to preserve current thumbnail if no new file uploaded
            Product existingProduct = productDAO.getProductById(productID);
            String thumbnail = existingProduct.getThumbnail();
            Part thumbnailPart = request.getPart("thumbnail");
            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
                thumbnail = saveUploadedFile(thumbnailPart);
            }

            // Create updated product object
            Product product = new Product();
            product.setProductID(productID);
            product.setProductName(name);
            product.setThumbnail(thumbnail);
            product.setDesciption(description);
            product.setPrice(price);
            product.setStatus(status);

            // Set brand and category
            Brand brand = new Brand();
            brand.setBrandID(brandID);
            product.setBrand(brand);

            Category category = new Category();
            category.setCategoryID(categoryID);
            product.setCategory(category);

            // Update product details
            productDAO.updateProduct(productID, product);

            // Handle image deletion
            String[] deleteImages = request.getParameterValues("deleteImages");
            if (deleteImages != null) {
                for (String imageUrl : deleteImages) {
                    productDAO.deleteProductImageByUrl(productID, imageUrl);
                }
            }

            // Handle new image uploads
            List<String> imagePaths = new ArrayList<>();
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    imagePaths.add(saveUploadedFile(part));
                }
            }

            // Add new images to product
            for (String imgPath : imagePaths) {
                productDAO.addListImageForProduct(productID, imgPath);
            }

            // Handle product sizes and stock
            List<ProductItem> currentItems = productDAO.getProductSizeAndQuantity(productID);
            Set<Integer> currentSizeIDs = new HashSet<>();
            for (ProductItem item : currentItems) {
                currentSizeIDs.add(item.getSize().getSizeID());
            }

            String[] selectedSizes = request.getParameterValues("sizes");
            Set<Integer> selectedSizeIDs = new HashSet<>();
            if (selectedSizes != null) {
                for (String sizeID : selectedSizes) {
                    selectedSizeIDs.add(Integer.parseInt(sizeID));
                }
            }

            // Get all existing ProductItems (including those with quantity 0)
            List<ProductItem> allProductItems = productDAO.getAllProductItems(productID);
            Set<Integer> allProductItemSizeIDs = new HashSet<>();
            for (ProductItem item : allProductItems) {
                allProductItemSizeIDs.add(item.getSize().getSizeID());
            }

            // For sizes that are no longer selected, update quantity to 0 instead of deleting
            for (Integer sizeID : currentSizeIDs) {
                if (!selectedSizeIDs.contains(sizeID)) {
                    productDAO.updateProductItem(productID, sizeID, 0);
                }
            }

            // Process selected sizes
            if (selectedSizes != null) {
                for (String sizeID : selectedSizes) {
                    int intSizeID = Integer.parseInt(sizeID);
                    String stockParam = request.getParameter("stock_" + sizeID);
                    int stockQuantity = stockParam != null && !stockParam.isEmpty() ? Integer.parseInt(stockParam) : 0;
                    
                    // If the size already exists in ProductItem (even with quantity 0), update it
                    if (allProductItemSizeIDs.contains(intSizeID)) {
                        productDAO.updateProductItem(productID, intSizeID, stockQuantity);
                    } else {
                        // Otherwise add a new ProductItem
                        productDAO.addProductItem(productID, intSizeID, stockQuantity);
                    }
                }
            }

            

            // Redirect with success message
            request.getSession().setAttribute("successMessage", "Product updated successfully!");
            response.sendRedirect(request.getContextPath() + "/product?action=list");

        } catch (Exception e) {
            e.printStackTrace();
            // Use session to pass error message
            request.getSession().setAttribute("errorMessage", "Failed to update product: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/updateProduct?id=" + request.getParameter("productId"));
        }
    }
    
    private String saveUploadedFile(Part part) throws IOException {
        // Generate unique filename to prevent overwriting
        String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String fileExtension = "";
        
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex > 0) {
            fileExtension = originalFileName.substring(dotIndex);
        }
        
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        
        // Ensure upload directory exists
        File uploadDir = new File(UPLOAD_DIRECTORY);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Save file
        String filePath = UPLOAD_DIRECTORY + File.separator + uniqueFileName;
        part.write(filePath);
        
        return "images/" + uniqueFileName; // Store relative path in database
    }
}
