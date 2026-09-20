package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.RecipeDao;
import com.wyu.canteen.model.Recipe;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

/** 食谱管理：查询 / 新增 / 修改 / 删除 / 批量删除 + 图片上传 */
@WebServlet("/recipe/*")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class RecipeServlet extends HttpServlet {

    private final RecipeDao dao = new RecipeDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/list" : req.getPathInfo();
        if ("/add".equals(path)) {
            req.setAttribute("mode", "add");
            req.getRequestDispatcher("/WEB-INF/views/recipe/form.jsp").forward(req, resp);
        } else if ("/edit".equals(path)) {
            int id = parseInt(req.getParameter("id"), 0);
            req.setAttribute("recipe", dao.find(id));
            req.setAttribute("mode", "edit");
            req.getRequestDispatcher("/WEB-INF/views/recipe/form.jsp").forward(req, resp);
        } else {
            String keyword = req.getParameter("keyword");
            req.setAttribute("recipes", dao.list(keyword));
            req.setAttribute("keyword", keyword == null ? "" : keyword);
            req.getRequestDispatcher("/WEB-INF/views/recipe/list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/list" : req.getPathInfo();
        if ("/save".equals(path)) {
            int id = parseInt(req.getParameter("recipeId"), 0);
            Recipe r = id > 0 ? dao.find(id) : new Recipe();
            if (r == null) r = new Recipe();
            r.setName(req.getParameter("name"));
            r.setClassify(req.getParameter("classify"));
            r.setUnit(req.getParameter("unit"));
            r.setPrice(parseDouble(req.getParameter("price"), 0));

            Part photo = null;
            String contentType = req.getContentType();
            if (contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
                photo = req.getPart("photo");
            }
            if (photo != null && photo.getSize() > 0) {
                String saved = saveUpload(photo);
                if (saved != null) r.setPhoto(saved);
            }
            if (id > 0) {
                r.setRecipeId(id);
                dao.update(r);
            } else {
                dao.insert(r);
            }
            resp.sendRedirect(req.getContextPath() + "/recipe/list");
        } else if ("/delete".equals(path)) {
            dao.delete(parseInt(req.getParameter("id"), 0));
            resp.sendRedirect(req.getContextPath() + "/recipe/list");
        } else if ("/batchDelete".equals(path)) {
            String[] ids = req.getParameterValues("ids");
            if (ids != null) {
                int[] arr = new int[ids.length];
                for (int i = 0; i < ids.length; i++) arr[i] = parseInt(ids[i], 0);
                dao.batchDelete(arr);
            }
            resp.sendRedirect(req.getContextPath() + "/recipe/list");
        } else {
            resp.sendRedirect(req.getContextPath() + "/recipe/list");
        }
    }

    /** 保存上传图片到 user.home/canteen-uploads, 返回文件名 */
    static String saveUpload(Part part) throws IOException {
        String origin = part.getSubmittedFileName();
        if (origin == null || origin.isEmpty()) return null;
        String ext = "";
        int dot = origin.lastIndexOf('.');
        if (dot >= 0) ext = origin.substring(dot);
        String fileName = UUID.randomUUID().toString().replace("-", "") + ext;
        File dir = new File(System.getProperty("user.home"), "canteen-uploads");
        if (!dir.exists() && !dir.mkdirs()) return null;
        part.write(new File(dir, fileName).getAbsolutePath());
        return fileName;
    }

    static int parseInt(String s, int def) {
        try { return Integer.parseInt(s.trim()); } catch (Exception e) { return def; }
    }

    static double parseDouble(String s, double def) {
        try { return Double.parseDouble(s.trim()); } catch (Exception e) { return def; }
    }
}
