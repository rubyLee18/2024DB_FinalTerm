<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%
    String loggedInUsername = (String) session.getAttribute("username");

    if (loggedInUsername == null) {
        response.sendRedirect("login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사진게시판 글 작성</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="header-container"></div>
    <h2 style="text-align: center;">사진게시판</h2>
    <form action="saveGallery.jsp" method="post" enctype="multipart/form-data">
        <table style="margin: 0 auto;">
            <tr>
                <td>제목</td>
                <td><input type="text" name="title" required></td>
            </tr>
            <tr>
                <td>내용</td>
                <td><textarea name="content" required></textarea></td>
            </tr>
            <tr>
                <td>사진 첨부</td>
                <td><input type="file" name="photo" accept="image/*"></td>
            </tr>
        </table>
        <div style="text-align: center; margin-top: 20px;">
            <button type="submit" class="btn-submit">등록</button>
            <button type="button" class="btn-cancel" onclick="location.href='gallerylist.jsp'">취소</button>
        </div>
    </form>
</body>
</html>
