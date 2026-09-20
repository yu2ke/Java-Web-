package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.StatsDao;
import com.wyu.canteen.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/** 报表导出下载(CSV) —— 必修的"文件下载" */
@WebServlet("/export")
public class ExportServlet extends HttpServlet {

    private final StatsDao statsDao = new StatsDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String type = req.getParameter("type");
        String ym = req.getParameter("ym");
        if (ym == null || ym.isEmpty()) ym = LocalDate.now().toString().substring(0, 7);
        User user = (User) req.getSession().getAttribute("loginUser");

        StringBuilder sb = new StringBuilder();
        String fileName;
        if ("employee".equals(type)) {
            sb.append("姓名,菜名,单位,数量,单价,合计\r\n");
            for (Map<String, Object> r : statsDao.employeeMonthly(ym)) {
                sb.append(csv(r.get("realName"), r.get("dishName"), r.get("unit"),
                              r.get("qty"), r.get("unitPrice"), r.get("amount"))).append("\r\n");
            }
            fileName = "employee_monthly_" + ym + ".csv";
        } else if ("mine".equals(type)) {
            sb.append("姓名,菜名,单位,数量,单价,合计\r\n");
            for (Map<String, Object> r : statsDao.myMonthly(user.getUserId(), ym)) {
                sb.append(csv(r.get("realName"), r.get("dishName"), r.get("unit"),
                              r.get("qty"), r.get("unitPrice"), r.get("amount"))).append("\r\n");
            }
            fileName = "my_monthly_" + ym + ".csv";
        } else {
            sb.append("统计月份,菜名,单位,数量,单价,合计金额\r\n");
            for (Map<String, Object> r : statsDao.monthlySales(ym)) {
                sb.append(csv(ym, r.get("dishName"), r.get("unit"),
                              r.get("qty"), r.get("unitPrice"), r.get("amount"))).append("\r\n");
            }
            sb.append("总计,,,,,").append(statsDao.monthlyTotal(ym)).append("\r\n");
            fileName = "monthly_sales_" + ym + ".csv";
        }

        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        try (OutputStream out = resp.getOutputStream()) {
            out.write(new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF});   // UTF-8 BOM, Excel 兼容
            out.write(sb.toString().getBytes(StandardCharsets.UTF_8));
        }
    }

    private String csv(Object... cols) {
        StringBuilder s = new StringBuilder();
        for (int i = 0; i < cols.length; i++) {
            if (i > 0) s.append(',');
            String v = cols[i] == null ? "" : String.valueOf(cols[i]);
            s.append(v.contains(",") ? "\"" + v + "\"" : v);
        }
        return s.toString();
    }
}
