<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>QnA 작성</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script src="../resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script src="../resources/summernote-0.8.18-dist/lang/summernote-ko-KR.js"></script>
<link rel="stylesheet" href="../resources/summernote-0.8.18-dist/summernote-lite.css"/>
<script>
	$(function(){
		fnSubmit();
		fnSummernote(); // summernote.js
	})
	
	function fnSubmit(){
		$('#f').on('submit', function(event){
			if( $('#title').val() == '' || $('#content').val() == '' ){
				alert('제목과 내용은 필수입니다.');
				event.preventDefault();
				return false;
			}
			return true;
		})
	}

	function fnSummernote(){
		$('#content').summernote({
			width: 1000,
			height: 600,
			lang: 'ko-KR',
			// 툴바 수정
			// https://summernote.org/deep-dive/#custom-toolbar-popover
			toolbar: [
			    // [groupName, [list of button]]
			    ['fontname', ['fontname']],
			    ['fontsize', ['fontsize']],
			    ['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
			    ['color', ['forecolor','color']],
			    ['table', ['table']],
			    ['para', ['ul', 'ol', 'paragraph']],
			    ['height', ['height']],
			    ['insert',['picture','link','video']],
			    ['view', ['fullscreen', 'help']]
			],
			fontNames: ['Arial', 'Arial Black', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체'],
			fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','36','48','72'],
			callbacks: {
				onImageUpload: function(files) {
					for (var i = 0; i < files.length; i++) {
						var formData = new FormData();
						formData.append('file', files[i]);
						$.ajax({
							url: '${contextPath}/board/uploadSummernoteImage',
							type: 'POST',
							data: formData,
							contentType: false,
							processData: false,
							dataType: 'json',
							success: function(obj){
								console.log(obj.src);
								$('#content').summernote('insertImage', obj.src);
							}
						})
					}
			    }
			}
		});
	}
</script>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>

	<form id="f" action="${contextPath}/board/questionAdd" method="post">
		<input type="text" name="writer" value="${loginMember.memberId}" readonly><br>
		<input type="text" name="title" placeholder="제목"><br>
		<textarea name="content" id="content"></textarea><br><br>
		<button>작성완료</button>	
		<input type="button" value="QnA 목록" onclick="location.href='${contextPath}/board/questionList'">
	</form>
	
</body>
</html>