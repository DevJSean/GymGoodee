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

	<h1>리뷰 목록</h1>
	<a href="${contextPath}/jsh">메인으로 돌아가기</a>
	<a href="${contextPath}/board/noticeList">공지사항</a>
	<a href="${contextPath}/board/questionList">QnA</a>
	<a href="${contextPath}/board/reviewList">리뷰</a>
	<br><br>
	<a href="${contextPath}/board/reviewAddPage">글 작성</a>

	<table>
	
	</table>
</body>
</html>