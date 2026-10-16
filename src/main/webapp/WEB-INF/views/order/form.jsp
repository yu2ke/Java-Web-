<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>订餐</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="wrap">
  <%-- 横幅：当日菜单里的菜品图最多 3 张轮播；一张都没有就退回渐变底 --%>
  <section class="hero ${empty bannerPhotos ? '' : 'banner'}">
    <c:if test="${not empty bannerPhotos}">
      <c:forEach var="ph" items="${bannerPhotos}" varStatus="st">
        <div class="slide ${st.first ? 'active' : ''}"
             style="background-image:url('${pageContext.request.contextPath}/img/${fn:escapeXml(ph)}')"></div>
      </c:forEach>
    </c:if>
    <div class="hero-text">
      <div class="eyebrow">今日菜单</div>
      <h1>${empty menuName ? '还没有可用菜单' : fn:escapeXml(menuName)}</h1>
      <p class="sub">订餐截止时间 ${fn:escapeXml(deadline)}，配餐开始时间 ${fn:escapeXml(serveStart)}。
         规则：当天须在截止时间前下单，次日须在配餐开始时间后下单，每人每天只能下一张订单。</p>
    </div>
    <c:if test="${fn:length(bannerPhotos) > 1}">
      <div class="dots" id="bannerDots">
        <c:forEach var="ph" items="${bannerPhotos}" varStatus="st">
          <button type="button" class="dot ${st.first ? 'active' : ''}" data-i="${st.index}"
                  aria-label="第 ${st.count} 张"></button>
        </c:forEach>
      </div>
    </c:if>
  </section>

  <form method="post" action="${pageContext.request.contextPath}/order/submit">
    <div class="inline">
      <label>就餐日期 <input type="date" name="orderDate" value="${today}"></label>
      <span class="muted">每道菜填上要几份，不要的留 0</span>
    </div>

    <h3>全部菜品 <span class="h3-count">共 ${fn:length(items)} 道</span></h3>

    <div class="chips" id="chips">
      <button type="button" class="chip active" data-filter="">全部</button>
      <c:forEach var="cf" items="${classifies}">
        <button type="button" class="chip" data-filter="${fn:escapeXml(cf)}">${fn:escapeXml(cf)}</button>
      </c:forEach>
    </div>

    <div class="dish-grid">
      <c:forEach var="it" items="${items}">
        <div class="dish-card" data-classify="${fn:escapeXml(it.classify)}" data-name="${fn:escapeXml(it.dishName)}">
          <c:choose>
            <c:when test="${not empty it.photo}">
              <img class="dish-photo" src="${pageContext.request.contextPath}/img/${fn:escapeXml(it.photo)}"
                   alt="${fn:escapeXml(it.dishName)}">
            </c:when>
            <c:otherwise>
              <div class="dish-photo empty">${fn:escapeXml(fn:substring(it.dishName, 0, 1))}</div>
            </c:otherwise>
          </c:choose>
          <c:if test="${not empty it.classify}">
            <span class="corner">${fn:escapeXml(it.classify)}</span>
          </c:if>
          <div class="dish-body">
            <div class="dish-name">${fn:escapeXml(it.dishName)}</div>
            <div class="dish-meta">
              <span class="muted">按 ${fn:escapeXml(it.unit)} 计</span>
            </div>
            <div class="dish-foot">
              <span class="price">￥<fmt:formatNumber value="${it.price}" pattern="0.00"/></span>
              <input type="number" name="qty_${it.itemId}" value="0" min="0" step="1"
                     aria-label="${fn:escapeXml(it.dishName)} 份数">
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
    <c:if test="${empty items}">
      <p class="muted">当前菜单还没有菜品，请先到菜单管理添加。</p>
    </c:if>

    <div class="submit-bar">
      <%-- 提示放在提交条里：提交后页面滚在下面，用户也一定看得见 --%>
      <c:choose>
        <c:when test="${not empty param.msg}">
          <span class="${fn:contains(param.msg, '成功') ? 'submit-ok' : 'submit-err'}">${fn:escapeXml(param.msg)}</span>
        </c:when>
        <c:otherwise>
          <span class="muted">填好数量后点右侧提交，每人每天只能下一张订单</span>
        </c:otherwise>
      </c:choose>
      <button class="btn" type="submit">提交订单</button>
    </div>
  </form>

</main>
<script>
  // 横幅轮播：点圆点切换，3 秒自动翻页
  (function () {
    var dots = document.getElementById("bannerDots");
    if (!dots) return;
    var slides = document.querySelectorAll(".hero.banner .slide");
    var btns = dots.querySelectorAll(".dot");
    var cur = 0;
    function show(i) {
      cur = i;
      slides.forEach(function (s, k) { s.classList.toggle("active", k === i); });
      btns.forEach(function (b, k) { b.classList.toggle("active", k === i); });
    }
    btns.forEach(function (b) {
      b.addEventListener("click", function () { show(Number(b.dataset.i)); });
    });
    setInterval(function () { show((cur + 1) % slides.length); }, 3000);
  })();

  // 分类筛选：点某个分类只留下对应的菜品卡片
  (function () {
    var chips = document.getElementById("chips");
    if (!chips) return;
    chips.addEventListener("click", function (e) {
      var chip = e.target.closest(".chip");
      if (!chip) return;
      chips.querySelectorAll(".chip").forEach(function (b) { b.classList.remove("active"); });
      chip.classList.add("active");
      var want = chip.dataset.filter;
      document.querySelectorAll(".dish-card").forEach(function (card) {
        card.hidden = !!want && card.dataset.classify !== want;
      });
    });
  })();
</script>
</body>
</html>
