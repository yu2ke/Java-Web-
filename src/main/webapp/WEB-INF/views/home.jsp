<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>主页 · 企业餐厅网络点餐系统</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <jsp:include page="/WEB-INF/views/common/header.jsp"/>

  <main class="wrap">
    <div class="eyebrow">Java Web 课程设计</div>
    <h1>你好，${loginUser.realName}</h1>
    <p class="sub">当前角色：${loginUser.roleName}</p>

    <div class="tiles">
      <div class="tile"><div class="num">${recipeCount}</div><div class="lbl">在售菜品</div></div>
      <div class="tile"><div class="num">${orderCount}</div><div class="lbl">历史订单</div></div>
    </div>

    <div class="card">
      <h3>已完成</h3>
      <p>登录（session + cookie）、JDBC 连接数据库、食谱管理（含图片上传）、菜单管理。
         接下来补：订餐、总括订单、统计报表、用户管理。</p>
    </div>
  </main>
</body>
</html>
