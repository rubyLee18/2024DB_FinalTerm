<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>

<%
	request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String nickname = request.getParameter("nickname");
    String gender = request.getParameter("gender");
    
    // 디버깅 메시지 추가 - 폼 데이터가 잘 넘어오는지 확인
    /* out.println("Received Username: " + username);
    out.println("Received Password: " + password);
    out.println("Received Name: " + name);
    out.println("Received Nickname: " + nickname);
    out.println("Received Gender: " + gender); */

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        //conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom", "root", "1116");
        String url = "jdbc:mysql://localhost:3306/bookcom?serverTimezone=UTC";
        conn = DriverManager.getConnection(url, "root", "1116");

        
        /* Class.forName("com.mysql.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/bookcom?serverTimezone=UTC";
        conn = DriverManager.getConnection(url, "root", "1116");
 */
 		
 		conn.setAutoCommit(false);
 
        String sql = "INSERT INTO users (username, password, name, nickname, gender) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, password);
        pstmt.setString(3, name);
        pstmt.setString(4, nickname);
        pstmt.setString(5, gender);
        //pstmt.executeUpdate();

        
		int result = pstmt.executeUpdate();
		conn.commit();

        if (result > 0) {
            out.println("<script>alert('회원가입이 완료되었습니다.'); location.href='login.html';</script>");
           // response.sendRedirect("login.html");
        } else {
            out.println("<script>alert('회원가입에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
        }
    } catch (Exception e) {
    	out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
