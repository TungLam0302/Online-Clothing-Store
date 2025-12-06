package dao;

import dbcontext.DBContext;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {
    
    // Create (Insert) a new category
    public boolean insertCategory(Category category) {
        String sql = "INSERT INTO Category (CategoryName, ParentCategoryID) VALUES (?, ?)";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, category.getCategoryName());
            
            // Handle potential null ParentCategoryID
            if (category.getParentCategoryID() != null) {
                ps.setInt(2, category.getParentCategoryID());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<Category> getAllCategory() {
        String sql = "select * from Category where ParentCategoryID != 0";
        List<Category> lb = new ArrayList<>();

        try (PreparedStatement st = connect.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Category b = new Category();
                b.setCategoryID(rs.getInt("CategoryID"));
                b.setCategoryName(rs.getString("CategoryName"));
                b.setParentCategoryID(rs.getInt("ParentCategoryID"));
                lb.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
        return lb;
    }
    // Read all categories
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Category";
        try {
            Statement st = connect.createStatement();
            ResultSet rs = st.executeQuery(sql);
            
            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName"),
                    rs.getObject("ParentCategoryID") != null ? 
                        rs.getInt("ParentCategoryID") : null
                );
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Read a specific category by ID
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM Category WHERE CategoryID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Category(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName"),
                    rs.getObject("ParentCategoryID") != null ? 
                        rs.getInt("ParentCategoryID") : null
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Update a category
    public boolean updateCategory(Category category) {
        String sql = "UPDATE Category SET CategoryName = ?, ParentCategoryID = ? WHERE CategoryID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, category.getCategoryName());
            
            // Handle potential null ParentCategoryID
            if (category.getParentCategoryID() != null) {
                ps.setInt(2, category.getParentCategoryID());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            
            ps.setInt(3, category.getCategoryID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete a category
    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM Category WHERE CategoryID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get categories with no parent (root categories)
    public List<Category> getRootCategories() {
        List<Category> rootCategories = new ArrayList<>();
        String sql = "SELECT * FROM Category WHERE ParentCategoryID IS NULL";
        try {
            Statement st = connect.createStatement();
            ResultSet rs = st.executeQuery(sql);
            
            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName"),
                    null
                );
                rootCategories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rootCategories;
    }
    
    // Get subcategories of a given parent category
    public List<Category> getSubcategories(int parentCategoryId) {
        List<Category> subcategories = new ArrayList<>();
        String sql = "SELECT * FROM Category WHERE ParentCategoryID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, parentCategoryId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName"),
                    parentCategoryId
                );
                subcategories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subcategories;
    }
}