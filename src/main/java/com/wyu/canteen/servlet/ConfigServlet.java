package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.SysConfigDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/** 系统参数：订餐截止时间 / 配餐开始时间 */
@WebServlet("/config")
public class ConfigServlet extends HttpServlet {

    private final SysConfigDao configDao = new SysConfigDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("deadline", configDao.get("order_deadline"));
        req.setAttribute("serveStart", configDao.get("serve_start"));
        req.getRequestDispatcher("/WEB-INF/views/config/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        configDao.set("order_deadline", req.getParameter("deadline"));
        configDao.set("serve_start", req.getParameter("serveStart"));
        resp.sendRedirect(req.getContextPath() + "/config?msg="
                + URLEncoder.encode("参数已保存", StandardCharsets.UTF_8));
    }
}
