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
		fnInit();
		fnFileCheck();
		fnAdd();
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
			
			let formData = new FormData();
			formData.append('title', $('#title').val());
			formData.append('content', $('#content').val());
			let files = $('#files')[0].files;
			for(let i = 0; i < files.length; i++){
				formData.append('files', files[i]);
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
					} else {
						alert('공지사항 등록이 실패했습니다.');
					}
					if(obj.noticeFileAttachResult) {
						alert('파일이 첨부되었습니다.');
						fnAttached(obj);
					} else {
						alert('파일 등록이 실패했습니다.');
					}
					fnInit();
				}
			})
		})
	}
	
	function fnAttached(obj) {
		$('#attached').empty();
		let result = '';
		for(let i = 0; i < obj.thumbnails.length; i++) { 
			result += '<div><img src="${contextPath}/board/display/?path=' + encodeURIComponent(obj.path) + '&thumbnail=' + obj.thumbnails[i] + '"></div>';
		}
		$('#attached').append(result);
	}
	
</script>
</head>
<body>
	
	<h1>공지사항 작성화면</h1>

	<div>
		제목 : <input type="text" name="title" id="title"><br>
		내용<br><textarea rows="30" cols="50" name="content" id="content"></textarea><br>
		첨부 : <input type="file" name="files" id="files" multiple="multiple"><br><br>
		<input type="button" value="등록" id="btnAdd">	
	</div>
	
	<div>
		<h3>첨부된 파일 확인</h3>
		<div id="attached"></div>
	</div>
	
</body>
</html>