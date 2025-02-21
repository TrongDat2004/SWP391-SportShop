<%-- 
    Document   : js-dashboard.jsp
    Created on : Feb 8, 2025, 6:26:57 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
  <!-- jQuery library js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/jquery-3.7.1.min.js"></script>
  <!-- Bootstrap js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/bootstrap.bundle.min.js"></script>
  <!-- Apex Chart js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/apexcharts.min.js"></script>
  <!-- Data Table js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/dataTables.min.js"></script>
  <!-- Iconify Font js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/iconify-icon.min.js"></script>
  <!-- jQuery UI js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/jquery-ui.min.js"></script>
  <!-- Vector Map js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/jquery-jvectormap-2.0.5.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/jquery-jvectormap-world-mill-en.js"></script>
  <!-- Popup js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/magnifc-popup.min.js"></script>
  <!-- Slick Slider js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/slick.min.js"></script>
  <!-- prism js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/prism.js"></script>
  <!-- file upload js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/file-upload.js"></script>
  <!-- audioplayer -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/lib/audioplayer.js"></script>
  
  <!-- main js -->
  <script src="${pageContext.request.contextPath}/assets/admin/js/app.js"></script>

  <script>
    $('.remove-item-btn').on('click', function () {
      $(this).closest('tr').addClass('d-none')
    }); 
  </script>
