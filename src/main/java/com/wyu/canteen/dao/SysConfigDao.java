package com.wyu.canteen.dao;

import com.wyu.canteen.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/** 系统参数(订餐截止时间/配餐开始时间) */
public class SysConfigDao {

    public String get(String key) {
        String sql = "SELECT cfg_value FROM sys_config WHERE cfg_key = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public int set(String key, String value) {
        String sql = "UPDATE sys_config SET cfg_value = ? WHERE cfg_key = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, value);
            ps.setString(2, key);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
