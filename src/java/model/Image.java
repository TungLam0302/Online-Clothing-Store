package model;

public class Image {
    private int imageID;
    private int productId;
    private String url;

    public Image() {
    }

    public Image(int imageID, int productId, String url) {
        this.imageID = imageID;
        this.productId = productId;
        this.url = url;
    }

    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
    
}