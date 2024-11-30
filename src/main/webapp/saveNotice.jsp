<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<% 
String title = request.getParameter("title");
String content = request.getParameter("content");
String author = (String) session.getAttribute("nickname"); // 로그인한 사용자 닉네임

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");
    
    String sql = "INSERT INTO notices (title, content, author) VALUES (?, ?, ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, title);
    pstmt.setString(2, content);
    pstmt.setString(3, author);
    
    int result = pstmt.executeUpdate();
    
    if (result > 0) {
        response.sendRedirect("noticelist.jsp"); // 글 작성 후 리스트 페이지로 이동
    } else {
        out.println("글 저장에 실패했습니다.");
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
