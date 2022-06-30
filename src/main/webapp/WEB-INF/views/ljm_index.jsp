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
	
	
	<h1>이정민</h1>
	
	<a href="${contextPath}/admin/addTeacherPage">강사 추가하기</a><br>
	<a href="${contextPath}/admin/addClassPage">강좌 개설하기</a>
	
	<hr>
	
	<a href="${contextPath}/reserve/swimPage">수영 예약페이지</a><br>
	<a href="${contextPath}/reserve/pilatesPage">필라테스 예약페이지</a><br>
	<a href="${contextPath}/reserve/spinningPage">스피닝 예약페이지</a><br>
	<a href="${contextPath}/reserve/dancePage">스포츠댄스 예약페이지</a><br>
	
	
	
</body>
</html>