<%-- 
    Document   : slider-edit
    Created on : 23 Apr 2025, 15:06:43
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../common/dashboard/css-dashboard.jsp" />
        <title>Edit Slider || Admin</title>
    </head>
    <body>

        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"/>
        <jsp:include page="../common/dashboard/header-dashboard.jsp"/>

        <div class="dashboard-main-body">
            <h4 class="fw-semibold mb-4">Edit Slider</h4>

            <div class="card p-24">
                <%-- Ensure the 'slider' object is passed from the servlet --%>
                <c:if test="${empty slider}">
                    <div class="alert alert-danger" role="alert">
                        Error: Slider data not found. Please go back to the list.
                    </div>
                </c:if>
                <c:if test="${not empty slider}">
                    <form action="${pageContext.request.contextPath}/slider" method="post" enctype="multipart/form-data">
                        <%-- Set action to 'edit' --%>
                        <input type="hidden" name="action" value="edit" />
                        <%-- Include the bannerId for identifying the slider to update --%>
                        <input type="hidden" name="bannerId" value="${slider.bannerId}" />

                        <div class="mb-3">
                            <label class="form-label">Name</label>
                            <%-- Pre-fill value from slider object --%>
                            <input type="text" name="name" class="form-control" value="${slider.name}" required /> 
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Product ID</label>
                            <%-- Pre-fill value from slider object --%>
                            <input type="text" name="productId" class="form-control" value="${slider.productId}" required />
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select name="status" class="form-select">
                                <%-- Select based on current slider status --%>
                                <option value="true" ${slider.status ? 'selected' : ''}>Active</option>
                                <option value="false" ${!slider.status ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Image (Optional: Choose a new image to replace the current one)</label>
                            <%-- Image is optional for editing --%>
                            <input type="file" name="imageFile" class="form-control" accept="image/*" /> 

                            <%-- Show the current image --%>
                            <div class="mt-2">
                                <label>Current Image:</label><br/>
                                <img src="${slider.imageUrl}" alt="Current Image" width="200" class="img-thumbnail"/>
                                <%-- Optional: Include hidden field for existing image URL if needed server-side --%>
                               <input type="hidden" name="existingImageUrl" value="${slider.imageUrl}" />

                            </div>

                        </div>

                        <%-- Button text is 'Update Slider' --%>
                        <button type="submit" class="btn btn-primary">Update Slider</button> 
                        <a href="${pageContext.request.contextPath}/slider?action=list" class="btn btn-secondary ms-2">Cancel</a>
                    </form>
                </c:if> <%-- End of check for non-empty slider --%>
            </div>
        </div>

        <jsp:include page="../common/dashboard/js-dashboard.jsp"/>
    </body>
</html>
