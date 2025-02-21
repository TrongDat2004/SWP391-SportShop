<%-- 
    Document   : sidebar
    Created on : Feb 8, 2025, 6:46:52 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<aside class="sidebar">
  <button type="button" class="sidebar-close-btn">
    <iconify-icon icon="radix-icons:cross-2"></iconify-icon>
  </button>
  <div>
    <a href="index.html" class="sidebar-logo">
      <img src="${pageContext.request.contextPath}/assets/admin/images/STORE 24.png" alt="site logo" class="light-logo">
      <img src="${pageContext.request.contextPath}/assets/admin/images/logo-light.png" alt="site logo" class="dark-logo">
      <img src="${pageContext.request.contextPath}/assets/admin/images/logo-icon.png" alt="site logo" class="logo-icon">
    </a>
  </div>
  <div class="sidebar-menu-area">
    <ul class="sidebar-menu" id="sidebar-menu">
      <li class="dropdown">
        <a href="javascript:void(0)">
          <iconify-icon icon="solar:home-smile-angle-outline" class="menu-icon"></iconify-icon>
          <span>Dashboard</span>
        </a>
        <ul class="sidebar-submenu">
          <li>
            <a href="index.html"><i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> AI</a>
          </li>
          <li>
            <a href="index-2.html"><i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> CRM</a>
          </li>
          <li>
            <a href="index-3.html"><i class="ri-circle-fill circle-icon text-info-main w-auto"></i> eCommerce</a>
          </li>
          <li>
            <a href="index-4.html"><i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Cryptocurrency</a>
          </li>
          <li>
            <a href="index-5.html"><i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Investment</a>
          </li>
          <li>
            <a href="index-6.html"><i class="ri-circle-fill circle-icon text-purple w-auto"></i> LMS</a>
          </li>
          <li>
            <a href="index-7.html"><i class="ri-circle-fill circle-icon text-info-main w-auto"></i> NFT & Gaming</a>
          </li>
          <li>
            <a href="index-8.html"><i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Medical</a>
          </li>
          <li>
            <a href="index-9.html"><i class="ri-circle-fill circle-icon text-purple w-auto"></i> Analytics</a>
          </li>
          <li>
            <a href="index-10.html"><i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> POS & Inventory </a>
          </li>
          <li>
            <a href="index-11.html"><i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Finance & Banking </a>
          </li>
          <li>
            <a href="index-12.html"><i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Booking System</a>
          </li>
        </ul>
      </li>     

      <li>
        <a href="${pageContext.request.contextPath}/manage-users">
          <iconify-icon icon="flowbite:users-group-outline" class="menu-icon"></iconify-icon>
          <span>Users Management</span> 
        </a>
      </li>
      
      <li>
        <a href="${pageContext.request.contextPath}/manage-settings">
          <iconify-icon icon="icon-park-outline:setting-two" class="menu-icon"></iconify-icon>
          <span>Settings Management</span> 
        </a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/change-password">
          <iconify-icon icon="icon-park-outline:setting-two" class="menu-icon"></iconify-icon>
          <span>Change Password</span> 
        </a>
      </li>
    </ul>
  </div>
</aside>
