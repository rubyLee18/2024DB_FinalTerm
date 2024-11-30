<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, javax.servlet.*, javax.servlet.http.*, javax.servlet.annotation.*" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<%
String title = request.getParameter("title");
String content = request.getParameter("content");
String author = (String) session.getAttribute("username"); // 로그인한 사용자 닉네임
String imagePath = null;

if (author == null) {
    out.println("<script>alert('로그인 후 글을 작성할 수 있습니다.'); location.href='login.html';</script>");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;

try {
    // 파일 저장 경로 설정
    String uploadPath = application.getRealPath("/") + "uploads";
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        uploadDir.mkdir();
    }

    // 파일 업로드 처리
    DiskFileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);
    List<FileItem> formItems = upload.parseRequest(request);

    for (FileItem item : formItems) {
        if (item.isFormField()) {
            // 제목과 내용 추출
            if ("title".equals(item.getFieldName())) {
                title = item.getString("UTF-8");
            } else if ("content".equals(item.getFieldName())) {
                content = item.getString("UTF-8");
            }
        } else {
            // 파일 업로드 처리
            if (!item.getName().isEmpty()) {
                String fileName = new File(item.getName()).getName();
                String filePath = uploadPath + File.separator + fileName;
                File storeFile = new File(filePath);
                item.write(storeFile);
                imagePath = "uploads/" + fileName;
            }
        }
    }

    // 데이터베이스 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookcom?useUnicode=true&characterEncoding=utf8", "root", "1116");

    // 데이터베이스에 게시물 저장
    String sql = "INSERT INTO pictures (title, content, author, image_path, created_at) VALUES (?, ?, ?, ?, NOW())";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, title);
    pstmt.setString(2, content);
    pstmt.setString(3, author);
    pstmt.setString(4, imagePath);
    int result = pstmt.executeUpdate();

    if (result > 0) {
        response.sendRedirect("gallerylist.jsp");
    } else {
        out.println("<script>alert('글 작성에 실패했습니다.'); history.back();</script>");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('오류가 발생했습니다. 다시 시도해 주세요.'); history.back();</script>");
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
