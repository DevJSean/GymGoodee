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

	})
	
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
					<li class="navItem"><a href="${contextPath}/admin/memberList">회원목록</a></li>
					<li class="navItem"><a href="${contextPath}/admin/addTeacherPage">강사등록</a></li>
					<li class="navItem"><a href="${contextPath}/admin/addClassPage">강좌개설</a></li>
					<li class="navItem"><a href="${contextPath}/admin/classList">개설강좌</a></li>
					<li class="navItem"><a href="${contextPath}/admin/reserveList">예약내역</a></li>
					<li class="navItem nowPage">결제내역</li>
				</ul>	
			</nav>
		
			<div>
			<table>
				<thead>
					<tr>
						<td>번호</td>
						<td>아이디</td>		
						<td>수강권</td>
						<td></td>
						<td></td>		
						<td>결제번호</td>
						<td>결제금액</td>
						<td>결제일</td>		
					</tr>
				</thead>
				<tbody>
					<c:forEach var="payList" items="${pays}">
						<tr>
							<td>${payList.rn}</td>
							<td>${payList.memberId}</td>
							<c:choose>
								<c:when test="${payList.ticket.ticketSubject eq 'SWIM'}">
									<td>수영</td>
								</c:when>
								<c:when test="${payList.ticket.ticketSubject eq 'DANCE'}">
									<td>스포츠댄스</td>
								</c:when>
								<c:when test="${payList.ticket.ticketSubject eq 'PILATES'}">
									<td>필라테스</td>
								</c:when>
								<c:when test="${payList.ticket.ticketSubject eq 'SPINNING'}">
									<td>스피닝</td>
								</c:when>
							</c:choose>
							<td>${payList.ticket.ticketPeriod}일</td>
							<td>${payList.ticket.ticketCount}회</td>
							<td>${payList.payListNo}</td>
							<td>${payList.ticket.ticketPrice}</td>
							<td>${payList.payListDate}</td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>	
					<tr>
						<td colspan="8">
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