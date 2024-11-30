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

int noticePage = 1; // 기본적으로 첫 번째 페이지
int limit = 7; // 한 페이지에 보여줄 글 개수

if (request.getParameter("page") != null) {
    noticePage = Integer.parseInt(request.getParameter("page"));
}

if (loggedInUsername == null) {
    response.sendRedirect("login.html");
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");

    // 전체 글 개수 가져오기
    String countSql = "SELECT COUNT(*) FROM notices";
    pstmt = conn.prepareStatement(countSql);
    rs = pstmt.executeQuery();
    rs.next();
    int totalCount = rs.getInt(1);

    int totalPage = (int) Math.ceil((double) totalCount / limit);
    int start = (noticePage - 1) * limit;

    // 현재 페이지의 글 가져오기
    String sql = "SELECT * FROM notices ORDER BY id DESC LIMIT ?, ?";
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
    <title>공지사항</title>
    <link rel="stylesheet" href="mainpage.css">
    <style>
        table {
            width: 80%;
            margin: 0 auto;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f4f4f4;
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
    <h2 style="text-align: center;">공지사항</h2>
    <table>
        <thead>
            <tr>
                <th>글 번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
        <%
			int rowNumber = totalCount - (noticePage - 1) * limit;
		%>
        <%
        	while (rs.next()) {
        %>
            <tr>
                <td><%= rowNumber-- %></td>
                <td><a href="noticepost.jsp?id=<%= rs.getInt("id") %>"><%= rs.getString("title") %></a></td>
                <td><%= rs.getString("author") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
            </tr>
        <%
        }
        %>
        </tbody>
    </table>

    <div class="pagination">
        <%
        if (noticePage > 1) {
        %>
            <a href="noticelist.jsp?page=<%= noticePage - 1 %>">&laquo; 이전</a>
        <%
        }
        for (int i = 1; i <= totalPage; i++) {
        %>
            <a href="noticelist.jsp?page=<%= i %>" <%= (i == noticePage) ? "class='active'" : "" %>><%= i %></a>
        <%
        }
        if (noticePage < totalPage) {
        %>
            <a href="noticelist.jsp?page=<%= noticePage + 1 %>">다음 &raquo;</a>
        <%
        }
        %>
    </div>
<!--   <button class="btn-register" onclick="location.href='noticewrite.jsp'">글 작성</button> -->
  
	<% if (loggedInUsername != null && "admin".equals(loggedInUsername)) { %>
	    <button class="btn-register" onclick="location.href='noticewrite.jsp'">공지 작성</button>
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
