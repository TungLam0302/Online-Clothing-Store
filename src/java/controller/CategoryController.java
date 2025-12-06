package controller;

import dao.CategoryDAO;
import model.Category;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "CategoryController", urlPatterns = {"/category"})
public class CategoryController extends HttpServlet {
    private CategoryDAO categoryDAO;

    public void init() {
        categoryDAO = new CategoryDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleID() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleID() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        
        switch (action) {
            case "insert":
                insertCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                break;
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        List<Category> rootCategories = categoryDAO.getRootCategories();
        
        request.setAttribute("categories", categories);
        request.setAttribute("rootCategories", rootCategories);
        request.getRequestDispatcher("/view/manager/categoryList.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> rootCategories = categoryDAO.getRootCategories();
        request.setAttribute("rootCategories", rootCategories);
        request.getRequestDispatcher("/view/manager/addCategory.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("id"));
        Category existingCategory = categoryDAO.getCategoryById(categoryId);
        List<Category> rootCategories = categoryDAO.getRootCategories();
        
        request.setAttribute("category", existingCategory);
        request.setAttribute("rootCategories", rootCategories);
        request.getRequestDispatcher("/view/manager/updateCategory.jsp").forward(request, response);
    }

    private void insertCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryName = request.getParameter("categoryName");
        String parentCategoryIdStr = request.getParameter("parentCategoryID");
        
        Category newCategory = new Category();
        newCategory.setCategoryName(categoryName);
        
        // Set parent category if selected
        if (parentCategoryIdStr != null && !parentCategoryIdStr.isEmpty()) {
            newCategory.setParentCategoryID(Integer.parseInt(parentCategoryIdStr));
        }
        
        if (categoryDAO.insertCategory(newCategory)) {
            response.sendRedirect(request.getContextPath() + "/category?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to add category");
            showNewForm(request, response);
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryID"));
        String categoryName = request.getParameter("categoryName");
        String parentCategoryIdStr = request.getParameter("parentCategoryID");
        
        Category category = new Category();
        category.setCategoryID(categoryId);
        category.setCategoryName(categoryName);
        
        // Set parent category if selected
        if (parentCategoryIdStr != null && !parentCategoryIdStr.isEmpty()) {
            category.setParentCategoryID(Integer.parseInt(parentCategoryIdStr));
        } else {
            category.setParentCategoryID(null);
        }
        
        if (categoryDAO.updateCategory(category)) {
            response.sendRedirect(request.getContextPath() + "/category?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to update category");
            request.setAttribute("category", category);
            showEditForm(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("id"));
        
        if (categoryDAO.deleteCategory(categoryId)) {
            response.sendRedirect(request.getContextPath() + "/category?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to delete category");
            listCategories(request, response);
        }
    }
} 