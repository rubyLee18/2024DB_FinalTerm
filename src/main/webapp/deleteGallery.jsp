<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
int id = Integer.parseInt(request.getParameter("id"));
String loggedInUsername = (String) session.getAttribute("username");

Connection conn = null;
PreparedStatement pstmt = null;

try {
    // 데이터베이스 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");

    // 작성자 확인
    String authorSql = "SELECT author FROM pictures WHERE id = ?";
    pstmt = conn.prepareStatement(authorSql);
    pstmt.setInt(1, id);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        String author = rs.getString("author");
        if (!"admin".equals(loggedInUsername) && !loggedInUsername.equals(author)) {
            out.println("<script>alert('삭제 권한이 없습니다.'); location.href='gallerylist.jsp';</script>");
            return;
        }
    } else {
        out.println("<script>alert('존재하지 않는 게시물입니다.'); location.href='gallerylist.jsp';</script>");
        return;
    }
    
    // 게시물 삭제
    String deleteSql = "DELETE FROM pictures WHERE id = ?";
    pstmt = conn.prepareStatement(deleteSql);
    pstmt.setInt(1, id);
    int result = pstmt.executeUpdate();

    if (result > 0) {
        // 글 번호 재정렬
        String updateSql = "UPDATE pictures SET id = id - 1 WHERE id > ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setInt(1, id);
        pstmt.executeUpdate();

        // AUTO_INCREMENT 값 수정
        String resetAutoIncrementSql = "ALTER TABLE pictures AUTO_INCREMENT = ?";
        pstmt = conn.prepareStatement(resetAutoIncrementSql);
        pstmt.setInt(1, id);
        pstmt.executeUpdate();

        response.sendRedirect("gallerylist.jsp");
    } else {
        out.println("글 삭제에 실패했습니다.");
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
