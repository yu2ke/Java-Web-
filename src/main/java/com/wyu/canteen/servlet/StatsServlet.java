package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.StatsDao;
import com.wyu.canteen.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

/** 统计报表：月度销售 / 员工月度 / 订单汇总 / 个人统计 */
@WebServlet("/stats")
public class StatsServlet extends HttpServlet {

    private final StatsDao statsDao = new StatsDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String ym = req.getParameter("ym");
        if (ym == null || ym.isEmpty()) ym = LocalDate.now().toString().substring(0, 7);
        User user = (User) req.getSession().getAttribute("loginUser");

        req.setAttribute("ym", ym);
        req.setAttribute("monthly", statsDao.monthlySales(ym));
        req.setAttribute("monthlyTotal", statsDao.monthlyTotal(ym));
        req.setAttribute("employeeMonthly", statsDao.employeeMonthly(ym));
        req.setAttribute("employeeOrders", statsDao.employeeOrders(ym));
        req.setAttribute("mine", statsDao.myMonthly(user.getUserId(), ym));
        req.getRequestDispatcher("/WEB-INF/views/stats/index.jsp").forward(req, resp);
    }
}
