<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>系统参数</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>系统参数</h1>
  <p class="sub">订餐截止时间与配餐开始时间可由最终用户自定义。</p>

  <c:if test="${not empty param.msg}"><p class="msg">${fn:escapeXml(param.msg)}</p></c:if>

  <form class="form-card" method="post" action="${pageContext.request.contextPath}/config">
    <label>订餐截止时间（当天在此时间前可下单）
      <input type="time" name="deadline" value="${fn:escapeXml(deadline)}" required>
    </label>
    <label>配餐开始时间（此时间后可预订次日餐）
      <input type="time" name="serveStart" value="${fn:escapeXml(serveStart)}" required>
    </label>
    <div class="actions"><button class="btn" type="submit">保存</button></div>
  </form>
</main>
</body>
</html>
