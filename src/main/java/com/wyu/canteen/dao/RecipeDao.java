package com.wyu.canteen.dao;

import com.wyu.canteen.model.Recipe;
import com.wyu.canteen.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/** 食谱数据库操作(增删查改) */
public class RecipeDao {

    /** 查询在售菜品, 可按菜名模糊查找 */
    public List<Recipe> list(String keyword) {
        List<Recipe> list = new ArrayList<>();
        boolean hasKey = keyword != null && !keyword.trim().isEmpty();
        String sql = "SELECT recipe_id, name, classify, photo, unit, price FROM recipe "
                   + "WHERE is_active = 1 " + (hasKey ? "AND name LIKE ? " : "") + "ORDER BY recipe_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (hasKey) ps.setString(1, "%" + keyword.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Recipe find(int id) {
        String sql = "SELECT recipe_id, name, classify, photo, unit, price FROM recipe WHERE recipe_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insert(Recipe r) {
        // 同名同单位的菜如果之前只是被逻辑删除过，直接把它恢复，避免"删了以后再加不回来"
        String restore = "UPDATE recipe SET classify = ?, photo = COALESCE(?, photo), price = ?, is_active = 1 "
                       + "WHERE name = ? AND unit = ? AND is_active = 0";
        String sql = "INSERT INTO recipe(name, classify, photo, unit, price) VALUES(?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(restore)) {
                ps.setString(1, r.getClassify());
                ps.setString(2, r.getPhoto());
                ps.setDouble(3, r.getPrice());
                ps.setString(4, r.getName());
                ps.setString(5, r.getUnit());
                if (ps.executeUpdate() > 0) return 1;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, r.getName());
                ps.setString(2, r.getClassify());
                ps.setString(3, r.getPhoto());
                ps.setString(4, r.getUnit());
                ps.setDouble(5, r.getPrice());
                return ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int update(Recipe r) {
        String sql = "UPDATE recipe SET name=?, classify=?, photo=?, unit=?, price=? WHERE recipe_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getClassify());
            ps.setString(3, r.getPhoto());
            ps.setString(4, r.getUnit());
            ps.setDouble(5, r.getPrice());
            ps.setInt(6, r.getRecipeId());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** 逻辑删除(下架), 不影响历史订单 */
    public int delete(int id) {
        String sql = "UPDATE recipe SET is_active = 0 WHERE recipe_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** 批量逻辑删除 */
    public int batchDelete(int[] ids) {
        if (ids == null || ids.length == 0) return 0;
        StringBuilder sb = new StringBuilder("UPDATE recipe SET is_active = 0 WHERE recipe_id IN (");
        for (int i = 0; i < ids.length; i++) sb.append(i == 0 ? "?" : ",?");
        sb.append(")");
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < ids.length; i++) ps.setInt(i + 1, ids[i]);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private Recipe map(ResultSet rs) throws Exception {
        Recipe r = new Recipe();
        r.setRecipeId(rs.getInt("recipe_id"));
        r.setName(rs.getString("name"));
        r.setClassify(rs.getString("classify"));
        r.setPhoto(rs.getString("photo"));
        r.setUnit(rs.getString("unit"));
        r.setPrice(rs.getDouble("price"));
        return r;
    }
}
