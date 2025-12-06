package model;

/**
 * User model class representing the User table
 */
public class User {
    private int userID;
    private String email;
    private String password;
    private String phone;
    private String name;
    private String address;
    private int roleID;
    private boolean status;
    private Role role;
    
    public User() {
    }
    
    public User(int userID, String email, String password, String phone, String name, String address, int roleID, boolean status) {
        this.userID = userID;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.name = name;
        this.address = address;
        this.roleID = roleID;
        this.status = status;
    }
    
    public User(int userID, String email, String password, String phone, String name, String address, int roleID, boolean status, Role role) {
        this.userID = userID;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.name = name;
        this.address = address;
        this.roleID = roleID;
        this.status = status;
        this.role = role;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    public Role getRole() {
        return role;
    }
    
    public void setRole(Role role) {
        this.role = role;
    }
    
    @Override
    public String toString() {
        return "User{" + "userID=" + userID + ", email=" + email + ", phone=" + phone + ", name=" + name + ", address=" + address + ", roleID=" + roleID + ", status=" + status + '}';
    }
}
