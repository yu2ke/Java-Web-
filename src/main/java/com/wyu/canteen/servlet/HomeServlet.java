package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.UserDao;
import com.wyu.canteen.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/** 主页：登录后才能进入 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("loginUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        UserDao dao = new UserDao();
        req.setAttribute("recipeCount", dao.countRecipe());
        req.setAttribute("orderCount", dao.countOrder());
        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
    }
}
