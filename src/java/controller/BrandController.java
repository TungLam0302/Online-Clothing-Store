package controller;

import dao.BrandDAO;
import model.Brand;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "BrandController", urlPatterns = {"/brand"})
public class BrandController extends HttpServlet {
    private BrandDAO brandDAO;

    public void init() {
        brandDAO = new BrandDAO();
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
                deleteBrand(request, response);
                break;
            default:
                listBrands(request, response);
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
                insertBrand(request, response);
                break;
            case "update":
                updateBrand(request, response);
                break;
            case "delete":
                deleteBrand(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                break;
        }
    }

    private void listBrands(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("brands", brands);
        request.getRequestDispatcher("/view/manager/brandList.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/manager/addBrand.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int brandId = Integer.parseInt(request.getParameter("id"));
        Brand existingBrand = brandDAO.getBrandById(brandId);
        request.setAttribute("brand", existingBrand);
        request.getRequestDispatcher("/view/manager/updateBrand.jsp").forward(request, response);
    }

    private void insertBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String brandName = request.getParameter("brandName");
        Brand newBrand = new Brand();
        newBrand.setBrandName(brandName);
        
        if (brandDAO.insertBrand(newBrand)) {
            response.sendRedirect(request.getContextPath() + "/brand?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to add brand");
            request.getRequestDispatcher("/view/manager/addBrand.jsp").forward(request, response);
        }
    }

    private void updateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int brandId = Integer.parseInt(request.getParameter("brandID"));
        String brandName = request.getParameter("brandName");
        
        Brand brand = new Brand();
        brand.setBrandID(brandId);
        brand.setBrandName(brandName);
        
        if (brandDAO.updateBrand(brand)) {
            response.sendRedirect(request.getContextPath() + "/brand?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to update brand");
            request.setAttribute("brand", brand);
            request.getRequestDispatcher("/view/manager/updateBrand.jsp").forward(request, response);
        }
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int brandId = Integer.parseInt(request.getParameter("id"));
        
        if (brandDAO.deleteBrand(brandId)) {
            response.sendRedirect(request.getContextPath() + "/brand?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to delete brand");
            listBrands(request, response);
        }
    }
} 