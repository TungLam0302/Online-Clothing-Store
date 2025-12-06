package dao;

import dbcontext.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Role;
import model.User;

/**
 * Data Access Object for User and Role entities
 */
public class UserDAO extends DBContext {
    
    /**
     * Check if a user with given email and password exists
     * @param email User's email
     * @param password User's password (not hashed)
     * @return User object if found, null otherwise
     */
    public User login(String email, String password) {
        String query = "SELECT u.*, r.RoleName FROM [User] u "
                + "JOIN Role r ON u.RoleID = r.ID "
                + "WHERE u.Email = ? AND u.Password = ? AND u.Status = 1";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Role role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                User user = new User(
                        rs.getInt("UserID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("Phone"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getInt("RoleID"),
                        rs.getBoolean("Status"),
                        role
                );
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error in login method: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Register a new user with customer role (RoleID = 1)
     * @param user User object with registration details
     * @return true if registration successful, false otherwise
     */
    public boolean register(User user) {
        String query = "INSERT INTO [User] (Email, Password, Phone, Name, Address, RoleID, Status) "
                + "VALUES (?, ?, ?, ?, ?, 1, 1)";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getName());
            ps.setString(5, user.getAddress());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error in register method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if email already exists in the database
     * @param email Email to check
     * @return true if email exists, false otherwise
     */
    public boolean checkEmailExists(String email) {
        String query = "SELECT COUNT(*) FROM [User] WHERE Email = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            
            ps.setString(1, email);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in checkEmailExists method: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if phone already exists in the database
     * @param phone Phone to check
     * @return true if phone exists, false otherwise
     */
    public boolean checkPhoneExists(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false; // Phone is optional, so no conflict if it's empty
        }
        
        String query = "SELECT COUNT(*) FROM [User] WHERE Phone = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            
            ps.setString(1, phone);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in checkPhoneExists method: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update user information in the database
     * @param user The user object with updated information
     * @return true if update successful, false otherwise
     */
    public boolean updateUser(User user) {
        String query = "UPDATE [User] SET Name = ?, Phone = ?, Address = ? WHERE UserID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            
            ps.setString(1, user.getName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setInt(4, user.getUserID());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error in updateUser method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update user's password
     * @param userID User's ID
     * @param newPassword New password (not hashed)
     * @return true if update successful, false otherwise
     */
    public boolean updatePassword(int userID, String newPassword) {
        String query = "UPDATE [User] SET Password = ? WHERE UserID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            
            ps.setString(1, newPassword);
            ps.setInt(2, userID);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error in updatePassword method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all users with their roles for admin management
     * @return List of all users with role information
     */
    public java.util.List<User> getAllUsers() {
        java.util.List<User> users = new java.util.ArrayList<>();
        String query = "SELECT u.*, r.RoleName FROM [User] u "
                + "JOIN Role r ON u.RoleID = r.ID "
                + "ORDER BY u.UserID";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Role role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                User user = new User(
                        rs.getInt("UserID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("Phone"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getInt("RoleID"),
                        rs.getBoolean("Status"),
                        role
                );
                users.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllUsers method: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Get user by ID with role information
     * @param userID User ID
     * @return User object with role information
     */
    public User getUserByID(int userID) {
        String query = "SELECT u.*, r.RoleName FROM [User] u "
                + "JOIN Role r ON u.RoleID = r.ID "
                + "WHERE u.UserID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Role role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                User user = new User(
                        rs.getInt("UserID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("Phone"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getInt("RoleID"),
                        rs.getBoolean("Status"),
                        role
                );
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error in getUserByID method: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Update user status (for delete functionality)
     * @param userID User ID
     * @param status New status (false for delete)
     * @return true if update successful, false otherwise
     */
    public boolean updateUserStatus(int userID, boolean status) {
        String query = "UPDATE [User] SET Status = ? WHERE UserID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setBoolean(1, status);
            ps.setInt(2, userID);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error in updateUserStatus method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update user role
     * @param userID User ID
     * @param roleID New role ID
     * @return true if update successful, false otherwise
     */
    public boolean updateUserRole(int userID, int roleID) {
        String query = "UPDATE [User] SET RoleID = ? WHERE UserID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setInt(1, roleID);
            ps.setInt(2, userID);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error in updateUserRole method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Create new user (for admin use)
     * @param user User object with user details
     * @return true if creation successful, false otherwise
     */
    public boolean createUser(User user) {
        String query = "INSERT INTO [User] (Email, Password, Phone, Name, Address, RoleID, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getName());
            ps.setString(5, user.getAddress());
            ps.setInt(6, user.getRoleID());
            ps.setBoolean(7, user.isStatus());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error in createUser method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update user information (for admin use)
     * @param user The user object with updated information
     * @return true if update successful, false otherwise
     */
    public boolean updateUserAdmin(User user) {
        String query = "UPDATE [User] SET Email = ?, Phone = ?, Name = ?, Address = ?, RoleID = ?, Status = ? WHERE UserID = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getName());
            ps.setString(4, user.getAddress());
            ps.setInt(5, user.getRoleID());
            ps.setBoolean(6, user.isStatus());
            ps.setInt(7, user.getUserID());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error in updateUserAdmin method: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all available roles
     * @return List of all roles
     */
    public java.util.List<Role> getAllRoles() {
        java.util.List<Role> roles = new java.util.ArrayList<>();
        String query = "SELECT * FROM Role ORDER BY ID";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Role role = new Role(rs.getInt("ID"), rs.getString("RoleName"));
                roles.add(role);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllRoles method: " + e.getMessage());
            e.printStackTrace();
        }
        return roles;
    }
    
    /**
     * Get total count of users
     * @return total user count
     */
    public int getTotalUserCount() {
        String query = "SELECT COUNT(*) FROM [User] WHERE Status = 1";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalUserCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Check if a user exists with given email and password (regardless of status)
     * @param email User's email
     * @param password User's password
     * @return User object if found, null otherwise
     */
    public User getUserByEmailAndPassword(String email, String password) {
        String query = "SELECT u.*, r.RoleName FROM [User] u "
                + "JOIN Role r ON u.RoleID = r.ID "
                + "WHERE u.Email = ? AND u.Password = ?";
        
        try {
            PreparedStatement ps = connect.prepareStatement(query);
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Role role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                User user = new User(
                        rs.getInt("UserID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("Phone"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getInt("RoleID"),
                        rs.getBoolean("Status"),
                        role
                );
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error in getUserByEmailAndPassword method: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
