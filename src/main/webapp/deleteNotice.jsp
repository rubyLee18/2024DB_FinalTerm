<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");

    String sql = "DELETE FROM notices WHERE id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, id);
    int result = pstmt.executeUpdate();

    if (result > 0) {
    	 // 글 번호 재정렬
    	String updateSql = "UPDATE notices SET id = id - 1 WHERE id > ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setInt(1, id);
        pstmt.executeUpdate();
        
     	// AUTO_INCREMENT 값 수정
        String resetAutoIncrementSql = "ALTER TABLE notices AUTO_INCREMENT = ?";
        pstmt = conn.prepareStatement(resetAutoIncrementSql);
        pstmt.setInt(1, id);
        pstmt.executeUpdate();
        
        response.sendRedirect("noticelist.jsp");
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