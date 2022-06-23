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
	
		// 삭제
		$('#btnRemove').on('click', function(){
			if(confirm('삭제할까요?')){
				location.href='${contextPath}/board/questionRemove?questionNo=${question.questionNo}';
			}
		})
		
		// 수정 화면으로 이동   qna는 수정 없음
		//$('#btnModifyPage').on('click', function(){
		//	location.href='${contextPath}/bbs/modifyPage?bbsNo=${bbs.bbsNo}';
		//})
		
		// 목록
		$('#btnList').on('click', function(){
			location.href='${contextPath}/board/questionList';
		})
		
	})
	
</script>
</head>
<body>

	게시글번호: ${question.questionNo}<br>
	작성자: ${question.memberId}<br>
	제목: ${question.questionTitle}<br>
	최초작성일: ${question.questionCreated}<br>
	최근수정일: ${question.questionModified}<br>
	내용
	${question.questionContent}<br>
	
	<hr>
	
	<input type="button" value="삭제" id="btnRemove">
	<!--  <input type="button" value="수정" id="btnModifyPage">-->
	<input type="button" value="목록" id="btnList">
	
</body>
</html>