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

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>

	번호 ${notice.noticeNo}<br>
	제목 ${notice.noticeTitle}<br>
	조회수 ${notice.noticeHit}<br>
	작성일 ${notice.noticeCreated}<br>
	수정일 ${notice.noticeModified}<br>
	내용<br><textarea rows="30" cols="80" class="content" readonly>${notice.noticeContent}</textarea><br>
	
	<c:if test="${loginMember.memberId eq 'admin'}">
		<input type="button" value="삭제" id="btnRemove">
		<input type="button" value="수정페이지" id="btnChangePage">
	</c:if>
	<input type="button" value="목록" id="btnListPage">
	
	<c:if test="${not empty noticeFileAttaches}">
		<hr>
		
		<div>첨부파일 다운로드</div>
		<c:forEach var="noticeFileAttach" items="${noticeFileAttaches}">
			<div><a href="${contextPath}/board/noticeDownload?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}">${noticeFileAttach.noticeFileAttachOrigin}</a></div>		
		</c:forEach>
		
		<hr>
		
		<div>첨부 이미지</div>	
		<c:forEach var="noticeFileAttach" items="${noticeFileAttaches}">
			<div><img alt="${noticeFileAttach.noticeFileAttachOrigin}" src="${contextPath}/board/noticeDisplay?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}"></div>
		</c:forEach>
	</c:if>
	
</body>
</html>