<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Size Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <jsp:include page="../layout/adminheader.jsp" />
</head>
<body>
    <div class="content-wrapper">
        <jsp:include page="../layout/adminSideBar.jsp">
            <jsp:param name="activePage" value="sizes"/>
        </jsp:include>
        
        <main class="main-content">
            <div class="container-fluid px-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center border-bottom mb-3 pt-2 pb-2">
                    <h1 class="h2"><i class="fas fa-ruler me-2"></i>Size Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSizeModal" onclick="openAddModal()">
                            <i class="fas fa-plus me-2"></i>Add New Size
                        </button>
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <div class="card border-0 shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4">Size ID</th>
                                        <th>Size Name</th>
                                        <th class="text-end pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty sizes}">
                                            <c:forEach var="size" items="${sizes}">
                                                <tr>
                                                    <td class="ps-4">${size.sizeID}</td>
                                                    <td>${size.sizeName}</td>
                                                    <td class="text-end pe-4">
                                                        <div class="d-flex justify-content-end">
                                                            <button class="btn btn-outline-primary btn-sm me-2" 
                                                                    onclick="openEditModal('${size.sizeID}', '${size.sizeName}')">
                                                                <i class="fas fa-edit me-1"></i>Edit
                                                            </button>
                                                            <button class="btn btn-outline-danger btn-sm" 
                                                                    onclick="confirmDelete('${size.sizeID}')">
                                                                <i class="fas fa-trash me-1"></i>Delete
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="3" class="text-center py-4">
                                                    <p class="text-muted mb-0">No sizes found. Add a new size to get started.</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Add Size Modal -->
    <div class="modal fade" id="addSizeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Size</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/size?action=insert" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="sizeName" class="form-label">Size Name</label>
                            <input type="text" class="form-control" id="sizeName" name="sizeName" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Size</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Size Modal -->
    <div class="modal fade" id="editSizeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Size</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/size?action=update" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="editSizeID" name="sizeID">
                        <div class="mb-3">
                            <label for="editSizeName" class="form-label">Size Name</label>
                            <input type="text" class="form-control" id="editSizeName" name="sizeName" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Size</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <style>
        /* Ensure modal works properly without Bootstrap JS */
        .modal.show {
            display: block !important;
        }

        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1040;
            width: 100vw;
            height: 100vh;
            background-color: #000;
            opacity: 0.5;
        }

        .modal-backdrop.fade.show {
            opacity: 0.5;
        }

        body.modal-open {
            overflow: hidden;
            padding-right: 17px; /* Compensate for scrollbar */
        }

        .modal {
            z-index: 1050;
        }
    </style>

    <jsp:include page="../layout/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Mở modal bằng Bootstrap nếu có, còn không thì fallback manual
            function showModal(id) {
                const el = document.getElementById(id);
                if (typeof bootstrap !== 'undefined') {
                    bootstrap.Modal.getOrCreateInstance(el).show();
                } else {
                    manualShow(el);
                }
            }
            // Đóng modal bằng Bootstrap nếu có, còn không thì fallback manual
            function hideModal(el) {
                if (typeof bootstrap !== 'undefined') {
                    bootstrap.Modal.getOrCreateInstance(el).hide();
                } else {
                    manualHide(el);
                }
            }
            // Fallback hiển thị
            function manualShow(modal) {
                modal.classList.add('show');
                modal.style.display = 'block';
                document.body.classList.add('modal-open');
                addBackdrop();
            }
            // Fallback ẩn
            function manualHide(modal) {
                modal.classList.remove('show');
                modal.style.display = 'none';
                document.body.classList.remove('modal-open');
                removeBackdrop();
                // Reset form khi đóng modal
                const form = modal.querySelector('form');
                if (form) {
                    form.reset();
                }
            }
            // Tạo backdrop cho fallback
            function addBackdrop() {
                if (!document.querySelector('.manual-backdrop')) {
                    const bd = document.createElement('div');
                    bd.className = 'manual-backdrop';
                    bd.style.cssText = `
                position: fixed; top:0; left:0;
                width:100vw; height:100vh;
                background:rgba(0,0,0,0.5);
                z-index:1040;
            `;
                    bd.addEventListener('click', () => {
                        const open = document.querySelector('.modal.show');
                        if (open)
                            manualHide(open);
                    });
                    document.body.appendChild(bd);
                }
            }
            function removeBackdrop() {
                const bd = document.querySelector('.manual-backdrop');
                if (bd)
                    bd.remove();
            }

            // Mở modal Add/Edit
            window.openAddModal = () => {
                document.getElementById('sizeName').value = '';
                showModal('addSizeModal');
            };

            window.openEditModal = (sizeId, sizeName) => {
                document.getElementById('editSizeID').value = sizeId;
                document.getElementById('editSizeName').value = sizeName;
                showModal('editSizeModal');
            };

            // Xác nhận xóa
            window.confirmDelete = sizeId => {
                if (confirm('Are you sure you want to delete this size?')) {
                    location.href = '${pageContext.request.contextPath}/size?action=delete&id=' + sizeId;
                }
            };

            // Close khi click nút X hoặc Cancel - sử dụng event delegation
            document.addEventListener('click', function(e) {
                if (e.target.matches('[data-bs-dismiss="modal"]') || e.target.closest('[data-bs-dismiss="modal"]')) {
                    e.preventDefault();
                    e.stopPropagation();
                    const modal = e.target.closest('.modal');
                    if (modal) {
                        hideModal(modal);
                    }
                }
            });

            // ESC để đóng
            document.addEventListener('keydown', e => {
                if (e.key === 'Escape') {
                    const open = document.querySelector('.modal.show');
                    if (open)
                        hideModal(open);
                }
            });
        });
    </script>
</body>
</html> 