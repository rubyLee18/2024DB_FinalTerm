<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>

<%
    String username = (String) session.getAttribute("username");

    if (username != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 데이터베이스 연결 설정
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom", "root", "1116");

            // 사용자 정보를 DB에서 삭제
            String sql = "DELETE FROM users WHERE username = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                System.out.println("회원탈퇴 성공: " + username);
            } else {
                System.out.println("회원탈퇴 실패: " + username + "을 찾을 수 없음");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }

    // 세션 무효화
    session.invalidate();

    // 회원탈퇴 후 메인 페이지로 리디렉션
    response.sendRedirect("mainpage.jsp");
%>
