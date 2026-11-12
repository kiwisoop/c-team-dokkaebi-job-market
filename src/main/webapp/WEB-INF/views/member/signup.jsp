<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입 - 목깨비의 취업시장</title>
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
    <nav class="breadcrumb" aria-label="현재 위치"><ol><li><a href="<c:url value='/'/>">홈</a></li><li aria-current="page">회원가입</li></ol></nav>
    <h1>회원가입</h1>
    <p>가입하면 관심 공고를 저장하고 관심 분야의 새 공고 알림을 받을 수 있습니다.</p>
  </div>
</div>
<main class="container page" id="main" tabindex="-1">
  <div class="card auth-box">
    <p class="req-note"><span class="req" aria-hidden="true">*</span> 표시는 필수 입력 항목입니다.</p>
    <c:if test="${not empty signupError}"><div class="error-msg" role="alert"><c:out value="${signupError}"/></div></c:if>
    <form id="form" action="<c:url value='/member/signup'/>" method="post" novalidate>
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="field"><label for="id">아이디<span class="req" aria-hidden="true">*</span></label><input type="text" id="id" name="userid" maxlength="20" autocomplete="username" required aria-describedby="id-hint" value='<c:out value="${member.userid}"/>'><div class="hint" id="id-hint">영문·숫자 4~20자</div><div class="error-msg"></div></div>
      <div class="field"><label for="pw">비밀번호<span class="req" aria-hidden="true">*</span></label><input type="password" id="pw" name="userpw" maxlength="50" autocomplete="new-password" required aria-describedby="pw-hint"><div class="hint" id="pw-hint">8자리 이상, 특수문자 1개 이상 포함</div><div class="error-msg"></div></div>
      <div class="field"><label for="name">이름<span class="req" aria-hidden="true">*</span></label><input type="text" id="name" name="username" maxlength="20" autocomplete="name" required value='<c:out value="${member.username}"/>'><div class="error-msg"></div></div>
      <div class="field"><label for="email">이메일<span class="req" aria-hidden="true">*</span></label><input type="email" id="email" name="email" maxlength="60" autocomplete="email" required value='<c:out value="${member.email}"/>'><div class="error-msg"></div></div>
      <button class="btn" type="submit">가입하기</button>
    </form>
    <p class="auth-links">이미 회원이신가요? <a href="<c:url value='/member/login'/>">로그인</a></p>
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
  var el = function (i) { return document.getElementById(i); };
  var rules = {
    id: function (v) { return /^[A-Za-z0-9]{4,20}$/.test(v) ? "" : "아이디는 영문·숫자 4~20자로 입력해 주세요."; },
    pw: function (v) { if (v.length < 8) return "비밀번호는 8자리 이상이어야 합니다."; return /[^A-Za-z0-9\s]/.test(v) ? "" : "비밀번호에 특수문자를 1개 이상 포함해 주세요."; },
    name: function (v) { return v.trim().length >= 2 ? "" : "이름을 2자 이상 입력해 주세요."; },
    email: function (v) { return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) ? "" : "올바른 이메일 형식이 아닙니다."; }
  };
  function setErr(input, msg) {
    var f = input.closest(".field");
    f.classList.toggle("invalid", !!msg);
    f.querySelector(".error-msg").textContent = msg || "";
    if (msg) input.setAttribute("aria-invalid", "true"); else input.removeAttribute("aria-invalid");
  }
  var idUrl = "<c:url value='/member/idCheck'/>";
  function checkId() {
    var v = el("id").value;
    var m = rules.id(v);
    setErr(el("id"), m);
    if (m) return;
    var xhr = new XMLHttpRequest();
    xhr.open("GET", idUrl + "?userid=" + encodeURIComponent(v));
    xhr.onload = function () {
      if (el("id").value !== v) return;
      try {
        var ok = JSON.parse(xhr.responseText).available === true;
        setErr(el("id"), ok ? "" : "이미 사용 중인 아이디입니다.");
      } catch (e) {}
    };
    xhr.send();
  }
  ["id", "pw", "name", "email"].forEach(function (k) {
    el(k).addEventListener("input", function () { setErr(el(k), rules[k](el(k).value)); });
    el(k).addEventListener("blur", function () { if (!el(k).value) return; if (k === "id") checkId(); else setErr(el(k), rules[k](el(k).value)); });
  });
  el("form").addEventListener("submit", function (e) {
    var ok = true;
    ["id", "pw", "name", "email"].forEach(function (k) { var m = rules[k](el(k).value); setErr(el(k), m); if (m) ok = false; });
    if (!ok) e.preventDefault();
  });
});
</script>
</body>
</html>
