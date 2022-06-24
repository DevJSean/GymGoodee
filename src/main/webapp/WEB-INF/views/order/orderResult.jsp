<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <title>결제요청 결과</title>
  </head>

<body>

	<c:if test="${payDate == null}">
		<h1>실패!</h1>
	</c:if>

	<c:if test="${payDate != null}">
		PCD_PAY_RST = ${pay_rst}		<!-- 요청결과 -->
		<br>
		PCD_PAY_MSG = ${pay_msg}		<!-- 요청결과 메세지 -->
		<br>
		PCD_PAY_TYPE = ${pay_type}		<!-- 결제수단 -->
		<br>
		PCD_PAY_WORK = ${pay_work}		<!-- 결제요청 방식* REST에서 사용될때는 요청작업의 종류를 표시 "AUTH" or "PAY" or "CERT" or REST API 사용시 각 API에 해당하는 값 -->
		<br>
		PCD_PAYER_NO = ${memberNo}		<!-- 고객번호 -->
		<br>
		PCD_PAYER_NAME = ${memberName}	<!-- 결제고객 이름 -->
		<br>
		PCD_PAYER_HP = ${memberPhone}	<!-- 고객 연락처 -->
		<br>
		PCD_PAYER_EMAIL = ${memberEmail}	<!-- 고객 이메일 -->
		<br>
		PCD_PAY_GOODS = ${ticketName}	<!-- 상품명 -->
		<br>
		PCD_PAY_TOTAL = ${ticketPrice}	<!-- 결제 요청금액 -->
		<br>
		PCD_PAY_CARDRECEIPT = ${pay_cardreceipt}	<!-- 카드 매출전표 URL -->
		<br>
		PCD_PAY_TIME = ${payDate}		<!-- 결제시간 -->
		<br>
		TICKET_NO = ${ticketNo}			<!-- 결제번호 -->
    </c:if>


</body>
</html>














































