<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
<title>결제정보 확인</title>
    <script src="../resources/js/jquery-3.6.0.js"></script>


<!-- payple js 호출. 테스트/운영 선택 -->
<script src="https://democpay.payple.kr/js/cpay.payple.1.0.1.js"></script> <!-- TEST (테스트) -->
	<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">


<script>
	$(document).ready(
		function() {
			
			// callBack 함수 사용
			var getResult = function(res) {
				var url = "${contextPath}/order/orderResult";
				var $form = $('<form></form>');
				$form.attr('action', url);
				$form.attr('method', 'post');
				$.each(res, function(key, val) {
					var input = $('<input type="hidden" name="' + key + '" value="' + val + '">');
					$form.append(input);
				});
				
				var input2 = '<input type="hidden" name="ticketNo" value="${ticketNo}">';
				input2 += '<input type="hidden" name="ticketSubject" value="${ticketSubject}">';
				input2 += '<input type="hidden" name="ticketCount" value="${ticketCount}">';
				input2 += '<input type="hidden" name="ticketPeriod" value="${ticketPeriod}">';
				$form.append(input2);
				
				$form.appendTo('body');
				$form.submit();
			};
			// 결제 요청
			$("#payAction").on("click", function() {
				var pay_type = "${pay_type}";
				var pay_work = "${pay_work}";
				var memberId = "${memberId}";
				var memberNo = "${memberNo}";
				var memberName = "${memberName}";
				var memberPhone = "${memberPhone}";
				var memberEmail = "${memberEmail}";
				var ticketName = "${ticketName}";
				var ticketPrice = Number("${ticketPrice}");
				var card_ver = "${card_ver}";
				var pcd_rst_url = "";
				var obj = new Object();
				/* 결제연동 파라미터 */
				//DEFAULT SET 1
				obj.PCD_PAY_TYPE = pay_type; 	// (필수) 결제수단 (transfer|card)
				obj.PCD_PAY_WORK = pay_work; 	// (필수) 결제요청 방식 (AUTH | PAY | CERT)
				// 카드결제 시 필수 (카드 세부 결제방식)
				obj.PCD_CARD_VER = card_ver; 	// Default: 01 (01: 간편/정기결제, 02: 앱카드)
				// 2.1 첫결제 및 단건(일반,비회원)결제
				if (pay_work != 'AUTH') {
					obj.PCD_PAY_GOODS = ticketName; 			// (필수) 상품명
					obj.PCD_PAY_TOTAL = ticketPrice; 			// (필수) 결제요청금액
					obj.PCD_PAYER_NO = memberNo; 				// (선택) 결제자 고유번호 (파트너사 회원 회원번호) (결과전송 시 입력값 그대로 RETURN)
					obj.PCD_PAYER_NAME = memberName; 			// (선택) 결제자 이름
					obj.PCD_PAYER_HP = memberPhone; 			// (선택) 결제자 휴대전화번호
					obj.PCD_PAYER_EMAIL = memberEmail; 			// (선택) 결제자 이메일
				}
				// DEFAULT SET 2
				obj.PCD_RST_URL = pcd_rst_url; 				// (필수) 결제(요청)결과 RETURN URL
				obj.callbackFunction = getResult; 		// (선택) 결과를 받고자 하는 callback 함수명 (callback함수를 설정할 경우 PCD_RST_URL 이 작동하지 않음)
				// 파트너 인증시 받은 AuthKey 값 입력
				obj.PCD_AUTH_KEY = "${authKey}";
				// 파트너 인증시 받은 return_url 값 입력
				obj.PCD_PAY_URL = "${payReqURL}";
				PaypleCpayAuthCheck(obj);
			});
		});
</script>


	<style>
	
	#orderConfirmForm {
		background-color : white;
		width : 800px;
		height: 650px;
		margin : 0 auto 40px;
		border-radius : 50px;
		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
	}
	
	#titleName{
        font-size: 2.75em;
        padding: 40px 0 0 0;
        margin: 40px;
     }
	
	#orderConfirmTable {
		width: 700px;
		margin: 50px 0 30px 50px;
		border: 1px;
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
		padding: 5px 0 5px 10px;
		width: 75%;
		border-top: 1px solid grey;
	}
	.last {
		border-bottom: 1px solid grey;
	}
	
	button {
		font-size: 1.0625em;
		background-color : lightgrey;
		border : 1px solid lightgrey;
		border-radius : 3px;
		cursor: pointer;
		float : right;
		margin: 10px 80px 0 0;
		width: 100px;
		height: 30px;
   }
   
   button:hover{
		background-color : #2C3E50;
		border : 1px solid #2C3E50;
		color: #F5F6F7;
   } 
	</style>

</head>

<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>

	<div id="orderConfirmForm">
		<div id="titleName">| 결제 정보 확인</div>
		<table id="orderConfirmTable">
			<tbody>
				<tr>
					<th>결제자 이름</th>
					<td>${memberName}</td>
				</tr>
				<tr>
					<th>결제자 연락처</th>
					<td>${memberPhone}</td>
				</tr>
				<tr>
					<th>결제자 이메일</th>
					<td>${memberEmail}</td>
				</tr>
				<tr>
					<th>회원아이디</th>
					<td>${memberId}</td>
				</tr>
				<tr>
					<th>구매상품</th>
					<td>${ticketName}</td>
				</tr>
				<tr>
					<th>결제금액</th>
					<td>${ticketPrice}</td>
				</tr>
				<tr>
					<th class="last">결제 수단</th>
					<td class="last">
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
			</tbody>
		</table>
		<br>
		<button id="payAction">결제하기</button>
	
	</div>

	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>
