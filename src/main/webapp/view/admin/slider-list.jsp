<%-- 
    Document   : slider-list.jsp
    Created on : 21 Apr 2025, 15:56:04
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"/>
        <title>Slider Management || Clothing</title>
    </head>
    <body>
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"/>
        <jsp:include page="../common/dashboard/header-dashboard.jsp"/>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Slider Management</h6>
                <a href="${pageContext.request.contextPath}/slider?action=add" class="btn btn-success">
                    Add New Slider
                </a>
            </div>

            <div class="card">
                <div class="card-body p-24">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                    <th>Image</th>                                  
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="slider" items="${sliderList}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td>${slider.name}</td>
                                        <td>
                                            <img src="${slider.imageUrl}" alt="Slider Image" width="100"/>
                                        </td>
                                        <td>
                                            <span class="badge ${slider.status ? 'bg-success' : 'bg-danger'}">
                                                ${slider.status ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/slider?action=edit&id=${slider.bannerId}" class="btn btn-sm btn-primary">
                                                Edit
                                            </a>
                                            <a href="${pageContext.request.contextPath}/slider?action=delete&id=${slider.bannerId}" 
                                               class="btn btn-sm btn-danger" 
                                               onclick="return confirm('Are you sure you want to delete this slider?')">
                                                Delete
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>

                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <nav class="mt-24">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}">&laquo;</a>
                                </li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}">&raquo;</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

        <jsp:include page="../common/dashboard/js-dashboard.jsp"/>
    </body>
</html>
