<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>订餐</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>订餐</h1>
  <p class="sub">当前菜单菜单 #${menuId}。订餐截止时间 ${deadline}，配餐开始时间 ${serveStart}。
     规则：当天须在截止时间前下单，次日须在配餐开始时间后下单，每人每天只能下一张订单。</p>

  <c:if test="${not empty param.msg}">
    <p class="msg">${param.msg}</p>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/order/submit">
    <div class="inline">
      <label>就餐日期 <input type="date" name="orderDate" value="${today}"></label>
    </div>
    <table class="tbl">
      <thead><tr><th>菜名</th><th>分类</th><th>单位</th><th>单价</th><th>分量</th></tr></thead>
      <tbody>
      <c:forEach var="it" items="${items}">
        <tr>
          <td>${it.dishName}</td>
          <td>${it.classify}</td>
          <td>${it.unit}</td>
          <td>￥<fmt:formatNumber value="${it.price}" pattern="0.00"/></td>
          <td><input type="number" name="qty_${it.itemId}" value="0" min="0" step="1" style="width:80px"></td>
        </tr>
      </c:forEach>
      <c:if test="${empty items}">
        <tr><td colspan="5" class="muted">当前菜单还没有菜品，请先到菜单管理添加</td></tr>
      </c:if>
      </tbody>
    </table>
    <div class="actions"><button class="btn" type="submit">提交订单</button></div>
  </form>

  <h3>我的订单</h3>
  <table class="tbl">
    <thead><tr><th>订单号</th><th>就餐日期</th><th>下单时间</th><th>菜品</th><th>总计</th><th>状态</th></tr></thead>
    <tbody>
    <c:forEach var="o" items="${myOrders}">
      <tr>
        <td>${o.orderId}</td>
        <td>${o.orderDate}</td>
        <td>${o.orderTime}</td>
        <td>
          <c:forEach var="it" items="${o.items}">
            ${it.dishName} ${it.quantity}${it.unit}（￥<fmt:formatNumber value="${it.amount}" pattern="0.00"/>）<br>
          </c:forEach>
        </td>
        <td>￥<fmt:formatNumber value="${o.totalPrice}" pattern="0.00"/></td>
        <td>${o.status}</td>
      </tr>
    </c:forEach>
    <c:if test="${empty myOrders}">
      <tr><td colspan="6" class="muted">还没有订单</td></tr>
    </c:if>
    </tbody>
  </table>
</main>
</body>
</html>
