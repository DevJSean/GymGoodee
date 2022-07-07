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

	section {
		display: flex;
	}
	
	#wrapper {
		background-color : white;
  		width : 65%;
  		margin: 50px auto;
  		border-radius : 50px;
  		padding: 30px;
		text-align: left;
  		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
  		overflow: hidden;
	}
	/* 표 */
	#list {
		border-collapse: collapse;
		width: 90%;		
		text-align : center;
		margin : 0 auto;
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
	table tbody tr{
		border-bottom : 1px solid lightgrey;
		line-height: 50px;
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
	}
	.navItem {
   	  text-align: center;
      background-color: white; 
      /* padding: 15px; */
      cursor: pointer;
      border-left: 2px solid  rgba(44, 62, 80, 0.65); 
	  border-right: 2px solid  rgba(44, 62, 80, 0.65);
	  width: 100px;
      height: 50px;
	  line-height: 50px;
   }
   .navItem a {
      text-decoration: none;
      color: rgb(70, 70, 70);
      display: inline-block;
      width: 100px;
      height: 50px;
   }
    .myPageNav .navItem:first-of-type { 
         border-radius : 10px 10px 0 0; 
         border-top: 2px solid  rgba(44, 62, 80, 0.65); 
    }
    .myPageNav .navItem:last-of-type { 
         border-radius : 0 0 10px 10px; 
         border-bottom: 2px solid  rgba(44, 62, 80, 0.65); 
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
	    display: flex;
		margin-right: 20px;
		margin-left: 80px;
		margin-top: 50px;
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
		margin-left: 95px;
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

	<section>
		
		<nav id="listNav">
			<ul class="myPageNav">
				<li class="navItem nowPage">공지사항</li>
				<li class="navItem"><a href="${contextPath}/board/questionList">QnA</a></li>
				<li class="navItem"><a href="${contextPath}/board/reviewList">리뷰</a></li>
			</ul>	
		</nav>
		
			
			
		<div id="wrapper">			
			
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