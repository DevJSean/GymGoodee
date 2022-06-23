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
				<li class="navItem"><a href="${contextPath}/mypage/myPayList?memberNo=101">결제내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myInfo?memberNo=101">개인정보</a></li>
			</ul>	
		</nav>
	
		<div>
		- 다가올 수업 - ${commingTotalCount}개
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
			<tbody>
				<c:forEach items="${commingReservations}" var="comming">
					<tr>
						<td>${comming.rn}</td>
						<td>${comming.classDate}</td>
						<c:choose>
							<c:when test="${comming.classTime eq 'A'}">
								<td>9:00</td>
							</c:when>
							<c:when test="${comming.classTime eq 'B'}">
								<td>10:00</td>
							</c:when>
							<c:when test="${comming.classTime eq 'C'}">
								<td>19:30</td>
							</c:when>
							<c:when test="${comming.classTime eq 'D'}">
								<td>20:30</td>
							</c:when>
						</c:choose>
						<c:choose>
							<c:when test="${fn:startsWith(comming.reservationCode, 'SWIM')}" >
			         			<td>수영</td>
			     			</c:when>
			     			<c:when test="${fn:startsWith(comming.reservationCode, 'PILATES')}" >
			         			<td>필라테스</td>
			     			</c:when>
			     			<c:when test="${fn:startsWith(comming.reservationCode, 'SPINNING')}" >
			         			<td>스피닝</td>
			     			</c:when>
			     			<c:when test="${fn:startsWith(comming.reservationCode, 'DANCE')}" >
			         			<td>스포츠댄스</td>
			     			</c:when>
						</c:choose>
						<td>${comming.reservationDate}</td>
						<td><input type="button" value="예약취소" id="btnCancle"></td>
					</tr>
				</c:forEach>
			</tbody>
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