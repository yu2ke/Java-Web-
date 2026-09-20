package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.OrderDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

/** 总括订单：订餐截止后厨房打印当天各菜品汇总数量 */
@WebServlet("/blanket")
public class BlanketServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String date = req.getParameter("date");
        if (date == null || date.isEmpty()) date = LocalDate.now().toString();
        req.setAttribute("date", date);
        req.setAttribute("rows", orderDao.blanket(date));
        req.getRequestDispatcher("/WEB-INF/views/order/blanket.jsp").forward(req, resp);
    }
}
