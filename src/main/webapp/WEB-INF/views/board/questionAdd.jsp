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
			fnSubmit();
			fnSummernote();
		})
		
		function fnSummernote(){
			$('#content').summernote({
				/* width: 910, */
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
		
</script>
<style>
 	article {
		background-color : white;
		width: 60%;
  		margin: 50px auto;		
  		border-radius : 50px;
  		padding: 30px;
		text-align: center;
  		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);		
	}
	#pageName {
		margin: 30px auto;
		font-size: 24px;
		font-weight: 900;
	}
	#divWriter {
		text-align: left;
		margin: 30px auto;
		width: 80%;
		font-size: 20px;
	}
	#divWriter > input[type="text"] {
		width: 90%;
		padding: 10px;
		border: solid 2px #2C3E50;
		border-radius: 10px;
		font-size: 16px;
		resize: none;
	}
	
	#divTitle {
		text-align: left;
		margin: 30px auto;
		width: 80%;
		font-size: 20px;
	}
	#divTitle > input[type="text"] {
		width: 90%;
		padding: 10px;
		border: solid 2px #2C3E50;
		border-radius: 10px;
		font-size: 16px;
		resize: none;
	}
	#btnAdd, #btnList {
		background-color: #2C3E50; 
 		padding: 10px;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		color: #F5F6F7;
		border: none;
		border-radius : 10px;
	}
	#btnAdd:hover, #btnList:hover {
		background-color: #2C3E50; opacity: 0.65;
	}
	#divBtn {
		margin: 20px auto;
	}

</style>
<link rel="stylesheet" href="../resources/summernote-0.8.18-dist/summernote-lite.css"/>
</head>
<body>

  	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>

	<script src="../resources/summernote-0.8.18-dist/summernote-lite.js"></script>
	<script src="../resources/summernote-0.8.18-dist/lang/summernote-ko-KR.js"></script>

	<article>
		<form id="f" action="${contextPath}/board/questionAdd" method="post">
			<div id="pageName">
				질문 작성
			</div>
			<div id="divWriter">
				작성자&nbsp;&nbsp;<input type="text" name="writer" value="${loginMember.memberId}" readonly>
			</div>
			<div id="divTitle">
				제목&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id="title" name="title" placeholder="제목을 입력해 주세요">
			</div>
			<div id="divContent">
				<textarea name="content" id="content"></textarea>
			</div>
			<div id="divBtn">
				<button id="btnAdd">작성완료</button>	
				<input type="button" id="btnList" value="QnA 목록" onclick="location.href='${contextPath}/board/questionList'">
			</div>
		</form>
	</article>

	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>