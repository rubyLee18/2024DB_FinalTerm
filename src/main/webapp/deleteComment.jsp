<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%
    String reviewId = request.getParameter("review_id");
    String createdAt = request.getParameter("created_at");
    String loggedInUsername = (String) session.getAttribute("username");

    if (loggedInUsername == null) {
        out.println("<script>alert('로그인이 필요합니다. 로그인 후 다시 시도해 주세요.'); history.back();</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");

        String sql = "DELETE FROM comments WHERE review_id = ? AND created_at = ? AND author = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(reviewId));
        pstmt.setString(2, createdAt);
        pstmt.setString(3, loggedInUsername);
        int result = pstmt.executeUpdate();

        if (result > 0) {
            out.println("<script>alert('댓글이 삭제되었습니다.'); location.href='reviewpost.jsp?id=" + reviewId + "';</script>");
        } else {
            out.println("<script>alert('댓글 삭제에 실패했습니다. 다시 시도해 주세요.'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 다시 시도해 주세요.'); history.back();</script>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
