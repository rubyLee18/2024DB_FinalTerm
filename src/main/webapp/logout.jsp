<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%
    // 세션 무효화
    session.invalidate();

    // 로그아웃 후 메인 페이지로 리디렉션
    response.sendRedirect("mainpage.jsp");
%>
