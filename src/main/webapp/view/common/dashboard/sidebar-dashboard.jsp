<%-- 
    Document   : sidebar
    Created on : Feb 8, 2025, 6:46:52 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="account" value="${sessionScope.account}" />
<c:set var="userRole" value="${account != null ? account.role : null}" />
<aside class="sidebar">
    <button type="button" class="sidebar-close-btn">
        <iconify-icon icon="radix-icons:cross-2"></iconify-icon>
    </button>
    <div>
        <a href="${pageContext.request.contextPath}/home" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="site logo" class="light-logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="site logo" class="dark-logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="site logo" class="logo-icon">
        </a>
    </div>
    <div class="sidebar-menu-area">
        <ul class="sidebar-menu" id="sidebar-menu">
            <c:if test="${userRole == 'admin'}">
                <li class="dropdown">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="menu-icon"></iconify-icon>
                        <span>Dashboard</span>
                    </a>
                </li>     

                <li>
                    <a href="${pageContext.request.contextPath}/admin/manage-account">
                        <iconify-icon icon="flowbite:users-group-outline" class="menu-icon"></iconify-icon>
                        <span>Users Management</span> 
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/admin/manage-product">
                        <iconify-icon icon="carbon:product" class="menu-icon"></iconify-icon>
                        <span>Product Management</span> 
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/manage-category">
                        <iconify-icon icon="carbon:category" class="menu-icon"></iconify-icon>
                        <span>Category Management</span> 
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/manage-voucher">
                        <iconify-icon icon="carbon:product" class="menu-icon"></iconify-icon>
                        <span>Vocuher Management</span> 
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageBlogController">
                        <iconify-icon icon="carbon:product" class="menu-icon"></iconify-icon>
                        <span>Blog manage</span> 
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/change-password">
                        <iconify-icon icon="icon-park-outline:setting-two" class="menu-icon"></iconify-icon>
                        <span>Change Password</span> 
                    </a>
                </li>
            </c:if>
            <c:if test="${userRole == 'staff'}">
                <li class="dropdown">
                    <a href="${pageContext.request.contextPath}/home">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="menu-icon"></iconify-icon>
                        <span>Home</span>
                    </a>
                </li>   
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <iconify-icon icon="carbon:category" class="menu-icon"></iconify-icon>
                        <span>Dashboard Management</span> 
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/manage-order">
                        <iconify-icon icon="carbon:category" class="menu-icon"></iconify-icon>
                        <span>Order Management</span> 
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/feedback">
                        <iconify-icon icon="carbon:category" class="menu-icon"></iconify-icon>
                        <span>Feedback Management</span> 
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/change-password">
                        <iconify-icon icon="icon-park-outline:setting-two" class="menu-icon"></iconify-icon>
                        <span>Change Password</span> 
                    </a>
                </li>
            </c:if>
            <c:if test="${userRole == 'user'}">
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="menu-icon"></iconify-icon>
                        <span>Dashboard</span>
                    </a>
                </li>   
                <li>
                    <a href="${pageContext.request.contextPath}/change-password">
                        <iconify-icon icon="icon-park-outline:setting-two" class="menu-icon"></iconify-icon>
                        <span>Change Password</span> 
                    </a>
                </li>
            </c:if> 
        </ul>
    </div>
</aside>
