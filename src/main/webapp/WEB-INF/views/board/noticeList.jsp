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
	
	/* 네비게이션 글작성, 표, 검색 감싸는 영역 */
	#mainArea {
		display: flex;
	}
	
	/* 글작성, 표, 검색 감싸는 영역 */
	article {
		text-align: center;
		background-color : white;
  		width : 50%;
  		height: 650px;
  		border-radius : 50px;
  		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
  		overflow: hidden;
  		margin: 80px 0 0 80px;
	}
	
	/* 표 */
	#list {
		border-collapse: collapse;
		width : 800px;
		height : 550px;
		margin :90px auto;
	}
	#list td {
		vertical-align: middle;
	}
	#list td:nth-of-type(1) { width: 70px; }
	#list td:nth-of-type(2) { width: 300px; }
	#list td:nth-of-type(3) { width: 120px; }
	#list td:nth-of-type(4) { width: 100px; }
	thead tr {
		font-size: 20px;
		font-weight: 900;
		height: 60px;
	}
	tfoot td {
		height: 80px;
		vertical-align: bottom;
	}
	
	/* 검색 */
	#searchForm {
		float: right;
		margin-top: 35px;
		margin-right: 80px;
	}
	#btnSearch {
		background-color: #2C3E50; 
 		padding: 13px;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		color: #F5F6F7;
		border: none;
		border-radius : 15px;	
	}
	#btnSearch:hover {
		background-color: #2C3E50; opacity: 0.65;
	}
	#btnSearchAll {
		background-color: #2C3E50; 
 		padding: 13px;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		color: #F5F6F7;
		border: none;
		border-radius : 15px;
	}
	#btnSearchAll:hover {
		background-color: #2C3E50; opacity: 0.65;
	}
	
	/* 표 아래 페이징 링크 */
	.unlink, .link {
		display: inline-block; 
		padding: 10px;
		margin: 5px;
		border: 1px solid white;
		text-align: center;
		text-decoration: none; 
		color: gray;
		font-size: 20px;
	}
	.link:hover {
		color: #63B47B;
	}
	.nowUnlinkPage{
	    color: black;
	}
	
	/* 왼쪽 네비게이션 */
	.myPageNav {
		display: flex;
		flex-direction: column;
		list-style-type: none;
  		font-size: 20px;
	}
	.navItem {
		background-color: white; 
		padding: 15px;
		cursor: pointer;
		border-left: 2px solid  rgba(44, 62, 80, 0.65); 
        border-right: 2px solid  rgba(44, 62, 80, 0.65);
	}
    .myPageNav .navItem:first-of-type { 
         border-radius : 10px 10px 0 0; 
         border-top: 2px solid  rgba(44, 62, 80, 0.65); 
    }
    .myPageNav .navItem:last-of-type { 
         border-radius : 0 0 10px 10px; 
         border-bottom: 2px solid  rgba(44, 62, 80, 0.65); 
    }
	.navItem a {
		text-decoration: none;
		color: #464646;
	}
	.nowPage {
		background-color: #2C3E50;
		opacity: 0.65;
		color: #F5F6F7;
	}
	.navItem:hover {
		background-color: #2C3E50;
		opacity: 1;
	}
	.navItem:hover > a {
		color: #F5F6F7;
	}
	#listNav {
		text-align: center;
		display: flex;
		margin-top: 280px;
		margin-left: 300px;
	}
	
	/* 글 작성 버튼 */
	#btnAdd {
		background-color: #2C3E50; 
 		padding: 15px;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		color: #F5F6F7;
		border: none;
		border-radius : 15px;
		float: left;
		margin-top: 35px;
		margin-left: 70px;
	}
	#btnAdd:hover {
		background-color: #2C3E50;
		opacity: 0.65;
	}

</style>
</head>
<body>
	
	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<div id="mainArea">
		<nav id="listNav">
			<ul class="myPageNav">
				<li class="navItem nowPage">공지사항</li>
				<li class="navItem"><a href="${contextPath}/board/questionList">QnA</a></li>
				<li class="navItem"><a href="${contextPath}/board/reviewList">리뷰</a></li>
			</ul>	
		</nav>
		
		<article>
			
			<c:if test="${loginMember.memberId eq 'admin'}">
				<input type="button" value="글 작성" id="btnAdd" onclick="location.href='${contextPath}/board/noticeAddPage'">
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

			
</body>
</html>