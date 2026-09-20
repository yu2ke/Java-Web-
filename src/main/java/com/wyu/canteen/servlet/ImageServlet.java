package com.wyu.canteen.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

/** 读取上传的菜品图片 /img/{文件名} */
@WebServlet("/img/*")
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getPathInfo();
        if (name == null || name.length() < 2) { resp.sendError(404); return; }
        name = new File(name).getName();   // 只取文件名, 防目录穿越
        File file = new File(new File(System.getProperty("user.home"), "canteen-uploads"), name);
        if (!file.exists()) { resp.sendError(404); return; }
        resp.setContentType(getServletContext().getMimeType(name));
        resp.setContentLengthLong(file.length());
        try (OutputStream out = resp.getOutputStream()) {
            Files.copy(file.toPath(), out);
        }
    }
}
