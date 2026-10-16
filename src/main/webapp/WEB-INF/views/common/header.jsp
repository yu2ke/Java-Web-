<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="cur" value="${requestScope.currentPath}"/>
<%-- 企业员工菜单少，用顶部导航；管理/员工角色菜单多，用左侧栏 --%>
<aside class="appnav ${loginUser.employee ? 'topnav' : 'sidebar'}">
  <div class="brand">企业餐厅<span>网络点餐系统</span></div>
  <nav class="nav">
    <jsp:include page="/WEB-INF/views/common/nav.jsp"/>
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
