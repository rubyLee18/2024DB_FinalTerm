<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
    
<%
    response.setContentType("application/json; charset=UTF-8");

    // 세션에서 로그인 상태 확인
    String loggedInUser = (String) session.getAttribute("username");

    if (loggedInUser != null) {
        out.print("{ \"loggedIn\": true, \"username\": \"" + loggedInUser + "\" }");
    } else {
        out.print("{ \"loggedIn\": false }");
    }
%>