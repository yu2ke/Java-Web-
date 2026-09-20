package com.wyu.canteen.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

/** 监听器：应用启动日志 + 在线人数统计 */
@WebListener
public class AppListener implements ServletContextListener, HttpSessionListener {

    @Override
    public void contextInitialized(ServletContextEvent e) {
        e.getServletContext().setAttribute("online", 0);
        e.getServletContext().log("企业餐厅网络点餐系统已启动");
    }

    @Override
    public void contextDestroyed(ServletContextEvent e) {
        e.getServletContext().log("企业餐厅网络点餐系统已关闭");
    }

    @Override
    public void sessionCreated(HttpSessionEvent e) {
        count(e, 1);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent e) {
        count(e, -1);
    }

    private synchronized void count(HttpSessionEvent e, int delta) {
        Object v = e.getSession().getServletContext().getAttribute("online");
        int n = (v == null ? 0 : (Integer) v) + delta;
        e.getSession().getServletContext().setAttribute("online", Math.max(0, n));
    }
}
