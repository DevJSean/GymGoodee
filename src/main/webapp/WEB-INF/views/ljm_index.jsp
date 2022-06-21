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
	
	
</body>
</html>