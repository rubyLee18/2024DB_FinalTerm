<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%
int id = Integer.parseInt(request.getParameter("id"));
String title = request.getParameter("title");
String content = request.getParameter("content");

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");

    String sql = "UPDATE notices SET title = ?, content = ? WHERE id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, title);
    pstmt.setString(2, content);
    pstmt.setInt(3, id);

    int result = pstmt.executeUpdate();

    if (result > 0) {
        response.sendRedirect("noticepost.jsp?id=" + id);
    } else {
        out.println("글 수정에 실패했습니다.");
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
