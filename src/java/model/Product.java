package model;

import java.math.BigDecimal;
import java.util.List;
import java.util.ArrayList;

public class Product {

    private int productID;
    private String productName;
    private String desciption;
    private String price;
    private Brand brand;
    private Category category;
    private Boolean status;
    private String thumbnail;

    public Product() {
    }

    public Product(int productID, String productName, String desciption, String price, Brand brand, Category category, Boolean status, String thumbnail) {
        this.productID = productID;
        this.productName = productName;
        this.desciption = desciption;
        this.price = price;
        this.brand = brand;
        this.category = category;
        this.status = status;
        this.thumbnail = thumbnail;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDesciption() {
        return desciption;
    }

    public void setDesciption(String desciption) {
        this.desciption = desciption;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public Brand getBrand() {
        return brand;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

}
