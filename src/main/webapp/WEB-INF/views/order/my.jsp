<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>我的订单</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>我的订单</h1>

  <c:if test="${not empty param.msg}">
    <p class="msg">${fn:escapeXml(param.msg)}</p>
  </c:if>

  <h3>全部记录 <span class="h3-count">共 ${fn:length(myOrders)} 单</span></h3>
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
            ${fn:escapeXml(it.dishName)} <fmt:formatNumber value="${it.quantity}" pattern="0.##"/>${fn:escapeXml(it.unit)}（￥<fmt:formatNumber value="${it.amount}" pattern="0.00"/>）<br>
          </c:forEach>
        </td>
        <td>￥<fmt:formatNumber value="${o.totalPrice}" pattern="0.00"/></td>
        <td><span class="badge ${o.status eq '已配餐' ? 'ok' : 'pending'}">${fn:escapeXml(o.status)}</span></td>
      </tr>
    </c:forEach>
    <c:if test="${empty myOrders}">
      <tr><td colspan="6" class="muted">你还没有订过餐，去「订餐」页选几道菜吧</td></tr>
    </c:if>
    </tbody>
  </table>

  <p class="hint"><a href="${pageContext.request.contextPath}/order">← 回到订餐</a></p>
</main>
</body>
</html>
