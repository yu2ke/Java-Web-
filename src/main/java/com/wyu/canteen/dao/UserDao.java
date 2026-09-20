package com.wyu.canteen.dao;

import com.wyu.canteen.model.User;
import com.wyu.canteen.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** 用户相关数据库操作 */
public class UserDao {

    /** 登录校验：密码以 SHA2-256 散列存放在 user 表 */
    public User login(String username, String password) {
        String sql = "SELECT u.user_id, u.username, u.real_name, u.phone, u.workstation, "
                   + "       u.role_id, r.role_name, d.dept_name "
                   + "FROM user u "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "JOIN department d ON u.dept_id = d.dept_id "
                   + "WHERE u.username = ? AND u.password = SHA2(?, 256) AND u.is_active = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setRealName(rs.getString("real_name"));
                u.setPhone(rs.getString("phone"));
                u.setWorkstation(rs.getString("workstation"));
                u.setRoleId(rs.getInt("role_id"));
                u.setRoleName(rs.getString("role_name"));
                u.setDeptName(rs.getString("dept_name"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return null;
    }

    /** 统计食谱数量(演示 JDBC 查询) */
    public int countRecipe() {
        return count("SELECT COUNT(*) FROM recipe WHERE is_active = 1");
    }

    /** 统计订单数量 */
    public int countOrder() {
        return count("SELECT COUNT(*) FROM orders");
    }

    private int count(String sql) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** 全部用户(含角色/部门名称) */
    public List<User> listAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.user_id, u.username, u.real_name, u.phone, u.workstation, "
                   + "       u.role_id, r.role_name, d.dept_name, u.is_active "
                   + "FROM user u JOIN role r ON u.role_id = r.role_id "
                   + "     JOIN department d ON u.dept_id = d.dept_id ORDER BY u.user_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setRealName(rs.getString("real_name"));
                u.setPhone(rs.getString("phone"));
                u.setWorkstation(rs.getString("workstation"));
                u.setRoleId(rs.getInt("role_id"));
                u.setRoleName(rs.getString("role_name"));
                u.setDeptName(rs.getString("dept_name"));
                u.setActive(rs.getInt("is_active") == 1);
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 新增用户, 密码以 SHA2-256 存储 */
    public int insert(String username, String password, String realName, String phone,
                      int deptId, String workstation, int roleId) {
        String sql = "INSERT INTO user(username,password,real_name,phone,dept_id,workstation,role_id) "
                   + "VALUES(?, SHA2(?,256), ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, realName);
            ps.setString(4, phone);
            ps.setInt(5, deptId);
            ps.setString(6, workstation);
            ps.setInt(7, roleId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<Map<String, Object>> listDepartments() {
        return pairs("SELECT dept_id, dept_name FROM department ORDER BY dept_id", "id", "name");
    }

    public List<Map<String, Object>> listRoles() {
        return pairs("SELECT role_id, role_name FROM role ORDER BY role_id", "id", "name");
    }

    private List<Map<String, Object>> pairs(String sql, String k1, String k2) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put(k1, rs.getInt(1));
                m.put(k2, rs.getString(2));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
