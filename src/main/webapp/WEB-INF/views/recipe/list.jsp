<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>食谱管理</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>食谱管理</h1>
  <p class="sub">在售菜品列表，可查找、新增、修改、删除（逻辑删除，不影响历史订单）。</p>

  <form class="inline" method="get" action="${pageContext.request.contextPath}/recipe/list">
    <input type="text" name="keyword" value="${fn:escapeXml(keyword)}" placeholder="按菜名查找">
    <button class="btn" type="submit">查找</button>
    <a class="btn-ghost" href="${pageContext.request.contextPath}/recipe/add">新增菜品</a>
  </form>

  <form method="post" action="${pageContext.request.contextPath}/recipe/batchDelete">
    <table class="tbl">
      <thead>
      <tr><th></th><th>序号</th><th>图片</th><th>菜名</th><th>分类</th><th>单位</th><th>单价</th><th>操作</th></tr>
      </thead>
      <tbody>
      <c:forEach var="r" items="${recipes}" varStatus="st">
        <tr>
          <td><input type="checkbox" name="ids" value="${r.recipeId}"></td>
          <td>${st.count}</td>
          <td>
            <c:choose>
              <c:when test="${not empty r.photo}">
                <img class="dish" src="${pageContext.request.contextPath}/img/${fn:escapeXml(r.photo)}" alt="">
              </c:when>
              <c:otherwise><span class="muted">无</span></c:otherwise>
            </c:choose>
          </td>
          <td>${fn:escapeXml(r.name)}</td>
          <td>${fn:escapeXml(r.classify)}</td>
          <td>${fn:escapeXml(r.unit)}</td>
          <td>￥<fmt:formatNumber value="${r.price}" pattern="0.00"/></td>
          <td>
            <a class="link" href="${pageContext.request.contextPath}/recipe/edit?id=${r.recipeId}">修改</a>
            <a class="link danger" href="${pageContext.request.contextPath}/recipe/delete?id=${r.recipeId}"
               onclick="return confirm('确定删除该菜品吗？')">删除</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty recipes}">
        <tr><td colspan="8" class="muted">没有查到菜品</td></tr>
      </c:if>
      </tbody>
    </table>
    <div class="actions">
      <button class="btn-ghost" type="submit" onclick="return confirm('确定批量删除选中菜品吗？')">批量删除</button>
    </div>
  </form>
</main>
</body>
</html>
