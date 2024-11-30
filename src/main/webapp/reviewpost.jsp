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
String userId = (String) session.getAttribute("user_id");
String reviewAuthorUsername = "";
String reviewAuthorNickname = "";
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");
    
    // 조회수 증가
    String updateSql = "UPDATE reviews SET views = views + 1 WHERE id = ?";
    pstmt = conn.prepareStatement(updateSql);
    pstmt.setInt(1, id);
    pstmt.executeUpdate();
    pstmt.close();  // pstmt를 재사용하기 전에 명시적으로 닫아줍니다.

    // 글 정보 가져오기
    String sql = "SELECT r.*, u.nickname FROM reviews r JOIN users u ON r.author = u.username WHERE r.id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, id);
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
        reviewAuthorUsername = rs.getString("author");
        reviewAuthorNickname = rs.getString("nickname");

        // 좋아요 개수 가져오기
        String likeCountSql = "SELECT COUNT(*) AS like_count FROM review_likes WHERE review_id = ?";
        pstmt = conn.prepareStatement(likeCountSql);
        pstmt.setInt(1, id);
        ResultSet likeRs = pstmt.executeQuery();
        int likeCount = 0;
        if (likeRs.next()) {
            likeCount = likeRs.getInt("like_count");
        }
        pstmt.close(); // pstmt 닫기
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>일반 게시판</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .comment-container {
            width: 66%;
            margin: 10px auto;
            padding: 5px 15px;
            background-color: #f0f0f0;
            border-radius: 10px;
            position: relative;
            text-align: left;
        }
        .comment-author {
            font-weight: bold;
            margin-bottom: 5px;
            margin-top: 0;
        }
        .button-delete {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background-color: #f44336;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;
        }
        .button-delete:hover {
            background-color: #d32f2f;
        }
        .comment-form {
            width: 66%;
            margin: 20px auto;
        }
        .comment-form textarea {
            width: 100%;
        }
        .comment-form input[type="submit"] {
            margin-top: 5px;
        }
        .comment-form input[type="submit"] {
            padding: 5px 10px;
            font-size: 0.9em;
            margin-top: 10px;
        }
        .button-group {
            margin-top: 30px;
            text-align: center;
        }
        .like-section {
            display: inline-block;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div id="header-container"></div>
    <h1>일반 게시판</h1>
    <h2><%= rs.getString("title") %></h2>
    <p>번호: <%= rs.getInt("id") %> | 작성일: <%= rs.getTimestamp("created_at") %> | 작성자: <%= reviewAuthorNickname %> | 조회수: <%= rs.getInt("views") %></p>
    <div class="content">
        <p><%= rs.getString("content") %></p>
    </div>

    <div class="button-group">
        <div class="like-section">
            <form action="toggleReviewLike.jsp" method="post" style="display: inline;">
                <input type="hidden" name="review_id" value="<%= id %>">
                <button type="submit" style="background-color: white; border: 2px solid black; border-radius: 50%; padding: 20px; cursor: pointer; font-size: 1.5em;">
                    👍 <span style="color: black;">(<%= likeCount %>)</span>
                </button>
            </form>
        </div>
        <button onclick="location.href='reviewlist.jsp'">목록</button>
        <% if ((loggedInUsername != null && loggedInUsername.equals(reviewAuthorUsername)) || "admin".equals(loggedInUsername)) { %>
            <button onclick="location.href='reviewedit.jsp?id=<%= rs.getInt("id") %>'">수정</button>
            <button onclick="location.href='deleteReview.jsp?id=<%= rs.getInt("id") %>'">삭제</button>
        <% } %>
    </div>

    <!-- 댓글 목록 표시 -->
    <%
       pstmt.close(); // pstmt 닫기
       
       // 댓글 목록 사용
       String commentSql = "SELECT content, created_at, author FROM comments WHERE review_id = ?";
       pstmt = conn.prepareStatement(commentSql);
       pstmt.setInt(1, id);
       rs = pstmt.executeQuery();

       while (rs.next()) {
           String content = rs.getString("content");
           String createdAt = rs.getString("created_at");
           String author = rs.getString("author");
    %>
           <div class="comment-container">
               <p class="comment-author"><%= author %> (<%= createdAt %>)</p>
               <p style="margin-top: 0;"><%= content %></p>
               <% if (loggedInUsername != null && loggedInUsername.equals(author)) { %>
                   <form action="deleteComment.jsp" method="post" style="display: inline;">
                       <input type="hidden" name="review_id" value="<%= id %>">
                       <input type="hidden" name="created_at" value="<%= createdAt %>">
                       <input type="submit" value="댓글 삭제" class="button-delete">
                   </form>
               <% } %>
           </div>
    <%
       }
    %>

    <!-- 추가된 내용: 댓글 폼 (로그인된 사용자만 접근 가능) -->
    <h3>댓글</h3>
    <% if (loggedInUsername != null) { %>
        <div class="comment-form">
            <form action="saveComment.jsp" method="post">
                <input type="hidden" name="review_id" value="<%= id %>">
                <textarea name="content" rows="4" placeholder="댓글을 입력하세요"></textarea><br>
                <input type="submit" value="댓글 달기">
            </form>
        </div>
    <% } else { %>
        <p>댓글을 작성하려면 <a href="login.jsp">로그인</a>해 주세요.</p>
    <% } %>
</body>
</html>
<%
    } else {
        out.println("<script>alert('존재하지 않는 게시물입니다.'); history.back();</script>");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('오류가 발생했습니다. 다시 시도해 주세요.'); history.back();</script>");
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
