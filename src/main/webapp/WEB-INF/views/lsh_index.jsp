<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>

	

</script>
</head>
<body>
	
	
	<h1>이상호</h1>
	
	<!-- 로그인 이전에 보여줄 링크 -->
	<c:if test="${loginMember eq null}">
		<a href="${contextPath}/member/loginPage">로그인</a>
	</c:if>
	
	
	<!-- 로그인 이후에 보여줄 링크 -->
	<c:if test="${loginMember ne null}">
		${loginMember.memberName} 님 반갑습니다. &nbsp;&nbsp;&nbsp;
		<a href="${contextPath}/member/logout">로그아웃</a>
		<a href="${contextPath}/member/signOut?memberNo=${loginMember.memberNo}">회원탈퇴하기</a>
	</c:if>	
	
</body>
</html>