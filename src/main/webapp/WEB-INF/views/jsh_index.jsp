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
	
	
		<a href="${contextPath}/board/noticeSearchPage">공지사항</a>
		<a href="${contextPath}/board/qnaSearchPage">QnA</a>
		<a href="${contextPath}/board/reviewSearchPage">리뷰</a>

	
</body>
</html>