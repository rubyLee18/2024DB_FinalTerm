<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
String loggedInUsername = (String) session.getAttribute("username");
String author = "";
String nickname = ""; // nickname을 저장하기 위한 변수
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom", "root", "1116");

    // 조회수 증가
    String updateSql = "UPDATE pictures SET views = views + 1 WHERE id = ?";
    pstmt = conn.prepareStatement(updateSql);
    pstmt.setInt(1, id);
    pstmt.executeUpdate();

    // 글 정보 가져오기 (nickname 포함)
    String sql = "SELECT p.*, u.nickname FROM pictures p JOIN users u ON p.author = u.username WHERE p.id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        author = rs.getString("author");
        nickname = rs.getString("nickname"); // nickname 가져오기
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사진게시판</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .post-container {
            display: flex;
            gap: 20px;
            margin: 30px auto;
            max-width: 1000px;
            justify-content: center;
        }
        .post-container img {
            max-width: 300px;
            width: 100%;
            height: auto;
            object-fit: cover;
        }
        .post-content {
            max-width: 450px; /* 기존보다 1.5배 더 길게 설정 */
            width: 100%;
            height: auto;
            border: 1px solid #ddd;
            padding: 10px;
            box-sizing: border-box;
        }
        .button-group {
            margin-top: 30px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div id="header-container"></div>
    <h1>사진게시판</h1>
    <h2><%= rs.getString("title") %></h2>
    <p>번호: <%= rs.getInt("id") %> | 작성일: <%= rs.getTimestamp("created_at") %> | 작성자: <%= nickname %> | 조회수: <%= rs.getInt("views") %></p> <!-- nickname 사용 -->

    <div class="post-container">
        <%
        String imagePath = rs.getString("image_path");
        if (imagePath != null && !imagePath.isEmpty()) {
        %>
            <img src="<%= imagePath %>" alt="이미지">
        <%
        }
        %>
        <div class="post-content">
            <p><%= rs.getString("content") %></p>
        </div>
    </div>

    <div class="button-group">
        <button onclick="location.href='gallerylist.jsp'">목록</button>
        <% if (loggedInUsername != null && (loggedInUsername.equals(author) || "admin".equals(loggedInUsername))) { %>
            <button onclick="location.href='galleryedit.jsp?id=<%= rs.getInt("id") %>'">수정</button>
            <button onclick="location.href='deleteGallery.jsp?id=<%= rs.getInt("id") %>'">삭제</button>
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
