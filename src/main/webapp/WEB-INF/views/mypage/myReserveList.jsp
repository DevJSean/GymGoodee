<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
<script>
	
	$(function() {
		fnSubjectList();
		fnCommingReserveList();
		fnOverReserveList();
		fnReserveCancle();
		fnGetTime();
		fnWriteReview();
		fnPagingLink();
	})
	
	// 오늘 날짜 추출
	var now = Date.now();
	var today = new Date(now);
	var year = today.getFullYear().toString();
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);
	var todayDate = year + month + day;
	
	
    // 예약일시 타임스탬프 날짜 형태로 수정
    function fnGetTime(date){
    	var date = new Date(date);
        return date.getFullYear() + "-" + ('0' + (date.getMonth() + 1)).slice(-2) + "-" + ('0' + date.getDate()).slice(-2) + " " + date.getHours() + ":" + ('0' + date.getMinutes()).slice(-2) + ":" + ('0' + date.getSeconds()).slice(-2) + ":" + date.getMilliseconds();
    }
	
    // 처음 수강내역 확인시 전체목록조회
    function fnCommingReserveList() {
		$.ajax({
			// 요청
			url: '${contextPath}/mypage/myCommingReserveList',
			data: 'subject=${remainTicket.remainTicketSubject}',
			type: 'get',
			// 응답
			dataType: 'json',
			success: function(obj) {
				$('#commingReservationsList').empty();
				$('#commingTotalCount').text(obj.commingTotalCount);
				if(obj.commingTotalCount == 0) {
					var tr = $('<tr>')
					.append($('<td colspan="5">').text('예약된 내역이 없습니다.'));
					$(tr).appendTo('#commingReservationsList');
				} 
				$.each(obj.commingReservations, function(i, comming) {
					var tr = $('<tr>')
					.append($('<td>').text(comming.rn))
					.append($('<td>').text(comming.classDate))
					.append($('<td>').text(comming.classTime));
					if(comming.reservationCode.startsWith('SWIM')) {
						$(tr).append($('<td>').text('수영'))
						.append($('<input type="hidden" name="remainTicketSubject" value="SWIM">'));
					} else if(comming.reservationCode.startsWith('DANCE')) {
						$(tr).append($('<td>').text('스포츠댄스'))
						.append($('<input type="hidden" name="remainTicketSubject" value="DANCE">'));
					} else if(comming.reservationCode.startsWith('SPINNING')) {
						$(tr).append($('<td>').text('스피닝'))
						.append($('<input type="hidden" name="remainTicketSubject" value="SPINNING">'));
					} else if(comming.reservationCode.startsWith('PILATES')) {
						$(tr).append($('<td>').text('필라테스'))
						.append($('<input type="hidden" name="remainTicketSubject" value="PILATES">'));
					}
					$(tr).append($('<td>').text(fnGetTime(comming.reservationDate)));
					if(comming.classDate == todayDate) {
						$(tr).append($('<td>').text('취소불가'));
					} else {
						$(tr).append($('<td>').html('<input type="button" value="예약취소" class="btnReserveCancle" data-reservation_code="' + comming.reservationCode + '">'));
					}
					
					$(tr).appendTo('#commingReservationsList');
				})
			}
		})	// ajax
	}
    
	// 전체 예약 내역 종목별로 보여주기
	var page = 1;  // 초기화
	function fnSubjectList() {
		$('body').on('click', '.subjectTab', function() {
			$('.tab').addClass('not_clicked').removeClass('clicked');
			$(this).parent().addClass('clicked').removeClass('not_clicked');
			$.ajax({
				// 요청
				url: '${contextPath}/mypage/myCommingReserveList',
				data: 'subject=' + $(this).data('subject'),
				type: 'get',
				// 응답
				dataType: 'json',
				success: function(obj) {
					$('#commingReservationsList').empty();
					$('#commingTotalCount').text(obj.commingTotalCount);
					if(obj.commingTotalCount == 0) {
						var tr = $('<tr>')
						.append($('<td colspan="5">').text('예약된 내역이 없습니다.'));
						$(tr).appendTo('#commingReservationsList');
					} 
					$.each(obj.commingReservations, function(i, comming) {
						var tr = $('<tr>')
						.append($('<td>').text(comming.rn))
						.append($('<td>').text(comming.classDate))
						.append($('<td>').text(comming.classTime));
						if(comming.reservationCode.startsWith('SWIM')) {
							$(tr).append($('<td>').text('수영'))
							.append($('<input type="hidden" name="remainTicketSubject" value="SWIM">'));
						} else if(comming.reservationCode.startsWith('DANCE')) {
							$(tr).append($('<td>').text('스포츠댄스'))
							.append($('<input type="hidden" name="remainTicketSubject" value="DANCE">'));
						} else if(comming.reservationCode.startsWith('SPINNING')) {
							$(tr).append($('<td>').text('스피닝'))
							.append($('<input type="hidden" name="remainTicketSubject" value="SPINNING">'));
						} else if(comming.reservationCode.startsWith('PILATES')) {
							$(tr).append($('<td>').text('필라테스'))
							.append($('<input type="hidden" name="remainTicketSubject" value="PILATES">'));
						}
						$(tr).append($('<td>').text(fnGetTime(comming.reservationDate)));
						if(comming.classDate == todayDate) {
							$(tr).append($('<td>').text('취소불가'));
						} else {
							$(tr).append($('<td>').html('<input type="button" value="예약취소" class="btnReserveCancle" data-reservation_code="' + comming.reservationCode + '">'));
						}
						
						$(tr).appendTo('#commingReservationsList');
					})
				}
			})	// ajax
			$.ajax({
				url: '${contextPath}/mypage/myOverReserveList',
				data: 'page=' + page + '&subject=' + $(this).data('subject'),
				type: 'get',
				dataType: 'json',
				success: function(obj){
					$('#overTotalCount').text(obj.overTotalCount);
					fnPrintOverReservationList(obj);
					fnPrintPaging(obj.p);
				}
			})	// ajax
		})
	}
	
	// 예약취소
	function fnReserveCancle() {
		$('body').on('click', '.btnReserveCancle', function() {
			if(confirm('예약을 취소할까요 ?')) {
				$.ajax({
					// 요청
					url: '${contextPath}/reserveCancle',
					data: 'reservationCode=' + $(this).data('reservation_code') + '&memberId=${loginMember.memberId}&remainTicketSubject=' + $(this).parent().prev().prev().val(),
					type: 'get',
					// 응답
					dataType: 'json',
					success: function(obj){
						if(obj.resState > 0 && obj.resRemain > 0) {
							alert('예약이 취소되었습니다.');
							fnRemainTickets();
							fnCommingReserveList();
							fnOverReserveList();
						} else {
							alert('예약취소에 실패했습니다.');
						}
					}
				}) // ajax
			}
		}) // onClick
	}
	
	// 페이징 링크 처리(page 전역변수 값을 링크의 data-page값으로 바꿈)
	function fnPagingLink() {
		$(document).on('click', '.enable_link', function(){
			page = $(this).data('page');
		})
	}
	
	// 지난 예약 목록 전체
	var page = 1;  // 초기화
	function fnOverReserveList() {
		$.ajax({
			url: '${contextPath}/mypage/myOverReserveList',
			data: 'page=' + page + '&subject=${remainTicket.remainTicketSubject}',
			type: 'get',
			dataType: 'json',
			success: function(obj){
				$('#overTotalCount').text(obj.overTotalCount);
				fnPrintOverReservationList(obj);
				fnPrintPaging(obj.p);
			}
		})	// ajax
	}
	
	// 지난 예약 목록 
	function fnPrintOverReservationList(obj){
		$('#overReservations').empty();
		if(obj.overTotalCount == 0) {
			var tr = $('<tr>')
			.append($('<td colspan="5">').text('수강한 내역이 없습니다.'));
			$(tr).appendTo('#overReservations');
		}
		$.each(obj.overReservations, function(i, over){
			var tr = '<tr>';
			tr += '<td>' + over.rn + '</td>';
			tr += '<td>' + over.classDate + '</td>';
			tr += '<td>' + over.classTime + '</td>';
			if(over.reservationCode.startsWith('SWIM')) {
				tr += '<td>수영</td>';
			} else if (over.reservationCode.startsWith('DANCE')) {
				tr += '<td>스포츠댄스</td>';
			} else if (over.reservationCode.startsWith('PILATES')) {
				tr += '<td>필라테스</td>';
			} else if (over.reservationCode.startsWith('SPINNING')) {
				tr += '<td>스피닝</td>';
			}
			tr += '<td>' + fnGetTime(over.reservationDate) +'</td>';
			tr += '<td><input type="button" value="리뷰작성" class="review" data-class_code="' + over.classCode +'"></td>';
			tr += '</tr>';
			$('#overReservations').append(tr);
		})
	}
	
	// 리뷰 작성 버튼 클릭시
	function fnWriteReview() {
		$('body').on('click', '.review', function() {
			location.href='${contextPath}/board/reviewAddPage';
			$('#class').val($(this).data('class_code'));
		})
	}
	
	// 페이징 정보 출력
	function fnPrintPaging(p){
		
		$('#paging').empty();
		
		var paging = '';
		
		// ◀◀ : 이전 블록으로 이동
		if(page <= p.pagePerBlock){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-left"></i><i class="fa-solid fa-caret-left"></i></div>';
		} else {
			paging += '<div class="enable_link" data-page="' + (p.beginPage - 1) + '"><i class=\"fa-solid fa-caret-left\"></i><i class=\"fa-solid fa-caret-left\"></i></div>';
		}
		
		// ◀  : 이전 페이지로 이동
		if(page == 1){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-left"></i></div>';
		} else {
			paging += '<div class="enable_link" data-page="' + (page - 1) + '"><i class=\"fa-solid fa-caret-left\"></i></div>';
		}
		
		// 1 2 3 4 5 : 페이지 번호
		for(let i = p.beginPage; i <= p.endPage; i++){
			if(i == page){
				paging += '<div class="disable_link nowUnlinkPage">' + i + '</div>';
			} else {
				paging += '<div class="enable_link" data-page="' + i + '">' + i + '</div>';
			}
		}
		
		// ▶  : 다음 페이지로 이동
		if(page == p.totalPage){
			paging += '<div class="disable_link"><i class=\"fa-solid fa-caret-right\"></i></div>';
		} else {
			paging += '<div class="enable_link" data-page="' + (page + 1) + '"><i class=\"fa-solid fa-caret-right\"></i></div>';
		}
		
		// ▶▶ : 다음 블록으로 이동
		if(p.endPage == p.totalPage){
			paging += '<div class="disable_link"><i class=\"fa-solid fa-caret-right\"></i><i class=\"fa-solid fa-caret-right\"></i></div>';
		} else {
			paging += '<div class="enable_link" data-page="' + (p.endPage + 1) + '"><i class=\"fa-solid fa-caret-right\"></i><i class=\"fa-solid fa-caret-right\"></i></div>';
		}
		
		$('#paging').append(paging);
		
	}
	
</script>
<style>
    /* 왼쪽 네비게이션 */
    .myPageNav {
        display: flex;
        width: 100px;
        flex-direction: column;
        list-style-type: none;
    }
    .navItem {
        background-color: white; 
        padding: 15px;
        cursor: pointer;
        border-left: 2px solid  rgba(44, 62, 80, 0.65); 
        border-right: 2px solid  rgba(44, 62, 80, 0.65);
    }
    .navItem a {
        text-align: center;
        text-decoration: none;
        color: rgb(70, 70, 70);
    }
    .nowPage {
        background-color: #2C3E50;
        opacity: 0.65;
        color: #F5F6F7;
    }
    .myPageNav .navItem:first-of-type { 
    	border-radius : 10px 10px 0 0; 
    	border-top: 2px solid  rgba(44, 62, 80, 0.65); 
    }
    .myPageNav .navItem:last-of-type { 
    	border-radius : 0 0 10px 10px; 
    	border-bottom: 2px solid  rgba(44, 62, 80, 0.65); 
    }
    .navItem:hover {
        background-color: #2C3E50;   
        opacity: 1;
    }
    .navItem:hover > a {
        color: #F5F6F7;
    }
    #listNav {
        display: flex;
        margin-right: 20px;
        margin-left: 80px;
        margin-top: 50px;
    }
   
   /* 페이징 */
   #paging{
        display : flex;
        justify-content: center;
      
   }
   #paging div{
        width : 32px;
        height : 20px;
        text-align: center;
   }
   .disable_link, .enable_link {
        display: inline-block;  
        padding: 10px;
        margin: 5px;
        border: 1px solid white;
        text-align: center
        text-decoration: none; 
        color: gray;
        font-size: 20px;
   }
   .enable_link:hover {
        color: #8AAAE5;
        cursor: pointer;
   }
   .nowUnlinkPage {
   		color: black;
   }
   
   /* 개별 페이지 */
	section {
		display: flex;
	}
	table{
        border-collapse: collapse;
        width: 90%;
        text-align: center;
        margin: 0 auto;
        vertical-align: middle;
    }
    table thead tr{
        border-top: 2px solid lightgrey;
        border-bottom: 2px solid lightgrey;
    }
    table tbody tr{
        border-bottom: 1px solid lightgrey;
    }
    table caption {
	  margin: 0 auto 10px auto;
   	  text-align: center;
    }
    td{
        padding: 5px;
        text-align: center;
    }
	.btnReserveCancle {
		height: 24px;
        background-color: lightgrey;
        border: 1px solid lightgrey;
        border-radius: 3px;
        cursor: pointer;
        margin: 2px;
    }
    .btnReserveCancle:hover{
        background-color: #2C3E50; 
		opacity: 0.65;
		color: #F5F6F7;
    } 
    #wrapper{
        background-color: white;
        width: 70%;
        margin: 50px auto;
        border-radius: 50px;
        padding: 30px;
        text-align: left;
        box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
    }
    #btn-wrapper {
    	display: flex;
		margin-left: 5%;
    }
    .tab {
    	display:inline-block;
        width: 70px;
   		height: 50px;
        border: 2px solid rgba(44, 62, 80, 0.65);
        border-bottom: none;
        position: relative;
        text-align: center;
    }
    .tab:hover {
    	background-color: #2C3E50; 
   		opacity: 1;
    }
    .tab:hover a {
    	color: #F5F6F7;
    }
    .subjectTab {
    	width: 100%;
        text-decoration: none;
        position: relative;
        top: 18px;
        padding: 5px;
		margin: 0 auto;
    }
    .subjectTab:hover {
    	cursor: pointer;
    }
    .tab:not(:first-of-type) {
    	border-left: none;
    }
    .tab:first-of-type {
        border-radius: 6px 0 0 0;
    }
    .tab:last-of-type {
        border-radius: 0 6px 0 0;
    }
    .clicked {
   		background-color: #2C3E50; 
   		opacity: 0.8;
    }	
    .clicked a {
   		color: #F5F6F7;
    }
    .not_clicked {
    	bakcgound-color: #FFFFFF;
    }
</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>	
	
	<section>
	
		<nav id="listNav">
			<ul class="myPageNav">
				<li class="navItem nowPage">수강내역</li>
				<li class="navItem"><a href="${contextPath}/mypage/myPayList">결제내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/pwCheckPage">개인정보</a></li>
			</ul>	
		</nav>
	

		<div id="wrapper">
			<div id="btn-wrapper"></div>
			<table>
				<caption>- 다가올 수업 <span id="commingTotalCount"></span>개 -</caption>
				<thead>
					<tr>
						<td>순번</td>
						<td>날짜</td>		
						<td>시간</td>		
						<td>종목</td>		
						<td>예약일시</td>		
					</tr>
				</thead>
				<tbody id="commingReservationsList"></tbody>
			</table>

			<br><br>

			<table>
				<caption>- 지난 수업 <span id="overTotalCount"></span>개 -</caption>
				<thead>
					<tr>
						<td>번호</td>
						<td>날짜</td>		
						<td>시간</td>		
						<td>종목</td>		
						<td>예약일시</td>		
					</tr>
				</thead>
				<tbody id="overReservations"></tbody>
				<tfoot>	
				<tr>
					<td colspan="6">
						<div id="paging"></div>
					</td>
				</tr>
			</tfoot>
			</table>
		
		</div>
	</section>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>