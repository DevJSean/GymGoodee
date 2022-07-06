<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>공지사항 상세보기</title>
<%
 String strReferer = request.getHeader("referer"); //이전 URL 가져오기
 
 if(strReferer == null){
%>
 <script type="text/javascript">
  	alert("url 입력을 통한 접근은 불가합니다.");
  	history.back();
 </script>
<%
  return;
 }
%>
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>

	$(function(){
		
		// 삭제
		$('#btnRemove').on('click', function(){
			if(confirm('삭제할까요?')){
				location.href='${contextPath}/board/noticeRemove?noticeNo=${notice.noticeNo}';
			}
		})
		// 수정 페이지
		$('#btnChangePage').on('click', function(){
			location.href='${contextPath}/board/noticeModifyPage?noticeNo=${notice.noticeNo}';
		})
		// 목록 페이지
		$('#btnListPage').on('click', function(){
			location.href='${contextPath}/board/noticeList';
		})
		
	})
	
</script>
<style>
	img {
		width: 500px;
	}
	* {
		box-sizing: border-box;
	}
	article {
		text-align: center;
		background-color : white;
		width: 50%;
  		border-radius : 50px;
  		position : absolute;
  		top : 200px;
  		left: 50%;
  		transform: translate(-50%, 0%);
  		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
  		padding: 0 0 30px 0; 
	}	
	.pageName {
		margin: 30px auto;
		font-size: 30px;
		font-weight: 900;
	}
	#divNo {
		margin: 30px auto 0 auto;
		width: 85%;
		text-align: left;
		font-size: 20px;
	}
	#divTitle, #divHit, #divCreated, #divModified {
		margin: 5px auto 0 auto;
		width: 85%;
		text-align: left;	
		font-size: 20px;	
	}
	#divContent {
		margin: 30px auto 0 auto;
	    width: 85%;
	    text-align: left;
	    font-size: 20px;	
	}
	#divContent > textarea {
		margin-top : 10px;	
		width: 97%;
		height: 400px;
		padding: 10px;
		border: solid 2px #2C3E50;
		border-radius: 30px;
		font-size: 16px;
		resize: none;
	}
	#btnRemove, #btnChangePage, #btnListPage {
		background-color: #2C3E50; 
 		padding: 10px;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		color: #F5F6F7;
		border: none;
		border-radius : 10px;
	}
	#btnRemove:hover, #btnChangePage:hover, #btnListPage:hover {
		background-color: #2C3E50; opacity: 0.65;
	}		
	#divBtn {
		margin: 20px auto;
	}	
</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>

	<article>
		<div class="pageName">
			공지사항
		</div>
		<div id="divNo">		
			번호 ${notice.noticeNo}
		</div>
		<div id="divTitle">
			제목 ${notice.noticeTitle}
		</div>
		<div id="divHit">
			조회수 ${notice.noticeHit}
		</div>
		<div id="divCreated">
			작성일 ${notice.noticeCreated}
		</div>
		<div id="divModified">
			수정일 ${notice.noticeModified}
		</div>
		<div id="divContent">
			내용<br><textarea rows="30" cols="80" id="content" class="content" readonly>${notice.noticeContent}</textarea><br>
		</div>
		<div id="divBtn">
			<c:if test="${loginMember.memberId eq 'admin'}">
				<input type="button" value="삭제" id="btnRemove">
				<input type="button" value="수정페이지" id="btnChangePage">
			</c:if>
			<input type="button" value="공지사항 목록" id="btnListPage">
		</div>
		
		<c:if test="${not empty noticeFileAttaches}">
			<hr>
			<div class="pageName">
				첨부 이미지(다운로드)
			</div>	
			<c:forEach var="noticeFileAttach" items="${noticeFileAttaches}">
				<div><img alt="${noticeFileAttach.noticeFileAttachOrigin}" src="${contextPath}/board/noticeDisplay?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}" onclick="location.href='${contextPath}/board/noticeDownload?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}'"></div>
			</c:forEach>
		</c:if>
	</article>
		
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>