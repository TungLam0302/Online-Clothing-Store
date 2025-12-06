package dao;

import dbcontext.DBContext;
import model.Brand;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO extends DBContext {
    
    // Create (Insert) a new brand
    public boolean insertBrand(Brand brand) {
        String sql = "INSERT INTO Brand (BrandName) VALUES (?)";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, brand.getBrandName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Read all brands
    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT * FROM Brand";
        try {
            Statement st = connect.createStatement();
            ResultSet rs = st.executeQuery(sql);
            
            while (rs.next()) {
                Brand brand = new Brand(
                    rs.getInt("BrandID"),
                    rs.getString("BrandName")
                );
                brands.add(brand);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }
    
    // Read a specific brand by ID
    public Brand getBrandById(int brandId) {
        String sql = "SELECT * FROM Brand WHERE BrandID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, brandId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Brand(
                    rs.getInt("BrandID"),
                    rs.getString("BrandName")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Update a brand
    public boolean updateBrand(Brand brand) {
        String sql = "UPDATE Brand SET BrandName = ? WHERE BrandID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, brand.getBrandName());
            ps.setInt(2, brand.getBrandID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete a brand
    public boolean deleteBrand(int brandId) {
        String sql = "DELETE FROM Brand WHERE BrandID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, brandId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
} 