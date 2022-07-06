<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수영 결제</title>
	<script src="../resources/js/jquery-3.6.0.js"></script>
	<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
</head>
<body>
	
	<h1>수강권 구매</h1><br>
	<h3>아래 버튼을 클릭하여 선택해 주세요</h3>
	<br>
	<hr>
	<br><br><br>
	
	
	<ul class="paymentNav">
		<li class="paySwim"><a href="${contextPath}/pay/paySwim">수영</a></li>
		<li class="payPilates"><a href="${contextPath}/pay/payPliates">필라테스</a></li>
		<li class="paySpinning"><a href="${contextPath}/pay/paySpinning">스피닝</a></li>
		<li class="payDance">스포츠 댄스</li>
	</ul>
	
	
	<br><br><br>
	<hr>
	<br><br><br>
	
	<table border="1">
		<thead>
			<tr>
				<td>1개월</td>
				<td></td>
				<td>3개월(10%)</td>
				<td></td>
				<td>6개월(20%)</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><a href="${contextPath}/order/order?ticketNo=7">8회 - 8만원</a></td>
				<td></td>
				<td><a href="${contextPath}/order/order?ticketNo=9">24회 - 21.6만원</a></td>
				<td></td>
				<td><a href="${contextPath}/order/order?ticketNo=11">40회 - 32만원</a></td>
			</tr>
			<tr>
				<td><a href="${contextPath}/order/order?ticketNo=8">16회 - 16만원</a></td>
				<td></td>
				<td><a href="${contextPath}/order/order?ticketNo=10">32회 - 28.8만원</a></td>
				<td></td>
				<td><a href="${contextPath}/order/order?ticketNo=12">48회- 38.4만원</a></td>
			</tr>
		</tbody>
	</table>
	
	<jsp:include page="../layout/footer.jsp"></jsp:include>
	
</body>
</html>































