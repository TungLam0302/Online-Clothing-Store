package model;

/**
 * Cart model class representing items in a user's shopping cart
 */
public class Cart {
    private int cartID;
    private int userID;
    private int productItemID;
    private int quantity;
    
    // Related entities
    private ProductItem productItem;
    private User user;

    public Cart() {
    }

    public Cart(int cartID, int userID, int productItemID, int quantity) {
        this.cartID = cartID;
        this.userID = userID;
        this.productItemID = productItemID;
        this.quantity = quantity;
    }
    
    public Cart(int userID, int productItemID, int quantity) {
        this.userID = userID;
        this.productItemID = productItemID;
        this.quantity = quantity;
    }

    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getProductItemID() {
        return productItemID;
    }

    public void setProductItemID(int productItemID) {
        this.productItemID = productItemID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public ProductItem getProductItem() {
        return productItem;
    }

    public void setProductItem(ProductItem productItem) {
        this.productItem = productItem;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
    
    @Override
    public String toString() {
        return "Cart{" + "cartID=" + cartID + ", userID=" + userID + ", productItemID=" + productItemID + ", quantity=" + quantity + '}';
    }
}
