<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>

	$(function(){
		
		// 수정 완료
		$('#f').on('submit', function(event){
			if($('#title').val() == '${notice.noticeTitle}'&& $('#content').val() == '${notice.noticeContent}' && $('#files').val() == '') {
				alert('변경된 내용이 없습니다.');
				event.preventDefault();
				return false;
			} else if($('#title').val() == '' || $('#content').val() == '') {
				alert('제목과 내용은 필수입니다.');
				event.preventDefault();
				return false;
			}
			return true;
		})
		
		$('#files').on('change', function(){
			var regExt = /(.*)[.](jpg|png|gif)$/;
			var maxSize = 1024 * 1024 * 10; 
			
			var files = $(this)[0].files;
			for(let i = 0; i < files.length; i++){
				if( regExt.test(files[i].name) == false ) {
					alert('이미지만 첨부할 수 있습니다.');
					$(this).val('');
					return;
				}
				if(files[i].size > maxSize) {
					alert('10MB 이하의 파일만 첨부할 수 있습니다.');
					$(this).val('');
					return;
				}
			}
		})
		
		$('#btnList').on('click', function(){
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
	
	<h1>공지사항 수정 화면</h1>

	<form id="f" action="${contextPath}/board/noticeModify" method="post" enctype="multipart/form-data">
		번호 ${notice.noticeNo}<br>
		작성일 ${notice.noticeCreated}<br>
		수정일 ${notice.noticeModified}<br>
		<input type="hidden" name="noticeNo" value="${notice.noticeNo}">
		제목 <input type="text" name="title" id="title" value="${notice.noticeTitle}"><br>
		내용<br><textarea rows="30" cols="80" id="content" class="content">${notice.noticeContent}</textarea><br>
		첨부파일 추가 <input type="file" name="files" id="files" multiple="multiple"><br><br>
		<button>수정 완료</button>
		<input type="button" value="목록" id="btnList">
	</form>
	
	<hr>
	
	<div>첨부파일 삭제</div>
	<c:forEach var="noticeFileAttach" items="${noticeFileAttaches}">
		<span>${noticeFileAttach.noticeFileAttachOrigin}</span> 
		<a href="${contextPath}/board/removeNoticeFileAttach?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}&noticeNo=${noticeFileAttach.noticeNo}"><i class="fa-solid fa-x"></i></a>	
		<div><img alt="${noticeFileAttach.noticeFileAttachOrigin}" src="${contextPath}/board/noticeDisplay?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}" width="300px"></div>
	</c:forEach>
	
</body>
</html>