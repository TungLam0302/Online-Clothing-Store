package controller;

import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Role;
import model.User;

/**
 * User Controller for Admin User Management
 */
@WebServlet(name = "UserController", urlPatterns = {"/admin/users"})
public class UserController extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleID() != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                showUserList(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                showUserList(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleID() != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }
        
        switch (action) {
            case "create":
                createUser(request, response);
                break;
            case "update":
                updateUser(request, response);
                break;
            default:
                showUserList(request, response);
                break;
        }
    }
    
    /**
     * Show user list
     */
    private void showUserList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.setAttribute("activePage", "users");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/accountList.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading users: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/accountList.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * Show add user form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Role> roles = userDAO.getAllRoles();
            request.setAttribute("roles", roles);
            request.setAttribute("activePage", "users");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/addAccount.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading roles: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/addAccount.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * Show edit user form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int userID = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserByID(userID);
            List<Role> roles = userDAO.getAllRoles();
            
            if (user == null) {
                request.setAttribute("error", "User not found");
                showUserList(request, response);
                return;
            }
            
            request.setAttribute("user", user);
            request.setAttribute("roles", roles);
            request.setAttribute("activePage", "users");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/updateAccount.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid user ID");
            showUserList(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading user: " + e.getMessage());
            showUserList(request, response);
        }
    }
    
    /**
     * Create new user
     */
    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            int roleID = Integer.parseInt(request.getParameter("roleID"));
            boolean status = request.getParameter("status") != null;
            
            // Validate input
            if (email == null || email.trim().isEmpty() || 
                password == null || password.trim().isEmpty() ||
                name == null || name.trim().isEmpty()) {
                
                request.setAttribute("error", "Email, password, and name are required");
                showAddForm(request, response);
                return;
            }
            
            // Check if email already exists
            if (userDAO.checkEmailExists(email)) {
                request.setAttribute("error", "Email already exists");
                showAddForm(request, response);
                return;
            }
            
            // Check if phone already exists (if provided)
            if (phone != null && !phone.trim().isEmpty() && userDAO.checkPhoneExists(phone)) {
                request.setAttribute("error", "Phone number already exists");
                showAddForm(request, response);
                return;
            }
            
            User user = new User();
            user.setEmail(email.trim());
            user.setPassword(password);
            user.setPhone(phone != null ? phone.trim() : "");
            user.setName(name.trim());
            user.setAddress(address != null ? address.trim() : "");
            user.setRoleID(roleID);
            user.setStatus(status);
            
            boolean success = userDAO.createUser(user);
            
            if (success) {
                request.setAttribute("success", "User created successfully");
                showUserList(request, response);
            } else {
                request.setAttribute("error", "Failed to create user");
                showAddForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid role ID");
            showAddForm(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating user: " + e.getMessage());
            showAddForm(request, response);
        }
    }
    
    /**
     * Update user
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            int roleID = Integer.parseInt(request.getParameter("roleID"));
            boolean status = request.getParameter("status") != null;
            
            // Validate input
            if (email == null || email.trim().isEmpty() || 
                name == null || name.trim().isEmpty()) {
                
                request.setAttribute("error", "Email and name are required");
                showEditForm(request, response);
                return;
            }
            
            // Get existing user to check if email changed
            User existingUser = userDAO.getUserByID(userID);
            if (existingUser == null) {
                request.setAttribute("error", "User not found");
                showUserList(request, response);
                return;
            }
            
            // Check if email already exists (only if email changed)
            if (!existingUser.getEmail().equals(email.trim()) && userDAO.checkEmailExists(email)) {
                request.setAttribute("error", "Email already exists");
                showEditForm(request, response);
                return;
            }
            
            // Check if phone already exists (only if phone changed and is not empty)
            if (phone != null && !phone.trim().isEmpty() && 
                !phone.trim().equals(existingUser.getPhone()) && 
                userDAO.checkPhoneExists(phone)) {
                
                request.setAttribute("error", "Phone number already exists");
                showEditForm(request, response);
                return;
            }
            
            User user = new User();
            user.setUserID(userID);
            user.setEmail(email.trim());
            user.setPhone(phone != null ? phone.trim() : "");
            user.setName(name.trim());
            user.setAddress(address != null ? address.trim() : "");
            user.setRoleID(roleID);
            user.setStatus(status);
            
            boolean success = userDAO.updateUserAdmin(user);
            
            if (success) {
                request.setAttribute("success", "User updated successfully");
                showUserList(request, response);
            } else {
                request.setAttribute("error", "Failed to update user");
                showEditForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid user ID or role ID");
            showEditForm(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating user: " + e.getMessage());
            showEditForm(request, response);
        }
    }
    
    /**
     * Delete user (set status to false)
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int userID = Integer.parseInt(request.getParameter("id"));
            
            // Get user to check if it exists
            User user = userDAO.getUserByID(userID);
            if (user == null) {
                request.setAttribute("error", "User not found");
                showUserList(request, response);
                return;
            }
            
            // Prevent admin from deleting themselves
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            if (currentUser.getUserID() == userID) {
                request.setAttribute("error", "Cannot delete your own account");
                showUserList(request, response);
                return;
            }
            
            boolean success = userDAO.updateUserStatus(userID, false);
            
            if (success) {
                request.setAttribute("success", "User deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete user");
            }
            
            showUserList(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid user ID");
            showUserList(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error deleting user: " + e.getMessage());
            showUserList(request, response);
        }
    }
}
