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
	div.content {
	    width: 1000px;
	    height: 600px;
	    border: 1px solid #dcdcdc;
	    overflow-y: auto;
	}
</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>

	<input type="button" value="QnA 목록" id="btnList">
	<c:if test="${loginMember.memberId eq question.memberId || loginMember.memberId eq 'admin'}">
		<input type="button" value="삭제" id="btnRemove">
	</c:if>
	<br>
	게시글번호: ${question.questionNo}<br>
	작성자: ${question.memberId}<br>
	제목: ${question.questionTitle}<br>
	최초작성일: ${question.questionCreated}<br>
	내용
	<div class="content" contenteditable="false">${question.questionContent}</div>
	
	<hr>
	
	<h3>답변</h3>
	<div>
		<c:if test="${loginMember.memberId ne 'admin'}">
			<textarea rows="10" cols="70" name="answerContent" id="answerContent" readonly>${answer.answerContent}</textarea>
		</c:if>
		<c:if test="${loginMember.memberId eq 'admin'}">
			<textarea rows="10" cols="70" name="answerContent" id="answerContent">${answer.answerContent}</textarea>
			<input type="button" value="답변 등록" id="btnAddAnswer">
			<input type="button" value="답변 삭제" id="btnRemoveAnswer">
		</c:if>
	</div>
	
</body>
</html>