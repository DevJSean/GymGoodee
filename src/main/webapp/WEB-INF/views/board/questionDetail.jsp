<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>QnA 상세보기</title>
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
		
		fnRemoveQuestion();
		fnQuestionList();
		fnRemoveAnswer();
		fnAddAnswer();
	})
	
	// 질문 삭제
	function fnRemoveQuestion() {
		$('#btnRemove').on('click', function(){
			if(confirm('삭제할까요?')){
				location.href='${contextPath}/board/questionRemove?questionNo=${question.questionNo}';
			}
		})
	}
	// 목록
	function fnQuestionList() {
		$('#btnList').on('click', function(){
			location.href='${contextPath}/board/questionList';
		})
	}
	// 답변 삭제
	function fnRemoveAnswer() {
		$('#btnRemoveAnswer').on('click', function(){
			$.ajax({
				url: '${contextPath}/board/answerRemove',
				type: 'get',
				data: 'questionNo=${question.questionNo}',
				dataType: 'json',
				success: function(obj){
					if(obj.res > 0){
						$('#answerContent').val('');
						alert('답변이 삭제되었습니다.');
					}
				},
				error: function(jqXHR){
					alert(jqXHR.status);
					alert(jqXHR.responseText);
				}
			})
		})	
	}
	// 답변 등록
	function fnAddAnswer() {
		$('#btnAddAnswer').on('click', function(){
			fnRemoveAnswer();
			$.ajax({
				url: '${contextPath}/board/answerAdd',
				type: 'post',
				data: 'questionNo=${question.questionNo}&answerContent=' + $('#answerContent').val(),
				
				dataType: 'json',
				success: function(obj){
					if(obj.res > 0) { 
						$('#answerContent').text(obj.answerContent);
						alert('답변이 등록되었습니다.');
					} else {
						alert('답변 등록이 실패했습니다.');
					}
				},
				error: function(jqXHR) {
					alert(jqXHR.status);
					alert(jqXHR.responseText);
				}
			})
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
	.pageName {
		margin: 30px auto;
		font-size: 30px;
		font-weight: 900;
	}
	#divNo {
		margin: 30px auto 0 auto;
		width: 75%;
		text-align: left;
		font-size: 20px;
	}
	#divTitle, #divWriter, #divCreated {
		font-size: 20px;	
		margin: 5px auto 0 auto;
		width: 75%;
		text-align: left;		
	}
	.content {
		margin: 30px auto 0 auto;
	    width: 75%;
	    text-align: left;
	    font-size: 20px;
	}
	#content {
		margin-top : 10px;
	    border: 2px solid #2C3E50; 
	    overflow-x: auto;
	    height: 300px;
		padding: 10px;
		border-radius: 30px;
		font-size: 16px;
	}
	#btnList, #btnRemove, #btnAddAnswer, #btnRemoveAnswer {
		background-color: #2C3E50; 
 		padding: 10px;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		color: #F5F6F7;
		border: none;
		border-radius : 10px;
	}
	#btnList:hover, #btnRemove:hover, #btnAddAnswer:hover, #btnRemoveAnswer:hover {
		background-color: #2C3E50; opacity: 0.65;
	}
	
	textarea {
		width: 75%;
		height: 300px;
		padding: 10px;
		border: solid 2px #2C3E50;
		border-radius: 30px;
		font-size: 16px;
		resize: none;
	}		
	.divBtn {
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
			질문
		</div>
		<div id="divNo">
			게시글번호 : ${question.questionNo}
		</div>
		<div id="divWriter">
			작성자 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: ${question.memberId}
		</div>
		<div id="divTitle">
			제목 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: ${question.questionTitle}
		</div>
		<div id="divCreated">
			최초작성일 : ${question.questionCreated}
		</div>
		<div class="content" contenteditable="false">
			내용<div id="content">${question.questionContent}</div>
		</div>
		<div class="divBtn">
			<input type="button" value="QnA 목록" id="btnList">
			<c:if test="${loginMember.memberId eq question.memberId || loginMember.memberId eq 'admin'}">
				<input type="button" value="삭제" id="btnRemove">
			</c:if>
		</div>
		
		
		<hr>
		<div class="pageName">
			답변
		</div>
		<div>
			<c:if test="${loginMember.memberId ne 'admin'}">
				<textarea rows="10" cols="70" name="answerContent" id="answerContent" readonly>${answer.answerContent}</textarea>
			</c:if>
			<c:if test="${loginMember.memberId eq 'admin'}">
				<textarea rows="10" cols="70" name="answerContent" id="answerContent">${answer.answerContent}</textarea>
				<div class="divBtn">
					<input type="button" value="답변 등록" id="btnAddAnswer">
					<input type="button" value="답변 삭제" id="btnRemoveAnswer">
				</div>
			</c:if>
		</div>
	</article>

	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>		
	</footer>
	
</body>
</html>