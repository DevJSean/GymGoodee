<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>

	$(function() {
		// 이메일 수정버튼
		$('#btnEmailChange').on('click', function() {
			$('#email').attr('readonly', false);
			$('#email').css('background-color', 'rgb(240, 240, 240)');
			$(this).css('display', 'none');
			$('#btnGetAuthCodeEmail').css('display', 'inline');
		})
		// 비밀번호 수정
		$('#btnPhoneChange').on('click', function() {
			$('#phone').attr('readonly', false);
			$('#phone').css('background-color', 'rgb(240, 240, 240)');
			$(this).css('display', 'none');
			$('#btnGetAuthCodeSMS').css('display', 'inline');
		})
		// 인증번호 받기
		$('#btnGetAuthCodeEmail').on('click', function() {
			$('#authCodeEmail').css('display', 'inline');
			$('#btnVerifyAuthCodeEmail').css('display', 'inline');
		})
		$('#btnGetAuthCodeSMS').on('click', function() {
			$('#authCodeSMS').css('display', 'inline');
			$('#btnVerifyAuthCodeSMS').css('display', 'inline');
		})
	})
	

</script>
<style>
	.myPageNav {
		display: flex;
		flex-direction: column;
		width: 100px;
		list-style-type: none;
	}
	.navItem {
		background-color: teal; 
		padding: 15px;
		cursor: pointer;
	}
	.navItem a {
		text-align: center;
		text-decoration: none;
		color: white;
	}
	.navItem:hover {
		background-color: navy;
	}
	nav {
		display: flex;
		margin-right: 30px;
	}
	section {
		display: flex;
		display: 
	}
	#btnPwChange {
		width: 300px;
		padding: 16px 0px 15px;
		margin-top: 10px;
		background-color: green;
		color: white;
		border: none;
		border-radius: 15px;
	}
	#btnEmailChange, #btnPhoneChange {
		background-color: green;
		 width: 40px;
		height: 32px;
		color: white;
		border: none;
		border-radius: 15px;
	}
	#btnPwChange:hover, #btnEmailChange:hover, #btnPhoneChange:hover
	, #btnGetAuthCodeEmail:hover, #btnGetAuthCodeSMS:hover, #btnVerifyAuthCodeEmail:hover, #btnVerifyAuthCodeSMS:hover {
		cursor: pointer;
	}
	#btnGetAuthCodeEmail, #btnGetAuthCodeSMS, #btnVerifyAuthCodeEmail, #btnVerifyAuthCodeSMS {
		background-color: green;
		 width: 70px;
		height: 32px;
		color: white;
		border: none;
		border-radius: 15px;
		display: none;
	}
	input[type=text] {
	  width: 200px;
	  height: 32px;
	  font-size: 15px;
	  border: 0;
	  border-radius: 15px;
	  outline: none;
	  padding-left: 10px;
	  background-color: rgb(233, 233, 233);
	}
	.authCode {
		margin-left: 54px;
	}
	#authCodeEmail, #authCodeSMS {
		display: none;
	}
</style>
</head>
<body>

	<jsp:include page="../layout/header.jsp"></jsp:include>
	
	<section>
	
		<nav>
			<ul class="myPageNav">
				<li class="navItem nowPage"><a href="${contextPath}/mypage/myReserveList?memberNo=101">수강내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myPayList?memberNo=101">결제내역</a></li>
				<li class="navItem">개인정보</li>
			</ul>	
		</nav>
		
		<div>
			<h1>개인정보</h1>
			<form>
				이름 ${member.memberName} <br>
				생년월일 ${member.memberBirth} 
				&nbsp;&nbsp;
				성별 
				<c:if test="${member.memberGender eq 'F'}">여자</c:if>
				<c:if test="${member.memberGender eq 'M'}">남자</c:if><br>
				아이디 ${member.memberId} <br>
				이메일
				<input type="text" name="email" id="email" value="${member.memberEmail}" readonly>
				<input type="button" value="수정" id="btnEmailChange">
				<input type="button" value="인증번호받기" id="btnGetAuthCodeEmail"><br>
				<div class="authCode">
					<input type="text" name="authCodeEmail" id="authCodeEmail" placeholder="인증번호 입력"> 
					<input type="button" value="인증하기" id="btnVerifyAuthCodeEmail"><br>
				</div>
				연락처
				<input type="text" name="phone" id="phone" value="${member.memberPhone}" readonly>
				<input type="button" value="수정" id="btnPhoneChange">
				<input type="button" value="인증번호받기" id="btnGetAuthCodeSMS"><br>
				<div class="authCode">
					<input type="text" name="authCodeSMS" id="authCodeSMS" placeholder="인증번호 입력"> 
					<input type="button" value="인증하기" id="btnVerifyAuthCodeSMS"><br>
				</div>
				<input type="button" value="비밀번호 수정" id="btnPwChange" onclick='location.href="${contextPath}/mypage/changePw?memberNo=101"'>
			</form>
		</div>
		
	</section>
</body>
</html>