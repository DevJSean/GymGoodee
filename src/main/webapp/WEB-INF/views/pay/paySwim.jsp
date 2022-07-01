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
<style>

	#swimImage{
		width : 150px;
		height: 150px;
		display : block;
		margin: auto;
	}
  	
  	#wrapper{
		background-color : white;
		width : 800px;
		height: 900px;
		margin : auto;
		border-radius : 50px;
	}
	#nav{
		position: center;
	}
  	
</style>
</head>
<body>
	
	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<div id="wrapper">
		<h1>수강권 구매</h1><br>
		<div><img id="swimImage" alt="수영" src="../resources/images/swim.png"></div>		
	
		<div class="nav"><h3>아래 버튼을 클릭하여 선택해 주세요</h3></div>
		<br>
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
	</div>
	
	
</body>
</html>