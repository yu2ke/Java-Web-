<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>用户管理</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <h1>用户管理</h1>
  <p class="sub">用户不需要注册，由有权限的用户添加，支持批量导入。</p>

  <c:if test="${not empty param.msg}"><p class="msg">${fn:escapeXml(param.msg)}</p></c:if>

  <div class="grid2">
    <div class="card">
      <h3>新增用户</h3>
      <form method="post" action="${pageContext.request.contextPath}/user/add">
        <label>登录名 <input type="text" name="username" required></label>
        <label>密码 <input type="password" name="password" required></label>
        <label>姓名 <input type="text" name="realName" required></label>
        <label>联系电话 <input type="text" name="phone" required></label>
        <label>部门
          <select name="deptId">
            <c:forEach var="d" items="${departments}">
              <option value="${d.id}">${fn:escapeXml(d.name)}</option>
            </c:forEach>
          </select>
        </label>
        <label>工位信息 <input type="text" name="workstation"></label>
        <label>角色
          <select name="roleId">
            <c:forEach var="r" items="${roles}">
              <option value="${r.id}">${fn:escapeXml(r.name)}</option>
            </c:forEach>
          </select>
        </label>
        <div class="actions"><button class="btn" type="submit">新增</button></div>
      </form>
    </div>

    <div class="card">
      <h3>批量导入</h3>
      <p class="muted">CSV/TXT 文件，每行：登录名,密码,姓名,电话,部门编号,工位,角色编号</p>
      <form method="post" action="${pageContext.request.contextPath}/user/import"
            enctype="multipart/form-data">
        <label>选择文件 <input type="file" name="file" accept=".csv,.txt"></label>
        <div class="actions"><button class="btn" type="submit">导入</button></div>
      </form>
    </div>
  </div>

  <h3>用户列表</h3>
  <table class="tbl">
    <thead><tr><th>编号</th><th>登录名</th><th>姓名</th><th>电话</th><th>部门</th><th>工位</th><th>角色</th><th>状态</th></tr></thead>
    <tbody>
    <c:forEach var="u" items="${users}">
      <tr>
        <td>${u.userId}</td>
        <td>${fn:escapeXml(u.username)}</td>
        <td>${fn:escapeXml(u.realName)}</td>
        <td>${fn:escapeXml(u.phone)}</td>
        <td>${fn:escapeXml(u.deptName)}</td>
        <td>${fn:escapeXml(u.workstation)}</td>
        <td>${fn:escapeXml(u.roleName)}</td>
        <td><span class="badge ${u.active ? 'ok' : 'pending'}">${u.active ? '在职' : '停用'}</span></td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</main>
</body>
</html>
