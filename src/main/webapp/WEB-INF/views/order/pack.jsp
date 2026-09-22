<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>配餐打印</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>配餐打印</h1>
  <p class="sub">按员工批量列出当天订单，供配餐员配送。</p>

  <form class="inline" method="get" action="${pageContext.request.contextPath}/pack">
    <label>日期 <input type="date" name="date" value="${date}"></label>
    <button class="btn" type="submit">查询</button>
    <button class="btn-ghost" type="button" onclick="window.print()">打印全部</button>
  </form>

  <c:forEach var="o" items="${orders}">
    <div class="card">
      <h3>${fn:escapeXml(o.realName)}　电话：${fn:escapeXml(o.phone)}　工位：${fn:escapeXml(o.workstation)}</h3>
      <table class="tbl">
        <thead><tr><th>菜名</th><th>单位</th><th>分量</th><th>单价</th><th>合计</th></tr></thead>
        <tbody>
        <c:forEach var="it" items="${o.items}">
          <tr>
            <td>${fn:escapeXml(it.dishName)}</td>
            <td>${fn:escapeXml(it.unit)}</td>
            <td><fmt:formatNumber value="${it.quantity}" pattern="0.##"/></td>
            <td>￥<fmt:formatNumber value="${it.price}" pattern="0.00"/></td>
            <td>￥<fmt:formatNumber value="${it.amount}" pattern="0.00"/></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <p>合计金额：￥<fmt:formatNumber value="${o.totalPrice}" pattern="0.00"/></p>
    </div>
  </c:forEach>
  <c:if test="${empty orders}">
    <p class="muted">当天没有订单</p>
  </c:if>
</main>
</body>
</html>
