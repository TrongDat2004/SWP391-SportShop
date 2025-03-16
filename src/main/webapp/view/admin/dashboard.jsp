<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Category Management || Clothing</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
            <style>
                .fixed-width-btn {
                    min-width: 120px;
                    text-align: center;
                }
            </style>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>

        <body>
            <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

            <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <c:url value="/admin/manage-order" var="paginationUrl">
            <c:param name="action" value="list" />
            <c:if test="${not empty param.status}">
                <c:param name="status" value="${param.status}" />
            </c:if>
            <c:if test="${not empty param.search}">
                <c:param name="search" value="${param.search}" />
            </c:if>
        </c:url>


        <div class="dashboard-main-body">
            <h2 class="text-center">📊 Revenue Statistics</h2>

            <!-- Form lọc dữ liệu -->
            <form method="get" action="${pageContext.request.contextPath}/admin/dashboard" class="row g-3 align-items-center mb-4">
                <div class="col-md-3">
                    <label for="startDate" class="form-label">From Date:</label>
                    <input type="date" id="startDate" name="startDate" value="${startDate}" class="form-control">
                </div>
                <div class="col-md-3">
                    <label for="endDate" class="form-label">To Date:</label>
                    <input type="date" id="endDate" name="endDate" value="${endDate}" class="form-control">
                </div>
                <div class="col-md-3">
                    <label class="form-label d-block">&nbsp;</label>
                    <button type="submit" class="btn btn-primary">🔍 Filter</button>
                </div>
            </form>

            <!-- Biểu đồ doanh thu -->
            <div class="card">
                <div class="card-body">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>

            <!-- Bảng dữ liệu -->
            <div class="card mt-4">
                <div class="card-header bg-primary text-white">
                    <h5>📅 Revenue Details</h5>
                </div>
                <div class="card-body">
                    <table class="table table-striped table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>Month</th>
                                <th>Revenue (VND)</th>
                                <th>Order Count</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="data" items="${revenueData}">
                                <tr>
                                    <td>${data.month}</td>
                                    <td>${data.revenue}</td>
                                    <td>${data.totalOrders}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card mt-4">
                <div class="dashboard-main-body">
                    <h5 class="mt-2">Order Quantity Statistics by Status</h5>
                    <canvas id="orderStatusChart"></canvas>
                    <table class="table table-bordered table-striped mt-5">
                        <thead class="table-dark">
                            <tr>
                                <th>Status</th>
                                <th>Number of Orders</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="orderStat" items="${orderStats}">
                                <tr>
                                    <td>${orderStat.status}</td>
                                    <td>${orderStat.totalOrders}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
            <script>
                // Lấy dữ liệu từ JSTL
                const labels = [];
                const revenues = [];
                const orders = [];
            <c:forEach var="data" items="${revenueData}">
                labels.push("${data.month}");
                revenues.push(${data.revenue});
                orders.push(${data.totalOrders});
            </c:forEach>

                // Vẽ biểu đồ với Chart.js
                const ctx = document.getElementById('revenueChart').getContext('2d');
                new Chart(ctx, {
                type: 'bar',
                        data: {
                        labels: labels,
                                datasets: [
                                {
                                label: 'Revenue (VNĐ)',
                                        data: revenues,
                                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                                        borderColor: 'rgba(54, 162, 235, 1)',
                                        borderWidth: 1
                                },
                                {
                                label: 'Total Orders',
                                        data: orders,
                                        backgroundColor: 'rgba(255, 99, 132, 0.6)',
                                        borderColor: 'rgba(255, 99, 132, 1)',
                                        borderWidth: 1
                                }
                                ]
                        },
                        options: {
                        responsive: true,
                                plugins: {
                                legend: {position: 'top'}
                                },
                                scales: {
                                y: {beginAtZero: true}
                                }
                        }
                });
        </script>
        <script>
            var ctxS = document.getElementById('orderStatusChart').getContext('2d');
            var orderStatusData = {
            labels: [
            <c:forEach var="orderStat" items="${orderStats}" varStatus="loop">
            "${orderStat.status}" <c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ],
                    datasets: [{
                    label: 'Number of order',
                            data: [
            <c:forEach var="orderStat" items="${orderStats}" varStatus="loop">
                ${orderStat.totalOrders} <c:if test="${!loop.last}">,</c:if>
            </c:forEach>
                            ],
                            backgroundColor: ['red', 'blue', 'green', 'yellow', 'purple'],
                            borderWidth: 1
                    }]
            };
            var myChart = new Chart(ctxS, {
            type: 'pie',
                    data: orderStatusData
            });</script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
