<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%
    String reviewId = request.getParameter("review_id");
    String loggedInUsername = (String) session.getAttribute("username");

    if (loggedInUsername == null) {
        out.println("<script>alert('로그인이 필요합니다. 로그인 후 다시 시도해 주세요.'); history.back();</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom", "root", "1116");

        // 좋아요 여부 확인
        String checkSql = "SELECT * FROM review_likes WHERE review_id = ? AND username = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, Integer.parseInt(reviewId));
        pstmt.setString(2, loggedInUsername);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 이미 좋아요를 눌렀다면 좋아요 취소
            String deleteSql = "DELETE FROM review_likes WHERE review_id = ? AND username = ?";
            pstmt = conn.prepareStatement(deleteSql);
            pstmt.setInt(1, Integer.parseInt(reviewId));
            pstmt.setString(2, loggedInUsername);
            pstmt.executeUpdate();
        } else {
            // 좋아요 추가
            String insertSql = "INSERT INTO review_likes (review_id, username) VALUES (?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt(1, Integer.parseInt(reviewId));
            pstmt.setString(2, loggedInUsername);
            pstmt.executeUpdate();
        }

        // 리뷰 페이지로 리다이렉트
        response.sendRedirect("reviewpost.jsp?id=" + reviewId);

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 다시 시도해 주세요.'); history.back();</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
