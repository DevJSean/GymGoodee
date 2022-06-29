<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="./resources/js/jquery-3.6.0.js"></script>
</head>
<body>
	
	<h1>index</h1>
	
	<jsp:include page="./layout/header.jsp"></jsp:include>
	
	<a href="${contextPath}/ljm">이정민 구현</a>
	<a href="${contextPath}/phg">박현규 구현</a>
	<a href="${contextPath}/lsh">이상호 구현</a>
	<a href="${contextPath}/ogy">오가연 구현</a>
	
</body>
</html>