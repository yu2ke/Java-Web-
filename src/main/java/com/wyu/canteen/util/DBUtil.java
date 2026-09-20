package com.wyu.canteen.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/** 数据库连接工具类(读取 classpath 下 db.properties) */
public class DBUtil {
    private static String url;
    private static String user;
    private static String password;

    static {
        try (InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            Properties p = new Properties();
            p.load(in);
            Class.forName(p.getProperty("jdbc.driver"));
            url = p.getProperty("jdbc.url");
            user = p.getProperty("jdbc.user");
            password = p.getProperty("jdbc.password");
        } catch (Exception e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }

    /** 统一关闭资源 */
    public static void close(AutoCloseable... rs) {
        for (AutoCloseable c : rs) {
            if (c != null) {
                try { c.close(); } catch (Exception ignored) { }
            }
        }
    }
}
