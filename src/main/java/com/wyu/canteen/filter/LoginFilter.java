package com.wyu.canteen.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/** 登录过滤器：未登录访问业务页面时跳转到登录页 */
@WebFilter("/*")
public class LoginFilter implements Filter {

    /** 无需登录即可访问的路径前缀 */
    private static final String[] WHITE = {"/login", "/logout", "/css/", "/js/", "/img/", "/index.jsp"};

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest r = (HttpServletRequest) req;
        HttpServletResponse p = (HttpServletResponse) resp;
        String uri = r.getRequestURI().substring(r.getContextPath().length());

        boolean white = uri.isEmpty() || uri.equals("/") || uri.equals("/favicon.ico");
        for (String w : WHITE) {
            if (uri.startsWith(w)) { white = true; break; }
        }
        if (white) {
            chain.doFilter(req, resp);
            return;
        }
        HttpSession session = r.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            p.sendRedirect(r.getContextPath() + "/login");
            return;
        }
        chain.doFilter(req, resp);
    }
}
