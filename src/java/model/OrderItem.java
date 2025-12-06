package model;

/**
 * OrderItem model class representing items in an order
 */
public class OrderItem {
    private int orderDetailID;
    private int orderID;
    private int productItemID;
    private int quantity;
    private double price;
    private double subtotal;
    private ProductItem productItem;

    public OrderItem() {
    }

    public OrderItem(int orderDetailID, int orderID, int productItemID, int quantity, double price, double subtotal) {
        this.orderDetailID = orderDetailID;
        this.orderID = orderID;
        this.productItemID = productItemID;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
    }

    public int getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(int orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public ProductItem getProductItem() {
        return productItem;
    }

    public void setProductItem(ProductItem productItem) {
        this.productItem = productItem;
    }

    @Override
    public String toString() {
        return "OrderItem{" + "orderDetailID=" + orderDetailID + ", orderID=" + orderID + ", productItemID=" + productItemID + ", quantity=" + quantity + ", price=" + price + ", subtotal=" + subtotal + '}';
    }
}