<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%
int id = Integer.parseInt(request.getParameter("id"));
String loggedInUsername = (String) session.getAttribute("username");
String author = "";
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String title = "";
String content = "";
String image_path = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom", "root", "1116");

    String sql = "SELECT * FROM pictures WHERE id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, id);
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
        author = rs.getString("author");
        if (!"admin".equals(loggedInUsername) && !loggedInUsername.equals(author)) {
            out.println("<script>alert('접근 권한이 없습니다.'); location.href='gallerylist.jsp';</script>");
            return;
        }

        title = rs.getString("title");
        content = rs.getString("content");
        image_path = rs.getString("image_path");
    } else {
        out.println("<script>alert('존재하지 않는 게시물입니다.'); history.back();</script>");
        return;
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
    <title>사진 게시글 수정</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h2 style="text-align: center;">사진게시판</h2>
    <form action="updateGallery.jsp" method="post" enctype="multipart/form-data" style="width: 60%; margin: 0 auto;">
        <input type="hidden" name="id" value="<%= id %>">
        <div>
            <label for="title">제목</label>
            <input type="text" name="title" id="title" value="<%= title %>" required style="width: 100%; padding: 10px; margin-bottom: 10px;">
        </div>
        <div>
            <label for="content">내용</label>
            <textarea name="content" id="content" rows="10" required style="width: 100%; padding: 10px; margin-bottom: 10px;"><%= content %></textarea>
        </div>
        <div>
            <label for="photo">사진 첨부:</label>
            <input type="file" name="photo" id="photo" accept="image/*">
            <% if (image_path != null && !image_path.isEmpty()) { %>
                <p>현재 첨부된 사진: <img src="<%= image_path %>" alt="첨부된 사진" style="max-width: 200px; margin-top: 10px;"></p>
            <% } %>
        </div>
        <div style="text-align: center; margin-top: 20px;">
            <button type="submit">수정 완료</button>
            <button type="button" onclick="location.href='gallerylist.jsp'">취소</button>
            
        </div>
    </form>
</body>
</html>
