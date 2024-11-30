<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
String loggedInUsername = (String) session.getAttribute("username");

if (loggedInUsername == null) {
    response.sendRedirect("login.html");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");

    // 삭제하려는 글의 작성자 확인
    String authorSql = "SELECT author FROM reviews WHERE id = ?";
    pstmt = conn.prepareStatement(authorSql);
    pstmt.setInt(1, id);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        String author = rs.getString("author");
        // 로그인한 사용자가 글 작성자이거나 관리자인 경우만 삭제 가능
        if (loggedInUsername.equals(author) || "admin".equals(loggedInUsername)) {
            // 글 삭제 쿼리
            String deleteSql = "DELETE FROM reviews WHERE id = ?";
            pstmt = conn.prepareStatement(deleteSql);
            pstmt.setInt(1, id);
            int result = pstmt.executeUpdate();

            if (result > 0) {
                response.sendRedirect("reviewlist.jsp");
            } else {
                out.println("<script>alert('글 삭제에 실패했습니다.'); history.back();</script>");
            }
        } else {
            out.println("<script>alert('삭제 권한이 없습니다.'); history.back();</script>");
        }
    } else {
        out.println("<script>alert('존재하지 않는 게시물입니다.'); history.back();</script>");
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
