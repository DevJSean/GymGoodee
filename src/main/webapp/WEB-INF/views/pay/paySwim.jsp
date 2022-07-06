<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수영 결제</title>
	<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
<style>

  	#wrapper {
		background-color : white;
		width : 800px;
		height: 950px;
		margin : 0 auto 40px;
		border-radius : 50px;
		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
	}

  	
  	.title{
  		text-align: center;
  		font-size: 5em;
        padding: 40px 0 0 0;
        margin: 40px;
  	}
	#swimImage {
		width : 150px;
		height: 150px;
		display : block;
		margin: auto;
	}
	.nav {
		text-align: center;
  		font-size: 1.25em;
		margin: 40px 0 0 0;
	}
	
	
	
	fieldset{
		width: 240px;
		height: 400px;
		display: inline;
		border-width: 2px;
		border-style: groove;
		border-radius: 20px;
		margin-left: 15px;
	}
	
	legend {
		width: 100px;
		height: 50px;
		text-align: center;
		font-size: 1.5em;
	}
	.first {
		line-height: 50px;  
	}
	
	
	.price {
		display: block;
		width: 210px;
		height: 130px;
		margin: 35px 14px;
	}
	
	.price > a {
		display: inline-block;
		width: 210px;
		height: 95px;
		text-align: center;
		vertical-align: middle;
		padding-top: 35px;
		font-size: 1.25em;
		line-height: 30px;
		color: #F5F6F7;
		text-decoration: none;
		border: 0;
		border-radius: 10px;
		background-color: #2C3E50;
		opacity: 0.65;
	}
	.price > .line {
		height: 82px;
		padding-top: 48px;
	}
	.price > a:hover {
		background-color: #2C3E50;
		opacity: inherit;
	}
  	
</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<div id="wrapper">
		<div class="title">수강권 구매</div>
		<div><img id="swimImage" alt="수영" src="../resources/images/swim.png"></div>		
	
		<div class="nav">원하시는 수강권을 아래에서 선택해 주세요</div>
		<br><br><br><br><br>
		<fieldset>
			<legend class="first">1개월</legend>
			<div class="price">
				<a class="line" href="${contextPath}/order/order?ticketNo=1">8회 - 8만원</a>
			</div>
			<div class="price">
				<a class="line" href="${contextPath}/order/order?ticketNo=2">16회 - 16만원</a>
			</div>
		</fieldset>
		<fieldset>
			<legend>3개월(10%)</legend>
			<div class="price">
				<a href="${contextPath}/order/order?ticketNo=3">24회 - <del>24만원</del><br>=>&nbsp;&nbsp;21.6만원</a>
			</div>
			<div class="price">
				<a href="${contextPath}/order/order?ticketNo=4">32회 - <del>32만원</del><br>=>&nbsp;&nbsp;28.8만원</a>
			</div>
		</fieldset>
		<fieldset>
			<legend>6개월(20%)</legend>
			<div class="price">
				<a href="${contextPath}/order/order?ticketNo=5">40회 - <del>40만원</del><br>=>&nbsp;&nbsp;32만원</a>
			</div>
			<div class="price">
				<a href="${contextPath}/order/order?ticketNo=6">48회 - <del>48만원</del><br>=>&nbsp;&nbsp;38.4만원</a>
			</div>
		</fieldset>
	</div>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>








































