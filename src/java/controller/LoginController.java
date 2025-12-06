package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * LoginController handles user authentication
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method - Shows login page
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

        //thêm
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("email")) {
                    request.setAttribute("email", cookie.getValue());
                }
                if (cookie.getName().equals("password")) {
                    request.setAttribute("password", cookie.getValue());
                }
                if (cookie.getName().equals("remember")) {
                    request.setAttribute("remember", "checked");
                }
            }
        }

        // Forward to login page
        request.getRequestDispatcher("view/authen/login.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method - Processes login request
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String remember = request.getParameter("rememberMe"); // checkbox value

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Please enter both email and password");
            request.getRequestDispatcher("view/authen/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmailAndPassword(email, password);

        if (user != null) {
            // Check if account is active
            if (!user.isStatus()) {
                request.setAttribute("error", "Tài khoản đã ngừng hoạt động. Vui lòng liên hệ quản trị viên.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("view/authen/login.jsp").forward(request, response);
                return;
            }

            // Login successful
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            //remember cookie
            if (remember != null) {
                Cookie emailCookie = new Cookie("email", email);
                Cookie passCookie = new Cookie("password", password);
                Cookie rememberCookie = new Cookie("remember", "true");

                emailCookie.setMaxAge(60 * 60 * 24 * 7);
                passCookie.setMaxAge(60 * 60 * 24 * 7);
                rememberCookie.setMaxAge(60 * 60 * 24 * 7);

                response.addCookie(emailCookie);
                response.addCookie(passCookie);
                response.addCookie(rememberCookie);
            }

            // Redirect based on role
            if (user.getRoleID() == 1) { // Customer
                response.sendRedirect("home");
            } else if (user.getRoleID() == 2) { // Manager
                response.sendRedirect("dashboard");
            } else if (user.getRoleID() == 3) { // Admin
                response.sendRedirect("dashboard");
            } else {
                response.sendRedirect("home");
            }
        } else {
            // Login failed
            request.setAttribute("error", "Invalid email or password");
            request.setAttribute("email", email); // Keep email for better UX
            request.getRequestDispatcher("view/authen/login.jsp").forward(request, response);
        }
    }
}
