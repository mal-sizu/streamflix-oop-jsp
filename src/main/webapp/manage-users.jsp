<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - StreamFlix Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-page">
    <jsp:include page="includes/admin-navbar.jsp" />

    <div class="admin-container">
        <jsp:include page="includes/admin-sidebar.jsp" />
        
        <main class="admin-content">
            <div class="admin-header">
                <h1>Manage Users</h1>
                <div class="admin-actions">
                    <button class="btn btn-primary" id="addUserBtn">
                        <i class="fas fa-user-plus"></i> Add New User
                    </button>
                </div>
            </div>
            
            <div class="admin-filters">
                <div class="filter-group">
                    <label for="statusFilter">Status:</label>
                    <select id="statusFilter" class="form-control">
                        <option value="all">All Status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="INACTIVE">Inactive</option>
                        <option value="SUSPENDED">Suspended</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="subscriptionFilter">Subscription:</label>
                    <select id="subscriptionFilter" class="form-control">
                        <option value="all">All Plans</option>
                        <option value="BASIC">Basic</option>
                        <option value="STANDARD">Standard</option>
                        <option value="PREMIUM">Premium</option>
                        <option value="NONE">No Subscription</option>
                    </select>
                </div>
                
                <div class="search-group">
                    <input type="text" id="userSearch" placeholder="Search users..." class="form-control">
                    <button id="searchBtn" class="btn btn-secondary">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    ${successMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    ${errorMessage}
                </div>
            </c:if>
            
            <div class="users-table-container">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Subscription</th>
                            <th>Join Date</th>
                            <th>Last Login</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${usersList}">
                            <tr>
                                <td>${user.userId}</td>
                                <td>${user.firstName} ${user.lastName}</td>
                                <td>${user.email}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty user.subscription}">
                                            <span class="subscription-badge none">None</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="subscription-badge ${user.subscription.plan.toLowerCase()}">
                                                ${user.subscription.plan}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" /></td>
                                <td><fmt:formatDate value="${user.lastLogin}" pattern="MMM dd, yyyy HH:mm" /></td>
                                <td>
                                    <span class="status-badge status-${user.status.toLowerCase()}">
                                        ${user.status}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-edit" onclick="editUser(${user.userId})" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-view" onclick="viewUserDetails(${user.userId})" title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm ${user.status eq 'ACTIVE' ? 'btn-suspend' : 'btn-activate'}" 
                                                onclick="toggleUserStatus(${user.userId}, '${user.status}')" 
                                                title="${user.status eq 'ACTIVE' ? 'Suspend' : 'Activate'}">
                                            <i class="fas ${user.status eq 'ACTIVE' ? 'fa-ban' : 'fa-check'}"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="?page=${currentPage - 1}" class="page-link">
                        <i class="fas fa-chevron-left"></i> Previous
                    </a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                    <a href="?page=${pageNum}" class="page-link ${pageNum == currentPage ? 'active' : ''}">
                        ${pageNum}
                    </a>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages}">
                    <a href="?page=${currentPage + 1}" class="page-link">
                        Next <i class="fas fa-chevron-right"></i>
                    </a>
                </c:if>
            </div>
        </main>
    </div>
    
    <!-- Add/Edit User Modal -->
    <div id="userModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="userModalTitle">Add New User</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <form id="userForm" action="${pageContext.request.contextPath}/admin/users/save" method="post">
                    <input type="hidden" id="userId" name="userId">
                    
                    <div class="form-row">
                        <div class="form-group col-6">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" class="form-control" required>
                        </div>
                        
                        <div class="form-group col-6">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" class="form-control" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    
                    <div class="form-group" id="passwordGroup">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control">
                        <small class="form-text text-muted">Leave blank to keep current password (when editing)</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status" class="form-control" required>
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                            <option value="SUSPENDED">Suspended</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="subscriptionPlan">Subscription Plan</label>
                        <select id="subscriptionPlan" name="subscriptionPlan" class="form-control">
                            <option value="">No Subscription</option>
                            <option value="BASIC">Basic</option>
                            <option value="STANDARD">Standard</option>
                            <option value="PREMIUM">Premium</option>
                        </select>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelUserForm">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- User Details Modal -->
    <div id="userDetailsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>User Details</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body" id="userDetailsContent">
                <!-- User details will be loaded here via AJAX -->
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        // Add User button
        document.getElementById('addUserBtn').addEventListener('click', function() {
            document.getElementById('userModalTitle').textContent = 'Add New User';
            document.getElementById('userForm').reset();
            document.getElementById('userId').value = '';
            document.getElementById('passwordGroup').style.display = 'block';
            document.getElementById('userModal').style.display = 'block';
        });
        
        // Close modals
        document.querySelectorAll('.close, #cancelUserForm').forEach(function(element) {
            element.addEventListener('click', function() {
                document.getElementById('userModal').style.display = 'none';
                document.getElementById('userDetailsModal').style.display = 'none';
            });
        });
        
        // Edit user function
        function editUser(userId) {
            // In a real application, this would fetch user data via AJAX
            document.getElementById('userModalTitle').textContent = 'Edit User';
            document.getElementById('userId').value = userId;
            document.getElementById('passwordGroup').style.display = 'block';
            document.getElementById('userModal').style.display = 'block';
            
            // Fetch user data and populate form
            fetch('${pageContext.request.contextPath}/admin/users/get?id=' + userId)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('firstName').value = data.firstName;
                    document.getElementById('lastName').value = data.lastName;
                    document.getElementById('email').value = data.email;
                    document.getElementById('status').value = data.status;
                    document.getElementById('subscriptionPlan').value = data.subscriptionPlan || '';
                })
                .catch(error => console.error('Error fetching user data:', error));
        }
        
        // View user details function
        function viewUserDetails(userId) {
            document.getElementById('userDetailsContent').innerHTML = '<div class="loading">Loading user details...</div>';
            document.getElementById('userDetailsModal').style.display = 'block';
            
            // Fetch user details
            fetch('${pageContext.request.contextPath}/admin/users/details?id=' + userId)
                .then(response => response.text())
                .then(data => {
                    document.getElementById('userDetailsContent').innerHTML = data;
                })
                .catch(error => {
                    document.getElementById('userDetailsContent').innerHTML = '<div class="error">Error loading user details</div>';
                    console.error('Error fetching user details:', error);
                });
        }
        
        // Toggle user status function
        function toggleUserStatus(userId, currentStatus) {
            const newStatus = currentStatus === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE';
            const confirmMessage = currentStatus === 'ACTIVE' ? 
                'Are you sure you want to suspend this user?' : 
                'Are you sure you want to activate this user?';
                
            if (confirm(confirmMessage)) {
                // Submit form to update status
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/users/updateStatus';
                
                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'status';
                statusInput.value = newStatus;
                
                form.appendChild(userIdInput);
                form.appendChild(statusInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Filter functionality
        document.getElementById('statusFilter').addEventListener('change', filterUsers);
        document.getElementById('subscriptionFilter').addEventListener('change', filterUsers);
        document.getElementById('searchBtn').addEventListener('click', filterUsers);
        
        function filterUsers() {
            // Implementation would be in admin.js
        }
    </script>
</body>
</html>