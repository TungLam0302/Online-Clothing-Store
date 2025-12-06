package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * RegisterController handles user registration
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method - Shows registration page
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            response.sendRedirect("home");
            return;
        }
        
        // Forward to register page
        request.getRequestDispatcher("view/authen/register.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method - Processes registration request
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get registration form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Store form data for re-display if there are errors
        request.setAttribute("email", email);
        request.setAttribute("name", name);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        
        // Validate input
        UserDAO userDAO = new UserDAO();
        
        if (email == null || email.isEmpty() || 
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty() ||
            name == null || name.isEmpty()) {
            
            request.setAttribute("error", "Please fill all required fields");
            request.getRequestDispatcher("view/authen/register.jsp").forward(request, response);
            return;
        }
        
        // Validate email format
        if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("error", "Invalid email format");
            request.getRequestDispatcher("view/authen/register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("view/authen/register.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (userDAO.checkEmailExists(email)) {
            request.setAttribute("error", "Email already exists");
            request.getRequestDispatcher("view/authen/register.jsp").forward(request, response);
            return;
        }
        
        // Check if phone already exists (if provided)
        if (phone != null && !phone.isEmpty() && userDAO.checkPhoneExists(phone)) {
            request.setAttribute("error", "Phone number already exists");
            request.getRequestDispatcher("view/authen/register.jsp").forward(request, response);
            return;
        }
        
        // Create new user object
        User newUser = new User();
        newUser.setEmail(email);
        newUser.setPassword(password); // No hashing as per requirement
        newUser.setName(name);
        newUser.setPhone(phone);
        newUser.setAddress(address);
        newUser.setRoleID(1); // Default role is customer (1)
        newUser.setStatus(true);
        
        // Register user
        boolean success = userDAO.register(newUser);
        
        if (success) {
            // Registration successful - redirect to login with success message
            request.getSession().setAttribute("registerSuccess", "Registration successful! Please login.");
            response.sendRedirect("login");
        } else {
            // Registration failed
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("view/authen/register.jsp").forward(request, response);
        }
    }
}
