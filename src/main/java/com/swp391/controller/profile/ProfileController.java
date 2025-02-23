package com.swp391.controller.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.swp391.config.GlobalConfig;
import com.swp391.entity.Account;
import com.swp391.dal.impl.AccountDAO;
import com.swp391.utils.MD5PasswordEncoderUtils;

@WebServlet(name = "ProfileController", urlPatterns = { "/profile", "/change-password" })
public class ProfileController extends HttpServlet {

    private AccountDAO accountDAO;
    private final String PROFILE_JSP = "view/profile/profile.jsp";
    private final String CHANGE_PASSWORD_JSP = "view/profile/change-password.jsp";
    private final String LOGIN_JSP = "authen?action=login";

    @Override
    public void init() {
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathRequest = request.getServletPath();
        if (pathRequest.equals("/profile")) {
            handleProfileRequest(request, response);
        } else if (pathRequest.equals("/change-password")) {
            handleChangePasswordRequest(request, response);
        } else {
            response.sendRedirect("authen?action=login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathRequest = request.getServletPath();

        if ("/profile".equals(pathRequest)) {
            updateProfile(request, response);
        } else if ("/change-password".equals(pathRequest)) {
            changePassword(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Lấy account từ session
            Account currentAccount = (Account) request.getSession().getAttribute(GlobalConfig.SESSION_ACCOUNT);

            // Kiểm tra xem account có quyền chỉnh sửa thông tin này không
            if (currentAccount != null && currentAccount.getUserId() == id) {
                // Tạo đối tượng Account với thông tin mới
                Account updatedAccount = new Account();
                updatedAccount.setUserId(id);
                updatedAccount.setFirstName(firstName);
                updatedAccount.setLastName(lastName);
                updatedAccount.setPhone(phone);
                updatedAccount.setAddress(address);

                // Giữ nguyên các thông tin không thay đổi
                updatedAccount.setRole(currentAccount.getRole());
                updatedAccount.setEmail(currentAccount.getEmail());
                updatedAccount.setUsername(currentAccount.getUsername());
                updatedAccount.setPassword(currentAccount.getPassword());
                updatedAccount.setAvatar(currentAccount.getAvatar());
                updatedAccount.setStatus(currentAccount.getStatus());
                // updatedAccount.setIsActive(currentAccount.getIsActive());

                // Cập nhật vào database
                boolean isUpdated = accountDAO.update(updatedAccount);

                if (isUpdated) {
                    // Cập nhật lại thông tin trong session
                    currentAccount.setFirstName(firstName);
                    currentAccount.setLastName(lastName);
                    currentAccount.setPhone(phone);
                    currentAccount.setAddress(address);

                    // Sử dụng toast message thay vì request attribute
                    request.getSession().setAttribute("toastMessage", "Profile updated successfully!");
                    request.getSession().setAttribute("toastType", "success");
                } else {
                    request.getSession().setAttribute("toastMessage", "Failed to update profile!");
                    request.getSession().setAttribute("toastType", "error");
                }
            } else {
                request.setAttribute("err", "Unauthorized access!");
            }
        } catch (Exception e) {
            request.setAttribute("err", "An error occurred: " + e.getMessage());
        }

        // Chuyển hướng trở lại trang profile
        doGet(request, response);
    }

    private void handleProfileRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy account từ session
        Account account = (Account) request.getSession().getAttribute(GlobalConfig.SESSION_ACCOUNT);

        // Kiểm tra nếu chưa đăng nhập thì chuyển hướng về trang login
        if (account == null) {
            response.sendRedirect("authen?action=login");
            return;
        }

        // Tìm kiếm account mới nhất trong database
        Account updatedAccount = accountDAO.findById(account.getUserId());

        // Đặt account vào request attribute và chuyển tiếp tới trang profile
        request.setAttribute("account", updatedAccount);
        request.getRequestDispatcher(PROFILE_JSP).forward(request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy account từ session
            Account account = (Account) request.getSession().getAttribute(GlobalConfig.SESSION_ACCOUNT);
            
            // Kiểm tra nếu account null
            if (account == null) {
                request.getSession().setAttribute("toastMessage", "Please login first!");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(LOGIN_JSP);
                return;
            }

            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Kiểm tra mật khẩu mới và xác nhận mật khẩu
            if (!newPassword.equals(confirmPassword)) {
                request.getSession().setAttribute("toastMessage", "New password and confirm password do not match!");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect("change-password");
                return;
            }

            // Tìm account trong database
            Account updatedAccount = accountDAO.findById(account.getUserId());
            if (updatedAccount == null) {
                request.getSession().setAttribute("toastMessage", "Account not found!");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect("change-password");
                return;
            }

            // Kiểm tra mật khẩu cũ
            if (!updatedAccount.getPassword().equals(MD5PasswordEncoderUtils.encodeMD5(oldPassword))) {
                request.getSession().setAttribute("toastMessage", "Old password is incorrect!");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect("change-password");
                return;
            }

            // Cập nhật mật khẩu mới
            updatedAccount.setPassword(MD5PasswordEncoderUtils.encodeMD5(newPassword));
            boolean isUpdated = accountDAO.updatePassword(updatedAccount);
            
            if (isUpdated) {
                // Cập nhật session và thông báo thành công
                request.getSession().setAttribute(GlobalConfig.SESSION_ACCOUNT, updatedAccount);
                request.getSession().setAttribute("toastMessage", "Password updated successfully!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to update password!");
                request.getSession().setAttribute("toastType", "error");
            }
            
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        response.sendRedirect("change-password");
    }

    private void handleChangePasswordRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account account = (Account) request.getSession().getAttribute(GlobalConfig.SESSION_ACCOUNT);
        if (account == null) {
            request.getSession().setAttribute("toastMessage", "Please login first!");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect("authen?action=login");
            return;
        }
        // Tìm account mới nhất trong database
        Account updatedAccount = accountDAO.findById(account.getUserId());
        request.setAttribute("account", updatedAccount);
        request.getRequestDispatcher(CHANGE_PASSWORD_JSP).forward(request, response);
    }
}
