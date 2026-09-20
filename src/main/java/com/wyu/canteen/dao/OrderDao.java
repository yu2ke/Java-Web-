package com.wyu.canteen.dao;

import com.wyu.canteen.model.Order;
import com.wyu.canteen.model.OrderItem;
import com.wyu.canteen.util.DBUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** 订单数据库操作(下单走存储过程, 使用 JDBC 事务) */
public class OrderDao {

    /**
     * 创建订单: 先 sp_create_order 建单, 再对每个菜品 sp_add_item
     * @param lines 每个元素为 {菜单菜品item_id, 分量}
     * @return null 表示成功, 否则返回错误信息
     */
    public String create(int userId, String orderDate, List<double[]> lines) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            int orderId = -1;
            try (CallableStatement cs = conn.prepareCall("{call sp_create_order(?,?)}")) {
                cs.setInt(1, userId);
                cs.setDate(2, Date.valueOf(orderDate));
                cs.execute();
                try (ResultSet rs = cs.getResultSet()) {
                    if (rs != null && rs.next()) orderId = rs.getInt(1);
                }
            }
            if (orderId <= 0) throw new IllegalStateException("创建订单失败");

            try (CallableStatement cs = conn.prepareCall("{call sp_add_item(?,?,?)}")) {
                for (double[] line : lines) {
                    cs.setInt(1, orderId);
                    cs.setInt(2, (int) line[0]);
                    cs.setDouble(3, line[1]);
                    cs.execute();
                }
            }
            conn.commit();
            return null;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignored) { }
            }
            return e.getMessage();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (Exception ignored) { }
            }
            DBUtil.close(conn);
        }
    }

    /** 某日订单(含明细), 按员工分组 */
    public List<Order> listByDate(String date) {
        String sql = "SELECT o.order_id, o.user_id, u.real_name, u.phone, u.workstation, "
                   + "       o.order_date, o.order_time, o.total_price, o.status, "
                   + "       oi.dish_name, oi.unit, oi.quantity, oi.price, oi.amount "
                   + "FROM orders o JOIN user u ON o.user_id = u.user_id "
                   + "     JOIN order_item oi ON oi.order_id = o.order_id "
                   + "WHERE o.order_date = ? ORDER BY o.user_id, o.order_id, oi.oitem_id";
        Map<Integer, Order> map = new LinkedHashMap<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int oid = rs.getInt("order_id");
                    Order o = map.get(oid);
                    if (o == null) {
                        o = new Order();
                        o.setOrderId(oid);
                        o.setUserId(rs.getInt("user_id"));
                        o.setRealName(rs.getString("real_name"));
                        o.setPhone(rs.getString("phone"));
                        o.setWorkstation(rs.getString("workstation"));
                        o.setOrderDate(rs.getString("order_date"));
                        o.setOrderTime(rs.getString("order_time"));
                        o.setTotalPrice(rs.getDouble("total_price"));
                        o.setStatus(rs.getString("status"));
                        map.put(oid, o);
                    }
                    OrderItem it = new OrderItem();
                    it.setDishName(rs.getString("dish_name"));
                    it.setUnit(rs.getString("unit"));
                    it.setQuantity(rs.getDouble("quantity"));
                    it.setPrice(rs.getDouble("price"));
                    it.setAmount(rs.getDouble("amount"));
                    o.getItems().add(it);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>(map.values());
    }

    /** 某员工最近的订单 */
    public List<Order> listByUser(int userId) {
        String sql = "SELECT o.order_id, o.user_id, u.real_name, u.phone, u.workstation, "
                   + "       o.order_date, o.order_time, o.total_price, o.status, "
                   + "       oi.dish_name, oi.unit, oi.quantity, oi.price, oi.amount "
                   + "FROM orders o JOIN user u ON o.user_id = u.user_id "
                   + "     JOIN order_item oi ON oi.order_id = o.order_id "
                   + "WHERE o.user_id = ? ORDER BY o.order_date DESC, oi.oitem_id";
        Map<Integer, Order> map = new LinkedHashMap<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int oid = rs.getInt("order_id");
                    Order o = map.get(oid);
                    if (o == null) {
                        o = new Order();
                        o.setOrderId(oid);
                        o.setUserId(rs.getInt("user_id"));
                        o.setRealName(rs.getString("real_name"));
                        o.setPhone(rs.getString("phone"));
                        o.setWorkstation(rs.getString("workstation"));
                        o.setOrderDate(rs.getString("order_date"));
                        o.setOrderTime(rs.getString("order_time"));
                        o.setTotalPrice(rs.getDouble("total_price"));
                        o.setStatus(rs.getString("status"));
                        map.put(oid, o);
                    }
                    OrderItem it = new OrderItem();
                    it.setDishName(rs.getString("dish_name"));
                    it.setUnit(rs.getString("unit"));
                    it.setQuantity(rs.getDouble("quantity"));
                    it.setPrice(rs.getDouble("price"));
                    it.setAmount(rs.getDouble("amount"));
                    o.getItems().add(it);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>(map.values());
    }

    /** 删除订单(级联删除明细, 触发器同步总价) */
    public int delete(int orderId) {
        String sql = "DELETE FROM orders WHERE order_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** 总括订单: 某日各菜品汇总(视图 v_blanket_order) */
    public List<Map<String, Object>> blanket(String date) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT dish_name, unit, classify, total_qty FROM v_blanket_order "
                   + "WHERE order_date = ? ORDER BY classify, dish_name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("dishName", rs.getString("dish_name"));
                    row.put("unit", rs.getString("unit"));
                    row.put("classify", rs.getString("classify"));
                    row.put("totalQty", rs.getDouble("total_qty"));
                    list.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
