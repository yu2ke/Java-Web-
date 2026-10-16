<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- 导航项：侧边栏和顶部导航共用，按角色过滤；图标用内联 SVG，跟随文字颜色 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="cur" value="${requestScope.currentPath}"/>
<%-- 订餐页：/order 本身，排除订单管理和我的订单这两个子路径 --%>
<c:set var="isOrderPage" value="${fn:startsWith(cur, '/order')
    and not fn:startsWith(cur, '/order/list')
    and not fn:startsWith(cur, '/order/mine')}"/>

<a class="${cur eq '/home' ? 'active' : ''}" href="${ctx}/home">
  <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M4 11 12 4l8 7"/><path d="M6 10v10h12V10"/></svg>
  主页
</a>

<c:if test="${loginUser.canAccess('/recipe')}">
  <a class="${fn:startsWith(cur, '/recipe') ? 'active' : ''}" href="${ctx}/recipe/list">
    <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M5 4h8a4 4 0 0 1 4 4v12H8a3 3 0 0 1-3-3z"/><path d="M9 4v16"/></svg>
    食谱管理
  </a>
</c:if>

<c:if test="${loginUser.canAccess('/menu')}">
  <a class="${fn:startsWith(cur, '/menu') ? 'active' : ''}" href="${ctx}/menu">
    <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><rect x="4" y="4" width="7" height="7" rx="1.5"/><rect x="13" y="4" width="7" height="7" rx="1.5"/><rect x="4" y="13" width="7" height="7" rx="1.5"/><rect x="13" y="13" width="7" height="7" rx="1.5"/></svg>
    菜单管理
  </a>
</c:if>

<c:if test="${loginUser.canAccess('/order')}">
  <a class="${isOrderPage ? 'active' : ''}" href="${ctx}/order">
    <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M4 11h16a8 8 0 0 1-16 0z"/><path d="M9 7v4M15 7v4"/></svg>
    订餐
  </a>
</c:if>

<c:if test="${loginUser.canAccess('/order/list')}">
  <a class="${fn:startsWith(cur, '/order/list') ? 'active' : ''}" href="${ctx}/order/list">
    <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><rect x="6" y="4" width="12" height="16" rx="2"/><path d="M9 4V3h6v1"/><path d="M9 10h6M9 14h4"/></svg>
    订单管理
  </a>
</c:if>

<a class="${fn:startsWith(cur, '/order/mine') ? 'active' : ''}" href="${ctx}/order/mine">
  <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><rect x="5" y="4" width="14" height="17" rx="2"/><path d="M9 9h6M9 13h6M9 17h3"/></svg>
  我的订单
</a>

<c:if test="${loginUser.canAccess('/blanket')}">
  <a class="${fn:startsWith(cur, '/blanket') ? 'active' : ''}" href="${ctx}/blanket">
    <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M4 6h16M4 12h16M4 18h10"/></svg>
    总括订单
  </a>
</c:if>

<c:if test="${loginUser.canAccess('/pack')}">
  <a class="${fn:startsWith(cur, '/pack') ? 'active' : ''}" href="${ctx}/pack">
    <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><rect x="6" y="3" width="12" height="5" rx="1"/><rect x="4" y="9" width="16" height="8" rx="2"/><rect x="7" y="16" width="10" height="5" rx="1"/></svg>
    配餐打印
  </a>
</c:if>

<c:if test="${loginUser.canAccess('/stats')}">
  <a class="${fn:startsWith(cur, '/stats') ? 'active' : ''}" href="${ctx}/stats">
    <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M5 20V12M12 20V5M19 20v-9"/><path d="M3 20h18"/></svg>
    统计报表
  </a>
</c:if>

<c:if test="${loginUser.canAccess('/user')}">
  <a class="${fn:startsWith(cur, '/user') ? 'active' : ''}" href="${ctx}/user/list">
    <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><circle cx="9" cy="8" r="3"/><path d="M3 20a6 6 0 0 1 12 0"/><path d="M16 6.5a3 3 0 0 1 0 5.8M17.5 20a6 6 0 0 0-2-4.5"/></svg>
    用户管理
  </a>
</c:if>

<c:if test="${loginUser.canAccess('/config')}">
  <a class="${fn:startsWith(cur, '/config') ? 'active' : ''}" href="${ctx}/config">
    <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><circle cx="12" cy="12" r="3"/><path d="M12 3v2.5M12 18.5V21M3 12h2.5M18.5 12H21M5.6 5.6l1.8 1.8M16.6 16.6l1.8 1.8M18.4 5.6l-1.8 1.8M7.4 16.6l-1.8 1.8"/></svg>
    系统参数
  </a>
</c:if>
