<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>
	$(function() {
		fnRemainTickets();
	})

	// 보유수강권 정보
	function fnRemainTickets() {
		$.ajax({
			// 요청
			url: '${contextPath}/remainTickets',
			data: 'memberId=${loginMember.memberId}',
			type: 'get',
			// 응답
			dataType: 'json',
			success: function(obj) {
				$('#myTickets').empty();
				$.each(obj.remainTickets, function(i, remainTicket) {
					let subject = null;
					switch(remainTicket.remainTicketSubject) {
					case 'SWIM': subject = '수영';
						break;
					case 'DANCE': subject = '스포츠댄스';
						break;
					case 'SPINNING': subject = '스피닝';
						break;
					case 'PILATES': subject = '필라테스';
						break;
					}
					$('#myTickets')
					.append($('<div>').text(subject + '\t' + remainTicket.remainTicketEndDate));
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

	<h1>결제내역</h1>
	
	<jsp:include page="../layout/header.jsp"></jsp:include>
	
	<section>
		
		<nav>
			<ul class="myPageNav">
				<li class="navItem"><a href="${contextPath}/mypage/myReserveList?memberNo=${loginMember.memberNo}&memberId=${loginMember.memberId}">수강내역</a></li>
				<li class="navItem nowPage">결제내역</li>
				<li class="navItem"><a href="${contextPath}/mypage/myInfo?memberNo=${loginMember.memberNo}">개인정보</a></li>
			</ul>	
		</nav>
		
		
    	수강권 만료일
	    <div id="myTickets">
	    </div>
		
		<table>
			<thead>
				<tr>
					<td>번호</td>
					<td>수강권</td>
					<td></td>
					<td></td>
					<td>결제번호</td>
					<td>결제금액</td>
					<td>결제일</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${payList}" var="pay">
					<tr>
						<td>${pay.rn}</td>
						<td>${pay.ticket.ticketSubject}</td>
						<td>${pay.ticket.ticketPeriod}일</td>
						<td>${pay.ticket.ticketCount}회</td>
						<td>${pay.payListNo}</td>
						<td>${pay.ticket.ticketPrice}원</td>
						<td>${pay.payListDate}</td>
					</tr>
				</c:forEach>			
			</tbody>
		</table>
		
	</section>

</body>
</html>