<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>${mode == 'add' ? '新增菜品' : '修改菜品'}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>${mode == 'add' ? '新增菜品' : '修改菜品'}</h1>

  <form class="form-card" method="post"
        action="${pageContext.request.contextPath}/recipe/save"
        enctype="multipart/form-data">
    <input type="hidden" name="recipeId" value="${recipe.recipeId}">

    <label>菜名
      <input type="text" name="name" value="${fn:escapeXml(recipe.name)}" required>
    </label>
    <label>分类（主食/菜肴/汤/甜点…）
      <input type="text" name="classify" value="${fn:escapeXml(recipe.classify)}" required>
    </label>
    <label>计量单位（份/两/个/例/杯/碗）
      <input type="text" name="unit" value="${fn:escapeXml(recipe.unit)}" required>
    </label>
    <label>单价（元）
      <input type="number" name="price" step="0.01" min="0" value="${recipe.price}" required>
    </label>
    <label>菜品图片
      <input type="file" name="photo" accept="image/*">
    </label>
    <c:if test="${not empty recipe.photo}">
      <p>当前图片：<img class="dish" src="${pageContext.request.contextPath}/img/${fn:escapeXml(recipe.photo)}" alt=""></p>
    </c:if>

    <div class="actions">
      <button class="btn" type="submit">保存</button>
      <a class="btn-ghost" href="${pageContext.request.contextPath}/recipe/list">取消</a>
    </div>
  </form>
</main>
</body>
</html>
