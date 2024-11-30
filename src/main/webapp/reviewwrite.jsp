<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 한글 인코딩 설정
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 권한 확인: 로그인한 사용자만 접근 가능
    String loggedInUsername = (String) session.getAttribute("username");
    String loggedInNickname = (String) session.getAttribute("nickname");

    if (loggedInUsername == null) {
        // 로그인하지 않은 경우 로그인 페이지로 이동
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 작성</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="header-container"></div>
    <h1>게시글 작성</h1>
    <form action="saveReview.jsp" method="post">
        <!-- 작성자 정보를 숨긴 필드로 포함 -->
        <input type="hidden" name="author" value="<%= loggedInUsername %>">
        <input type="hidden" name="nickname" value="<%= loggedInNickname %>">

        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" placeholder="제목 입력" required>
        </div>
        <div class="form-group">
            <label for="content">내용</label>
            <textarea id="content" name="content" placeholder="내용 입력" rows="10" required></textarea>
        </div>
        <div class="button-group">
            <button type="submit">등록</button>
            <button type="button" onclick="location.href='reviewlist.jsp'">취소</button>
        </div>
    </form>
</body>
</html>
