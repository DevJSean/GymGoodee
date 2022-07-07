<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
    <title>결제 내역</title>
    <link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
    
    
<style>
	
	#orderResultForm {
		background-color : white;
		width : 800px;
		height: 650px;
		margin : 40px auto;
		border-radius : 50px;
		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
	}
	img {
		float: left;
        margin-top: 40px;
        margin-left: 40px;
		width: 50px;
		height: 50px;
	}
	#titleName {
        font-size: 2.75em;
        padding-top: 40px;
        margin-left: 105px;
     }
     #sub {
        font-size: 2em;
        margin-top: 10px;
        margin-left: 110px;
     }
	
	
	#orderResultTable {
		width: 700px;
		margin: 50px 0 40px 50px;
		border: 1px;
		border-radius: 15px;
		line-height: 35px;
		border-collapse: separate;
	}
	th {
		width: 25%;
		text-align: left;
		padding: 5px 0 5px 20px;
		background-color: #2C3E50;
		opacity: 0.65;
		color: #F5F6F7;
		border-top: 1px solid lightgrey;
		border-right: 1px solid lightgrey;
	}
	
	td{
		padding: 5px 0 5px 20px;
		width: 75%;
		border-top: 1px solid grey;
	}
	.last{
		border-bottom: 1px solid grey;
	}
	.tag {
		line-height: 0;
		font-size: 0.5em;
	}
	
	
	
	input[type=button]{
		font-size: 1.0625em;
		background-color : lightgrey;
		border : 1px solid lightgrey;
		border-radius : 3px;
		cursor: pointer;
		float : right;
		margin: 10px 80px 0 0;
		width: 130px;
		height: 30px;
	}
   
	input[type=button]:hover{
		background-color : #2C3E50;
		border : 1px solid #2C3E50;
		color: #F5F6F7;
	} 
</style>

</head>
    
    
    
    
    
  </head>

<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>

	<c:if test="${payDate == null}">
		<form id="orderResultForm">
			<div id="wrap">
				<img src="../resources/images/remove.png">
				<div id="titleName">결제 취소</div>
				<br>
				<div id="sub">다시 결제하시려면 아래버튼을 클릭해주세요</div>
			</div>
			<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
			<input type="button" value="다시 예약하기" id=""  onclick="location.href='${contextPath}/pay/paySwim'">
		</form>
	</c:if>

	<c:if test="${payDate != null}">
		<form id="orderResultForm">
			<img id="checkImage" src="../resources/images/check2.png">
			<div id="titleName">${pay_msg}</div>
			<table id="orderResultTable">
				<tbody>
					<tr>
						<th>결제 수단</th>
						<td>
							<c:if test="${pay_type == 'transfer' and card_ver == '01'}">
								계좌이체 결제
							</c:if>
							<c:if test="${pay_type == 'card' and card_ver == '01'}">
								신용카드 간편결제
							</c:if>
							<c:if test="${pay_type == 'card' and card_ver == '02'}">
								앱카드 결제
							</c:if>
						</td>
					</tr>
					<tr>
						<th>구매자 성함</th>
						<td>${memberName}</td>
					</tr>
					<tr>
						<th>구매자 연락처</th>
						<td>${memberPhone}</td>
					</tr>
					<tr>
						<th>구매자 이메일</th>
						<td>${memberEmail}</td>
					</tr>
					<tr>
						<th>상품명</th>
						<td>${ticketName}</td>
					</tr>
					<tr>
						<th>결제금액</th>
						<td>${ticketPrice}</td>
					</tr>
					<tr>
						<th class="last">영수증</th>
						<td class="last"><a href="${pay_cardreceipt}">결제 전표 확인</a>&nbsp;&nbsp;<span class="tag">※ 결제 금액은 익일 오전 04시 경 자동 환급됩니다.</span></td>
					</tr>
				</tbody>
			</table>
			<br>
			<input type="button" value="결제 확인" id=""  onclick="location.href='${contextPath}/mypage/myPayList'">

		</form>
    </c:if>

	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>

</body>
</html>














































