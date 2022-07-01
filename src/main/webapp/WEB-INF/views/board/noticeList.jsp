<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>공지사항</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
	* {
		box-sizing: border-box;
	}
	.unlink, .link {
		display: inline-block; 
		padding: 10px;
		margin: 5px;
		border: 1px solid white;
		text-align: center;
		text-decoration: none; 
		color: gray;
	}
	.link:hover {
		border: 1px solid orange;
		color: limegreen;
	}
	table {
		border-collapse: collapse;
	}
	#list td:nth-of-type(1) { width: 70px; }
	#list td:nth-of-type(2) { width: 300px; }
	#list td:nth-of-type(3) { width: 120px; }
	#list td:nth-of-type(4) { width: 100px; }
	#list td {
		padding: 5px;
		text-align: center;
	}
	tfoot td {
		border-left: 0;
		border-right: 0;
		border-bottom: 0;
		border-top: 0;
	}
	.myPageNav {
		display: flex;
		flex-direction: column;
		width: 150px;
		list-style-type: none;
	}
	.navItem {
		background-color: teal; 
		padding: 15px;
		cursor: pointer;
	}
	.navItem a {
		text-align: center;
		text-decoration: none;
		color: white;
	}
	.navItem:hover {
		background-color: navy;
	}
	nav {
		display: flex;
		margin-right: 30px;
		text-align: center;
	}
	section {
		display: flex;
	}
</style>
</head>
<body>
	
	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<section>
		<nav>
			<ul class="myPageNav">
				<li class="navItem nowPage">공지사항</li>
				<li class="navItem"><a href="${contextPath}/board/questionList">QnA</a></li>
				<li class="navItem"><a href="${contextPath}/board/reviewList">리뷰</a></li>
			</ul>	
		</nav>
		
		<br><br>
		<c:if test="${loginMember.memberId eq 'admin'}">
			<input type="button" value="글 작성" onclick="location.href='${contextPath}/board/noticeAddPage'">
		</c:if>
		  
		<table id="list">
			<thead>
				<tr>
					<td>글 번호</td>
					<td>제목</td>
					<td>작성일</td>
					<td>조회수</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${notices}" var="notice" varStatus="vs">
					<tr>
						<td>${beginNo - vs.index}</td>
						<td><a href="${contextPath}/board/noticeDetail?noticeNo=${notice.noticeNo}">${notice.noticeTitle}</a></td>
						<td>${notice.noticeCreated}</td>
						<td>${notice.noticeHit}</td>
					</tr>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="4">
						${paging}
					</td>
				</tr>
			</tfoot>
		</table>
	</section>
</body>
</html>