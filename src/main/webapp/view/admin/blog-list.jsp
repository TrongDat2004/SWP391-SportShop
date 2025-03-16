<%-- 
    Document   : blog-list
    Created on : Mar 11, 2025, 10:10:04 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <title>Add New Account || Clothing</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
</head>

<body>
    <!-- Sidebar -->
    <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

    <!-- Header -->
    <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <div class="dashboard-main-body">

    <h2 class="mb-4">Blog List</h2>

    <a href="ManageBlogController?action=add" class="btn btn-primary mb-3">Add Blog Post</a>

    <table class="table table-bordered">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Author</th>
                <th>Status</th>
                <th>Image</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="blog" items="${blogs}">
                <tr>
                    <td>${blog.blogId}</td>
                    <td>${blog.title}</td>
                    <td>${blog.authorId}</td>
                    <td>${blog.status}</td>
                    <td>
                        <img src=".${blog.image}" alt="Blog Image" width="50">
                    </td>
                    <td>
                        <a href="ManageBlogController?action=edit&blog_id=${blog.blogId}" class="btn btn-warning btn-sm">Edit</a>
                        <a href="ManageBlogController?action=delete&blog_id=${blog.blogId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete?')">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

<jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Success' : 'Error',
                    message: toastMessage,
                    position: 'topRight',
                    color: toastType === 'success' ? 'green' : 'red',
                    timeout: 5000,
                    onClosing: function() {
                        fetch('${pageContext.request.contextPath}/remove-toast', {
                            method: 'POST'
                        });
                    }
                });
            }
        });
    </script>
</body>
</html> 
