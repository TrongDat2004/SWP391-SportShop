<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">

    <title>User Profile || Clothing</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
</head>
<body>
    <!-- Sidebar -->
<jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

    <!-- Header -->
<jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">View Profile</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">View Profile</li>
            </ul>
        </div>

        <div class="row gy-4">
            <div class="col-lg-4">
                <div class="user-grid-card position-relative border radius-16 overflow-hidden bg-base h-100">

                    <div class="pb-24 ms-16 mb-24 me-16  mt--100">
                        <div class="text-center border border-top-0 border-start-0 border-end-0">
                            <img src="" alt="" class="border br-white border-width-2-px w-200-px h-120-px rounded-circle object-fit-cover">
                            <h6 class="mb-0 mt-16">${user.firstName} ${user.lastName}</h6>
                        <span class="text-secondary-light mb-16">${user.email}</span>
                    </div>
                    <div class="mt-24">
                        <h6 class="text-xl mb-16">Personal Info</h6>
                        <ul>
                            <li class="d-flex align-items-center gap-1 mb-12">
                                <span class="w-30 text-md fw-semibold text-primary-light">Full Name</span>
                                <span class="w-70 text-secondary-light fw-medium">: ${user.firstName} ${user.lastName}</span>
                            </li>
                            <li class="d-flex align-items-center gap-1 mb-12">
                                <span class="w-30 text-md fw-semibold text-primary-light"> Email</span>
                                <span class="w-70 text-secondary-light fw-medium">: ${user.email}</span>
                            </li>
                            <li class="d-flex align-items-center gap-1 mb-12">
                                <span class="w-30 text-md fw-semibold text-primary-light"> Phone Number</span>
                                <span class="w-70 text-secondary-light fw-medium">: ${user.phone}</span>
                            </li>
                            <li class="d-flex align-items-center gap-1 mb-12">
                                <span class="w-30 text-md fw-semibold text-primary-light"> BirthDate</span>
                                <span class="w-70 text-secondary-light fw-medium">: ${user.dob}</span>
                            </li>
                            <li class="d-flex align-items-center gap-1 mb-12">
                                <span class="w-30 text-md fw-semibold text-primary-light"> Sex</span>
                                <span class="w-70 text-secondary-light fw-medium">: ${user.sex ? 'Male' : 'Female'}</span>
                            </li>
                            <li class="d-flex align-items-center gap-1 mb-12">
                                <span class="w-30 text-md fw-semibold text-primary-light"> Role</span>
                                <span class="w-70 text-secondary-light fw-medium">: ${user.roleId == 2 ? 'Sale' 
                                                                                      : user.roleId == 3 ? 'Marketing' 
                                                                                      : user.roleId == 4 ? 'User'
                                                                                      : user.roleId == 5 ? 'Sale Manager' 
                                                                                      : "Staff"}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card h-100">
                <div class="card-body p-24">
                    <ul class="nav border-gradient-tab nav-pills mb-20 d-inline-flex" id="pills-tab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link d-flex align-items-center px-24 active" id="pills-edit-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-edit-profile" type="button" role="tab" aria-controls="pills-edit-profile" aria-selected="true">
                                Edit Profile 
                            </button>
                        </li>                                   
                    </ul>

                    <div class="tab-content" id="pills-tabContent">   
                        <div class="tab-pane fade show active" id="pills-edit-profile" role="tabpanel" aria-labelledby="pills-edit-profile-tab" tabindex="0">

                            <form action="${pageContext.request.contextPath}/profile" method="POST">
                                <input type="hidden" name="id" value="${user.id}">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="mb-20">
                                            <label for="firstName" class="form-label fw-semibold text-primary-light text-sm mb-8">First Name</label>
                                            <input type="text" class="form-control radius-8" id="firstName" name="firstName" value="${user.firstName}">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="mb-20">
                                            <label for="lastName" class="form-label fw-semibold text-primary-light text-sm mb-8">Last Name</label>
                                            <input type="text" class="form-control radius-8" id="lastName" name="lastName" value="${user.lastName}">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="mb-20">
                                            <label for="email" class="form-label fw-semibold text-primary-light text-sm mb-8">Email</label>
                                            <input type="email" class="form-control radius-8" id="email" name="email" value="${user.email}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="mb-20">
                                            <label for="phone" class="form-label fw-semibold text-primary-light text-sm mb-8">Phone</label>
                                            <input type="text" class="form-control radius-8" id="phone" name="phone" value="${user.phone}">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="mb-20">
                                            <label for="dob" class="form-label fw-semibold text-primary-light text-sm mb-8">BirthDate</label>
                                            <input type="date" class="form-control radius-8" id="dob" name="dob" value="${user.dob}">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="mb-20">
                                            <label for="sex" class="form-label fw-semibold text-primary-light text-sm mb-8">Sex</label>
                                            <select class="form-control radius-8 form-select" id="sex" name="sex">
                                                <option value="true" ${user.sex ? 'selected' : ''}>Male</option>
                                                <option value="false" ${!user.sex ? 'selected' : ''}>Female</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center justify-content-center gap-3">
                                    <button type="button" class="border border-danger-600 bg-hover-danger-200 text-danger-600 text-md px-56 py-11 radius-8"
                                            onclick="window.location.href = '${pageContext.request.contextPath}/manage-users'"> 
                                        Cancel
                                    </button>
                                    <button type="submit" class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8"> 
                                        Save
                                    </button>
                                </div>
                                <div class="text-center mt-3">
                                    <span style="color: #198754">${suc}</span>  <!-- Màu xanh cho thông báo thành công -->
                                    <span style="color: #dc3545">${err}</span>  <!-- Màu đỏ cho thông báo lỗi -->
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>


</main>

<!-- JS here -->
<jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>


</body>
</html>