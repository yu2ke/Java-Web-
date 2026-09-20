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

1. 建库并导入表结构（见下方「数据库」）
2. 复制 `src/main/resources/db.properties.example` 为 `db.properties`，改成自己的数据库账号密码
3. `mvn clean package`
4. 把 `target/canteen.war` 部署到 Tomcat 10.1，访问 `http://localhost:8080/canteen`

必须用 Tomcat 10.1+，Tomcat 9 及以下不兼容（本项目用 `jakarta.*`）。

## 数据库

库名 `restaurant_order`，用到的表 / 视图：`user`、`role`、`department`、`menu`、
`menu_item`、`recipe`、`orders`、`sys_config`、`v_blanket_order`、
`v_monthly_sales`、`v_employee_monthly_orders`。

建表 SQL 未包含在本仓库中。执行 `db.properties.example` 中的连接串前，请自行建库建表。
