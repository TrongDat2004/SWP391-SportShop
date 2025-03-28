<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard || Revenue & Orders</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    <style>
        .dashboard-main-body {
            padding: 20px;
            background: #f5f7fa;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-title {
            color: #333;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .filter-form {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .btn-primary {
            background: #007bff;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .btn-primary:hover {
            background: #0056b3;
        }
        .table {
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }
        .table thead th {
            background: #343a40;
            color: white;
            border: none;
        }
        .chart-container {
            padding: 20px;
            background: white;
            border-radius: 10px;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>
    <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <h2 class="text-center mb-4" style="color: #2c3e50;">
            <span class="material-icons" style="vertical-align: middle;">insights</span> 
            Revenue & Order Statistics
        </h2>

        <!-- Filter Form -->
        <form method="get" action="${pageContext.request.contextPath}/admin/dashboard" class="filter-form row g-3 align-items-end mb-5">
            <div class="col-md-4">
                <label for="startDate" class="form-label">From Date</label>
                <input type="date" id="startDate" name="startDate" value="${startDate}" class="form-control">
            </div>
            <div class="col-md-4">
                <label for="endDate" class="form-label">To Date</label>
                <input type="date" id="endDate" name="endDate" value="${endDate}" class="form-control">
            </div>
            <div class="col-md-4">
                <button type="submit" class="btn btn-primary w-100">
                    <span class="material-icons" style="vertical-align: middle;">filter_list</span> Filter
                </button>
            </div>
        </form>

        <!-- Charts -->
        <div class="row mb-5">
            <div class="col-md-6 mb-4">
                <div class="card chart-container">
                    <div class="card-body">
                        <h5 class="card-title">
                            <span class="material-icons" style="vertical-align: middle;">attach_money</span>
                            Revenue (VNĐ)
                        </h5>
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6 mb-4">
                <div class="card chart-container">
                    <div class="card-body">
                        <h5 class="card-title">
                            <span class="material-icons" style="vertical-align: middle;">shopping_cart</span>
                            Total Orders
                        </h5>
                        <canvas id="orderChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Revenue Details Table -->
        <div class="card mb-5">
            <div class="card-header bg-primary text-white">
                <h5>
                    <span class="material-icons" style="vertical-align: middle;">table_chart</span>
                    Revenue Details
                </h5>
            </div>
            <div class="card-body p-0">
                <table class="table table-striped table-bordered m-0">
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
                                <td><fmt:formatNumber value="${data.revenue}" type="currency" currencySymbol="₫"/></td>
                                <td>${data.totalOrders}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Order Status Chart & Table -->
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">
                    <span class="material-icons" style="vertical-align: middle;">pie_chart</span>
                    Order Status Statistics
                </h5>
                <div class="row">
                    <div class="col-md-6">
                        <canvas id="orderStatusChart"></canvas>
                    </div>
                    <div class="col-md-6">
                        <table class="table table-bordered table-striped mt-3">
                            <thead class="table-dark">
                                <tr>
                                    <th>Status</th>
                                    <th>Orders</th>
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
        </div>
    </div>

    <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    <script>
        (function() {
            const revenueData = {
                labels: [<c:forEach var="data" items="${revenueData}" varStatus="loop">"${data.month}"<c:if test="${!loop.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Revenue (VNĐ)',
                    data: [<c:forEach var="data" items="${revenueData}" varStatus="loop">${data.revenue}<c:if test="${!loop.last}">,</c:if></c:forEach>],
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            };
            new Chart(document.getElementById('revenueChart').getContext('2d'), {
                type: 'bar',
                data: revenueData,
                options: {
                    responsive: true,
                    plugins: { legend: { position: 'top' } },
                    scales: { y: { beginAtZero: true, ticks: { callback: value => '₫' + value.toLocaleString() } } }
                }
            });

            const orderData = {
                labels: [<c:forEach var="data" items="${revenueData}" varStatus="loop">"${data.month}"<c:if test="${!loop.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Total Orders',
                    data: [<c:forEach var="data" items="${revenueData}" varStatus="loop">${data.totalOrders}<c:if test="${!loop.last}">,</c:if></c:forEach>],
                    backgroundColor: 'rgba(255, 99, 132, 0.6)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                }]
            };
            new Chart(document.getElementById('orderChart').getContext('2d'), {
                type: 'bar',
                data: orderData,
                options: {
                    responsive: true,
                    plugins: { legend: { position: 'top' } },
                    scales: { y: { beginAtZero: true } }
                }
            });

            const statusData = {
                labels: [<c:forEach var="orderStat" items="${orderStats}" varStatus="loop">"${orderStat.status}"<c:if test="${!loop.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Orders by Status',
                    data: [<c:forEach var="orderStat" items="${orderStats}" varStatus="loop">${orderStat.totalOrders}<c:if test="${!loop.last}">,</c:if></c:forEach>],
                    backgroundColor: ['#ff6384', '#36a2eb', '#ffce56', '#4bc0c0', '#9966ff'],
                    borderWidth: 1
                }]
            };
            new Chart(document.getElementById('orderStatusChart').getContext('2d'), {
                type: 'pie',
                data: statusData,
                options: {
                    responsive: true,
                    plugins: { legend: { position: 'bottom' } }
                }
            });
        })();
    </script>
</body>
</html>