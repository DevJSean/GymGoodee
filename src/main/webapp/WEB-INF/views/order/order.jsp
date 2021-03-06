<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
    <title>결제정보 수정</title>

    <script src="../resources/js/jquery-3.6.0.js"></script>
	<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../resources/css/reset.css">

	<script>
	$(document).ready(function () {
		$("#orderFormSubmit").on("click", function (event) {
			var fm = $("#orderForm")[0];
			if ($('#memberPhone').val() == '카카오가입') {
				alert('마이페이지에서 전화번호를 수정해 주세요.')
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
	
	
	<style>
	
	#orderForm {
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
	
	#orderTable {
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
	
	input, select {
		width:200px;
		height: 25px;
		padding: 0;
	}
	.tag {
		margin-left: 10px;
		line-height: 0;
		font-size: 0.5em;
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

    <form id="orderForm" name="orderForm">
        <div id="titleName">| 주문 정보 설정</div>
        <table id="orderTable" border="1">
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
						<input type="text" name="memberEmail" id="memberEmail" value="" placeholder="이메일을 입력해주세요(선택)">
					</td>
				</tr>
				<tr>
					<th>상품명</th>
					<td>
						<input type="hidden" name="ticketName" id="ticketName" 
								value="<c:choose><c:when test="${ticket.ticketSubject == 'SWIM'}">수영</c:when><c:when test="${ticket.ticketSubject == 'SPINNING'}">스피닝</c:when><c:when test="${ticket.ticketSubject == 'PILATES'}">필라테스</c:when><c:when test="${ticket.ticketSubject == 'DANCE'}">스포츠댄스</c:when></c:choose>&nbsp;&nbsp;&nbsp;${ticket.ticketCount}회">
										<c:choose>
											<c:when test="${ticket.ticketSubject == 'SWIM'}">수영</c:when>
											<c:when test="${ticket.ticketSubject == 'SPINNING'}">스피닝</c:when>
											<c:when test="${ticket.ticketSubject == 'PILATES'}">필라테스</c:when>
											<c:when test="${ticket.ticketSubject == 'DANCE'}">스포츠댄스</c:when>
										</c:choose>&nbsp;&nbsp;&nbsp;${ticket.ticketCount}회
						<input type="hidden" name="ticketSubject" value="${ticket.ticketSubject}">
						<input type="hidden" name="ticketCount" value="${ticket.ticketCount}">
					</td>
				</tr>
				<tr>
					<th>결제금액</th>
					<td>
						<input type="hidden" name="ticketPrice" id="ticketPrice" value="1000">${ticket.ticketPrice}원
						<span class="tag">※ 실 결제는 1000원으로 통일됩니다.</span>
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
					<th class="last">결제수단</th>
					<td class="last">
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
		<br>
		<button id="orderFormSubmit">상품구매</button>
	</form>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
</body>
</html>
