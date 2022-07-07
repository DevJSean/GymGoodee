<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>QnA</title>
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
	#list td:nth-of-type(1) { width: 60px; }
	#list td:nth-of-type(2) { width: 260px; }
	#list td:nth-of-type(3) { width: 120px; }
	#list td:nth-of-type(4) { width: 100px; }
	#list td:nth-of-type(5) { width: 60px; }
	#list td:nth-of-type(6) { width: 100px; }
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
		color: #8AAAE5;
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
		margin-left: 65px;
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
				<li class="navItem"><a href="${contextPath}/board/noticeList">공지사항</a></li>
				<li class="navItem nowPage">QnA</li>
				<li class="navItem"><a href="${contextPath}/board/reviewList">리뷰</a></li>
			</ul>	
		</nav>
			
		<div id="wrapper">	
		
			<c:if test="${loginMember ne null && loginMember.memberId ne 'admin'}">
				<input type="button" value="글 작성" id="btnAdd" onclick="location.href='${contextPath}/board/questionAddPage'">
			</c:if>
			
			<table id="list">
				<thead>
					<tr>
						<td>글 번호</td>
						<td>제목</td>
						<td>작성자</td>
						<td>작성일</td>
						<td>조회수</td>
						<td>상태</td>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${questions}" var="question" varStatus="vs">
						<tr>
							<td>${beginNo - vs.index}</td>
							<td><a href="${contextPath}/board/questionDetail?questionNo=${question.questionNo}">${question.questionTitle}</a></td>
							<td>
								${fn:substring(question.memberId,0,3)}<c:forEach begin="4" end="${fn:length(question.memberId)}" step="1">*</c:forEach>
							</td>
							<td>${question.questionCreated}</td>
							<td>${question.questionHit}</td>
							<c:if test="${question.answerNo eq null}">
								<td>답변 대기</td>
							</c:if>
							<c:if test="${question.answerNo ne null}">
								<td>답변 완료</td>
							</c:if>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="6">
							${paging}
						</td>
					</tr>
				</tfoot>
			
</body>
</html>