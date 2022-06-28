<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <title>결제창 데모</title>

    <script src="../resources/js/jquery-3.6.0.js"></script>


	<script>
	$(document).ready(function () {
		$("#orderFormSubmit").on("click", function (event) {
			var fm = $("#orderForm")[0];
			if ($('#memberPhone').val() == '카카오가입') {
				alert('마이페이지에서 비밀번호를 수정해 주세요.')
				location.href="${contextPath}/mypage/myInfo"
				return false;
			}
			fm.method = "POST";
			fm.action = "${contextPath}/order/orderConfirm";
			fm.submit();
		});

        /*
         *  #pay_type: 결제수단
         *  #taxsave_view: 현금영수증 발행여부 view
         *  #card_ver_view: 카드 세부 결제방식 view
         */
		$("#pay_type").on("change", function (e) {
			e.preventDefault();
			
			if ($(this).val() == "card") {
				$("#card_ver_view").css("display", "");
			} else {
				$("#card_ver_view").css("display", "none");
			}
		
			$("#card_ver").on("change", function () {
				if ($(this).val() == "01") {
					$('#pay_work option[value*="AUTH"]').prop("disabled", false);
				} else {
					$('#pay_work option[value*="AUTH"]').prop("disabled", true);
				}
			});
		});	
	});
	</script>

</head>
<body>
    <form id="orderForm" name="orderForm">
        <h2>| 주문 정보 설정</h2>
        <table border="1">
        	<thead>
				<tr>
					<th>항목</th>
					<th>값</th>
				</tr>
        	</thead>
        	<tbody>
				<tr>
					<th>이름</th>
					<td>
						<input type="text" name="memberName" id="memberName" value="${loginMember.memberName}">
					</td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td>
						<input type="hidden" name="memberPhone" id="memberPhone" value="${loginMember.memberPhone}">
						${loginMember.memberPhone}
					</td>
				</tr>
				<tr>
					<th>이메일</th>
					<td>
						<input type="text" name="memberEmail" id="memberEmail" value="${loginMember.memberEmail}">
					</td>
				</tr>
				<tr>
					<th>상품명</th>
					<td>
						<input type="hidden" name="ticketName" id="ticketName" value="${ticket.ticketSubject}&nbsp;&nbsp;&nbsp;${ticket.ticketCount}회">
						${ticket.ticketSubject}&nbsp;&nbsp;&nbsp;${ticket.ticketCount}회
						<input type="hidden" name="ticketSubject" value="${ticket.ticketSubject}">
						<input type="hidden" name="ticketCount" value="${ticket.ticketCount}">
					</td>
				</tr>
				<tr>
					<th>결제금액</th>
					<td>
						<input type="hidden" name="ticketPrice" id="ticketPrice" value="100">
						${ticket.ticketPrice}원
						<div>※ 실 결제는 1000원으로 통일됩니다.</div>
					</td>
				</tr>
				<tr>
					<th>회원아이디</th>
					<td>
						<input type="hidden" name="memberId" id="memberId" value="${loginMember.memberId}">
						${loginMember.memberId}
						<input type="hidden" name="memberNo" value="${loginMember.memberNo}">
						<input type="hidden" name="ticketNo" value="${ticket.ticketNo}">
						<input type="hidden" name="ticketPeriod" value="${ticket.ticketPeriod}">
					</td>
				</tr>
				<tr>
					<th>결제수단</th>
					<td>
						<span>
							<select id="pay_type" name="pay_type">
								<option value="transfer">계좌이체결제</option>
								<option value="card">신용카드</option>
							</select>
						</span>
						<span id="card_ver_view" style="display:none;">
							<select id="card_ver" name="card_ver">
								<option value="01">간편결제</option>
								<option value="02">앱카드</option>
							</select>
						</span>
				    </td>
				</tr>
        	</tbody>
		</table>
	</form>
	<button id="orderFormSubmit">상품구매</button>
</body>
</html>
