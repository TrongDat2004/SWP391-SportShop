/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package Authentication;

import com.swp391.config.GlobalConfig;
import com.swp391.entity.Account;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 *
 * @author HP
 */
@WebFilter(filterName = "Authentication", urlPatterns = {"/*"})
public class Authentication implements Filter {

    private static final String[] adminPaths = {
        "/admin/manage-account", "/admin/manage-product",
        "/admin/manage-category",
        "/admin/manage-voucher", "/ManageBlogController",
        "/admin/dashboard"
    };
    
    private static final String[] sellerPaths = {"/admin/manage-order", "/admin/feedback", "/admin/dashboard"};
    private static final boolean debug = true;

    private FilterConfig filterConfig = null;

    public Authentication() {
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(true);

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length()).replaceAll("[/]+$", "");
        if (path.matches(".*\\.(jpg|jpeg|png|gif|svg|css|js|jsp)$")) {
            chain.doFilter(request, response);
            return;
        }

        boolean isAdminPath = false;
        boolean isSellerPath = false;

        for (String adminPath : adminPaths) {
            if (path.startsWith(adminPath)) {
                isAdminPath = true;
                break;
            }
        }

        for (String sellerPath : sellerPaths) {
            if (path.startsWith(sellerPath)) {
                isSellerPath = true;
                break;
            }
        }

        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        if (isAdminPath) {
            if (isSellerPath && session != null && account != null && (account.getRole().equals("staff"))) {
                chain.doFilter(request, response);
            }else
            if (session != null && account != null && account.getRole().equals("admin")) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/authen?action=login&error=Unauthorized access");
            }
        } else if (isSellerPath) {
            if (session != null && account != null && (account.getRole().equals("staff"))) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/authen?action=login&error=Unauthorized access");
            }
        } else {
            chain.doFilter(request, response);
        }
    }

    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (filterConfig != null && debug) {
            log("Authentication: Initializing filter");
        }
    }

    public void destroy() {
    }

    public void log(String msg) {
        filterConfig.getServletContext().log(msg);
    }
}
