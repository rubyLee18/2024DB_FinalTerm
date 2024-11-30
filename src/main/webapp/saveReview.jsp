<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<% 
    // 폼에서 전달된 데이터 가져오기
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String author = (String) session.getAttribute("username"); // 로그인한 사용자 username

    // 데이터베이스 연결을 위한 객체 선언
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // MySQL JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        // 데이터베이스 연결
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");
        
        // 데이터베이스에 리뷰 데이터 삽입
        String sql = "INSERT INTO reviews (title, content, author, created_at, views) VALUES (?, ?, ?, NOW(), 0)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, author);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // 성공 시 리뷰 목록 페이지로 리다이렉트
            response.sendRedirect("reviewlist.jsp");
        } else {
            // 삽입 실패 시 경고 메시지 출력
            out.println("<script>alert('글 저장에 실패했습니다.'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 다시 시도해 주세요.'); history.back();</script>");
    } finally {
        // 자원 해제
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
