<%-- 
    Document   : slider-add
    Created on : 23 Apr 2025, 15:06:23
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../common/dashboard/css-dashboard.jsp" />
    <title>Add New Slider || Admin</title>
</head>
<body>

<jsp:include page="../common/dashboard/sidebar-dashboard.jsp"/>
<jsp:include page="../common/dashboard/header-dashboard.jsp"/>

<div class="dashboard-main-body">
    <h4 class="fw-semibold mb-4">Add New Slider</h4>

    <div class="card p-24">
        <form action="${pageContext.request.contextPath}/slider" method="post" enctype="multipart/form-data">
            <%-- Set action to 'add' --%>
            <input type="hidden" name="action" value="add" />

            <div class="mb-3">
                <label class="form-label">Name</label>
                <input type="text" name="name" class="form-control" value="" required /> <%-- Value is empty --%>
            </div>

            <div class="mb-3">
                <label class="form-label">Product ID</label>
                <input type="text" name="productId" class="form-control" value="" required /> <%-- Value is empty --%>
            </div>

            <div class="mb-3">
                <label class="form-label">Status</label>
                <select name="status" class="form-select">
                    <option value="true" selected>Active</option> <%-- Default to Active --%>
                    <option value="false">Inactive</option>
                </select>
            </div>
 
            <div class="mb-3">
                <label class="form-label">Image</label>
                <%-- Image is required for adding --%>
                <input type="file" name="imageFile" class="form-control" accept="image/*" required /> 
                <%-- No current image preview needed for adding --%>
            </div>

            <%-- Button text is 'Add Slider' --%>
            <button type="submit" class="btn btn-primary">Add Slider</button> 
            <a href="${pageContext.request.contextPath}/slider?action=list" class="btn btn-secondary ms-2">Cancel</a>
        </form>
    </div>
</div>

<jsp:include page="../common/dashboard/js-dashboard.jsp"/>
</body>
</html>
