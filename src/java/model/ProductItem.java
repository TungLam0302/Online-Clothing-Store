package model;

public class ProductItem {
    private int productItemId;
    private Product product;
    private Size size;
    private int stockQuantity;

    public ProductItem() {
    }

    public ProductItem(int productItemId, Product product, Size size, int stockQuantity) {
        this.productItemId = productItemId;
        this.product = product;
        this.size = size;
        this.stockQuantity = stockQuantity;
    }

    public int getProductItemId() {
        return productItemId;
    }

    public void setProductItemId(int productItemId) {
        this.productItemId = productItemId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Size getSize() {
        return size;
    }

    public void setSize(Size size) {
        this.size = size;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
    
    
}
