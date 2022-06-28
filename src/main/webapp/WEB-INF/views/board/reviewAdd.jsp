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
		
		$('#f').on('submit', function(event){
			if( $('#title').val() == '' || $('#content').val() == '' ){
				alert('제목과 내용은 필수입니다.');
				event.preventDefault();
				return false;
			} else if (!$('#class > option:selected').val()) {
				alert('수강 이력이 있어야 리뷰를 작성할 수 있습니다.');
				event.preventDefault();
				return false;
			}
		})		
		
		$('#btnList').on('click', function(){
			location.href="${contextPath}/board/reviewList";
		})
	})
	
</script>
</head>
<body>
	
	<h3>리뷰 작성</h3>
	
	<form action="${contextPath}/board/reviewAdd" method="post" id="f">
		작성자 <input type="text" name="writer" value="${loginMember.memberId}" readonly><br>
		수강 내역
		<select name="class" id="class">
			<c:forEach items="${classCodes}" var="classCode">
				<option value="${classCode.classCode}">${classCode.classCode}</option>
			</c:forEach>
		</select>
		<br>
		제목 <input type="text" name="title" id="title"><br>
		내용 <br>
		<textarea rows="30" cols="80" name="content"></textarea><br><br>
		<input type="reset" value="다시작성">
		<button>작성 완료</button>
		<input type="button" value="리뷰 목록" id="btnList">
	</form>
	
</body>
</html>