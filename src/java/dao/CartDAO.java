package dao;

import dbcontext.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.Product;
import model.ProductItem;
import model.Size;

/**
 * Data Access Object for Cart operations
 */
public class CartDAO extends DBContext {
    
    /**
     * Add an item to the user's cart
     * @param userID User's ID
     * @param productItemID Product item ID
     * @param quantity Quantity to add
     * @return true if successful, false otherwise
     */
    public boolean addToCart(int userID, int productItemID, int quantity) {
        // First check the stock quantity
        String stockQuery = "SELECT StockQuantity FROM ProductItem WHERE ProductItemID = ?";
        
        try {
            PreparedStatement stockPs = connect.prepareStatement(stockQuery);
            stockPs.setInt(1, productItemID);
            ResultSet stockRs = stockPs.executeQuery();
            
            if (stockRs.next()) {
                int stockQuantity = stockRs.getInt("StockQuantity");
                if (stockQuantity <= 0) {
                    // Product is out of stock
                    return false;
                }
                
                // If quantity to add exceeds stock, limit it to available stock
                if (quantity > stockQuantity) {
                    quantity = stockQuantity;
                }
            } else {
                // Product item not found
                return false;
            }
        } catch (SQLException e) {
            System.out.println("Error checking stock quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    
        // Now check if the item already exists in the cart
        String checkQuery = "SELECT CartID, Quantity FROM Cart WHERE UserID = ? AND ProductItemID = ?";
        
        try {
            PreparedStatement checkPs = connect.prepareStatement(checkQuery);
            checkPs.setInt(1, userID);
            checkPs.setInt(2, productItemID);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                // Item already exists, update quantity
                int cartID = rs.getInt("CartID");
                int currentQuantity = rs.getInt("Quantity");
                int newQuantity = currentQuantity + quantity;
                
                // Check again to make sure the new quantity doesn't exceed stock
                String reCheckStockQuery = "SELECT StockQuantity FROM ProductItem WHERE ProductItemID = ?";
                PreparedStatement reCheckPs = connect.prepareStatement(reCheckStockQuery);
                reCheckPs.setInt(1, productItemID);
                ResultSet reCheckRs = reCheckPs.executeQuery();
                
                if (reCheckRs.next()) {
                    int stockQuantity = reCheckRs.getInt("StockQuantity");
                    if (newQuantity > stockQuantity) {
                        newQuantity = stockQuantity;
                    }
                }
                
                String updateQuery = "UPDATE Cart SET Quantity = ? WHERE CartID = ?";
                PreparedStatement updatePs = connect.prepareStatement(updateQuery);
                updatePs.setInt(1, newQuantity);
                updatePs.setInt(2, cartID);
                
                int result = updatePs.executeUpdate();
                return result > 0;
            } else {
                // Item doesn't exist, insert new cart item
                String insertQuery = "INSERT INTO Cart (UserID, ProductItemID, Quantity) VALUES (?, ?, ?)";
                PreparedStatement insertPs = connect.prepareStatement(insertQuery);
                insertPs.setInt(1, userID);
                insertPs.setInt(2, productItemID);
                insertPs.setInt(3, quantity);
                
                int result = insertPs.executeUpdate();
                return result > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in addToCart method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get ProductItem ID based on product ID and size ID
     * @param productID Product ID
     * @param sizeID Size ID
     * @return ProductItem ID if found, -1 otherwise
     */
    public int getProductItemID(int productID, int sizeID) {
        // Using the correct column name for ProductItemID
        String query = "SELECT ProductItemID FROM ProductItem WHERE ProductID = ? AND SizeID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, productID);
            ps.setInt(2, sizeID);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("ProductItemID");
            }
        } catch (SQLException e) {
            System.out.println("Error in getProductItemID method: " + e.getMessage());
            System.out.println("Product ID: " + productID + ", Size ID: " + sizeID);
            e.printStackTrace();
        }
        
        return -1; // Not found
    }
    
    /**
     * Get all cart items for a specific user with product details
     * @param userID User ID
     * @return List of cart items with product details
     */
    public List<Cart> getCartItems(int userID) {
        List<Cart> cartItems = new ArrayList<>();
        
        // First, let's try a simpler query to diagnose issues
        String query = "SELECT c.* FROM Cart c WHERE c.UserID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, userID);
            
            ResultSet rs = ps.executeQuery();
            
            // If this works, we'll try a more complex query with joins
            boolean hasItems = false;
            
            while (rs.next()) {
                hasItems = true;
                // Create a basic Cart object with just the cart data
                Cart cart = new Cart();
                cart.setCartID(rs.getInt("CartID"));
                cart.setUserID(rs.getInt("UserID"));
                cart.setProductItemID(rs.getInt("ProductItemID"));
                cart.setQuantity(rs.getInt("Quantity"));
                
                // Now let's get the product item details separately
                loadCartItemDetails(cart);
                
                cartItems.add(cart);
            }
            
            if (!hasItems) {
                System.out.println("No cart items found for user ID: " + userID);
            }
            
        } catch (SQLException e) {
            System.out.println("Error in getCartItems basic query: " + e.getMessage());
            e.printStackTrace();
        }
        
        return cartItems;
        
    }
    
    /**
     * Load product item details for a cart item
     * @param cart Cart object to load details for
     * @return true if successful, false otherwise
     */
    private boolean loadCartItemDetails(Cart cart) {
        String query = "SELECT pi.ProductItemID, pi.StockQuantity, " +
                      "p.ProductID, p.Name, p.Description, p.Price, p.Thumbnail, p.Status, " +
                      "s.SizeID, s.SizeName " +
                      "FROM ProductItem pi " +
                      "JOIN Product p ON pi.ProductID = p.ProductID " +
                      "JOIN Size s ON pi.SizeID = s.SizeID " +
                      "WHERE pi.ProductItemID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, cart.getProductItemID());
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Create Size object
                Size size = new Size();
                size.setSizeID(rs.getInt("SizeID"));
                size.setSizeName(rs.getString("SizeName"));
                
                // Create Product object
                Product product = new Product();
                product.setProductID(rs.getInt("ProductID"));
                product.setProductName(rs.getString("Name"));
                product.setPrice(rs.getString("Price"));
                product.setDesciption(rs.getString("Description"));
                product.setThumbnail(rs.getString("Thumbnail"));
                product.setStatus(rs.getBoolean("Status"));
                
                // Create ProductItem object
                ProductItem productItem = new ProductItem();
                productItem.setProductItemId(rs.getInt("ProductItemID"));
                productItem.setProduct(product);
                productItem.setSize(size);
                productItem.setStockQuantity(rs.getInt("StockQuantity"));
                
                // Set the productItem in the cart
                cart.setProductItem(productItem);
                
                System.out.println("Loaded details for cart item: CartID=" + cart.getCartID() + 
                                   ", Product=" + product.getProductName() + 
                                   ", Size=" + size.getSizeName() + 
                                   ", Stock=" + productItem.getStockQuantity());
                
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error in loadCartItemDetails method: " + e.getMessage());
            System.out.println("Failed to load details for ProductItemID: " + cart.getProductItemID());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update cart item quantity with stock quantity validation
     * @param cartID Cart item ID
     * @param quantity New quantity
     * @return A response object with success flag, message, and current quantity
     */
    public CartUpdateResponse updateCartItemQuantity(int cartID, int quantity) {
        CartUpdateResponse response = new CartUpdateResponse();
        
        try {
            // First get the current cart item to check the product item ID
            String getCartQuery = "SELECT ProductItemID FROM Cart WHERE CartID = ?";
            PreparedStatement getCartPs = connect.prepareStatement(getCartQuery);
            getCartPs.setInt(1, cartID);
            ResultSet cartRs = getCartPs.executeQuery();
            
            if (!cartRs.next()) {
                response.setSuccess(false);
                response.setMessage("Cart item not found");
                return response;
            }
            
            int productItemID = cartRs.getInt("ProductItemID");
            
            // Check stock quantity
            String stockQuery = "SELECT StockQuantity FROM ProductItem WHERE ProductItemID = ?";
            PreparedStatement stockPs = connect.prepareStatement(stockQuery);
            stockPs.setInt(1, productItemID);
            ResultSet stockRs = stockPs.executeQuery();
            
            if (!stockRs.next()) {
                response.setSuccess(false);
                response.setMessage("Product item not found");
                return response;
            }
            
            int stockQuantity = stockRs.getInt("StockQuantity");
            
            if (quantity > stockQuantity) {
                response.setSuccess(false);
                response.setMessage("Cannot add more than available stock (" + stockQuantity + ")");
                response.setCurrentQuantity(stockQuantity < 1 ? 1 : stockQuantity);
                return response;
            }
            
            // Update the quantity
            String updateQuery = "UPDATE Cart SET Quantity = ? WHERE CartID = ?";
            PreparedStatement updatePs = connect.prepareStatement(updateQuery);
            updatePs.setInt(1, quantity);
            updatePs.setInt(2, cartID);
            
            int result = updatePs.executeUpdate();
            
            if (result > 0) {
                response.setSuccess(true);
                response.setMessage("Quantity updated successfully");
                response.setCurrentQuantity(quantity);
            } else {
                response.setSuccess(false);
                response.setMessage("Failed to update quantity");
            }
            
        } catch (SQLException e) {
            System.out.println("Error in updateCartItemQuantity method: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Database error: " + e.getMessage());
        }
        
        return response;
    }
    
    /**
     * Response class for cart update operations
     */
    public class CartUpdateResponse {
        private boolean success;
        private String message;
        private int currentQuantity;
        
        public CartUpdateResponse() {
            this.success = false;
            this.message = "";
            this.currentQuantity = 0;
        }
        
        public boolean isSuccess() {
            return success;
        }
        
        public void setSuccess(boolean success) {
            this.success = success;
        }
        
        public String getMessage() {
            return message;
        }
        
        public void setMessage(String message) {
            this.message = message;
        }
        
        public int getCurrentQuantity() {
            return currentQuantity;
        }
        
        public void setCurrentQuantity(int currentQuantity) {
            this.currentQuantity = currentQuantity;
        }
    }
    
    /**
     * Remove an item from the cart
     * @param cartID Cart item ID
     * @return true if successful, false otherwise
     */
    public boolean removeCartItem(int cartID) {
        String query = "DELETE FROM Cart WHERE CartID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, cartID);
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in removeCartItem method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get the count of items in a user's cart
     * @param userID User ID
     * @return Count of cart items
     */
    public int getCartItemCount(int userID) {
        String query = "SELECT COUNT(*) FROM Cart WHERE UserID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, userID);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getCartItemCount method: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // The clearCart method has been removed as requested
}
