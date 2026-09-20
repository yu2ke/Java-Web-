package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.UserDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/** 用户管理：列表 / 新增 / 批量导入 */
@WebServlet("/user/*")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class UserServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("users", userDao.listAll());
        req.setAttribute("departments", userDao.listDepartments());
        req.setAttribute("roles", userDao.listRoles());
        req.getRequestDispatcher("/WEB-INF/views/user/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        String msg;
        if ("/add".equals(path)) {
            int rows = userDao.insert(req.getParameter("username"), req.getParameter("password"),
                    req.getParameter("realName"), req.getParameter("phone"),
                    RecipeServlet.parseInt(req.getParameter("deptId"), 1),
                    req.getParameter("workstation"),
                    RecipeServlet.parseInt(req.getParameter("roleId"), 5));
            msg = rows > 0 ? "新增用户成功" : "新增失败（登录名可能已存在）";
        } else if ("/import".equals(path)) {
            msg = importCsv(req);
        } else {
            msg = "";
        }
        resp.sendRedirect(req.getContextPath() + "/user/list?msg="
                + URLEncoder.encode(msg, StandardCharsets.UTF_8));
    }

    /** 批量导入: 每行 username,password,姓名,电话,部门id,工位,角色id */
    private String importCsv(HttpServletRequest req) throws IOException, ServletException {
        String contentType = req.getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("multipart/")) {
            return "请选择要导入的文件";
        }
        Part part = req.getPart("file");
        if (part == null || part.getSize() == 0) return "请选择要导入的文件";

        int ok = 0, fail = 0;
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(part.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] p = line.split(",");
                if (p.length < 7) { fail++; continue; }
                int rows = userDao.insert(p[0].trim(), p[1].trim(), p[2].trim(), p[3].trim(),
                        RecipeServlet.parseInt(p[4], 1), p[5].trim(), RecipeServlet.parseInt(p[6], 5));
                if (rows > 0) ok++; else fail++;
            }
        }
        return "导入完成：成功 " + ok + " 条，失败 " + fail + " 条";
    }
}
