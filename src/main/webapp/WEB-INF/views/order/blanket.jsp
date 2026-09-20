<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>总括订单</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>总括订单</h1>
  <p class="sub">供厨房主管按当天各菜品的总分量备餐（来源：视图 v_blanket_order）。</p>

  <form class="inline" method="get" action="${pageContext.request.contextPath}/blanket">
    <label>日期 <input type="date" name="date" value="${date}"></label>
    <button class="btn" type="submit">查询</button>
    <button class="btn-ghost" type="button" onclick="window.print()">打印</button>
  </form>

  <table class="tbl">
    <thead><tr><th>分类</th><th>菜名</th><th>单位</th><th>总分量</th></tr></thead>
    <tbody>
    <c:forEach var="r" items="${rows}">
      <tr>
        <td>${r.classify}</td>
        <td>${r.dishName}</td>
        <td>${r.unit}</td>
        <td><fmt:formatNumber value="${r.totalQty}" pattern="0.##"/></td>
      </tr>
    </c:forEach>
    <c:if test="${empty rows}">
      <tr><td colspan="4" class="muted">当天没有订单</td></tr>
    </c:if>
    </tbody>
  </table>
</main>
</body>
</html>
