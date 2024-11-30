<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커뮤니티 사이트</title>
    <link rel="stylesheet" href="mainpage.css">
</head>
<body>
    <div class="container">
    	<div class="recommendation">
            <div class="welcome-box">
            <img src="welcome.jpg" alt="Welcome Image" class="welcome-image">
            <div class="welcome-text">환영합니다!</div>
        </div>
        </div>
        <a href="noticelist.jsp" class="box notice">공지사항</a>
        <a href="reviewlist.jsp" class="box review">일반게시판</a>
        
        <a href="gallerylist.jsp" class="box gallery">사진게시판</a>
    </div>

   
</body>
</html>
