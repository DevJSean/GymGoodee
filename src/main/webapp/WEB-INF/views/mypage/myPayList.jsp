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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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
				<li class="navItem"><a href="${contextPath}/mypage/myReserveList">수강내역</a></li>
				<li class="navItem nowPage">결제내역</li>
				<li class="navItem"><a href="${contextPath}/mypage/myInfo">개인정보</a></li>
			</ul>	
		</nav>
		
		
		<table border="1">
			<caption id="endDate">
			</caption>
			<thead>
				<tr>
					<td>번호</td>
					<td colspan="3">수강권</td>
					<td>결제번호</td>
					<td>결제금액</td>
					<td>결제일</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${payList}" var="pay">
					<tr>
						<td>${pay.rn}</td>
						<c:choose>
							<c:when test="${pay.ticket.ticketSubject eq 'SWIM'}">
								<td>수영</td>
							</c:when>
							<c:when test="${pay.ticket.ticketSubject eq 'DANCE'}">
								<td>스포츠댄스</td>
							</c:when>
							<c:when test="${pay.ticket.ticketSubject eq 'PILATES'}">
								<td>필라테스</td>
							</c:when>
							<c:when test="${pay.ticket.ticketSubject eq 'SPINNING'}">
								<td>스피닝</td>
							</c:when>
						</c:choose>
						<td>${pay.ticket.ticketPeriod}일</td>
						<td>${pay.ticket.ticketCount}회</td>
						<td>${pay.payListNo}</td>
						<td>${pay.ticket.ticketPrice}원</td>
						<td>${pay.payListDate}</td>
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
		
	</section>

</body>
</html>