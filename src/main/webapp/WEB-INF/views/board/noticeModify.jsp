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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
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
		font-size: 24px;
		font-weight: 900;
	}
	#divNo {
		margin: 30px auto 0 auto;
		width: 78%;
		text-align: left;
		font-size: 20px;
	}
	#divCreated, #divModified {
		margin: 5px auto 0 auto;
		width: 78%;
		text-align: left;
		font-size: 20px;
	}
	#divTitle {
		margin: 30px auto 30px auto;
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
	#content {
		margin-top: 10px;
		margin-bottom: 10px;
	}
	#divContent {
		margin: 0 auto;
		width: 78%;
		text-align: left;
		font-size: 20px;
	}
	#divContent > textarea {
		width: 100%;
		height: 400px;
		padding: 10px;
		border: solid 2px #2C3E50;
		border-radius: 30px;
		font-size: 16px;
		resize: none;
	}
	#fileLabel, #btnAdd, #btnList {
		background-color: #2C3E50; 
 		padding: 10px;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		color: #F5F6F7;
		border: none;
		border-radius : 10px;
	}
	#fileLabel:hover, #btnAdd:hover, #btnList:hover {
		background-color: #2C3E50; opacity: 0.65;	
	}		
	#divFile {
		margin: 20px auto;
	}
	#divBtn {
		margin: 20px auto;
	}
	#newAttached {
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
			공지사항 수정
		</div>
		<form id="f" action="${contextPath}/board/noticeModify" method="post" enctype="multipart/form-data">
			<div id="divNo">
			번호   ${notice.noticeNo}
			</div>
			<div id="divCreated">
				작성일 ${notice.noticeCreated}
			</div>
			<div id="divModified">
				수정일 ${notice.noticeModified}
			</div>
			<input type="hidden" name="noticeNo" value="${notice.noticeNo}">
			<div id="divTitle">
				제목&nbsp;&nbsp;&nbsp;<input type="text" name="title" id="title" value="${notice.noticeTitle}"><br>
			</div>
			<div id="divContent">
				내용<textarea rows="30" cols="80" id="content" name="content">${notice.noticeContent}</textarea><br>
			</div>
			<div id="divFile">
				<label id="fileLabel" for="files">파일 선택<input type="file" name="files" id="files" multiple="multiple" onchange="fnImagePreview(event);" style="display:none;"></label>
			</div>
			<div id="divBtn">			
				<button id="btnAdd">수정 완료</button>
				<input type="button" value="목록" id="btnList">
			</div>
		</form>
		
		<hr>
		
		<c:if test="${not empty noticeFileAttaches}">
			<div class="pageName">
				첨부파일 삭제
			</div>
			<c:forEach var="noticeFileAttach" items="${noticeFileAttaches}">
				<span>${noticeFileAttach.noticeFileAttachOrigin}</span>
				<input type="hidden" value="${noticeFileAttach.noticeFileAttachNo}">
				<i class="fa-solid fa-x"></i>
				<div><img alt="${noticeFileAttach.noticeFileAttachOrigin}" src="${contextPath}/board/noticeDisplay?noticeFileAttachNo=${noticeFileAttach.noticeFileAttachNo}"></div>
			</c:forEach>
		</c:if>
				
		<div id="newAttached" class="blind">
			<div class="pageName">
				새로 첨부된 파일
			</div>
			<div id="attached"></div>
		</div>
		
	</article>

	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>