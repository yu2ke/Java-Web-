<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>统计报表</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>统计报表</h1>
  <p class="sub">数据来自数据库视图；可导出 CSV 下载。</p>

  <form class="inline" method="get" action="${pageContext.request.contextPath}/stats">
    <label>统计月份 <input type="month" name="ym" value="${ym}"></label>
    <button class="btn" type="submit">查询</button>
  </form>

  <h3>月度销售统计总报表
    <a class="btn-ghost small" href="${pageContext.request.contextPath}/export?type=monthly&ym=${ym}">导出 CSV</a>
  </h3>
  <table class="tbl">
    <thead><tr><th>菜名</th><th>单位</th><th>数量</th><th>单价</th><th>合计金额</th></tr></thead>
    <tbody>
    <c:forEach var="r" items="${monthly}">
      <tr>
        <td>${r.dishName}</td>
        <td>${r.unit}</td>
        <td><fmt:formatNumber value="${r.qty}" pattern="0.##"/></td>
        <td>￥<fmt:formatNumber value="${r.unitPrice}" pattern="0.00"/></td>
        <td>￥<fmt:formatNumber value="${r.amount}" pattern="0.00"/></td>
      </tr>
    </c:forEach>
    <c:if test="${empty monthly}">
      <tr><td colspan="5" class="muted">该月没有销售数据</td></tr>
    </c:if>
    </tbody>
  </table>
  <p>总计金额：<b>￥<fmt:formatNumber value="${monthlyTotal}" pattern="0.00"/></b></p>

  <h3>员工月度菜品统计表
    <a class="btn-ghost small" href="${pageContext.request.contextPath}/export?type=employee&ym=${ym}">导出 CSV</a>
  </h3>
  <table class="tbl">
    <thead><tr><th>员工</th><th>菜名</th><th>单位</th><th>数量</th><th>单价</th><th>合计</th></tr></thead>
    <tbody>
    <c:forEach var="r" items="${employeeMonthly}">
      <tr>
        <td>${r.realName}</td>
        <td>${r.dishName}</td>
        <td>${r.unit}</td>
        <td><fmt:formatNumber value="${r.qty}" pattern="0.##"/></td>
        <td>￥<fmt:formatNumber value="${r.unitPrice}" pattern="0.00"/></td>
        <td>￥<fmt:formatNumber value="${r.amount}" pattern="0.00"/></td>
      </tr>
    </c:forEach>
    <c:if test="${empty employeeMonthly}">
      <tr><td colspan="6" class="muted">该月没有员工消费数据</td></tr>
    </c:if>
    </tbody>
  </table>

  <h3>员工月度订单汇总表</h3>
  <table class="tbl">
    <thead><tr><th>员工</th><th>订单号</th><th>就餐日期</th><th>菜名</th><th>分量</th><th>单价</th><th>合计</th><th>状态</th></tr></thead>
    <tbody>
    <c:forEach var="r" items="${employeeOrders}">
      <tr>
        <td>${r.realName}</td>
        <td>${r.orderId}</td>
        <td>${r.orderDate}</td>
        <td>${r.dishName}</td>
        <td><fmt:formatNumber value="${r.quantity}" pattern="0.##"/></td>
        <td>￥<fmt:formatNumber value="${r.price}" pattern="0.00"/></td>
        <td>￥<fmt:formatNumber value="${r.amount}" pattern="0.00"/></td>
        <td>${r.status}</td>
      </tr>
    </c:forEach>
    <c:if test="${empty employeeOrders}">
      <tr><td colspan="8" class="muted">该月没有订单</td></tr>
    </c:if>
    </tbody>
  </table>

  <h3>我的月度消费统计
    <a class="btn-ghost small" href="${pageContext.request.contextPath}/export?type=mine&ym=${ym}">导出 CSV</a>
  </h3>
  <table class="tbl">
    <thead><tr><th>姓名</th><th>菜名</th><th>单位</th><th>数量</th><th>单价</th><th>合计</th></tr></thead>
    <tbody>
    <c:forEach var="r" items="${mine}">
      <tr>
        <td>${r.realName}</td>
        <td>${r.dishName}</td>
        <td>${r.unit}</td>
        <td><fmt:formatNumber value="${r.qty}" pattern="0.##"/></td>
        <td>￥<fmt:formatNumber value="${r.unitPrice}" pattern="0.00"/></td>
        <td>￥<fmt:formatNumber value="${r.amount}" pattern="0.00"/></td>
      </tr>
    </c:forEach>
    <c:if test="${empty mine}">
      <tr><td colspan="6" class="muted">你本月还没有消费记录</td></tr>
    </c:if>
    </tbody>
  </table>
</main>
</body>
</html>
