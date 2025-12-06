package controller;

import dao.BrandDAO;
import dao.CategoryDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Brand;
import model.Category;
import model.User;

/**
 * Controller for handling profile page display and updates
 */
@WebServlet(name = "ProfileController", urlPatterns = {"/profile", "/profile/update", "/profile/changePassword"})
public class ProfileController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method. Display profile page
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        BrandDAO brandDAO = new BrandDAO();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // If user not logged in, redirect to login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<Category> allCategories = categoryDAO.getAllCategories();
        List<Category> parentCategories = new ArrayList<>();

        // Filter parent categories
        for (Category category : allCategories) {
            if (category.getParentCategoryID() == null) {
                parentCategories.add(category);
            }
        }
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("categories", allCategories);
        request.setAttribute("parentCategories", parentCategories);
        request.setAttribute("brands", brands);

        // Forward to profile page
        request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method. Process profile updates or password changes
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // If user not logged in, redirect to login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Instantiate DAO
        UserDAO userDAO = new UserDAO();

        // Handle profile update
        if (path.equals("/profile/update")) {
            handleProfileUpdate(request, response, user, userDAO);
        } // Handle password change
        else if (path.equals("/profile/changePassword")) {
            handlePasswordChange(request, response, user, userDAO);
        }
    }

    /**
     * Handle profile information update
     */
    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response,
            User user, UserDAO userDAO) throws ServletException, IOException {
        // Get parameters
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate input
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Name cannot be empty");
            request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
            return;
        }

        // Check if phone number already exists (and is not the current user's phone)
        if (phone != null && !phone.trim().isEmpty() && !phone.equals(user.getPhone()) && userDAO.checkPhoneExists(phone)) {
            request.setAttribute("errorMessage", "This phone number is already in use by another account");
            request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
            return;
        }

        // Update user object
        user.setName(name);
        user.setPhone(phone);
        user.setAddress(address);

        // Update in database
        boolean success = userDAO.updateUser(user);

        if (success) {
            // Update session
            request.getSession().setAttribute("user", user);
            request.setAttribute("successMessage", "Your profile has been updated successfully");
        } else {
            request.setAttribute("errorMessage", "Error updating profile. Please try again.");
        }

        // Redirect back to profile page
        request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
    }

    /**
     * Handle password change request
     */
    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response,
            User user, UserDAO userDAO) throws ServletException, IOException {
        // Get parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (currentPassword == null || newPassword == null || confirmPassword == null
                || currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All password fields are required");
            request.setAttribute("tab", "security"); // To maintain the security tab active
            request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
            return;
        }

        // Check if current password is correct
        if (!currentPassword.equals(user.getPassword())) {
            request.setAttribute("errorMessage", "Current password is incorrect");
            request.setAttribute("tab", "security");
            request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
            return;
        }

        // Check if new passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New passwords do not match");
            request.setAttribute("tab", "security");
            request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
            return;
        }

        // Password strength validation
        if (newPassword.length() < 8
                || !newPassword.matches(".*[A-Z].*")
                || !newPassword.matches(".*[a-z].*")
                || !newPassword.matches(".*[0-9].*")) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters and contain uppercase, lowercase letters and numbers");
            request.setAttribute("tab", "security");
            request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
            return;
        }

        // Update password in database
        boolean success = userDAO.updatePassword(user.getUserID(), newPassword);

        if (success) {
            // Update session
            user.setPassword(newPassword);
            request.getSession().setAttribute("user", user);
            request.setAttribute("successMessage", "Your password has been changed successfully");
        } else {
            request.setAttribute("errorMessage", "Error changing password. Please try again.");
        }

        // Set tab parameter to maintain the security tab active
        request.setAttribute("tab", "security");
        request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
    }
}
