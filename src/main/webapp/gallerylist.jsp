<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
String loggedInUsername = (String) session.getAttribute("username");

int galleryPage = 1; // 기본적으로 첫 번째 페이지
int limit = 8; // 한 페이지에 보여줄 글 개수

if (request.getParameter("page") != null) {
    galleryPage = Integer.parseInt(request.getParameter("page"));
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom", "root", "1116");

    // 전체 글 개수 가져오기
    String countSql = "SELECT COUNT(*) FROM pictures";
    pstmt = conn.prepareStatement(countSql);
    rs = pstmt.executeQuery();
    rs.next();
    int totalCount = rs.getInt(1);

    int totalPage = (int) Math.ceil((double) totalCount / limit);
    int start = (galleryPage - 1) * limit;

    // 현재 페이지의 글 가져오기
    String sql = "SELECT * FROM pictures ORDER BY id DESC LIMIT ?, ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, start);
    pstmt.setInt(2, limit);
    rs = pstmt.executeQuery();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사진게시판</title>
    <link rel="stylesheet" href="gallery.css">
    <style>
        .gallery-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            margin: 20px auto;
            width: 90%;
        }
        .gallery-item {
            width: 22%;
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
            background-color: #f9f9f9;
            transition: box-shadow 0.3s;
        }
        .gallery-item:hover {
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }
        .gallery-item img {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
        }
        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a {
            margin: 0 5px;
            text-decoration: none;
            padding: 8px 16px;
            border: 1px solid #ddd;
            color: #333;
        }
        .pagination a.active {
            background-color: #333;
            color: #fff;
        }
        .pagination a:hover {
            background-color: #ddd;
        }
        .btn-register {
            display: block;
            width: 100px;
            margin: 20px auto;
            padding: 10px;
            background-color: #333;
            color: #fff;
            text-align: center;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-register:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">사진게시판</h2>
    <div class="gallery-container">
        <%
        while (rs.next()) {
        %>
            <div class="gallery-item">
                <a href="gallerypost.jsp?id=<%= rs.getInt("id") %>">
                    <img src="<%= rs.getString("image_path") %>" alt="<%= rs.getString("title") %>">
                    <p><%= rs.getString("title") %></p>
                </a>
            </div>
        <%
        }
        %>
    </div>

    <div class="pagination">
        <%
        if (galleryPage > 1) {
        %>
            <a href="gallerylist.jsp?page=<%= galleryPage - 1 %>">&laquo; 이전</a>
        <%
        }
        for (int i = 1; i <= totalPage; i++) {
        %>
            <a href="gallerylist.jsp?page=<%= i %>" <%= (i == galleryPage) ? "class='active'" : "" %>><%= i %></a>
        <%
        }
        if (galleryPage < totalPage) {
        %>
            <a href="gallerylist.jsp?page=<%= galleryPage + 1 %>">다음 &raquo;</a>
        <%
        }
        %>
    </div>

    <% if (loggedInUsername != null) { %>
        <button class="btn-register" onclick="location.href='gallerywrite.jsp'">글 작성</button>
    <% } %>
</body>
</html>
<%
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
