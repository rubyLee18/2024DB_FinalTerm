<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%
// 로그인 상태를 확인하여 버튼 텍스트와 동작을 동적으로 설정
String username = (String) session.getAttribute("username");
boolean isLoggedIn = (username != null);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커뮤니티 사이트</title>
    <link rel="stylesheet" href="header.css">
</head>
<body>
    <div class="header">
        <h1 id="myDiv" onclick="location.href='mainpage.jsp'" style="cursor: pointer;">커뮤니티 사이트</h1>
        <div class="buttons">
            <button onclick="<%= isLoggedIn ? "location.href='deleteAccount.jsp'" : "location.href='signup.html'" %>">
                <%= isLoggedIn ? "회원탈퇴" : "회원가입" %>
            </button>
            <button onclick="<%= isLoggedIn ? "location.href='logout.jsp'" : "location.href='login.html'" %>">
                <%= isLoggedIn ? "로그아웃" : "로그인" %>
            </button>
        </div>
        <hr class="header-line">
    </div>
</body>
</html>
