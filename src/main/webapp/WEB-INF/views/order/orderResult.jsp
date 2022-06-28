<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <title>결제요청 결과</title>
  </head>

<body>

	<c:if test="${payDate == null}">
		<h1>결제 취소</h1>
		<input type="button" value="다시 예약하기" id=""  onclick="location.href='${contextPath}/phg'">
	</c:if>

	<c:if test="${payDate != null}">
		<h1>${pay_msg}</h1>
		결제 방식 = 
		<c:if test="${pay_type == 'transfer' and card_ver == '01'}">
			계좌이체 결제
		</c:if>
		<c:if test="${pay_type == 'card' and card_ver == '01'}">
			신용카드 간편결제
		</c:if>
		<c:if test="${pay_type == 'card' and card_ver == '02'}">
			앱카드 결제
		</c:if>
		<br>
		구매자 성함 = ${memberName}
		<br>
		구매자 연락처 = ${memberPhone}
		<br>
		구매자 이메일 = ${memberEmail}
		<br>
		상품명 = ${ticketName}
		<br>
		결제 금액 = ${ticketPrice}
		<br>
		영수증 = <span><a href="${pay_cardreceipt}">결제 전표 확인</a></span>	<!-- 카드 매출전표 URL -->
		<div>※ 결제 금액은 익일 오전 04시 경 자동 환급됩니다.</div>
		<input type="button" value="결제 확인" id=""  onclick="location.href='${contextPath}/mypage/myPayList?memberNo=${memberNo}'">
    </c:if>


</body>
</html>














































