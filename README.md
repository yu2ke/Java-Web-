# 企业餐厅网络点餐系统

Java Web 课程设计。企业食堂在线点餐、食谱与菜单管理、订单统计。

## 技术栈

- Java 17、Servlet 6.0 / JSP 3.1（Jakarta EE 10，`jakarta.*` 命名空间）
- JSTL 3.0、MySQL 8 + JDBC（无 ORM）
- Maven，打包 `war`，部署到 Tomcat 10.1

## 功能模块

| 模块 | 说明 |
| --- | --- |
| 登录 | 密码在 `user` 表中以 SHA2-256 存放；cookie 记住登录名 |
| 菜单 | 按日期维护每日菜单，可复制上一天 |
| 食谱 | 菜品食谱的增删改查 |
| 订单 | 点餐、合餐（多人拼单）、打包 |
| 统计 | 月度销售额、员工月度订餐量（视图 `v_monthly_sales` 等） |
| 用户 | 员工、角色、部门管理 |
| 配置 | 系统参数维护（`sys_config`） |

## 运行

1. 导入数据库：`mysql -uroot -p < sql/restaurant_order.sql`
2. 复制 `src/main/resources/db.properties.example` 为 `db.properties`，改成自己的数据库账号密码
3. `mvn clean package`
4. 把 `target/canteen.war` 部署到 Tomcat 10.1，访问 `http://localhost:8080/canteen`

必须用 Tomcat 10.1+，Tomcat 9 及以下不兼容（本项目用 `jakarta.*`）。

## 数据库

[sql/restaurant_order.sql](sql/restaurant_order.sql) 是完整的库导出（含示例数据），
导入后即建好库 `restaurant_order`：

- 表：`user`、`role`、`department`、`menu`、`menu_item`、`recipe`、`orders`、
  `order_item`、`sys_config`
- 视图：`v_blanket_order`、`v_monthly_sales`、`v_employee_monthly`、
  `v_employee_monthly_orders`、`v_emp_own_monthly`、`v_emp_own_orders`、
  `v_menu_current`、`v_recipe_mgr`、`v_user_mgr`

示例账号存在 `user` 表，密码是 SHA2-256 散列值，登录时直接比对散列。
