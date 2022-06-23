<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.indexNav {
		display: flex;
		flex-direction: row;
		width: 100%;
		list-style-type: none;
	}
	.indexItem {
		background-color: teal; 
		padding: 15px;
		cursor: pointer;
	}
	.indexItem a {
		text-align: center;
		text-decoration: none;
		color: white;
	}
	.indexItem:hover {
		background-color: navy;
	}
</style>
</head>
<body>

	<!-- 로그인 이전에 보여줄 링크 -->
	<c:if test="${loginMember eq null}">
		<a href="${contextPath}/member/loginPage">로그인</a>
		<a href="${contextPath}/member/agreePage">회원가입</a>
	</c:if>
	
	<!-- 로그인 이후에 보여줄 링크 -->
	<c:if test="${loginMember ne null}">
		${loginMember.name}님 반갑습니다.&nbsp;&nbsp;&nbsp;
		<a href="${contextPath}/member/logout">로그아웃</a>
	</c:if>
	
	<hr>
	
	<nav>
		<ul class="indexNav">
			<li class="indexItem"><a href="">센터소개</a></li>
			<li class="indexItem"><a href="">운동소개</a></li>
			<li class="indexItem"><a href="">게시판</a></li>
			<li class="indexItem"><a href="${contextPath}/mypage/myReserveList?memberNo=101">마이페이지</a></li>
		</ul>
	</nav>
	

</body>
</html>