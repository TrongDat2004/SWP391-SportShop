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

                <h2 class="mb-4">
                <c:if test="${empty blog}">Add</c:if>
                <c:if test="${not empty blog}">Edit</c:if> Blog Post
                </h2>
            <c:if test="${not empty errors}">
                <div class="alert alert-danger">
                    <ul>
                        <c:forEach var="error" items="${errors}">
                            <li>${error.value}</li>
                            </c:forEach>
                    </ul>
                </div>
            </c:if>
            <form action="ManageBlogController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="<c:if test='${empty blog}'>add</c:if><c:if test='${not empty blog}'>update</c:if>">
                <input type="hidden" name="blog_id" value="${blog.blogId}">

                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" name="title" class="form-control" value="${blog.title}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Content</label>
                    <textarea id="content" name="content" class="form-control" required>${blog.content}</textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select">
                        <option value="published" <c:if test="${blog.status == 'published'}">selected</c:if>>Published</option>
                        <option value="hidden" <c:if test="${blog.status == 'hidden'}">selected</c:if>>Draft</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Image</label>
                        <input type="file" name="image" class="form-control" accept="image/*" onchange="previewImage(event)">
                    <c:if test="${not empty blog}">
                        <input type="hidden" name="oldImage" class="form-control" value="${blog.image}">
                        <img id="preview" src=".${blog.image}" class="mt-2 img-fluid rounded" style="max-width: 200px; display: block;">
                    </c:if>
                    <img id="preview" class="mt-2 img-fluid rounded" style="max-width: 200px; display: none;">
                </div>

                <button type="submit" class="btn btn-success">Save</button>
                <a href="blogs" class="btn btn-secondary">Cancel</a>
            </form>

            <script>
                function previewImage(event) {
                    var reader = new FileReader();
                    reader.onload = function () {
                        var output = document.getElementById('preview');
                        output.src = reader.result;
                        output.style.display = 'block';
                    };
                    reader.readAsDataURL(event.target.files[0]);
                }
            </script>
            <script src="https://cdn.ckeditor.com/4.19.1/standard/ckeditor.js"></script>
            <script>
                CKEDITOR.replace('content');
            </script>
            <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        var toastMessage = "${sessionScope.toastMessage}";
                        var toastType = "${sessionScope.toastType}";
                        if (toastMessage) {
                            iziToast.show({
                                title: toastType === 'success' ? 'Success' : 'Error',
                                message: toastMessage,
                                position: 'topRight',
                                color: toastType === 'success' ? 'green' : 'red',
                                timeout: 5000,
                                onClosing: function () {
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