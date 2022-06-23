<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
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
				<li class="navItem"><a href="${contextPath}/mypage/myReserveList?memberNo=101">수강내역</a></li>
				<li class="navItem nowPage?memberNo=101">결제내역</li>
				<li class="navItem"><a href="${contextPath}/mypage/myInfo?memberNo=101">개인정보</a></li>
			</ul>	
		</nav>
		
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
					<td>이용기간</td>
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
						<td>${pay.payListDate} ~ ${pay.dueDate}</td>
					</tr>
				</c:forEach>			
			</tbody>
		</table>
		
	</section>

</body>
</html>