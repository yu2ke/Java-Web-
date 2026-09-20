package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.OrderDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

/** 配餐打印：按员工批量列出订单, 供配餐员配送 */
@WebServlet("/pack")
public class PackServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String date = req.getParameter("date");
        if (date == null || date.isEmpty()) date = LocalDate.now().toString();
        req.setAttribute("date", date);
        req.setAttribute("orders", orderDao.listByDate(date));
        req.getRequestDispatcher("/WEB-INF/views/order/pack.jsp").forward(req, resp);
    }
}
