<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>订单管理</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>订单管理</h1>
  <p class="sub">按日期查看所有员工的订单；餐厅经理可删除已提交的订单。</p>

  <form class="inline" method="get" action="${pageContext.request.contextPath}/order/list">
    <label>日期 <input type="date" name="date" value="${date}"></label>
    <button class="btn" type="submit">查询</button>
  </form>

  <table class="tbl">
    <thead><tr><th>订单号</th><th>员工</th><th>电话</th><th>工位</th><th>菜品</th><th>总计</th><th>状态</th><th>操作</th></tr></thead>
    <tbody>
    <c:forEach var="o" items="${orders}">
      <tr>
        <td>${o.orderId}</td>
        <td>${o.realName}</td>
        <td>${o.phone}</td>
        <td>${o.workstation}</td>
        <td>
          <c:forEach var="it" items="${o.items}">
            ${it.dishName} ${it.quantity}${it.unit}<br>
          </c:forEach>
        </td>
        <td>￥<fmt:formatNumber value="${o.totalPrice}" pattern="0.00"/></td>
        <td>${o.status}</td>
        <td>
          <form class="inline" method="post" action="${pageContext.request.contextPath}/order/delete">
            <input type="hidden" name="orderId" value="${o.orderId}">
            <input type="hidden" name="date" value="${date}">
            <button class="btn-ghost small" type="submit" onclick="return confirm('确定删除该订单吗？')">删除</button>
          </form>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty orders}">
      <tr><td colspan="8" class="muted">当天没有订单</td></tr>
    </c:if>
    </tbody>
  </table>
</main>
</body>
</html>
