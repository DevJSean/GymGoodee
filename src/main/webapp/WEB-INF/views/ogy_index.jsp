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
	
	
	<h1>오가연</h1>
	
	<c:if test="${user == null}">
		<form action="${contextPath}/user/login" method="post">
			<input type="text" name="id" placeholder="ID"><br>
			<input type="password" name="pw" placeholder="password"><br>
			<button>로그인</button>
		</form>
	</c:if>
	
	<c:if test="${user != null}">
		${user.name}님 반갑습니다<br><br>
	</c:if>
	
	<hr>
	
	<nav>
		<ul class="indexNav">
			<li><a href="">센터소개</a></li>
			<li><a href="">운동소개</a></li>
			<li><a href="">게시판</a></li>
			<li><a href="${contextPath}/mypage/myReserveList?memberNo=101">마이페이지</a></li>
		</ul>
	</nav>
	
</body>
</html>