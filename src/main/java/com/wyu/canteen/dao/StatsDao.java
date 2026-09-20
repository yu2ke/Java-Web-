package com.wyu.canteen.dao;

import com.wyu.canteen.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** 统计报表(数据来自数据库视图) */
public class StatsDao {

    /** 月度销售统计总报表: 各菜品汇总 */
    public List<Map<String, Object>> monthlySales(String ym) {
        String sql = "SELECT dish_name, unit, total_qty, unit_price, total_amount "
                   + "FROM v_monthly_sales WHERE stat_month = ? ORDER BY total_amount DESC";
        return query(sql, ym, "dishName", "unit", "qty", "unitPrice", "amount");
    }

    /** 月度销售总计 */
    public double monthlyTotal(String ym) {
        String sql = "SELECT IFNULL(SUM(total_amount),0) FROM v_monthly_sales WHERE stat_month = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ym);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** 员工月度菜品统计表 */
    public List<Map<String, Object>> employeeMonthly(String ym) {
        String sql = "SELECT real_name, dish_name, unit, total_qty, unit_price, total_amount "
                   + "FROM v_employee_monthly WHERE stat_month = ? ORDER BY real_name, total_amount DESC";
        return query(sql, ym, "realName", "dishName", "unit", "qty", "unitPrice", "amount");
    }

    /** 员工月度订单汇总 */
    public List<Map<String, Object>> employeeOrders(String ym) {
        String sql = "SELECT real_name, order_id, order_date, order_time, total_price, status, "
                   + "       dish_name, unit, quantity, price, amount "
                   + "FROM v_employee_monthly_orders WHERE stat_month = ? "
                   + "ORDER BY real_name, order_date, order_id";
        return query(sql, ym, "realName", "orderId", "orderDate", "orderTime", "totalPrice",
                     "status", "dishName", "unit", "quantity", "price", "amount");
    }

    /** 某个员工自己的月度统计 */
    public List<Map<String, Object>> myMonthly(int userId, String ym) {
        String sql = "SELECT real_name, dish_name, unit, total_qty, unit_price, total_amount "
                   + "FROM v_employee_monthly WHERE user_id = ? AND stat_month = ? ORDER BY total_amount DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, ym);
            try (ResultSet rs = ps.executeQuery()) {
                String[] keys = {"realName", "dishName", "unit", "qty", "unitPrice", "amount"};
                while (rs.next()) list.add(row(rs, keys));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Map<String, Object>> query(String sql, String ym, String... keys) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ym);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(row(rs, keys));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Map<String, Object> row(ResultSet rs, String[] keys) throws Exception {
        Map<String, Object> m = new LinkedHashMap<>();
        for (int i = 0; i < keys.length; i++) {
            Object v = rs.getObject(i + 1);
            m.put(keys[i], v);
        }
        return m;
    }
}
