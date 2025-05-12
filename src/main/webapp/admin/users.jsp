<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - StreamFlix Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body class="admin-page">
    <div class="admin-container">
        <c:set var="activePage" value="users" scope="request" />
        <jsp:include page="includes/sidebar.jsp" />
        
        <div class="admin-content">
            <div class="admin-header">
                <h1>User Management</h1>
                <div class="admin-actions">
                    <a href="${pageContext.request.contextPath}/admin/user-form.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New User
                    </a>
                </div>
            </div>
            
            <div class="user-filters">
                <div class="filter-group">
                    <label for="subscriptionFilter">Subscription:</label>
                    <select id="subscriptionFilter">
                        <option value="all">All Plans</option>
                        <option value="basic">Basic</option>
                        <option value="standard">Standard</option>
                        <option value="premium">Premium</option>
                        <option value="none">No Subscription</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="statusFilter">Status:</label>
                    <select id="statusFilter">
                        <option value="all">All Status</option>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                        <option value="suspended">Suspended</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="sortBy">Sort By:</label>
                    <select id="sortBy">
                        <option value="name_asc">Name (A-Z)</option>
                        <option value="name_desc">Name (Z-A)</option>
                        <option value="date_asc">Join Date (Oldest)</option>
                        <option value="date_desc">Join Date (Newest)</option>
                    </select>
                </div>
                
                <div class="filter-group search">
                    <input type="text" id="userSearch" placeholder="Search users...">
                    <button id="searchBtn" class="btn btn-small">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
            
            <div class="user-table-container">
                <table class="admin-table user-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Subscription</th>
                            <th>Status</th>
                            <th>Join Date</th>
                            <th>Last Login</th>
                            <th class="actions-col">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${users}" var="user">
                            <tr>
                                <td>
                                    <div class="user-info">
                                        <div class="user-avatar">
                                            <c:choose>
                                                <c:when test="${not empty user.avatarUrl}">
                                                    <img src="${user.avatarUrl}" alt="${user.name}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="avatar-placeholder">
                                                        ${fn:substring(user.name, 0, 1)}
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <span>${user.name}</span>
                                    </div>
                                </td>
                                <td>${user.email}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty user.subscription}">
                                            <span class="badge ${user.subscription.type.toLowerCase()}">
                                                ${user.subscription.type}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge none">None</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="status-indicator ${user.status.toLowerCase()}">
                                        ${user.status}
                                    </span>
                                </td>
                                <td>
                                    <fmt:formatDate value="${user.createdAt}" pattern="MMM d, yyyy" />
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty user.lastLoginAt}">
                                            <fmt:formatDate value="${user.lastLoginAt}" pattern="MMM d, yyyy HH:mm" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Never</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions-col">
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/admin/user-form.jsp?id=${user.id}" class="btn-icon" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/user-details.jsp?id=${user.id}" class="btn-icon" title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <button class="btn-icon status-toggle-btn ${user.status == 'Active' ? 'suspend' : 'activate'}" 
                                                data-id="${user.id}" 
                                                data-action="${user.status == 'Active' ? 'suspend' : 'activate'}" 
                                                title="${user.status == 'Active' ? 'Suspend' : 'Activate'}">
                                            <i class="fas ${user.status == 'Active' ? 'fa-ban' : 'fa-check-circle'}"></i>
                                        </button>
                                        <button class="btn-icon delete-btn" data-id="${user.id}" title="Delete">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="pagination">
                <c:if test="${totalPages > 1}">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}${queryParams}" class="page-link">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                        <a href="?page=${pageNum}${queryParams}" class="page-link ${pageNum == currentPage ? 'active' : ''}">
                            ${pageNum}
                        </a>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}${queryParams}" class="page-link">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:if>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Confirm Deletion</h2>
                <span class="close-modal">&times;</span>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this user? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button id="cancelDelete" class="btn btn-outline">Cancel</button>
                <button id="confirmDelete" class="btn btn-danger">Delete</button>
            </div>
        </div>
    </div>
    
    <!-- Status Change Modal -->
    <div id="statusModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="statusModalTitle">Confirm Status Change</h2>
                <span class="close-modal">&times;</span>
            </div>
            <div class="modal-body">
                <p id="statusModalMessage"></p>
            </div>
            <div class="modal-footer">
                <button id="cancelStatus" class="btn btn-outline">Cancel</button>
                <button id="confirmStatus" class="btn btn-primary">Confirm</button>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const subscriptionFilter = document.getElementById('subscriptionFilter');
            const statusFilter = document.getElementById('statusFilter');
            const sortBy = document.getElementById('sortBy');
            const searchInput = document.getElementById('userSearch');
            const searchBtn = document.getElementById('searchBtn');
            
            // Apply filters when changed
            function applyFilters() {
                const subscription = subscriptionFilter.value;
                const status = statusFilter.value;
                const sort = sortBy.value;
                const search = searchInput.value.trim();
                
                let url = '${pageContext.request.contextPath}/admin/users.jsp?';
                
                if (subscription !== 'all') url += `&subscription=${subscription}`;
                if (status !== 'all') url += `&status=${status}`;
                if (sort) url += `&sort=${sort}`;
                if (search !== '') url += `&search=${encodeURIComponent(search)}`;
                
                window.location.href = url;
            }
            
            subscriptionFilter.addEventListener('change', applyFilters);
            statusFilter.addEventListener('change', applyFilters);
            sortBy.addEventListener('change', applyFilters);
            searchBtn.addEventListener('click', applyFilters);
            
            // Also apply filters when pressing Enter in search box
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    applyFilters();
                }
            });
            
            // Set filter values from URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('subscription')) subscriptionFilter.value = urlParams.get('subscription');
            if (urlParams.has('status')) statusFilter.value = urlParams.get('status');
            if (urlParams.has('sort')) sortBy.value = urlParams.get('sort');
            if (urlParams.has('search')) searchInput.value = urlParams.get('search');
            
            // Delete modal functionality
            const deleteModal = document.getElementById('deleteModal');
            const closeDeleteModal = deleteModal.querySelector('.close-modal');
            const cancelDelete = document.getElementById('cancelDelete');
            const confirmDelete = document.getElementById('confirmDelete');
            const deleteButtons = document.querySelectorAll('.delete-btn');
            
            let userIdToDelete = null;
            
            // Open modal when delete button is clicked
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    userIdToDelete = this.getAttribute('data-id');
                    deleteModal.style.display = 'block';
                });
            });
            
            // Close delete modal functions
            function closeDeleteModalFn() {
                deleteModal.style.display = 'none';
                userIdToDelete = null;
            }
            
            closeDeleteModal.addEventListener('click', closeDeleteModalFn);
            cancelDelete.addEventListener('click', closeDeleteModalFn);
            
            // Handle delete confirmation
            confirmDelete.addEventListener('click', function() {
                if (userIdToDelete) {
                    window.location.href = `${pageContext.request.contextPath}/admin/users/delete?id=${userIdToDelete}`;
                }
            });
            
            // Status change modal functionality
            const statusModal = document.getElementById('statusModal');
            const statusModalTitle = document.getElementById('statusModalTitle');
            const statusModalMessage = document.getElementById('statusModalMessage');
            const closeStatusModal = statusModal.querySelector('.close-modal');
            const cancelStatus = document.getElementById('cancelStatus');
            const confirmStatus = document.getElementById('confirmStatus');
            const statusButtons = document.querySelectorAll('.status-toggle-btn');
            
            let userIdToChangeStatus = null;
            let statusAction = null;
            
            // Open modal when status button is clicked
            statusButtons.forEach(button => {
                button.addEventListener('click', function() {
                    userIdToChangeStatus = this.getAttribute('data-id');
                    statusAction = this.getAttribute('data-action');
                    
                    if (statusAction === 'suspend') {
                        statusModalTitle.textContent = 'Suspend User';
                        statusModalMessage.textContent = 'Are you sure you want to suspend this user? They will not be able to access their account until reactivated.';
                    } else {
                        statusModalTitle.textContent = 'Activate User';
                        statusModalMessage.textContent = 'Are you sure you want to activate this user? They will regain access to their account.';
                    }
                    
                    statusModal.style.display = 'block';
                });
            });
            
            // Close status modal functions
            function closeStatusModalFn() {
                statusModal.style.display = 'none';
                userIdToChangeStatus = null;
                statusAction = null;
            }
            
            closeStatusModal.addEventListener('click', closeStatusModalFn);
            cancelStatus.addEventListener('click', closeStatusModalFn);
            
            // Handle status change confirmation
            confirmStatus.addEventListener('click', function() {
                if (userIdToChangeStatus && statusAction) {
                    window.location.href = `${pageContext.request.contextPath}/admin/users/status?id=${userIdToChangeStatus}&action=${statusAction}`;
                }
            });
            
            // Close modals if clicked outside
            window.addEventListener('click', function(event) {
                if (event.target === deleteModal) {
                    closeDeleteModalFn();
                }
                if (event.target === statusModal) {
                    closeStatusModalFn();
                }
            });
        });
    </script>
</body>
</html>