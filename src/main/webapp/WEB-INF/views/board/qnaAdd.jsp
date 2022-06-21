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
<script src="../resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script src="../resources/summernote-0.8.18-dist/lang/summernote-ko-KR.js"></script>
<link rel="stylesheet" href="../resources/summernote-0.8.18-dist/summernote-lite.css">
<script>

	$(function(){
		fnSummernote();
	})
	
	function fnSummernote(){
		$('#content').summernote({
			width: 800,
			height: 400,
			lang: 'ko-KR',
			callbacks: {
				onImageUpload: function(files) {
					var formData = new FormData();
					formData.append('file', files[0]); 
					$.ajax({
						url: '${contextPath}/board/uploadSummernoteImage',
						type: 'POST',
						data: formData,
						contentType: false,
						processData: false,
						success: function(obj){
							$('#content').summernote('insertImage', obj.src);
							// 요청 : /getImage/abc.jpg  이걸
							// 실제 저장 : C:/upload/summernote/abc/jpg 이렇게 바꿔야 한다. WebMvcConfig에서 해결
						}
					})
				}
			}
		});
	}


</script>

</head>
<body>

	<h1>질문 작성화면</h1>
	
	<form id="f" action="${contextPath}/board/addQuestion" method="post" enctype="multipart/form-data">
		<input type="text" name="writer" placeholder="작성자"><br>
		<input type="text" name="title" placeholder="제목"><br>
		<textarea name="content" id="content"></textarea><br><br>
		<button>작성완료</button>	
	</form>
	
</body>
</html>