<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수영 결제</title>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=ce1eb18e13a39e414dcad60a6592533c"></script>

</head>
<body>
	
	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<h1>수강권 구매</h1><br>
	<h3>아래 버튼을 클릭하여 선택해 주세요</h3>
	<br>
	<hr>
	<br><br><br>
	
	<ul class="paymentNav">
		<li class="paySwim">수영</li>
		<li class="payPilates"><a href="${contextPath}/pay/payPliates">필라테스</a></li>
		<li class="paySpinning"><a href="${contextPath}/pay/paySpinning">스피닝</a></li>
		<li class="payDance"><a href="${contextPath}/pay/payDance">스포츠 댄스</a></li>
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
				<td><a href="${contextPath}/order/order?ticketNo=1">8회 - 8만원</a></td>
				<td></td>
				<td><a href="${contextPath}/order/order?ticketNo=3">24회 - 21.6만원</a></td>
				<td></td>
				<td><a href="${contextPath}/order/order?ticketNo=5">40회 - 32만원</a></td>
			</tr>
			<tr>
				<td><a href="${contextPath}/order/order?ticketNo=2">16회 - 16만원</a></td>
				<td></td>
				<td><a href="${contextPath}/order/order?ticketNo=4">32회 - 28.8만원</a></td>
				<td></td>
				<td><a href="${contextPath}/order/order?ticketNo=6">48회 - 38.4만원</a></td>
			</tr>
		</tbody>
	</table>
	
	
</body>
</html>