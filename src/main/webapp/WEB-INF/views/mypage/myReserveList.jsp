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
<script>
	
	$(function() {
		fnCommingReserveList();
		fnReserveCancle();
	})
	
	// 다가올 수업 내역
	function fnCommingReserveList() {
		$.ajax({
			// 요청
			url: '${contextPath}/mypage/myCommingReserveList',
			data: 'memberNo=${loginMember.memberNo}',
			type: 'get',
			// 응답
			dataType: 'json',
			success: function(obj) {
				$('#commingReservationsList').empty();
				$('#commingTotalCount').text(obj.commingTotalCount);
				$.each(obj.commingReservations, function(i, comming) {
					var tr = $('<tr>')
					.append($('<td>').text(comming.rn))
					.append($('<td>').text(comming.classDate));
					switch(comming.classTime) {
					case 'A': $(tr).append($('<td>').text('9:00'));
						break;
					case 'B': $(tr).append($('<td>').text('10:00'));
						break;
					case 'C': $(tr).append($('<td>').text('19:30'));
						break;
					case 'D': $(tr).append($('<td>').text('20:30'));
						break;
					}
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
					$(tr).append($('<td>').text(comming.reservationDate))
					.append(($('<td>').html('<input type="button" value="예약취소" class="btnReserveCancle" data-reservation_code="' + comming.reservationCode + '">')));
					
					$(tr).appendTo('#commingReservationsList');
				})
				
			}
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
							} else {
								alert('예약취소에 실패했습니다.');
							}
						}
					})
				}
			})	
		}
	
	
	
</script>
<style>
	.myPageNav {
		display: flex;
		flex-direction: column;
		width: 100px;
		list-style-type: none;
	}
	.navItem {
		background-color: teal; 
		padding: 15px;
		cursor: pointer;
	}
	.navItem a {
		text-align: center;
		text-decoration: none;
		color: white;
	}
	.navItem:hover {
		background-color: navy;
	}
	nav {
		display: flex;
		margin-right: 30px;
	}
	section {
		display: flex;
	}
	td {
		text-align: center;
	}
	
</style>
</head>
<body>

	<h1>수강내역</h1>
	
	<jsp:include page="../layout/header.jsp"></jsp:include>
	
	<section>
	
		<nav>
			<ul class="myPageNav">
				<li class="navItem nowPage">수강내역</li>
				<li class="navItem"><a href="${contextPath}/mypage/myPayList?memberNo=${loginMember.memberNo}">결제내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myInfo?memberNo=${loginMember.memberNo}">개인정보</a></li>
			</ul>	
		</nav>
	
		<div>
		- 다가올 수업 - <span id="commingTotalCount"></span>개
		<table>
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
		
		- 지난 수업 - ${overTotalCount}개
		<table>
			<thead>
				<tr>
					<td>번호</td>
					<td>날짜</td>		
					<td>시간</td>		
					<td>종목</td>		
					<td>예약일시</td>		
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${overReservations}" var="over">
					<tr>
						<td>${over.rn}</td>
						<td>${over.classDate}</td>
						<c:choose>
							<c:when test="${over.classTime eq 'A'}">
								<td>9:00</td>
							</c:when>
							<c:when test="${over.classTime eq 'B'}">
								<td>10:00</td>
							</c:when>
							<c:when test="${over.classTime eq 'C'}">
								<td>19:30</td>
							</c:when>
							<c:when test="${over.classTime eq 'D'}">
								<td>20:30</td>
							</c:when>
						</c:choose>
						<c:choose>
							<c:when test="${fn:startsWith(over.reservationCode, 'SWIM')}" >
			         			<td>수영</td>
			     			</c:when>
			     			<c:when test="${fn:startsWith(over.reservationCode, 'PILATES')}" >
			         			<td>필라테스</td>
			     			</c:when>
			     			<c:when test="${fn:startsWith(over.reservationCode, 'SPINNING')}" >
			         			<td>스피닝</td>
			     			</c:when>
			     			<c:when test="${fn:startsWith(over.reservationCode, 'DANCE')}" >
			         			<td>스포츠댄스</td>
			     			</c:when>
						</c:choose>
						<td>${over.reservationDate}</td>
					</tr>
				</c:forEach>
			</tbody>
			<tfoot>	
			<tr>
				<td colspan="5">
					${paging}
				</td>
			</tr>
		</tfoot>
		</table>
		</div>
	</section>
</body>
</html>