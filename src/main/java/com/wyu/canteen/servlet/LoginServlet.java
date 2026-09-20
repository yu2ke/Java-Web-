package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.UserDao;
import com.wyu.canteen.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/** 登录：session 保存登录用户, cookie 记住登录名 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 读取 cookie, 回填"记住的登录名"
        String remembered = "";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("rememberUser".equals(c.getName())) {
                    remembered = c.getValue();
                }
            }
        }
        req.setAttribute("remembered", remembered);
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        User user = new UserDao().login(username, password);
        if (user == null) {
            req.setAttribute("error", "用户名或密码错误");
            req.setAttribute("remembered", username);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("loginUser", user);

        String path = req.getContextPath().isEmpty() ? "/" : req.getContextPath();
        Cookie cookie = new Cookie("rememberUser", "1".equals(remember) ? user.getUsername() : "");
        cookie.setMaxAge("1".equals(remember) ? 7 * 24 * 3600 : 0);
        cookie.setPath(path);
        resp.addCookie(cookie);

        resp.sendRedirect(req.getContextPath() + "/home");
    }
}
