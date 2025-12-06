package controller;

import dao.BrandDAO;
import dao.CategoryDAO;
import dao.ProductDAO;
import dao.SizeDAO;
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Brand;
import model.Category;
import model.Product;
import model.Size;
import model.User;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB trước khi ghi ra disk
    maxFileSize       = 1024 * 1024 * 10,   // mỗi file tối đa 10 MB
    maxRequestSize    = 1024 * 1024 * 50    // tổng request tối đa 50 MB
)

public class AddProductController extends HttpServlet {

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
        BrandDAO bDao = new BrandDAO();
        CategoryDAO cDao = new CategoryDAO();
        SizeDAO sDao = new SizeDAO();
        List<Size> ls = sDao.getAllSize();
        List<Category> lc = cDao.getAllCategories();
        List<Brand> lb = bDao.getAllBrands();
        request.setAttribute("categories", lc);
        request.setAttribute("brands", lb);
        request.setAttribute("sizes", ls);
        
        // Check if we should load the test form
       
            request.getRequestDispatcher("view/manager/addProduct.jsp").forward(request, response);
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
        try {
            
            // Extract product details
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String brandIDStr = request.getParameter("brandID");
            String categoryIDStr = request.getParameter("categoryID");

            // Debug logging to identify missing fields
            System.out.println("Debug form values:");
            System.out.println("Name: " + name);
            System.out.println("Description: " + description);
            System.out.println("Price: " + priceStr);
            System.out.println("Brand ID: " + brandIDStr);
            System.out.println("Category ID: " + categoryIDStr);
            
            // Check if any parts are available
            System.out.println("Parts available:");
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                System.out.println("Part name: " + part.getName() + ", size: " + part.getSize());
            }

            // Validate required fields
            if (name == null || name.trim().isEmpty() || 
                priceStr == null || priceStr.trim().isEmpty() || 
                brandIDStr == null || categoryIDStr == null) {
                throw new IllegalArgumentException("Missing required product details - Name: " + (name == null ? "null" : (name.trim().isEmpty() ? "empty" : "ok")) +
                    ", Price: " + (priceStr == null ? "null" : (priceStr.trim().isEmpty() ? "empty" : "ok")) +
                    ", BrandID: " + (brandIDStr == null ? "null" : "ok") + 
                    ", CategoryID: " + (categoryIDStr == null ? "null" : "ok"));
            }

            // Process thumbnail
            Part thumbnailPart = request.getPart("thumbnail");
            String thumbnailFileName = null;
            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
                thumbnailFileName = saveUploadedFile(thumbnailPart);
            }

            // Process additional images
            List<String> imageFileNames = new ArrayList<>();
            Collection<Part> imageParts = request.getParts();
            for (Part part : imageParts) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    imageFileNames.add(saveUploadedFile(part));
                }
            }

            // Create Product object
            Product product = new Product();
            product.setProductName(name);
            product.setDesciption(description); // Note: there's a typo in the model class (desciption instead of description)
            product.setPrice(priceStr);
            product.setThumbnail(thumbnailFileName);
            // Default status to active (true) for new products
            product.setStatus(true);
            
            Brand brand = new Brand();
            brand.setBrandID(Integer.parseInt(brandIDStr));
            product.setBrand(brand);

            Category category = new Category();
            category.setCategoryID(Integer.parseInt(categoryIDStr));
            product.setCategory(category);

            // DAO to handle database operations
            ProductDAO productDAO = new ProductDAO();

            // Insert product and get generated ID
            int productID = productDAO.addNewProduct(product);

            // Process product sizes and stock
            String[] sizeIDs = request.getParameterValues("sizes");
            
            if (sizeIDs != null) {
                for (String sizeIDStr : sizeIDs) {
                    int sizeID = Integer.parseInt(sizeIDStr);
                    String stockQuantityParam = request.getParameter("stock_" + sizeID);
                    
                    if (stockQuantityParam != null && !stockQuantityParam.trim().isEmpty()) {
                        int stockQuantity = Integer.parseInt(stockQuantityParam);
                        productDAO.addProductItem(productID, sizeID, stockQuantity);
                    }
                }
            }

            // Add additional images
            for (String imageFileName : imageFileNames) {
                productDAO.addListImageForProduct(productID, imageFileName);
            }

            // Redirect to product list with success message
            response.sendRedirect(request.getContextPath() + "/product?action=list");

        } catch (Exception e) {
            e.printStackTrace();
            
            // Set error message and forward back to the form
            request.setAttribute("errorMessage", "Error adding product: " + e.getMessage());
            
            // Re-populate dropdowns
            BrandDAO bDao = new BrandDAO();
            CategoryDAO cDao = new CategoryDAO();
            SizeDAO sDao = new SizeDAO();
            
            request.setAttribute("categories", cDao.getAllCategories());
            request.setAttribute("brands", bDao.getAllBrands());
            request.setAttribute("sizes", sDao.getAllSize());
            
            request.getRequestDispatcher("view/manager/addProduct.jsp").forward(request, response);
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