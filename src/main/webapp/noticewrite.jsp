<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%
    String loggedInUsername = (String) session.getAttribute("username");
    if (loggedInUsername == null || !"admin".equals(loggedInUsername)) {
        out.println("<script>alert('접근 권한이 없습니다.'); history.back();</script>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 글쓰기</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="header-container"></div>
    <h1>공지사항 작성</h1>
    <form action="saveNotice.jsp" method="post">
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
            <button type="button" onclick="location.href='noticelist.jsp'">취소</button>
        </div>
    </form>
    
</body>
</html>
