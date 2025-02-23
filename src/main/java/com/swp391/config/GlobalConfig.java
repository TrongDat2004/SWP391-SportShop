/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.config;

/**
 *
 * @author manhpthe172481
 */
public class GlobalConfig {
    /**
     * SESSION_ACCOUNT: Đối tượng tài khoản được lưu trong phiên làm việc (session)
     */
    public static final String SESSION_ACCOUNT = "account";

    /**
     * USERNAME_EMAIL: Địa chỉ email được sử dụng để gửi email từ ứng dụng
     */
    public static final String USERNAME_EMAIL = "isp1804cardweb3@gmail.com";

    /**
     * PASSWORD_APP_EMAIL: Mật khẩu của địa chỉ email được sử dụng để gửi email từ
     * ứng dụng
     */
    public static final String PASSWORD_APP_EMAIL = "pchn xlef opnr bhca";

    /**
     * GOOGLE_CLIENT_ID: ID của ứng dụng khách (client) được cấp bởi Google để xác
     * thực
     */
    public static String GOOGLE_CLIENT_ID = "974254864248-1mut4qdv8ps8vgtak6etojmg0m5thb0o.apps.googleusercontent.com";

    /**
     * GOOGLE_CLIENT_SECRET: Khóa bí mật của ứng dụng khách được cấp bởi Google để
     * xác thực
     */
    public static String GOOGLE_CLIENT_SECRET = "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";

    /**
     * GOOGLE_REDIRECT_URI: URI được sử dụng để đổi mã xác thực (authorization code)
     * lấy từ Google thành mã truy cập (access token)
     */
    public static String GOOGLE_REDIRECT_URI = "http://localhost:9998/SWP391-Sport-Shop-DatNguyen/LoginGoogleHandler";

    /**
     * GOOGLE_LINK_GET_TOKEN: Liên kết để trao đổi mã xác thực từ Google để lấy mã
     * truy cập
     */
    public static String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";

    /**
     * GOOGLE_LINK_GET_USER_INFO: Liên kết để lấy thông tin người dùng từ Google
     * bằng cách sử dụng mã truy cập
     */
    public static String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

    /**
     * GOOGLE_GRANT_TYPE: Loại cấp phép được sử dụng trong quy trình xác thực Google
     * (authorization code)
     */
    public static String GOOGLE_GRANT_TYPE = "authorization_code";


    public static final String ROLE_USER = "user";

    public static final String ROLE_ADMIN = "admin";

    public static final String ROLE_STAFF = "staff";

}
