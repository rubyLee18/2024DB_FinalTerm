<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%
int id = Integer.parseInt(request.getParameter("id"));
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String title = "";
String content = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");

    // 글 정보 가져오기
    String sql = "SELECT * FROM reviews WHERE id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
    	 title = rs.getString("title");
         content = rs.getString("content");

    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>글 수정</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="header-container"></div>
    <h1>일반 게시판</h1>
    <form action="updateReview.jsp" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" value="<%= title %>" placeholder="제목 입력" required>
        </div>
        <div class="form-group">
            <label for="content">내용</label>
            <textarea id="content" name="content" placeholder="내용 입력" rows="10" required><%= content %></textarea>
        </div>
        <div class="button-group">
            <button type="submit">수정완료</button>
            <button type="button" onclick="location.href='reviewpost.jsp?id=<%= id %>'">취소</button>
        </div>
    </form>
    <script src="header.js"></script>
</body>
</html>