<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
    <h1>你好，${fn:escapeXml(loginUser.realName)}</h1>
    <p class="sub">当前角色：${fn:escapeXml(loginUser.roleName)}</p>

    <div class="tiles">
      <div class="tile"><div class="num">${recipeCount}</div><div class="lbl">在售菜品</div></div>
      <div class="tile"><div class="num">${orderCount}</div><div class="lbl">历史订单</div></div>
    </div>

    <div class="card">
      <h3>系统功能</h3>
      <p>食谱维护（含菜品图片上传）、按日期维护每日菜单、员工订餐与合餐拼单、
         总括订单与配餐打印、月度销售与员工订餐统计报表、用户与系统参数管理。</p>
    </div>
  </main>
</body>
</html>
