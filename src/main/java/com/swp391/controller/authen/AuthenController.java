/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.authen;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.swp391.dal.impl.AccountDAO;
import com.swp391.entity.Account;
import com.swp391.config.GlobalConfig;
import com.swp391.utils.MD5PasswordEncoderUtils;
import com.swp391.utils.EmailUtils;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AuthenController", urlPatterns = {"/authen"})
public class AuthenController extends HttpServlet {

    // URL constants
    private static final String LOGIN_PAGE = "view/authen/login.jsp";
    private static final String REGISTER_PAGE = "view/authen/register.jsp";
    private static final String ENTER_EMAIL_PAGE = "view/authen/enterEmailForgotPassword.jsp";
    private static final String VERIFY_OTP_PAGE = "view/authen/verifyOTP.jsp";
    private static final String RESET_PASSWORD_PAGE = "view/authen/resetPassword.jsp";
    private static final String HOME_PAGE = "home";

    AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // get ve action
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";
        // dua theo action set URL trang can chuyen den
        String url;
        switch (action) {
            case "login":
                url = LOGIN_PAGE;
                // url = fakeLogin(request, response);
                break;
            case "logout":
                url = logOut(request, response);
                break;
            case "sign-up":
                url = REGISTER_PAGE;
                break;
            case "enter-email":
                url = ENTER_EMAIL_PAGE;
                break;
            default:
                url = LOGIN_PAGE;
        }

        // chuyen trang
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // get ve action
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";
        // dựa theo action để xử lí request
        String url;
        switch (action) {
            case "login":
                url = loginDoPost(request, response);
                break;
            case "sign-up":
                url = signUp(request, response);
                break;
            case "verify-otp":
                url = verifyOTP(request, response);
                break;
            case "forgot-password":
                url = forgotPassword(request, response);
                break;
            case "reset-password":
                url = resetPassword(request, response);
                break;
            default:
                url = HOME_PAGE;
        }
        request.getRequestDispatcher(url).forward(request, response);

    }

    private String logOut(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().removeAttribute(GlobalConfig.SESSION_ACCOUNT);
        return LOGIN_PAGE;
    }

    private String loginDoPost(HttpServletRequest request, HttpServletResponse response) {
        String url = null;
        // get về các thong tin người dufg nhập
        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");
        // kiểm tra thông tin có tồn tại trong DB ko
        Account account = Account.builder()
                .username(usernameOrEmail)
                .email(usernameOrEmail)
                .password(MD5PasswordEncoderUtils.encodeMD5(password))
                .build();
        Account accFoundByUsernamePass = accountDAO.findByEmailOrUsernameAndPass(account);
        // true => trang home ( set account vao trong session )
        if (accFoundByUsernamePass != null) {
            if (!accFoundByUsernamePass.getStatus()) {
                request.setAttribute("error", "Your account is locked!!");
                url = LOGIN_PAGE;
            } else {
                request.getSession().setAttribute(GlobalConfig.SESSION_ACCOUNT,
                        accFoundByUsernamePass);
                url = HOME_PAGE;
            }
            // false => quay tro lai trang login ( set them thong bao loi )
        } else {
            request.setAttribute("error", "Username or password incorrect!!");
            url = LOGIN_PAGE;
        }
        return url;
    }

    private String signUp(HttpServletRequest request, HttpServletResponse response) {
        String url;
        // Lấy thông tin người dùng nhập
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        boolean gender = Boolean.parseBoolean(request.getParameter("gender"));
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu và xác nhận mật khẩu có khớp không
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Password and confirm password do not match!");
            setFormAttributes(request, username, firstName, lastName, gender, email, mobile);
            return REGISTER_PAGE;
        }

        // Tạo đối tượng Account (chưa lưu vào DB)
        Account account = Account.builder()
                .username(username)
                .firstName(firstName)
                .lastName(lastName)
                .phone(mobile)
                .email(email)
                .password(MD5PasswordEncoderUtils.encodeMD5(password)) // Giữ MD5 như gốc
                .role(GlobalConfig.ROLE_USER)
                .status(true) // Sẽ lưu với status = 1 sau OTP
                .build();

        // Kiểm tra trùng username và email
        AccountDAO accountDAO = new AccountDAO();
        Account accountFoundByUsername = accountDAO.findByUsername(username);
        Account accountFoundByEmail = accountDAO.findByEmail(email);

        if (accountFoundByUsername != null) {
            request.setAttribute("errorMessage", "Username already exists!");
            setFormAttributes(request, username, firstName, lastName, gender, email, mobile);
            url = REGISTER_PAGE;
        } else if (accountFoundByEmail != null) {
            request.setAttribute("errorMessage", "Email already exists!");
            setFormAttributes(request, username, firstName, lastName, gender, email, mobile);
            url = REGISTER_PAGE;
        } else {
            // Không lưu vào DB, lưu tạm vào session và gửi OTP
            HttpSession session = request.getSession();
            session.setAttribute("pendingAccount", account);
            session.setAttribute("email", email);
            session.setMaxInactiveInterval(300);

            // Gửi OTP
            try {
                String otp = EmailUtils.sendOTPMail(email);
                session.setAttribute("otp", otp);
                session.setAttribute("otp_purpose", "activation"); // Thêm mục đích OTP
                url = VERIFY_OTP_PAGE;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Failed to send OTP. Please try again.");
                setFormAttributes(request, username, firstName, lastName, gender, email, mobile);
                url = REGISTER_PAGE;
            }
        }
        return url;
    }

// Phương thức hỗ trợ để giữ lại dữ liệu form
    private void setFormAttributes(HttpServletRequest request, String username, String firstName, String lastName,
            boolean gender, String email, String mobile) {
        request.setAttribute("username", username);
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("gender", String.valueOf(gender));
        request.setAttribute("email", email);
        request.setAttribute("mobile", mobile);
    }

    /*private String signUp(HttpServletRequest request, HttpServletResponse response) {
        String url;
        // Lấy thông tin người dùng nhập
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        boolean gender = Boolean.parseBoolean(request.getParameter("gender"));
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu và xác nhận mật khẩu có khớp không
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Password and confirm password not matching");
            return REGISTER_PAGE;
        }

        // Kiểm tra xem email đã tồn tại trong db chưa
        Account account = Account.builder()
                .username(username)
                .firstName(firstName)
                .lastName(lastName)
                .phone(mobile)
                .email(email)
                .password(MD5PasswordEncoderUtils.encodeMD5(password))
                .role(GlobalConfig.ROLE_USER)
                // .stat(false)
                .status(false)
                .build();
        Account accountFoundByEmail = accountDAO.findByEmail(account);

        if (accountFoundByEmail != null) {
            if (accountFoundByEmail.getUsername().equalsIgnoreCase(email)) {
                request.setAttribute("errorMessage", "Username already exist!");
            } else {
                request.setAttribute("errorMessage", "Email already exists!");
            }
            url = REGISTER_PAGE;
        } else {
            // Lưu tài khoản vào database
            int accountId = accountDAO.insert(account);
            if (accountId > 0) {
                // Tạo session cho việc kích hoạt tài khoản sau này
                HttpSession session = request.getSession();
                account.setUserId(accountId);
                session.setAttribute(GlobalConfig.SESSION_ACCOUNT, account);
                session.setAttribute("email", email);
                session.setMaxInactiveInterval(300);

                // Gửi OTP
                String otp = EmailUtils.sendOTPMail(email);
                session.setAttribute("otp", otp);
                session.setAttribute("otp_purpose", "activation"); // Thêm mục đích OTP

                url = VERIFY_OTP_PAGE;
            } else {
                request.setAttribute("errorMessage", "Username already exist!");
                url = REGISTER_PAGE;
            }
        }
        return url;
    }*/
    private String verifyOTP(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false); // Không tạo session mới
        String url;

        // Lấy thông tin từ session và request
        String storedOTP = (String) session.getAttribute("otp");
        String email = (String) session.getAttribute("email");
        String enteredOTP = request.getParameter("otp");
        String purpose = (String) session.getAttribute("otp_purpose");

        // Kiểm tra session
        if (session == null || storedOTP == null || email == null || purpose == null) {
            session.setAttribute("toastMessage", "Session expired. Please try again.");
            session.setAttribute("toastType", "error");
            return purpose != null && purpose.equals("activation") ? REGISTER_PAGE : ENTER_EMAIL_PAGE;
        }

        // Kiểm tra OTP
        if (storedOTP.equals(enteredOTP)) {
            // OTP đúng
            session.removeAttribute("otp");

            if ("activation".equals(purpose)) {
                // Xử lý OTP đăng ký
                Account pendingAccount = (Account) session.getAttribute("pendingAccount");
                if (pendingAccount == null) {
                    session.setAttribute("toastMessage", "Session expired. Please register again.");
                    session.setAttribute("toastType", "error");
                    url = REGISTER_PAGE;
                } else {
                    // Lưu tài khoản vào database
                    AccountDAO accountDAO = new AccountDAO();
                    int accountId = accountDAO.insert(pendingAccount);
                    if (accountId > 0) {
                        pendingAccount.setUserId(accountId);
                        session.setAttribute(GlobalConfig.SESSION_ACCOUNT, pendingAccount);
                        // Xóa dữ liệu tạm
                        session.removeAttribute("pendingAccount");
                        session.removeAttribute("otp_purpose");
                        session.removeAttribute("email");
                        url = LOGIN_PAGE; // Giả sử: "/view/authen/login.jsp"
                    } else {
                        session.setAttribute("toastMessage", "Failed to create account. Please try again.");
                        session.setAttribute("toastType", "error");
                        url = VERIFY_OTP_PAGE;
                    }
                }
            } else if ("password_reset".equals(purpose)) {
                // Xử lý OTP quên mật khẩu
                Integer accountId = (Integer) session.getAttribute("account_id");
                if (accountId == null) {
                    session.setAttribute("toastMessage", "Session expired. Please try again.");
                    session.setAttribute("toastType", "error");
                    url = ENTER_EMAIL_PAGE;
                } else {
                    // Xóa otp_purpose, giữ account_id và email
                    session.removeAttribute("otp_purpose");
                    url = RESET_PASSWORD_PAGE; // Giả sử: "/view/authen/reset-password.jsp"
                }
            } else {
                session.setAttribute("toastMessage", "Invalid OTP purpose.");
                session.setAttribute("toastType", "error");
                url = VERIFY_OTP_PAGE;
            }
        } else {
            session.setAttribute("toastMessage", "Incorrect OTP. Please try again.");
            session.setAttribute("toastType", "error");
            url = VERIFY_OTP_PAGE;
        }

        return url;
    }

    /*private String verifyOTP(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String storedOTP = (String) session.getAttribute("otp");
        String email = (String) session.getAttribute("email");
        String enteredOTP = request.getParameter("otp");
        String purpose = (String) session.getAttribute("otp_purpose");

        if (storedOTP == null || email == null) {
            session.setAttribute("toastMessage", "Session expired. Please try again.");
            session.setAttribute("toastType", "error");
            return ENTER_EMAIL_PAGE;
        }

        if (storedOTP.equals(enteredOTP)) {
            // OTP is correct
            session.removeAttribute("otp");

            if ("activation".equals(purpose)) {
                return handleAccountActivation(request, session);
            } else if ("password_reset".equals(purpose)) {
                return handlePasswordReset(request, session);
            } else {
                request.setAttribute("error", "Invalid OTP purpose.");
                return VERIFY_OTP_PAGE;
            }
        } else {
            session.setAttribute("toastMessage", "Incorrect OTP. Please try again.");
            session.setAttribute("toastType", "error");
            return VERIFY_OTP_PAGE;
        }
    }*/
    private String forgotPassword(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String url;
        String email = request.getParameter("email");

        // Kiểm tra xem email có tồn tại trong cơ sở dữ liệu không
        Account account = Account.builder().email(email).build();
        Account foundAccount = accountDAO.findByEmail(email);

        if (foundAccount == null) {
            session.setAttribute("toastMessage", "No account found with this email address.");
            session.setAttribute("toastType", "error");
            url = ENTER_EMAIL_PAGE;
            return url;
        }

        // Gửi OTP
        String otp = EmailUtils.sendOTPMail(email);

        // Lưu thông tin vào session
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);
        session.setAttribute("otp_purpose", "password_reset");
        session.setAttribute("account_id", foundAccount.getUserId());

        // Đặt thời gian hết hạn cho session (ví dụ: 15 phút)
        session.setMaxInactiveInterval(15 * 60);

        url = VERIFY_OTP_PAGE;
        return url;
    }

    private String handleAccountActivation(HttpServletRequest request, HttpSession session) {
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        if (account != null) {
            account.setStatus(true);
            accountDAO.activateAccount(account.getUserId());
            request.setAttribute("message", "Your account has been successfully activated!");
            return HOME_PAGE;
        } else {
            request.setAttribute("error", "Session expired. Please sign up again.");
            return REGISTER_PAGE;
        }
    }

    private String handlePasswordReset(HttpServletRequest request, HttpSession session) {
        // Redirect to password reset page
        return RESET_PASSWORD_PAGE;
    }

    private String resetPassword(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            session.setAttribute("toastMessage", "Session expired. Please start the password reset process again.");
            session.setAttribute("toastType", "error");
            return ENTER_EMAIL_PAGE;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("toastMessage", "Passwords do not match.");
            session.setAttribute("toastType", "error");
            return RESET_PASSWORD_PAGE;
        }

        Account account = Account.builder()
                .email(email)
                .password(MD5PasswordEncoderUtils.encodeMD5(newPassword))
                .build();

        boolean updated = accountDAO.updatePassword(account);
        if (updated) {
            return LOGIN_PAGE;
        } else {
            session.setAttribute("toastMessage", "Failed to reset password. Please try again.");
            session.setAttribute("toastType", "error");
            return RESET_PASSWORD_PAGE;
        }
    }
}
