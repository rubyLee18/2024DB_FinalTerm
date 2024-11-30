<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
String loggedInUsername = (String) session.getAttribute("username");
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String title = "";
String content = "";
String author = "";
String createdAt = "";
int viewCount = 0;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");
    
    // 조회수 증가
    String updateSql = "UPDATE notices SET views = views + 1 WHERE id = ?";
    pstmt = conn.prepareStatement(updateSql);
    pstmt.setInt(1, id);
    pstmt.executeUpdate();

    // 글 정보 가져오기
    String sql = "SELECT * FROM notices WHERE id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, id);
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
        title = rs.getString("title");
        content = rs.getString("content");
        author = rs.getString("author");
        createdAt = rs.getTimestamp("created_at").toString();
        viewCount = rs.getInt("views");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %></title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="header-container"></div>
    <h1><%= title %></h1>
    <p>번호: <%= id %> | 작성일: <%= createdAt %> | 작성자: <%= author %> | 조회수: <%= viewCount %></p>
    <div class="content">
        <p><%= content %></p>
    </div>
    <div class="button-group">
        <button onclick="location.href='noticelist.jsp'">목록</button>
        <% if ("admin".equals(loggedInUsername) || loggedInUsername.equals(author)) { %>
            <button onclick="location.href='noticeedit.jsp?id=<%= id %>'">수정</button>
            <button onclick="location.href='deleteNotice.jsp?id=<%= id %>'">삭제</button>
        <% } %>
    </div>
    
</body>
</html>
<%
    } else {
        out.println("<script>alert('존재하지 않는 게시물입니다.'); history.back();</script>");
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
