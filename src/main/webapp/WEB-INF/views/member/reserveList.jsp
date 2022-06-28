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

	$(function(){
		fnReserveCancle();
	})



		function fnReserveCancle() {
			$('body').on('click', '.btnReserveCancle', function() {
				if(confirm('예약을 취소할까요 ?')) {
					$.ajax({
						// 요청
						url: '${contextPath}/member/reserveCancle',
						data: 'reservationCode=' + $(this).data('reservation_code') + '&memberId=' + $(this).next().val() + '&remainTicketSubject=' + $(this).prev().val(),
						type: 'get',
						// 응답
						dataType: 'json',
						success: function(obj){
							if(obj.resState > 0 && obj.resRemain > 0) {
								alert('예약이 취소되었습니다.');
								location.href = '${contextPath}/member/reserveList';
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

	<h1>관리자페이지</h1>
	
	<jsp:include page="../layout/header.jsp"></jsp:include>
	<c:if test="${loginMember.memberId eq 'admin'}">
		<section>
		
			<nav>
				<ul class="myPageNav">
					<li class="navItem"><a href="${contextPath}/member/memberList">회원목록</a></li>
					<li class="navItem"><a href="${contextPath}/member/payList">결제내역</a></li>
					<li class="navItem"><a href="${contextPath}/member/classList">개설강좌</a></li>
					<li class="navItem nowPage">예약내역</li>
				</ul>	
			</nav>
		
			<div>
			<table>
				<thead>
					<tr>
						<td>번호</td>
						<td>예약코드</td>
						<td>아이디</td>		
						<td>강좌코드</td>		
						<td>신청일시</td>		
						<td>예약상태</td>		
						<td></td>		
					</tr>
				</thead>
				<tbody>
					<c:forEach var="reservation" items="${reservations}">
						<tr>
							<td>${totalRecord - reservation.rn + 1}</td>
							<td>${reservation.reservationCode}</td>
							<td>${reservation.memberId}</td>
							<td>${reservation.classCode}</td>
							<td>${reservation.reservationDate}</td>
							
							<td>
								<c:if test="${reservation.reservationState == -1}">
									예약취소							
								</c:if>
								<c:if test="${reservation.reservationState == 0}">
									예약완료							
								</c:if>
								<c:if test="${reservation.reservationState == 1}">
									수강완료							
								</c:if>
							</td>
							
							<td>
								<c:if test="${fn:startsWith(reservation.reservationCode, 'SWIM')}">
									<input type="hidden" name="remainTicketSubject" value="수영">
								</c:if>
								<c:if test="${fn:startsWith(reservation.reservationCode, 'DANCE')}">
									<input type="hidden" name="remainTicketSubject" value="스포츠댄스">
								</c:if>
								<c:if test="${fn:startsWith(reservation.reservationCode, 'SPINNING')}">
									<input type="hidden" name="remainTicketSubject" value="스피닝">
								</c:if>
								<c:if test="${fn:startsWith(reservation.reservationCode, 'PILATES')}">
									<input type="hidden" name="remainTicketSubject" value="필라테스">
								</c:if>
								
								<c:if test="${reservation.reservationState == 0}">
									<input type="button" value="예약취소" class="btnReserveCancle" data-reservation_code="${reservation.reservationCode}">
									<input type="hidden" name="memberId" value="${reservation.memberId}">
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>	
					<tr>
						<td colspan="7">
							${paging}
						</td>
					</tr>
				</tfoot>
			</table>
			</div>
		</section>
	</c:if>
	<c:if test="${loginMember.memberId ne 'admin'}">
		<a href="${contextPath}/member/loginPage">관리자 페이지는 관리자만 확인할 수 있습니다.</a>
	</c:if>
</body>
</html>