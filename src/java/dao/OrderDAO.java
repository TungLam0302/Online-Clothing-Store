package dao;

import dbcontext.DBContext;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Brand;
import model.Cart;
import model.Order;
import model.OrderItem;
import model.Product;
import model.ProductItem;
import model.Size;
import model.Status;
import model.User;

/**
 * Data Access Object for Order operations
 */
public class OrderDAO extends DBContext {
    
    /**
     * Create a new order
     * @param userID User ID
     * @param totalAmount Order total amount
     * @param shippingAddress The shipping address
     * @return Order ID if successful, -1 otherwise
     */
    public int createOrder(int userID, double totalAmount, String shippingAddress) {
        // StatusID is set to 1 (Pending) by default as per your schema
        String query = "INSERT INTO [Order] (UserID, OrderDate, TotalAmount, ShippingAddress, StatusID) VALUES (?, GETDATE(), ?, ?, 1)";
        
        try (PreparedStatement ps = connect.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userID);
            ps.setDouble(2, totalAmount);
            ps.setString(3, shippingAddress);
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in createOrder method: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Add order items to an order
     * @param orderID Order ID
     * @param cartItems List of cart items to convert to order items
     * @return true if successful, false otherwise
     */
    public boolean addOrderItems(int orderID, List<Cart> cartItems) {
        String query = "INSERT INTO OrderDetail (OrderID, ProductItemID, Quantity, Price) VALUES (?, ?, ?, ?)";
        
        try {
            // Disable auto-commit to enable transaction
            connect.setAutoCommit(false);
            
            try (PreparedStatement ps = connect.prepareStatement(query)) {
                for (Cart cart : cartItems) {
                    if (cart.getProductItem() == null || cart.getProductItem().getProduct() == null) {
                        continue; // Skip invalid cart items
                    }
                    
                    // Parse price from string to double
                    double price = Double.parseDouble(cart.getProductItem().getProduct().getPrice());
                    double subtotal = price * cart.getQuantity();
                    
                    ps.setInt(1, orderID);
                    ps.setInt(2, cart.getProductItemID());
                    ps.setInt(3, cart.getQuantity());
                    ps.setDouble(4, price);
                    ps.addBatch();
                    
                    // Update product item stock quantity
                    updateProductStock(cart.getProductItemID(), cart.getQuantity());
                }
                
                // Execute batch
                int[] results = ps.executeBatch();
                boolean success = true;
                
                for (int result : results) {
                    if (result <= 0) {
                        success = false;
                        break;
                    }
                }
                
                if (success) {
                    connect.commit();
                    return true;
                } else {
                    connect.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in addOrderItems method: " + e.getMessage());
            e.printStackTrace();
            
            try {
                // Rollback transaction on error
                connect.rollback();
            } catch (SQLException ex) {
                System.out.println("Error rolling back transaction: " + ex.getMessage());
                ex.printStackTrace();
            }
        } finally {
            try {
                // Restore auto-commit
                connect.setAutoCommit(true);
            } catch (SQLException e) {
                System.out.println("Error restoring auto-commit: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return false;
    }
    
    /**
     * Update product stock quantity after order
     * @param productItemID Product item ID
     * @param quantity Quantity to reduce
     * @return true if successful, false otherwise
     */
    private boolean updateProductStock(int productItemID, int quantity) {
        String query = "UPDATE ProductItem SET StockQuantity = StockQuantity - ? WHERE ProductItemID = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productItemID);
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in updateProductStock method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Remove cart items after order completion
     * @param userID User ID
     * @param cartIDs List of cart item IDs to remove
     * @return true if successful, false otherwise
     */
    public boolean removeOrderedCartItems(int userID, List<Integer> cartIDs) {
        if (cartIDs == null || cartIDs.isEmpty()) {
            return false;
        }
        
        StringBuilder query = new StringBuilder("DELETE FROM Cart WHERE UserID = ? AND CartID IN (");
        for (int i = 0; i < cartIDs.size(); i++) {
            query.append("?");
            if (i < cartIDs.size() - 1) {
                query.append(",");
            }
        }
        query.append(")");
        
        try (PreparedStatement ps = connect.prepareStatement(query.toString())) {
            ps.setInt(1, userID);
            
            for (int i = 0; i < cartIDs.size(); i++) {
                ps.setInt(i + 2, cartIDs.get(i));
            }
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in removeOrderedCartItems method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all orders for a user
     * @param userID User ID
     * @return List of orders
     */
    public List<Order> getOrdersByUser(int userID) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT o.OrderID, o.UserID, o.OrderDate, o.TotalAmount, o.ShippingAddress, o.StatusID, " +
                      "s.StatusName " +
                      "FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE o.UserID = ? " +
                      "ORDER BY o.OrderDate DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(query)) {
            ps.setInt(1, userID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderID(rs.getInt("OrderID"));
                    order.setUserID(rs.getInt("UserID"));
                    order.setOrderDate(rs.getTimestamp("OrderDate"));
                    order.setTotalAmount(rs.getDouble("TotalAmount"));
                    order.setShippingAddress(rs.getString("ShippingAddress"));
                    order.setStatusID(rs.getInt("StatusID"));
                    
                    Status status = new Status();
                    status.setStatusID(rs.getInt("StatusID"));
                    status.setStatusName(rs.getString("StatusName"));
                    order.setStatus(status);
                    
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getOrdersByUser method: " + e.getMessage());
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Get an order by ID
     * @param orderID Order ID
     * @return Order object if found, null otherwise
     */
    public Order getOrderById(int orderID) {
        String query = "SELECT o.OrderID, o.UserID, o.OrderDate, o.TotalAmount, o.ShippingAddress, o.StatusID, " +
                      "s.StatusName " +
                      "FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE o.OrderID = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(query)) {
            ps.setInt(1, orderID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderID(rs.getInt("OrderID"));
                    order.setUserID(rs.getInt("UserID"));
                    order.setOrderDate(rs.getTimestamp("OrderDate"));
                    order.setTotalAmount(rs.getDouble("TotalAmount"));
                    order.setShippingAddress(rs.getString("ShippingAddress"));
                    order.setStatusID(rs.getInt("StatusID"));
                    
                    Status status = new Status();
                    status.setStatusID(rs.getInt("StatusID"));
                    status.setStatusName(rs.getString("StatusName"));
                    order.setStatus(status);
                    
                    return order;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getOrderById method: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get items for an order
     * @param orderID Order ID
     * @return List of order items
     */
    public List<OrderItem> getOrderItems(int orderID) {
        List<OrderItem> items = new ArrayList<>();
        String query = "SELECT od.OrderDetailID, od.OrderID, od.ProductItemID, od.Quantity, od.Price, " +
                      "pi.SizeID, s.SizeName, p.ProductID, p.Name, p.Thumbnail, " +
                      "b.BrandName " +
                      "FROM OrderDetail od " +
                      "JOIN ProductItem pi ON od.ProductItemID = pi.ProductItemID " +
                      "JOIN Product p ON pi.ProductID = p.ProductID " +
                      "JOIN Size s ON pi.SizeID = s.SizeID " +
                      "JOIN Brand b ON p.BrandID = b.BrandID " +
                      "WHERE od.OrderID = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(query)) {
            ps.setInt(1, orderID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderDetailID(rs.getInt("OrderDetailID"));
                    item.setOrderID(rs.getInt("OrderID"));
                    item.setProductItemID(rs.getInt("ProductItemID"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setPrice(rs.getDouble("Price"));
                    item.setSubtotal(rs.getDouble("Price") * rs.getInt("Quantity"));
                    
                    ProductItem productItem = new ProductItem();
                    productItem.setProductItemId(rs.getInt("ProductItemID"));
                    
                    Size size = new Size();
                    size.setSizeID(rs.getInt("SizeID"));
                    size.setSizeName(rs.getString("SizeName"));
                    productItem.setSize(size);
                    
                    Product product = new Product();
                    product.setProductID(rs.getInt("ProductID"));
                    product.setProductName(rs.getString("Name"));
                    product.setThumbnail(rs.getString("Thumbnail"));
                    
                    Brand brand = new Brand();
                    brand.setBrandName(rs.getString("BrandName"));
                    product.setBrand(brand);
                    
                    productItem.setProduct(product);
                    item.setProductItem(productItem);
                    
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getOrderItems method: " + e.getMessage());
            e.printStackTrace();
        }
        
        return items;
    }
    
    /**
     * Update order status
     * @param orderID Order ID
     * @param statusID New status ID
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatus(int orderID, int statusID) {
        String query = "UPDATE [Order] SET StatusID = ? WHERE OrderID = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(query)) {
            ps.setInt(1, statusID);
            ps.setInt(2, orderID);
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in updateOrderStatus method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cancel an order (set status to 5 - Cancelled)
     * Only orders with status 1 (Pending) can be cancelled
     * @param orderID Order ID
     * @param userID User ID (for security check)
     * @return true if successful, false otherwise
     */
    public boolean cancelOrder(int orderID, int userID) {
        // First check if the order is owned by this user and has status 1 (Pending)
        String checkQuery = "SELECT StatusID FROM [Order] WHERE OrderID = ? AND UserID = ?";
        
        try (PreparedStatement checkPs = connect.prepareStatement(checkQuery)) {
            checkPs.setInt(1, orderID);
            checkPs.setInt(2, userID);
            
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    int currentStatus = rs.getInt("StatusID");
                    
                    // Only cancel if status is 1 (Pending)
                    if (currentStatus == 1) {
                        return updateOrderStatus(orderID, 5); // 5 is Cancelled
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in cancelOrder method: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get all orders for manager view
     * @return List of all orders
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT o.OrderID, o.UserID, o.OrderDate, o.TotalAmount, o.ShippingAddress, o.StatusID, " +
                      "s.StatusName, u.Name " +
                      "FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "JOIN [User] u ON o.UserID = u.UserID " +
                      "ORDER BY o.OrderDate DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(query)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderID(rs.getInt("OrderID"));
                    order.setUserID(rs.getInt("UserID"));
                    order.setOrderDate(rs.getDate("OrderDate"));
                    order.setTotalAmount(rs.getDouble("TotalAmount"));
                    order.setShippingAddress(rs.getString("ShippingAddress"));
                    order.setStatusID(rs.getInt("StatusID"));
                    
                    // Set status
                    Status status = new Status();
                    status.setStatusID(rs.getInt("StatusID"));
                    status.setStatusName(rs.getString("StatusName"));
                    order.setStatus(status);
                    
                    // Set user
                    User user = new User();
                    user.setUserID(rs.getInt("UserID"));
                    user.setName(rs.getString("Name"));
                    order.setUser(user);
                    
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllOrders method: " + e.getMessage());
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Get order count by status
     * @param status Order status (Pending, Confirmed, Shipped, Delivered, Cancelled)
     * @return Order count
     */
    public int getOrderCountByStatus(String status) {
        String query = "SELECT COUNT(*) FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE s.StatusName = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getOrderCountByStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Get total order count
     * @return Total order count
     */
    public int getTotalOrderCount() {
        String query = "SELECT COUNT(*) FROM [Order]";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalOrderCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Get revenue by specific date
     * @param date Date to get revenue for
     * @return revenue amount
     */
    public java.math.BigDecimal getRevenueByDate(java.time.LocalDate date) {
        String query = "SELECT COALESCE(SUM(o.TotalAmount), 0) FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE CAST(o.OrderDate AS DATE) = ? AND s.StatusName = 'Delivered'";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setDate(1, java.sql.Date.valueOf(date));
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getRevenueByDate: " + e.getMessage());
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
    
    /**
     * Get revenue for this week
     * @return revenue amount
     */
    public java.math.BigDecimal getRevenueThisWeek() {
        String query = "SELECT COALESCE(SUM(o.TotalAmount), 0) FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE DATEPART(WEEK, o.OrderDate) = DATEPART(WEEK, GETDATE()) " +
                      "AND DATEPART(YEAR, o.OrderDate) = DATEPART(YEAR, GETDATE()) " +
                      "AND s.StatusName = 'Delivered'";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getRevenueThisWeek: " + e.getMessage());
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
    
    /**
     * Get revenue for this month
     * @return revenue amount
     */
    public java.math.BigDecimal getRevenueThisMonth() {
        String query = "SELECT COALESCE(SUM(o.TotalAmount), 0) FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE DATEPART(MONTH, o.OrderDate) = DATEPART(MONTH, GETDATE()) " +
                      "AND DATEPART(YEAR, o.OrderDate) = DATEPART(YEAR, GETDATE()) " +
                      "AND s.StatusName = 'Delivered'";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getRevenueThisMonth: " + e.getMessage());
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
    
    /**
     * Get revenue by quarter
     * @param year Year
     * @param quarter Quarter (1,2,3,4)
     * @return revenue amount
     */
    public java.math.BigDecimal getRevenueByQuarter(int year, int quarter) {
        String query = "SELECT COALESCE(SUM(o.TotalAmount), 0) FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE DATEPART(YEAR, o.OrderDate) = ? " +
                      "AND DATEPART(QUARTER, o.OrderDate) = ? " +
                      "AND s.StatusName = 'Delivered'";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, year);
            ps.setInt(2, quarter);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getRevenueByQuarter: " + e.getMessage());
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
    
    /**
     * Get revenue by year
     * @param year Year
     * @return revenue amount
     */
    public java.math.BigDecimal getRevenueByYear(int year) {
        String query = "SELECT COALESCE(SUM(o.TotalAmount), 0) FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE DATEPART(YEAR, o.OrderDate) = ? " +
                      "AND s.StatusName = 'Delivered'";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getRevenueByYear: " + e.getMessage());
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
    
    /**
     * Get revenue by specific month and year
     * @param year Year
     * @param month Month (1-12)
     * @return revenue amount
     */
    public java.math.BigDecimal getRevenueByMonth(int year, int month) {
        String query = "SELECT COALESCE(SUM(o.TotalAmount), 0) FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE DATEPART(YEAR, o.OrderDate) = ? " +
                      "AND DATEPART(MONTH, o.OrderDate) = ? " +
                      "AND s.StatusName = 'Delivered'";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, year);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getRevenueByMonth: " + e.getMessage());
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
    
    /**
     * Get revenue by specific week and year
     * @param year Year
     * @param week Week of year (1-52)
     * @return revenue amount
     */
    public java.math.BigDecimal getRevenueByWeek(int year, int week) {
        String query = "SELECT COALESCE(SUM(o.TotalAmount), 0) FROM [Order] o " +
                      "JOIN Status s ON o.StatusID = s.StatusID " +
                      "WHERE DATEPART(YEAR, o.OrderDate) = ? " +
                      "AND DATEPART(WEEK, o.OrderDate) = ? " +
                      "AND s.StatusName = 'Delivered'";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, year);
            ps.setInt(2, week);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getRevenueByWeek: " + e.getMessage());
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
}
