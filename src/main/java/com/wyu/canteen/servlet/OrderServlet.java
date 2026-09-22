package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.MenuDao;
import com.wyu.canteen.dao.OrderDao;
import com.wyu.canteen.dao.SysConfigDao;
import com.wyu.canteen.model.MenuItem;
import com.wyu.canteen.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** 订餐：员工下单(存储过程)、订单查询、经理删除订单 */
@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final MenuDao menuDao = new MenuDao();
    private final SysConfigDao configDao = new SysConfigDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        if ("/list".equals(path)) {
            String date = req.getParameter("date");
            if (date == null || date.isEmpty()) date = LocalDate.now().toString();
            req.setAttribute("date", date);
            req.setAttribute("orders", orderDao.listByDate(date));
            req.getRequestDispatcher("/WEB-INF/views/order/list.jsp").forward(req, resp);
            return;
        }
        User user = (User) req.getSession().getAttribute("loginUser");
        int menuId = menuDao.currentMenuId();
        req.setAttribute("menuId", menuId);
        req.setAttribute("items", menuDao.items(menuId));
        req.setAttribute("myOrders", orderDao.listByUser(user.getUserId()));
        req.setAttribute("today", LocalDate.now().toString());
        req.setAttribute("deadline", configDao.get("order_deadline"));
        req.setAttribute("serveStart", configDao.get("serve_start"));
        req.getRequestDispatcher("/WEB-INF/views/order/form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        User user = (User) req.getSession().getAttribute("loginUser");
        if ("/submit".equals(path)) {
            String date = req.getParameter("orderDate");
            List<double[]> lines = new ArrayList<>();
            for (MenuItem it : menuDao.items(menuDao.currentMenuId())) {
                double qty = RecipeServlet.parseDouble(req.getParameter("qty_" + it.getItemId()), 0);
                if (qty > 0) lines.add(new double[]{it.getItemId(), qty});
            }
            if (lines.isEmpty()) {
                redirect(resp, req, "/order", "请至少选择一种菜品");
                return;
            }
            String err = orderDao.create(user.getUserId(), date, lines);
            redirect(resp, req, "/order", err == null ? "下单成功" : err);
        } else if ("/delete".equals(path)) {
            if (!user.isManager()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            int id = RecipeServlet.parseInt(req.getParameter("orderId"), 0);
            orderDao.delete(id);
            String date = req.getParameter("date");
            resp.sendRedirect(req.getContextPath() + "/order/list?date=" + (date == null ? "" : date));
        } else {
            resp.sendRedirect(req.getContextPath() + "/order");
        }
    }

    private void redirect(HttpServletResponse resp, HttpServletRequest req, String path, String msg) throws IOException {
        resp.sendRedirect(req.getContextPath() + path + "?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
    }
}
