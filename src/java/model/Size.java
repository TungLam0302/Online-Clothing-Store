package model;

public class Size {
    private int sizeID;
    private String sizeName;

    // Default constructor
    public Size() {}

    // Parameterized constructor
    public Size(int sizeID, String sizeName) {
        this.sizeID = sizeID;
        this.sizeName = sizeName;
    }

    // Getters and Setters
    public int getSizeID() {
        return sizeID;
    }

    public void setSizeID(int sizeID) {
        this.sizeID = sizeID;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

    // toString method for debugging
    @Override
    public String toString() {
        return "Size{" +
                "sizeID=" + sizeID +
                ", sizeName='" + sizeName + '\'' +
                '}';
    }
} 