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
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js" integrity="sha256-6XMVI0zB8cRzfZjqKcD01PBsAy3FlDASrlC8SxCpInY=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">
<script>

	/* 페이지 로드 이벤트 */
	$(function(){
		fnGetClassList();
	})
	
	
	
	/* 함수 */
	
	// 1. 날짜 선택시 해당 날짜에 개설된 강좌 목록과 실시간 예약 현황 불러오기
	function fnGetClassList(){
		$('#test').on('click',function(){
			var popupX = (window.screen.width / 2) - (600 / 2);
			// 만들 팝업창 좌우 크기의 1/2 만큼 보정값으로 빼주었음

			var popupY= (window.screen.height /2) - (300 / 2);
			// 만들 팝업창 상하 크기의 1/2 만큼 보정값으로 빼주었음

			window.open("${contextPath}/reserve/reserveSwim?subject=SWIM&classDate=" + $(this).text(), '', 'status=no, height=300, width=600, left='+ popupX + ', top='+ popupY + ', scrollbars=yes,resizable=yes');
		})

	} // fnGetClassList
	
	
</script>
<style>

	.wrapper1{
		text-align:center;
		border : 2px solid grey;
	}
	.title{
		text-align: center;
		font-weight : 400;
		font-size: 40px;
	}
	.Day{
		display : inline-block;
		border: 7px solid lightgreen;
		width: 80px;
		height: 30px;
		text-align : center;
	}
	
	.test{
		display : inline-block;
		border: 3px solid lightgrey;
		width: 80px;
		height: 80px;
		text-align : center;
		
	}

</style>
</head>
<body>

	<h1>수영 예약 페이지</h1>
	
	<img alt="수영이미지">
	
	<hr>
	
	
	<!-- div로 달력 만들기... -->
	<div class="wrapper1">
		<div class="wrapper2">
			<div class="title">2022-06</div>
			<div class="Day">SUN</div>
			<div class="Day">MON</div>
			<div class="Day">TUE</div>
			<div class="Day">WED</div>
			<div class="Day">THU</div>
			<div class="Day">FRI</div>
			<div class="Day">SAT</div>		
		</div>
		<div class="wrapper3">
			<div class="week1"></div>
				<div class="test" name="classDate" id="test">20220623</div>
			<div class="week2"></div>
			<div class="week3"></div>
			<div class="week4"></div>
			<div class="week5"></div>
		</div>
	
	
	</div>
	
	
	
	
	
	
</body>
</html>