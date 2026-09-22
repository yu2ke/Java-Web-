package com.wyu.canteen.filter;

import com.wyu.canteen.model.User;

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
        // 供 header.jsp 高亮当前菜单：包含页里的 requestURI 指向被包含的资源，取不到原始地址
        r.setAttribute("currentPath", uri);

        boolean white = uri.isEmpty() || uri.equals("/") || uri.equals("/favicon.ico");
        for (String w : WHITE) {
            if (uri.startsWith(w)) { white = true; break; }
        }
        if (white) {
            chain.doFilter(req, resp);
            return;
        }
        HttpSession session = r.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("loginUser");
        if (user == null) {
            p.sendRedirect(r.getContextPath() + "/login");
            return;
        }
        // 角色权限：不在 User.ACCESS 表内的路径对所有已登录用户开放
        if (!user.canAccess(uri)) {
            p.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        chain.doFilter(req, resp);
    }
}
