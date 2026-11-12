<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>로그인 - 목깨비의 취업시장</title>
<link rel="stylesheet" href="<c:url value='/resources/front/css/style.css'/>">
<link rel="icon" type="image/png" href="<c:url value='/resources/front/img/favicon.png'/>">
</head>
<body>
<header class="site-header">
  <a class="skip-link" href="#main">본문 바로가기</a>
  <div class="util-bar">
    <div class="container">
      <p class="util-desc">목포대 재학생·졸업생을 위한 통합 취업정보 서비스</p>
      <div class="util-menu">
        <div class="acct">
          <sec:authorize access="isAnonymous()">
            <a href="<c:url value='/member/login'/>">로그인</a>
            <a href="<c:url value='/member/signup'/>">회원가입</a>
          </sec:authorize>
          <sec:authorize access="isAuthenticated()">
            <span class="user-name"><sec:authentication property="principal.member.username"/>님</span>
            <form action="<c:url value='/logout'/>" method="post" style="display:inline;">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <a href="#" onclick="this.closest('form').submit();return false;">로그아웃</a>
            </form>
          </sec:authorize>
        </div>
      </div>
    </div>
  </div>
  <div class="gnb-wrap">
    <div class="container">
      <a class="logo" href="<c:url value='/'/>">
        <img class="emblem" src="<c:url value='/resources/front/img/mascot.png'/>" alt="" width="143" height="160">
        <span>목깨비의 취업시장</span>
      </a>
      <button class="menu-btn" id="menu-btn" type="button" aria-label="주 메뉴 열기" aria-expanded="false" aria-controls="nav"><span></span><span></span><span></span></button>
      <nav class="nav" id="nav" aria-label="주 메뉴">
        <a href="<c:url value='/resources/front/jobs.html'/>">채용정보</a>
        <a href="<c:url value='/board/list'/>">정보공유 게시판</a>
        <a href="<c:url value='/resources/front/alerts.html'/>">맞춤 알림</a>
        <a href="<c:url value='/resources/front/about.html'/>">서비스 소개</a>
      </nav>
    </div>
  </div>
</header>

<div class="page-head">
  <div class="container">
    <nav class="breadcrumb" aria-label="현재 위치"><ol><li><a href="<c:url value='/'/>">홈</a></li><li aria-current="page">로그인</li></ol></nav>
    <h1>로그인</h1>
    <p>관심 공고 저장과 맞춤 알림은 로그인 후 이용할 수 있습니다.</p>
  </div>
</div>
<main class="container page" id="main" tabindex="-1">
  <div class="card auth-box">
    <c:if test="${not empty signupDone}"><p class="hint" role="status"><c:out value="${signupDone}"/></p></c:if>
    <c:if test="${not empty logoutMsg}"><p class="hint" role="status"><c:out value="${logoutMsg}"/></p></c:if>
    <p class="auth-lead">아이디와 비밀번호를 입력해 주세요.</p>
    <form id="form" action="<c:url value='/login'/>" method="post" novalidate>
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="field"><label for="id">아이디</label><input type="text" id="id" name="username" autocomplete="username"><div class="error-msg"></div></div>
      <div class="field"><label for="pw">비밀번호</label><input type="password" id="pw" name="password" autocomplete="current-password"><div class="error-msg"><c:out value="${loginError}"/></div></div>
      <button class="btn" type="submit">로그인</button>
    </form>
    <p class="auth-links">아직 회원이 아니신가요? <a href="<c:url value='/member/signup'/>">회원가입</a></p>
  </div>
</main>

<footer class="site-footer">
  <div class="container">
    <ul class="footer-links">
      <li><a href="<c:url value='/resources/front/jobs.html'/>">채용정보</a></li>
      <li><a href="<c:url value='/board/list'/>">정보공유 게시판</a></li>
      <li><a href="<c:url value='/resources/front/alerts.html'/>">맞춤 알림</a></li>
      <li><a href="<c:url value='/resources/front/about.html'/>">서비스 소개</a></li>
    </ul>
    <div class="footer-brand">
      <img class="emblem" src="<c:url value='/resources/front/img/mascot.png'/>" alt="" width="143" height="160">
      <span>목깨비의 취업시장</span>
    </div>
    <div class="footer-info">
      <p>국립목포대학교 컴퓨터공학과 C팀 프로젝트</p>
      <p>화면 시연용 서비스입니다.</p>
    </div>
    <p class="copyright">© 2026 목깨비의 취업시장</p>
  </div>
</footer>

<script>
document.addEventListener("DOMContentLoaded", function () {
  var menuBtn = document.getElementById("menu-btn");
  if (menuBtn) menuBtn.addEventListener("click", function () {
    var open = document.getElementById("nav").classList.toggle("open");
    menuBtn.setAttribute("aria-expanded", open);
    menuBtn.setAttribute("aria-label", open ? "주 메뉴 닫기" : "주 메뉴 열기");
  });
  var form = document.getElementById("form");
  function setErr(input, msg) {
    var f = input.closest(".field");
    f.classList.toggle("invalid", !!msg);
    f.querySelector(".error-msg").textContent = msg || "";
  }
  form.addEventListener("submit", function (e) {
    var id = document.getElementById("id"), pw = document.getElementById("pw"), ok = true;
    setErr(id, ""); setErr(pw, "");
    if (!id.value.trim()) { setErr(id, "아이디를 입력해 주세요."); ok = false; }
    if (!pw.value) { setErr(pw, "비밀번호를 입력해 주세요."); ok = false; }
    if (!ok) e.preventDefault();
  });
});
</script>
</body>
</html>
