package dao;

import dbcontext.DBContext;
import model.Size;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SizeDAO extends DBContext {
    
    // Create (Insert) a new size
    public boolean insertSize(Size size) {
        String sql = "INSERT INTO Size (SizeName) VALUES (?)";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, size.getSizeName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<Size> getAllSize() {
        String sql = "select * from size";
        List<Size> lb = new ArrayList<>();

        try (PreparedStatement st = connect.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Size b = new Size();
                b.setSizeID(rs.getInt("SizeID"));
                b.setSizeName(rs.getString("SizeName"));
                lb.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
        return lb;
    }
    // Read all sizes
    public List<Size> getAllSizes() {
        List<Size> sizes = new ArrayList<>();
        String sql = "SELECT * FROM Size ORDER BY SizeID";
        try {
            Statement st = connect.createStatement();
            ResultSet rs = st.executeQuery(sql);
            
            while (rs.next()) {
                Size size = new Size(
                    rs.getInt("SizeID"),
                    rs.getString("SizeName")
                );
                sizes.add(size);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sizes;
    }
    
    // Read a specific size by ID
    public Size getSizeById(int sizeId) {
        String sql = "SELECT * FROM Size WHERE SizeID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, sizeId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Size(
                    rs.getInt("SizeID"),
                    rs.getString("SizeName")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Update a size
    public boolean updateSize(Size size) {
        String sql = "UPDATE Size SET SizeName = ? WHERE SizeID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, size.getSizeName());
            ps.setInt(2, size.getSizeID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete a size
    public boolean deleteSize(int sizeId) {
        String sql = "DELETE FROM Size WHERE SizeID = ?";
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, sizeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
} 