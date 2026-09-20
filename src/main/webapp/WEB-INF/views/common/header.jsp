<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="topbar">
  <span class="brand">企业餐厅网络点餐系统</span>
  <nav class="nav">
    <a href="${pageContext.request.contextPath}/home">主页</a>
    <a href="${pageContext.request.contextPath}/recipe/list">食谱管理</a>
    <a href="${pageContext.request.contextPath}/menu">菜单管理</a>
    <a href="${pageContext.request.contextPath}/order">订餐</a>
    <a href="${pageContext.request.contextPath}/order/list">订单管理</a>
    <a href="${pageContext.request.contextPath}/blanket">总括订单</a>
    <a href="${pageContext.request.contextPath}/pack">配餐打印</a>
    <a href="${pageContext.request.contextPath}/stats">统计报表</a>
    <a href="${pageContext.request.contextPath}/user/list">用户管理</a>
    <a href="${pageContext.request.contextPath}/config">系统参数</a>
  </nav>
  <span class="user">
    ${loginUser.realName}（${loginUser.roleName}）
    <a class="link" href="${pageContext.request.contextPath}/logout">退出</a>
  </span>
</header>
