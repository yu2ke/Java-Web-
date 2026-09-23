<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="cur" value="${requestScope.currentPath}"/>
<aside class="sidebar">
  <div class="brand">企业餐厅<span>网络点餐系统</span></div>
  <nav class="nav">
    <a class="${cur eq '/home' ? 'active' : ''}" href="${ctx}/home">主页</a>
    <c:if test="${loginUser.canAccess('/recipe')}">
      <a class="${fn:startsWith(cur, '/recipe') ? 'active' : ''}" href="${ctx}/recipe/list">食谱管理</a>
    </c:if>
    <c:if test="${loginUser.canAccess('/menu')}">
      <a class="${fn:startsWith(cur, '/menu') ? 'active' : ''}" href="${ctx}/menu">菜单管理</a>
    </c:if>
    <c:if test="${loginUser.canAccess('/order')}">
      <a class="${fn:startsWith(cur, '/order') and not fn:startsWith(cur, '/order/list') ? 'active' : ''}" href="${ctx}/order">订餐</a>
    </c:if>
    <c:if test="${loginUser.canAccess('/order/list')}">
      <a class="${fn:startsWith(cur, '/order/list') ? 'active' : ''}" href="${ctx}/order/list">订单管理</a>
    </c:if>
    <c:if test="${loginUser.canAccess('/blanket')}">
      <a class="${fn:startsWith(cur, '/blanket') ? 'active' : ''}" href="${ctx}/blanket">总括订单</a>
    </c:if>
    <c:if test="${loginUser.canAccess('/pack')}">
      <a class="${fn:startsWith(cur, '/pack') ? 'active' : ''}" href="${ctx}/pack">配餐打印</a>
    </c:if>
    <c:if test="${loginUser.canAccess('/stats')}">
      <a class="${fn:startsWith(cur, '/stats') ? 'active' : ''}" href="${ctx}/stats">统计报表</a>
    </c:if>
    <c:if test="${loginUser.canAccess('/user')}">
      <a class="${fn:startsWith(cur, '/user') ? 'active' : ''}" href="${ctx}/user/list">用户管理</a>
    </c:if>
    <c:if test="${loginUser.canAccess('/config')}">
      <a class="${fn:startsWith(cur, '/config') ? 'active' : ''}" href="${ctx}/config">系统参数</a>
    </c:if>
  </nav>
  <div class="side-user">
    <span class="user">${fn:escapeXml(loginUser.realName)}<span>${fn:escapeXml(loginUser.roleName)}</span></span>
    <a class="link" href="${ctx}/logout">退出</a>
  </div>
</aside>

<!-- 双击任意图片放大；点击遮罩或按 Esc 关闭 -->
<div class="lightbox" id="lightbox" hidden role="dialog" aria-modal="true" aria-label="图片预览">
  <img src="" alt="放大预览">
</div>
<script>
  (function () {
    var box = document.getElementById("lightbox");
    var big = box.querySelector("img");
    document.addEventListener("dblclick", function (e) {
      var img = e.target.closest ? e.target.closest("img") : null;
      if (!img || img === big) return;
      big.src = img.src;
      box.hidden = false;
    });
    box.addEventListener("click", function () {
      box.hidden = true;
    });
    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") box.hidden = true;
    });
  })();
</script>
