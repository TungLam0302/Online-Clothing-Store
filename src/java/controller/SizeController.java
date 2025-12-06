package controller;

import dao.SizeDAO;
import model.Size;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "SizeController", urlPatterns = {"/size"})
public class SizeController extends HttpServlet {
    private SizeDAO sizeDAO;

    public void init() {
        sizeDAO = new SizeDAO();
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
                deleteSize(request, response);
                break;
            default:
                listSizes(request, response);
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
                insertSize(request, response);
                break;
            case "update":
                updateSize(request, response);
                break;
            case "delete":
                deleteSize(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                break;
        }
    }

    private void listSizes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Size> sizes = sizeDAO.getAllSizes();
        request.setAttribute("sizes", sizes);
        request.getRequestDispatcher("/view/manager/sizeList.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/manager/addSize.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int sizeId = Integer.parseInt(request.getParameter("id"));
        Size existingSize = sizeDAO.getSizeById(sizeId);
        request.setAttribute("size", existingSize);
        request.getRequestDispatcher("/view/manager/updateSize.jsp").forward(request, response);
    }

    private void insertSize(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sizeName = request.getParameter("sizeName");
        Size newSize = new Size();
        newSize.setSizeName(sizeName);
        
        if (sizeDAO.insertSize(newSize)) {
            response.sendRedirect(request.getContextPath() + "/size?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to add size");
            request.getRequestDispatcher("/view/manager/addSize.jsp").forward(request, response);
        }
    }

    private void updateSize(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int sizeId = Integer.parseInt(request.getParameter("sizeID"));
        String sizeName = request.getParameter("sizeName");
        
        Size size = new Size();
        size.setSizeID(sizeId);
        size.setSizeName(sizeName);
        
        if (sizeDAO.updateSize(size)) {
            response.sendRedirect(request.getContextPath() + "/size?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to update size");
            request.setAttribute("size", size);
            request.getRequestDispatcher("/view/manager/updateSize.jsp").forward(request, response);
        }
    }

    private void deleteSize(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int sizeId = Integer.parseInt(request.getParameter("id"));
        
        if (sizeDAO.deleteSize(sizeId)) {
            response.sendRedirect(request.getContextPath() + "/size?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to delete size");
            listSizes(request, response);
        }
    }
} 