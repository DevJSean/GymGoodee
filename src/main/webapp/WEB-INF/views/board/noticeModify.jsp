<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>공지사항 수정</title>
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
		
		$('.fa-x').on('click', function(){
			$.ajax({
				url: '${contextPath}/board/removeNoticeFileAttach',
				type: 'get',
				data: 'noticeFileAttachNo=' + $(this).prev().val(),
				success: function(obj) {
					if(obj.res == 1) {
						alert('첨부파일이 삭제되었습니다.');
						location.href='${contextPath}/board/noticeModifyPage?noticeNo=${notice.noticeNo}';
					}
				},
				error: function(jqXHR) {
					alert(jqXHR.responseText);
				}
			})
		})
		
	})
	
	function fnImagePreview(event){
		$('#attached').empty();
		$('#newAttached').removeClass('blind');
		for(var image of event.target.files){
			var reader = new FileReader();
			
			reader.onload = function(event){
				var img = document.createElement("img");
				img.setAttribute("src", event.target.result);
				img.setAttribute("class", "col-lg-6");
				img.setAttribute("width", "500px");
				document.querySelector("div#attached").appendChild(img);
			};
			reader.readAsDataURL(image);
		}
	}
	
</script>
<style>
	img {
		width: 500px;
	}
	.blind {
		display: none;
	}
	.fa-x {
		cursor: pointer;
	}
</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<form id="f" action="${contextPath}/board/noticeModify" method="post" enctype="multipart/form-data">
		번호 ${notice.noticeNo}<br>
		작성일 ${notice.noticeCreated}<br>
		수정일 ${notice.noticeModified}<br>
		<input type="hidden" name="noticeNo" value="${notice.noticeNo}">
		제목 <input type="text" name="title" id="title" value="${notice.noticeTitle}"><br>
		내용<br><textarea rows="30" cols="80" id="content" name="content">${notice.noticeContent}</textarea><br>
		첨부파일 <input type="file" name="files" id="files" multiple="multiple" onchange="fnImagePreview(event);"><br><br>
		<button>수정 완료</button>
		<input type="button" value="목록" id="btnList">
	</form>
	
	<hr>
	
	<c:if test="${not empty noticeFileAttaches}">
		<h3>첨부파일 삭제</h3>
		<c:forEach var="noticeFileAttach" items="${noticeFileAttaches}">
			<span>${noticeFileAttach.noticeFileAttachOrigin}</span>
			<input type="hidden" value="${noticeFileAttach.noticeFileAttachNo}">
			<i class="fa-solid fa-x"></i>
			<div><img alt="${noticeFileAttach.noticeFileAttachOrigin}" src="${contextPath}/board/noticeDisplay?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}" width="300px"></div>
		</c:forEach>
	</c:if>
	
	<div id="newAttached" class="blind">
		<h3>새로 첨부된 파일</h3>
		<div id="attached"></div>
	</div>
	
</body>
</html>