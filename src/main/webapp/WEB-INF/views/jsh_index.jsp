<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	
	<input type="button" value="공지사항" onclick="location.href='${contextPath}/board/noticeList'">
	<input type="button" value="QnA" onclick="location.href='${contextPath}/board/questionList'">
	<input type="button" value="리뷰" onclick="location.href='${contextPath}/board/reviewList'">

	
</body>
</html>