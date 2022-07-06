<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>SWIM</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js" integrity="sha256-6XMVI0zB8cRzfZjqKcD01PBsAy3FlDASrlC8SxCpInY=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/reset.css">

<script src='../resources/fullcalendar-5.11.0/lib/main.js'></script>
<link href='../resources/fullcalendar-5.11.0/lib/main.css' rel='stylesheet' />
<script>

	/* 페이지 로드 이벤트 */
	$(function(){
		fnGetClassList();
	})
	/* calendar */
	document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
          initialView: 'dayGridMonth',
          locale: 'ko'
        });
        calendar.render();
     });
	
	
	
	/* 함수 */
	
	// 1. 날짜 선택시 해당 날짜에 개설된 강좌 목록과 실시간 예약 현황 불러오기
	function fnGetClassList(){
		$('body').on('click', '.fc-day', function(ev){
			
			// yyyy-mm-dd 까지만 나오게 하기!
			var now = new Date();
			var today = new Date().toISOString().substring(0,10);
			
			var date = new Date($(this).data('date')).toISOString().substring(0,10);	// 선택한 날짜
			var sevenDayAgo = new Date(now.setDate(now.getDate() -7)).toISOString().substring(0,10);
		
			//console.log(sevenDayAgo);
			
			if(date < sevenDayAgo){
				alert('일주일 전까지만 택할 수 있습니다.');
				ev.preventDefault();
				return false;
			} 
			
			var strDate = date.replace(/-/gi,"");
			
			var popupX = (window.screen.width / 2) - (600 / 2);
			// 만들 팝업창 좌우 크기의 1/2 만큼 보정값으로 빼주었음

			var popupY= (window.screen.height /2) - (300 / 2);
			// 만들 팝업창 상하 크기의 1/2 만큼 보정값으로 빼주었음

			window.open("${contextPath}/reserve/reserveSwimPage?subject=SWIM&classDate=" + strDate, '', 'status=no, height=300, width=600, left='+ popupX + ', top='+ popupY + ', scrollbars=yes,resizable=yes');
		})

	} // fnGetClassList
	
	
</script>
<style>

	#calendar {
	    width: 600px;
  		height: 550px;
	    margin: 0 auto;
	    font-size: 90%;
  	}
  	
  	#title{
  		/* display: flex; */
  		margin: 0px auto 10px auto;
  		text-align: center;
  	}
  	
  	#titleName{
  		font-size: 3.75em;
  		margin: auto;
  	}
  	
  	#swimImage{
  		width : 100px;
  		height: 100px;
  		display : block;
  		margin: auto;
  	}
  
  	
  	#wrapper{
  		background-color : white;
  		width : 700px;
  		height: 770px;
  		margin : auto;
  		border-radius : 50px;
  		margin : 30px auto;
  		padding: 10px 10px;
  		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
  	}


</style>
</head>
<body>
	
	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>	
	
	<div id="wrapper">
		<div id="title">
			
			<img id="swimImage" alt="수영" src="../resources/images/swim.png">				
			<div id="titleName">SWIM</div>
		</div>
		<div id="calendar"></div>
	</div>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
	
	
	
	
</body>
</html>