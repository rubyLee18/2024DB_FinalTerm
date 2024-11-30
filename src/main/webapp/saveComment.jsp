<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%
    String reviewId = request.getParameter("review_id");
    String author = (String) session.getAttribute("username"); // 로그인한 사용자 username 가져오기
    //String loggedInNickname = (String) session.getAttribute("nickname");
    String content = request.getParameter("content");

    // 로그인되지 않은 경우 처리
    if (author == null) {
        out.println("<script>alert('로그인이 필요합니다. 로그인 후 댓글을 작성해주세요.'); history.back();</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom", "root", "1116");

        String sql = "INSERT INTO comments (review_id, author, content) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(reviewId));
        pstmt.setString(2, author);
        pstmt.setString(3, content);
        pstmt.executeUpdate();

        response.sendRedirect("reviewpost.jsp?id=" + reviewId);
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert('데이터베이스 오류가 발생했습니다. 관리자에게 문의하세요.'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 다시 시도해 주세요.'); history.back();</script>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
