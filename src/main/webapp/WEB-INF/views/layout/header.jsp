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

	<!-- 로그인 이전에 보여줄 링크 -->
	<c:if test="${loginMember eq null}">
		<a href="${contextPath}/member/loginPage">로그인페이지</a>
		<a href="${contextPath}/member/agreePage">회원가입페이지</a>
	</c:if>
	
	<!-- 로그인 이후에 보여줄 링크 -->
	<c:if test="${loginMember ne null}">
		${loginMember.name}님 반갑습니다.&nbsp;&nbsp;&nbsp;
		<a href="${contextPath}/member/logout">로그아웃</a>
		<a href="${contextPath}/member/signOut?memberNo=${loginMember.memberNo}">회원탈퇴하기</a>
	</c:if>
	
	<hr>
	

</body>
</html>