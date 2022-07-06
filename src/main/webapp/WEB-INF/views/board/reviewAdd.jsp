<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>리뷰 작성</title>
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
<style>
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
	#pageName {
		margin: 30px auto;
		font-size: 24px;
		font-weight: 900;
	}
	#divWriter, #divClass, #divTitle {
		text-align: left;
		margin: 30px auto;
		width: 80%;
		font-size: 20px;
	}
	#divWriter > input[type="text"], #divTitle > input[type="text"] {
		width: 80%;
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
		width: 80%;
		text-align: left;
		font-size: 20px;
	}
	#divContent > textarea {
		margin-top : 10px;
		width: 100%;
		height: 400px;
		padding: 10px;
		border: solid 2px #2C3E50;
		border-radius: 30px;
		font-size: 16px;
		resize: none;
	}
	#divBtn {
		margin: 20px auto;
	}
	#btnReset, #btnAdd, #btnList {
		background-color: #2C3E50; 
 		padding: 10px;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		color: #F5F6F7;
		border: none;
		border-radius : 10px;
	}
	#btnReset:hover, #btnAdd:hover, #btnList:hover {
		background-color: #2C3E50; opacity: 0.65;	
	}		
	#class {
		font-size: 19px;
		border: solid 2px #2C3E50;
		border-radius: 5px;		
	}	
</style>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<article>
		<div id="pageName">
			리뷰 작성
		</div>
		<form action="${contextPath}/board/reviewAdd" method="post" id="f">
			<div id="divWriter">
				작성자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="writer" value="${loginMember.memberId}" readonly><br>
			</div>
			<div id="divClass">
				수강 내역&nbsp;&nbsp;
				<select name="class" id="class">
					<c:forEach items="${classCodes}" var="classCode">
						<c:set var="code" value="${classCode.classCode}"/>
						<c:set var="classLength" value="${fn:length(code)}"/>
						<c:set var="classSubject" value="${fn:substring(code,11,classLength)}"/>
							<c:if test="${fn:startsWith(classSubject, 'SWIM')}">
								<option value="${classCode.classCode}">${fn:replace(code, 'SWIM', '수영')}반</option>
							</c:if>
							<c:if test="${fn:startsWith(classSubject, 'DANCE')}">
								<option value="${classCode.classCode}">${fn:replace(code, 'DANCE', '댄스')}반</option>
							</c:if>
							<c:if test="${fn:startsWith(classSubject, 'PILATES')}">
								<option value="${classCode.classCode}">${fn:replace(code, 'PILATES', '필라테스')}반</option>
							</c:if>
							<c:if test="${fn:startsWith(classSubject, 'SPINNING')}">
								<option value="${classCode.classCode}">${fn:replace(code, 'SPINNING', '스피닝')}반</option>
							</c:if>
					</c:forEach>
				</select>
			</div>
			<div id="divTitle">
				제목&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="title" id="title">
			</div>
			<div id="divContent">
				내용 <textarea rows="30" cols="80" name="content"></textarea>
			</div>
			<div id="divBtn">
				<input type="reset" id="btnReset" value="다시작성">
				<button id="btnAdd">작성 완료</button>
				<input type="button" value="리뷰 목록" id="btnList">
			</div>
		</form>
	</article>

	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>		
	</footer>

</body>
</html>