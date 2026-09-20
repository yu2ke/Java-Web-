<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>登录 · 企业餐厅网络点餐系统</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="login-body">
  <div class="login-card">
    <div class="eyebrow">企业餐厅网络点餐系统</div>
    <h1>欢迎回来</h1>
    <p class="sub">登录后在截止时间前选择今天的午餐。</p>

    <c:if test="${not empty error}">
      <p class="err">${error}</p>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login">
      <label>登录名
        <input name="username" value="${remembered}" autocomplete="username" required>
      </label>
      <label>密码
        <input name="password" type="password" autocomplete="current-password" required>
      </label>
      <label class="check">
        <input type="checkbox" name="remember" value="1"> 记住登录名
      </label>
      <div class="actions">
        <button class="btn" type="submit">登 录</button>
      </div>
    </form>
    <p class="hint">演示账号：manager / liu / zhang，密码均为 123456</p>
  </div>
</body>
</html>
