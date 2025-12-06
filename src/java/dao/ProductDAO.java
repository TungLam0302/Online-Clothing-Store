package dao;

import dbcontext.DBContext;
import model.Product;
import model.ProductItem;
import model.Image;
import model.Brand;
import model.Category;
import model.Size;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.util.stream.Collectors;

public class ProductDAO extends DBContext {

    // Create a new product with its items and images
    public List<Product> getAllProductsForHome() {
        String sql = "select * from Product where Status = 1";
        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connect.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Product pro = new Product();
                pro.setProductID(rs.getInt("ProductID"));
                pro.setProductName(rs.getString("Name"));
                pro.setPrice(rs.getString("Price"));
                pro.setDesciption(rs.getString("Description"));
                pro.setThumbnail(rs.getString("Thumbnail"));
                products.add(pro);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
        return products;
    }

    public List<Product> getProductsByPage(int start, int total) {
        String sql = "SELECT * FROM Product WHERE Status = 1 ORDER BY ProductID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, start);  // OFFSET - bắt đầu từ dòng số 'start'
            st.setInt(2, total);  // FETCH NEXT - lấy 'total' dòng

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Product pro = new Product();
                    pro.setProductID(rs.getInt("ProductID"));
                    pro.setProductName(rs.getString("Name"));
                    pro.setPrice(rs.getString("Price"));
                    pro.setDesciption(rs.getString("Description"));
                    pro.setThumbnail(rs.getString("Thumbnail"));
                    products.add(pro);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
        return products;
    }

    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM Product WHERE Status = 1";
        try (PreparedStatement st = connect.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Size> getAllSize() {
        String sql = "select * from Size";
        List<Size> listSize = new ArrayList<>();

        try (PreparedStatement st = connect.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Size size = new Size();
                size.setSizeID(rs.getInt("SizeID"));
                size.setSizeName(rs.getString("SizeName"));
                listSize.add(size);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
        return listSize;
    }

    public List<Category> getParentCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName FROM Category WHERE ParentCategoryID IS NULL";

        try (PreparedStatement st = connect.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Category cate = new Category();
                cate.setCategoryID(rs.getInt("CategoryID"));
                cate.setCategoryName(rs.getString("CategoryName"));
                categories.add(cate);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

//    public List<Category> getSubCategories(int parentID) {
//        List<Category> subCategories = new ArrayList<>();
//        String sql = "SELECT CategoryID, CategoryName FROM Category WHERE ParentCategoryID = ?";
//
//        try (PreparedStatement st = connect.prepareStatement(sql)) {
//            st.setInt(1, parentID);
//            ResultSet rs = st.executeQuery();
//            while (rs.next()) {
//                Category cate = new Category();
//                cate.setCateID(rs.getInt("CategoryID"));
//                cate.setCateName(rs.getString("CategoryName"));
//                subCategories.add(cate);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return subCategories;
//    }
    public List<Product> getAllProductForManage(int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.ProductID, p.Name, p.Thumbnail, p.Description, p.Price, p.Status, "
                + "b.BrandName, c.CategoryName "
                + "FROM Product p "
                + "JOIN Category c ON p.CategoryID = c.CategoryID "
                + "JOIN Brand b ON b.BrandID = p.BrandID "
                + "ORDER BY p.ProductID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, (page - 1) * pageSize);
            st.setInt(2, pageSize);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Product pro = new Product();
                    pro.setProductID(rs.getInt("ProductID"));
                    pro.setProductName(rs.getString("Name"));
                    pro.setPrice(rs.getString("Price"));
                    pro.setDesciption(rs.getString("Description"));
                    pro.setThumbnail(rs.getString("Thumbnail"));
                    pro.setStatus(rs.getBoolean("Status"));
                    Brand brand = new Brand();
                    brand.setBrandName(rs.getString("BrandName"));
                    pro.setBrand(brand);
                    Category cate = new Category();
                    cate.setCategoryName(rs.getString("CategoryName"));
                    pro.setCategory(cate);
                    products.add(pro);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

// Hàm lấy tổng số sản phẩm để tính tổng số trang
    public int getTotalProductsForManager() {
        String sql = "SELECT COUNT(*) AS total FROM Product";
        try (PreparedStatement st = connect.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int addNewProduct(Product product) {
        int productId = -1; // Mặc định nếu lỗi thì trả về -1

        String sql = "INSERT INTO Product (Name, Thumbnail, Description, Price, Status, BrandID, CategoryID) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement st = connect.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            st.setString(1, product.getProductName());
            st.setString(2, product.getThumbnail());
            st.setString(3, product.getDesciption());
            st.setString(4, product.getPrice()); // Chuyển đổi Price sang Double
            st.setBoolean(5, product.getStatus()); // Status là boolean
            st.setInt(6, product.getBrand().getBrandID());
            st.setInt(7, product.getCategory().getCategoryID());

            int rowsInserted = st.executeUpdate();

            // Lấy ProductID vừa thêm vào
            if (rowsInserted > 0) {
                ResultSet generatedKeys = st.getGeneratedKeys();
                if (generatedKeys.next()) {
                    productId = generatedKeys.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
        return productId; // Trả về ProductID vừa thêm
    }

    public void addListImageForProduct(int productID, String imagePath) {
        String sql = "INSERT INTO Image (ProductID, ImageURL) VALUES (?, ?)";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, productID);
            st.setString(2, imagePath);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi nếu có
        }
    }

    public void addProductItem(int productID, int sizeID, int stock) {
        String sql = "INSERT INTO ProductItem (ProductID, SizeID, StockQuantity) VALUES (?, ?, ?)";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, productID);
            st.setInt(2, sizeID);
            st.setInt(3, stock);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi nếu có
        }
    }

    public Product getProductById(int productID) {
        String sql = "SELECT p.ProductID, p.Name, p.Description, p.Price, p.Status, "
                + "p.Thumbnail, b.BrandID, b.BrandName, c.CategoryID, c.CategoryName "
                + "FROM Product p "
                + "JOIN Brand b ON p.BrandID = b.BrandID "
                + "JOIN Category c ON p.CategoryID = c.CategoryID "
                + "WHERE p.ProductID = ?";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, productID);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product();
                    product.setProductID(rs.getInt("ProductID"));
                    product.setProductName(rs.getString("Name"));
                    product.setDesciption(rs.getString("Description"));
                    product.setPrice(rs.getString("Price"));
                    product.setStatus(rs.getBoolean("Status"));
                    product.setThumbnail(rs.getString("Thumbnail"));

                    Brand brand = new Brand();
                    brand.setBrandID(rs.getInt("BrandID"));
                    brand.setBrandName(rs.getString("BrandName"));
                    product.setBrand(brand);

                    Category category = new Category();
                    category.setCategoryID(rs.getInt("CategoryID"));
                    category.setCategoryName(rs.getString("CategoryName"));
                    product.setCategory(category);

                    return product;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu không tìm thấy sản phẩm
    }

    public List<Image> getProductImages(int productID) {
        List<Image> images = new ArrayList<>();
        String sql = "SELECT ImageID, ImageURL FROM Image WHERE productID = ?";
        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, productID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {  // Sử dụng while thay vì if
                    Image image = new Image();
                    image.setImageID(rs.getInt("ImageID"));
                    image.setUrl(rs.getString("ImageURL"));
                    images.add(image);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return images;
    }

    public void deleteProductImageByUrl(int productID, String imageUrl) {
        String sql = "DELETE FROM Image WHERE ProductID = ? AND ImageURL = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, productID);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<ProductItem> getProductSizeAndQuantity(int productID) {
        List<ProductItem> list = new ArrayList<>();
        String sql = "SELECT s.SizeID, s.SizeName, ps.StockQuantity\n"
                + "               FROM ProductItem ps\n"
                + "               JOIN Size s ON ps.sizeID = s.sizeID\n"
                + "               WHERE ps.productID = ?";
        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, productID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    ProductItem stock = new ProductItem();
                    Size size = new Size();
                    size.setSizeID(rs.getInt("SizeID"));
                    size.setSizeName(rs.getString("SizeName"));
                    stock.setSize(size);
                    stock.setStockQuantity(rs.getInt("StockQuantity"));
                    list.add(stock);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get all product items for a product, including those with zero quantity
    public List<ProductItem> getAllProductItems(int productID) {
        List<ProductItem> list = new ArrayList<>();
        String sql = "SELECT s.SizeID, s.SizeName, pi.StockQuantity\n"
                + "FROM ProductItem pi\n"
                + "JOIN Size s ON pi.SizeID = s.SizeID\n"
                + "WHERE pi.ProductID = ?";
        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, productID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    ProductItem stock = new ProductItem();
                    Size size = new Size();
                    size.setSizeID(rs.getInt("SizeID"));
                    size.setSizeName(rs.getString("SizeName"));
                    stock.setSize(size);
                    stock.setStockQuantity(rs.getInt("StockQuantity"));
                    list.add(stock);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateProduct(int productID, Product product) {
        String sql = "UPDATE Product SET Name = ?, Thumbnail = ?, Description = ?, Price = ?, Status = ?, BrandID = ?, CategoryID = ? WHERE ProductID = ?";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setString(1, product.getProductName());
            st.setString(2, product.getThumbnail());
            st.setString(3, product.getDesciption());
            st.setString(4, product.getPrice()); // Giả định Price là String như trong addNewProduct
            st.setBoolean(5, product.getStatus()); // Status là boolean
            st.setInt(6, product.getBrand().getBrandID());
            st.setInt(7, product.getCategory().getCategoryID());
            st.setInt(8, productID); // Điều kiện WHERE để xác định sản phẩm cần cập nhật

            st.executeUpdate(); // Thực hiện cập nhật, không cần kiểm tra kết quả
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
    }

    public void deleteProductImages(int productID) {
        String sql = "delete from Image where ProductID = ?";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, productID); // Gán productID vào câu lệnh SQL

            st.executeUpdate(); // Thực hiện xóa
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }

    }

    public int countProductsByParentCategory(int parentID) {
        int totalProducts = 0;
        List<Integer> categoryIDs = new ArrayList<>();

        String categoryQuery = "SELECT CategoryID FROM Category WHERE ParentCategoryID = ?";
        try (PreparedStatement stmt = connect.prepareStatement(categoryQuery)) {
            stmt.setInt(1, parentID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                categoryIDs.add(rs.getInt("CategoryID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (!categoryIDs.isEmpty()) {
            String placeholders = categoryIDs.stream().map(id -> "?").collect(Collectors.joining(","));
            String sql = "SELECT COUNT(*) FROM Product WHERE Status = 1 AND CategoryID IN (" + placeholders + ")";

            try (PreparedStatement stmt = connect.prepareStatement(sql)) {
                for (int i = 0; i < categoryIDs.size(); i++) {
                    stmt.setInt(i + 1, categoryIDs.get(i));
                }

                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    totalProducts = rs.getInt(1);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return totalProducts;
    }

    public int countProductsByCategory(int categoryID) {
        int totalProducts = 0;
        String sql = "SELECT COUNT(*) FROM Product WHERE CategoryID = ? AND Status = 1";

        try (PreparedStatement stmt = connect.prepareStatement(sql)) {
            stmt.setInt(1, categoryID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                totalProducts = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalProducts;
    }

    public List<Product> getProductsByParentCategory(int parentID, int page, int pageSize) {
        List<Product> productList = new ArrayList<>();
        List<Integer> categoryIDs = new ArrayList<>();

        String categoryQuery = "SELECT CategoryID FROM Category WHERE ParentCategoryID = ?";
        try (PreparedStatement stmt = connect.prepareStatement(categoryQuery)) {
            stmt.setInt(1, parentID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                categoryIDs.add(rs.getInt("CategoryID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (!categoryIDs.isEmpty()) {
            String placeholders = categoryIDs.stream().map(id -> "?").collect(Collectors.joining(","));
            String sql = "SELECT * FROM Product WHERE Status = 1 AND CategoryID IN (" + placeholders + ") "
                    + "ORDER BY ProductID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            try (PreparedStatement stmt = connect.prepareStatement(sql)) {
                int i = 0;
                for (; i < categoryIDs.size(); i++) {
                    stmt.setInt(i + 1, categoryIDs.get(i));
                }
                stmt.setInt(i + 1, (page - 1) * pageSize); // OFFSET
                stmt.setInt(i + 2, pageSize); // LIMIT

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Product pro = new Product();
                    pro.setProductID(rs.getInt("ProductID"));
                    pro.setProductName(rs.getString("Name"));
                    pro.setPrice(rs.getString("Price"));
                    pro.setDesciption(rs.getString("Description"));
                    pro.setThumbnail(rs.getString("Thumbnail"));
                    productList.add(pro);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return productList;
    }

    public List<Product> getProductsByCategory(int categoryID, int page, int pageSize) {
        List<Product> productList = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE CategoryID = ? AND Status = 1 "
                + "ORDER BY ProductID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement stmt = connect.prepareStatement(sql)) {
            stmt.setInt(1, categoryID);
            stmt.setInt(2, (page - 1) * pageSize);
            stmt.setInt(3, pageSize);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Product pro = new Product();
                pro.setProductID(rs.getInt("ProductID"));
                pro.setProductName(rs.getString("Name"));
                pro.setPrice(rs.getString("Price"));
                pro.setDesciption(rs.getString("Description"));
                pro.setThumbnail(rs.getString("Thumbnail"));
                productList.add(pro);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return productList;
    }

    public void updateProductItem(int productID, int sizeID, int stockQuantity) {
        String sql = "UPDATE ProductItem SET StockQuantity = ? WHERE productID = ? AND sizeID = ?";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, stockQuantity); // Số lượng tồn kho mới
            st.setInt(2, productID);     // Điều kiện productID
            st.setInt(3, sizeID);        // Điều kiện sizeID

            st.executeUpdate(); // Thực hiện cập nhật
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
    }

    public void deleteProductItem(int productID, int sizeID) {
        String sql = "DELETE FROM ProductItem\n"
                + "WHERE productID = ? \n"
                + "  AND sizeID = ?;";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, productID); // Điều kiện productID
            st.setInt(2, sizeID);    // Điều kiện sizeID

            st.executeUpdate(); // Thực hiện xóa
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
    }

    public List<Product> getProductsByCategory(int categoryID) {
        List<Product> productList = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE CategoryID = ? and Status = 1";

        try (PreparedStatement stmt = connect.prepareStatement(sql)) {
            stmt.setInt(1, categoryID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product pro = new Product();
                pro.setProductID(rs.getInt("ProductID"));
                pro.setProductName(rs.getString("Name"));
                pro.setPrice(rs.getString("Price"));
                pro.setDesciption(rs.getString("Description"));
                pro.setThumbnail(rs.getString("Thumbnail"));
                productList.add(pro);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return productList;
    }

    public List<Product> getProductsByParentCategory(int parentID) {
        List<Product> productList = new ArrayList<>();
        List<Integer> categoryIDs = new ArrayList<>();

        // Truy vấn để lấy tất cả CategoryID con từ ParentCategoryID
        String categoryQuery = "SELECT CategoryID FROM Category WHERE ParentCategoryID = ?";
        try (PreparedStatement stmt = connect.prepareStatement(categoryQuery)) {
            stmt.setInt(1, parentID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                categoryIDs.add(rs.getInt("CategoryID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Nếu có danh mục con thì lấy sản phẩm trong danh mục đó
        if (!categoryIDs.isEmpty()) {
            String placeholders = categoryIDs.stream().map(id -> "?").collect(Collectors.joining(","));
            String productQuery = "SELECT * FROM Product WHERE Status = 1 and CategoryID IN (" + placeholders + ")";

            try (PreparedStatement stmt = connect.prepareStatement(productQuery)) {
                for (int i = 0; i < categoryIDs.size(); i++) {
                    stmt.setInt(i + 1, categoryIDs.get(i));
                }

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Product pro = new Product();
                    pro.setProductID(rs.getInt("ProductID"));
                    pro.setProductName(rs.getString("Name"));
                    pro.setPrice(rs.getString("Price"));
                    pro.setDesciption(rs.getString("Description"));
                    pro.setThumbnail(rs.getString("Thumbnail"));
                    productList.add(pro);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return productList;
    }

    public List<Product> searchProduct(String keyword) {
        List<Product> productList = new ArrayList<>();
        if (keyword == null) {
            keyword = ""; // Nếu keyword là null, chuyển thành chuỗi rỗng để tránh lỗi
        }
        String sql = "SELECT * FROM Product WHERE Name LIKE ? AND Status = 1"; // Loại bỏ N

        try (PreparedStatement stmt = connect.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%"); // JDBC sẽ tự xử lý Unicode
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product pro = new Product();
                    pro.setProductID(rs.getInt("ProductID"));
                    pro.setProductName(rs.getString("Name"));
                    pro.setPrice(rs.getString("Price")); // Sửa thành double (giả định cột Price là số)
                    pro.setDesciption(rs.getString("Description")); // Đảm bảo khớp với class Product
                    pro.setThumbnail(rs.getString("Thumbnail"));
                    productList.add(pro);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error searching products: " + e.getMessage()); // Ném lỗi để servlet xử lý
        }

        return productList;
    }

    // Get products with pagination
    public List<Product> getProductsWithPagination(int offset, int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, b.BrandID, b.BrandName, c.CategoryID, c.CategoryName "
                + "FROM Product p "
                + "LEFT JOIN Brand b ON p.BrandID = b.BrandID "
                + "LEFT JOIN Category c ON p.CategoryID = c.CategoryID "
                + "WHERE p.Status = 1 "
                + "ORDER BY p.ProductID DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, offset);
            st.setInt(2, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setProductID(rs.getInt("ProductID"));
                    product.setProductName(rs.getString("Name"));
                    product.setDesciption(rs.getString("Description"));
                    product.setPrice(rs.getString("Price"));
                    product.setStatus(rs.getBoolean("Status"));
                    product.setThumbnail(rs.getString("Thumbnail"));

                    // Set brand
                    Brand brand = new Brand();
                    brand.setBrandID(rs.getInt("BrandID"));
                    brand.setBrandName(rs.getString("BrandName"));
                    product.setBrand(brand);

                    // Set category
                    Category category = new Category();
                    category.setCategoryID(rs.getInt("CategoryID"));
                    category.setCategoryName(rs.getString("CategoryName"));
                    product.setCategory(category);

                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // Count total products for pagination
    public int countTotalProducts() {
        String sql = "SELECT COUNT(*) FROM Product WHERE Status = 1";
        try (PreparedStatement st = connect.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Filter products by category with pagination
    public List<Product> getProductsByCategoryWithPagination(int categoryId, int offset, int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, b.BrandID, b.BrandName, c.CategoryID, c.CategoryName "
                + "FROM Product p "
                + "LEFT JOIN Brand b ON p.BrandID = b.BrandID "
                + "LEFT JOIN Category c ON p.CategoryID = c.CategoryID "
                + "WHERE p.Status = 1 AND p.CategoryID = ? "
                + "ORDER BY p.ProductID DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            st.setInt(2, offset);
            st.setInt(3, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setProductID(rs.getInt("ProductID"));
                    product.setProductName(rs.getString("Name"));
                    product.setDesciption(rs.getString("Description"));
                    product.setPrice(rs.getString("Price"));
                    product.setStatus(rs.getBoolean("Status"));
                    product.setThumbnail(rs.getString("Thumbnail"));

                    // Set brand
                    Brand brand = new Brand();
                    brand.setBrandID(rs.getInt("BrandID"));
                    brand.setBrandName(rs.getString("BrandName"));
                    product.setBrand(brand);

                    // Set category
                    Category category = new Category();
                    category.setCategoryID(rs.getInt("CategoryID"));
                    category.setCategoryName(rs.getString("CategoryName"));
                    product.setCategory(category);

                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // Count total products by category
//    public int countProductsByCategory(int categoryId) {
//        String sql = "SELECT COUNT(*) FROM Product WHERE Status = 1 AND CategoryID = ?";
//        try (PreparedStatement st = connect.prepareStatement(sql)) {
//            st.setInt(1, categoryId);
//            try (ResultSet rs = st.executeQuery()) {
//                if (rs.next()) {
//                    return rs.getInt(1);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return 0;
//    }
    // Search products with pagination
    public List<Product> searchProductsWithPagination(String keyword, int offset, int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, b.BrandID, b.BrandName, c.CategoryID, c.CategoryName "
                + "FROM Product p "
                + "LEFT JOIN Brand b ON p.BrandID = b.BrandID "
                + "LEFT JOIN Category c ON p.CategoryID = c.CategoryID "
                + "WHERE p.Status = 1 AND (p.Name LIKE ? OR p.Description LIKE ?) "
                + "ORDER BY p.ProductID DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setString(1, "%" + keyword + "%");
            st.setString(2, "%" + keyword + "%");
            st.setInt(3, offset);
            st.setInt(4, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setProductID(rs.getInt("ProductID"));
                    product.setProductName(rs.getString("Name"));
                    product.setDesciption(rs.getString("Description"));
                    product.setPrice(rs.getString("Price"));
                    product.setStatus(rs.getBoolean("Status"));
                    product.setThumbnail(rs.getString("Thumbnail"));

                    // Set brand
                    Brand brand = new Brand();
                    brand.setBrandID(rs.getInt("BrandID"));
                    brand.setBrandName(rs.getString("BrandName"));
                    product.setBrand(brand);

                    // Set category
                    Category category = new Category();
                    category.setCategoryID(rs.getInt("CategoryID"));
                    category.setCategoryName(rs.getString("CategoryName"));
                    product.setCategory(category);

                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // Count total products by search keyword
    public int countProductsBySearch(String keyword) {
        String sql = "SELECT COUNT(*) FROM Product WHERE Status = 1 AND (Name LIKE ? OR Description LIKE ?)";
        try (PreparedStatement st = connect.prepareStatement(sql)) {
            st.setString(1, "%" + keyword + "%");
            st.setString(2, "%" + keyword + "%");
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get total count of products
     *
     * @return total product count
     */
    public int getTotalProductCount() {
        String query = "SELECT COUNT(*) FROM Product WHERE Status = 1";

        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalProductCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    public boolean deleteProduct(int productID) {
        String sql = "Update Product set Status = 0 where ProductID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, productID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
