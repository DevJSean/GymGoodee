<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
		width: 300px;
	}
</style>
</head>
<body>

	<h1>공지사항 상세 보기</h1>

	번호 ${notice.noticeNo}<br>
	제목 ${notice.noticeTitle}<br>
	내용 ${notice.noticeContent}<br>
	IP ${notice.noticeIp}<br>
	조회수 ${notice.noticeHit}<br>
	작성일 ${notice.noticeCreated}<br>
	수정일 ${notice.noticeModified}<br>
	
	<input type="button" value="삭제" id="btnRemove">
	<input type="button" value="수정페이지" id="btnChangePage">
	<input type="button" value="목록" id="btnListPage">
	
	<hr>
	
	<div>첨부목록</div>
	<c:forEach var="noticeFileAttach" items="${noticeFileAttaches}">
		<div><a href="${contextPath}/board/noticeDownload?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}">${noticeFileAttach.noticeFileAttachOrigin}</a></div>		
	</c:forEach>
	
	<hr>
	
	<c:forEach var="noticeFileAttach" items="${noticeFileAttaches}">
		<div><img alt="${noticeFileAttach.noticeFileAttachOrigin}" src="${contextPath}/board/noticeDisplay?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}"></div>
	</c:forEach>
</body>
</html>