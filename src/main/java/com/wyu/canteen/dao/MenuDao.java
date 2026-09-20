package com.wyu.canteen.dao;

import com.wyu.canteen.model.Menu;
import com.wyu.canteen.model.MenuItem;
import com.wyu.canteen.util.DBUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/** 菜单数据库操作 */
public class MenuDao {

    public List<Menu> listMenus() {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT menu_id, menu_name, is_current FROM menu ORDER BY menu_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Menu m = new Menu();
                m.setMenuId(rs.getInt("menu_id"));
                m.setMenuName(rs.getString("menu_name"));
                m.setCurrent(rs.getInt("is_current") == 1);
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int currentMenuId() {
        String sql = "SELECT menu_id FROM menu WHERE is_current = 1 LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<MenuItem> items(int menuId) {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT item_id, menu_id, dish_name, classify, photo, unit, price "
                   + "FROM menu_item WHERE menu_id = ? ORDER BY item_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MenuItem it = new MenuItem();
                    it.setItemId(rs.getInt("item_id"));
                    it.setMenuId(rs.getInt("menu_id"));
                    it.setDishName(rs.getString("dish_name"));
                    it.setClassify(rs.getString("classify"));
                    it.setPhoto(rs.getString("photo"));
                    it.setUnit(rs.getString("unit"));
                    it.setPrice(rs.getDouble("price"));
                    list.add(it);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 新建菜单(非当前) */
    public int create(String name, int createBy) {
        String sql = "INSERT INTO menu(menu_name, is_current, create_by) VALUES(?,0,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, createBy);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** 从食谱把一个菜品加入菜单(复制快照) */
    public int addItemFromRecipe(int menuId, int recipeId) {
        String sql = "INSERT INTO menu_item(menu_id, recipe_id, dish_name, classify, photo, unit, price) "
                   + "SELECT ?, recipe_id, name, classify, photo, unit, price FROM recipe WHERE recipe_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            ps.setInt(2, recipeId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int updateItemPrice(int itemId, double price) {
        String sql = "UPDATE menu_item SET price = ? WHERE item_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, price);
            ps.setInt(2, itemId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int deleteItem(int itemId) {
        String sql = "DELETE FROM menu_item WHERE item_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /** 调用存储过程切换当前菜单 */
    public void activate(int menuId) {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement cs = conn.prepareCall("{call sp_activate_menu(?)}")) {
            cs.setInt(1, menuId);
            cs.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
