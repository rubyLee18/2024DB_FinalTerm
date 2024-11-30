<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%
//관리자 권한 확인
String username = (String) session.getAttribute("username");
if (username == null || !username.equals("admin")) {
    out.println("<script>alert('접근 권한이 없습니다.'); location.href='noticelist.jsp';</script>");
    return;
}

int id = Integer.parseInt(request.getParameter("id"));
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");

    // 글 정보 가져오기
    String sql = "SELECT * FROM notices WHERE id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 수정</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="header-container"></div>
    <h1>공지사항 수정</h1>
    <form action="updateNotice.jsp" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" value="<%= rs.getString("title") %>" required>
        </div>
        <div class="form-group">
            <label for="content">내용</label>
            <textarea id="content" name="content" rows="10" required><%= rs.getString("content") %></textarea>
        </div>
        <div class="button-group">
            <button type="submit">수정완료</button>
            <button type="button" onclick="location.href='noticepost.jsp?id=<%= id %>'">취소</button>
        </div>
    </form>
    <script src="header.js"></script>
</body>
</html>
<%
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
