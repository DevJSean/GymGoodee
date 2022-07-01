<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>공지사항 작성</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>
	
	$(function(){
		fnInit();
		fnFileCheck();
		fnAdd();
		fnRemoveAttached();
		
		if($('#files').val() == '') {
			$('.attached').addClass('blind');
		}
	})
	
	function fnInit() {
		$('#title').val('');
		$('#content').val('');
		$('#files').val('');
	}
	
	function fnFileCheck() {
		$('#files').on('change', function(){
			// 첨부 규칙
			var regExt = /(.*)[.](jpg|png|gif)$/;
			// / : 시작
			// $ : 끝
			// . : 아무 글자나 상관 없다.
			// * : 몇 글자가 오든 상관 없다.
			// [.] or \. : 확장자용 마침표
			var maxSize = 1024 * 1024 * 10; // 하나당 최대 크기
			
			// 첨부 가져오기
			var files = $(this)[0].files;
			// 각 첨부의 순회
			for(let i = 0; i < files.length; i++){
				// 확장자 체크
				if( regExt.test(files[i].name) == false ) {
					alert('이미지만 첨부할 수 있습니다.');
					$(this).val(''); // 첨부된 파일이 모두 없어진다.
					return;
				}
				// 크기 체크
				if(files[i].size > maxSize) {
					alert('10MB 이하의 파일만 첨부할 수 있습니다.');
					$(this).val('');
					return;
				}
			}
		})
	}
	
	function fnAdd() {
		$('#btnAdd').on('click', function(){
			
			if( $('#title').val() == '' || $('#content').val() == '' ){
				alert('제목과 내용은 필수입니다.');
				event.preventDefault();
				return false;
			}
			
			let formData = new FormData();
			formData.append('title', $('#title').val());
			formData.append('content', $('#content').val());
			if($('#files')[0].files.length > 0) {
				let files = $('#files')[0].files;
				for(let i = 0; i < files.length; i++){
					formData.append('files', files[i]);
				}
			}
			$.ajax({
				url: '${contextPath}/board/noticeAdd',
				type: 'POST',
				data: formData,
				contentType: false,
				processData: false,
				dataType: 'json',
				success: function(obj){
					if(obj.noticeResult) { 
						alert('공지사항이 등록되었습니다.');
						if(obj.noticeFileAttachResult > 0) {
							alert('파일이 첨부되었습니다.');
							//fnAttached(obj);
							location.href="${contextPath}/board/noticeList";
						} else {
							alert('파일은 등록되지 않았습니다.');
							location.href="${contextPath}/board/noticeList";
						}
					} else {
						alert('공지사항이 등록되지 않았습니다.');
					}
					//fnInit();
				}
			})
		})
	}
	
/* 	function fnAttached(obj) {
		$('#attached').empty();
		let result = '';
		for(let i = 0; i < obj.thumbnails.length; i++) { 
			result += '<div><img src="${contextPath}/board/display/?path=' + encodeURIComponent(obj.path) + '&thumbnail=' + obj.thumbnails[i] + '"></div>';
		}
		$('#attached').append(result);
	} */
	
	function fnImagePreview(event){
		$('.attached').removeClass('blind');
		$('#attached').empty();
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

	function fnRemoveAttached(){
		$('#btnRemoveAttached').on('click', function(){
			$('#attached').empty();
			$('#files').val('');
			$('.attached').addClass('blind');
		})
	}
	
</script>
<style>
	.blind {
		display: none;
	}
</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<div>
		제목 : <input type="text" name="title" id="title"><br>
		내용<br><textarea rows="30" cols="80" name="content" id="content" class="content"></textarea><br>
		첨부 : <input type="file" name="files" id="files" multiple="multiple" onchange="fnImagePreview(event);">
		<input type="button" value="첨부파일 제거" id="btnRemoveAttached">
		<br><br>
		<input type="button" value="등록" id="btnAdd">	
		<input type="button" value="공지사항 목록" onclick="location.href='${contextPath}/board/noticeList'">
	</div>
	
	<div class="attached">
		<h3>첨부된 파일 확인</h3>
		<div id="attached"></div>
	</div>
	
</body>
</html>