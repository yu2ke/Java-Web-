<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>菜单管理</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>菜单管理</h1>
  <p class="sub">从食谱挑选菜品组成菜单；可改名价、删菜、切换当前菜单，历史菜单留存可复用。</p>

  <c:if test="${not empty param.msg}"><p class="msg">${fn:escapeXml(param.msg)}</p></c:if>

  <form class="inline" method="post" action="${pageContext.request.contextPath}/menu/create">
    <input type="text" name="menuName" placeholder="新菜单名字" required>
    <button class="btn" type="submit">新建菜单</button>
  </form>

  <c:forEach var="m" items="${menus}">
    <c:if test="${m.menuId == menuId}"><c:set var="viewName" value="${m.menuName}"/></c:if>
    <c:if test="${m.current}"><c:set var="currentName" value="${m.menuName}"/></c:if>
  </c:forEach>
  <h3>当前菜单：${empty currentName ? '（还没有菜单）' : fn:escapeXml(currentName)}
    <c:if test="${not empty currentName and menuId != currentId}">
      正在查看：${fn:escapeXml(viewName)}
    </c:if>
  </h3>
  <table class="tbl">
    <thead>
    <tr><th>序号</th><th>图片</th><th>菜名</th><th>分类</th><th>单位</th><th>价格</th><th>操作</th></tr>
    </thead>
    <tbody>
    <c:forEach var="it" items="${items}" varStatus="st">
      <tr>
        <td>${st.count}</td>
        <td>
          <c:if test="${not empty it.photo}">
            <img class="dish" src="${pageContext.request.contextPath}/img/${fn:escapeXml(it.photo)}" alt="">
          </c:if>
        </td>
        <td>${fn:escapeXml(it.dishName)}</td>
        <td>${fn:escapeXml(it.classify)}</td>
        <td>${fn:escapeXml(it.unit)}</td>
        <td>
          <form class="inline" method="post" action="${pageContext.request.contextPath}/menu/itemPrice">
            <input type="hidden" name="itemId" value="${it.itemId}">
            <input type="number" name="price" step="0.01" min="0" value="<fmt:formatNumber value='${it.price}' pattern='0.00'/>">
            <button class="btn-ghost small" type="submit">改价</button>
          </form>
        </td>
        <td>
          <form class="inline" method="post" action="${pageContext.request.contextPath}/menu/itemDelete">
            <input type="hidden" name="itemId" value="${it.itemId}">
            <button class="btn-ghost small" type="submit" onclick="return confirm('确定从菜单删除该菜品吗？')">删除</button>
          </form>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty items}">
      <tr><td colspan="7" class="muted">该菜单还没有菜品</td></tr>
    </c:if>
    </tbody>
  </table>

  <h3>从食谱加入菜品</h3>
  <form class="inline" method="post" action="${pageContext.request.contextPath}/menu/addItem">
    <input type="hidden" name="menuId" value="${menuId}">
    <select name="recipeId">
      <c:forEach var="r" items="${recipes}">
        <option value="${r.recipeId}">${fn:escapeXml(r.name)}（${fn:escapeXml(r.classify)} · ${fn:escapeXml(r.unit)} · ￥<fmt:formatNumber value="${r.price}" pattern="0.00"/>）</option>
      </c:forEach>
    </select>
    <button class="btn" type="submit">加入菜单</button>
  </form>

  <h3>历史菜单（可改名、删除、切换当前菜单）</h3>
  <table class="tbl">
    <thead><tr><th>序号</th><th>菜单名</th><th>状态</th><th>查看</th><th>操作</th></tr></thead>
    <tbody>
    <c:forEach var="m" items="${menus}" varStatus="st">
      <tr>
        <td>${st.count}</td>
        <td>
          <form class="inline" method="post" action="${pageContext.request.contextPath}/menu/rename">
            <input type="hidden" name="menuId" value="${m.menuId}">
            <input type="text" name="menuName" value="${fn:escapeXml(m.menuName)}" required>
            <button class="btn-ghost small" type="submit">改名</button>
          </form>
        </td>
        <td><c:if test="${m.current}"><span class="badge ok">当前</span></c:if></td>
        <td><a class="link" href="${pageContext.request.contextPath}/menu?menuId=${m.menuId}">查看</a></td>
        <td>
          <div class="inline">
            <c:if test="${not m.current}">
              <form class="inline" method="post" action="${pageContext.request.contextPath}/menu/activate">
                <input type="hidden" name="menuId" value="${m.menuId}">
                <button class="btn-ghost small" type="submit">设为当前</button>
              </form>
            </c:if>
            <form class="inline" method="post" action="${pageContext.request.contextPath}/menu/menuDelete">
              <input type="hidden" name="menuId" value="${m.menuId}">
              <button class="btn-ghost small danger" type="submit"
                      onclick="return confirm('删除菜单会同时删掉它的全部菜品（历史订单不受影响），确定吗？')">删除</button>
            </form>
          </div>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty menus}">
      <tr><td colspan="5" class="muted">还没有菜单，先在上面的输入框新建一个</td></tr>
    </c:if>
    </tbody>
  </table>
</main>
</body>
</html>
