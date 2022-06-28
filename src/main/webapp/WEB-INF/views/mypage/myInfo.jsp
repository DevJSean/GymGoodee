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
			$('#memberEmail').attr('readonly', false);
			$('#memberEmail').css('background-color', 'rgb(240, 240, 240)');
			$(this).css('display', 'none');
			$('#btnGetAuthCodeEmail').css('display', 'inline');
		})
		// 비밀번호 수정
		$('#btnPhoneChange').on('click', function() {
			$('#memberPhone').attr('readonly', false);
			$('#memberPhone').css('background-color', 'rgb(240, 240, 240)');
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
		fnEmailAuth();
		fnPhoneAuth();
		fnToUpperCase();
		fnChangeInfo();
	})
	
	function fnChangeInfo() {
		$('#f').on('submit', function(event){
			// 이메일과 연락처 둘 다 수정 X
			if($('#memberEmail').val() == '${loginMember.memberEmail}' && $('#memberPhone').val() == '${loginMember.memberPhone}') {
				alert('변경된 정보가 없습니다.');
				event.preventDefault();
				return false;
			}
			// 이메일은 그대로, 연락처만 수정
			else if($('#memberEmail').val() == '${loginMember.memberEmail}' && authCodePassSMS == false){
				alert('SMS 인증을 받아야 합니다.');
				event.preventDefault();
				return false;
			}
			// 이메일만 수정, 연락처는 그대로
			else if($('#memberPhone').val() == '${loginMember.memberPhone}' && authCodePassEmail == false){
				alert('이메일 인증을 받아야 합니다.');
				event.preventDefault();
				return false;
			}
			// 둘다 수정
			else if(authCodePassSMS == false && authCodePassEmail == false){
				alert('모든 인증을 받아야 합니다.');
				event.preventDefault();
				return false;
			}
			return true;
		})
	}
	
	// 1. SMS 인증코드 검증
	let authCodePassSMS = false;
	function fnVerifyAuthCodeSMS(authCodeSMS){  
		$('#btnVerifyAuthCodeSMS').on('click', function(){
			if($('#authCodeSMS').val() == authCodeSMS){
				alert('인증되었습니다.');
				authCodePassSMS = true;
			} else {
				alert('인증에 실패했습니다.');
				authCodePassSMS = false;
			}
		})
	}
	
	// 2. SMS 인증
	function fnPhoneAuth(){
		$('#btnGetAuthCodeSMS').on('click', function(){
			let regPhone = /^01[0169]-[0-9]{3,4}-[0-9]{4}$/; 
			if(regPhone.test($('#memberPhone').val())==false){
				alert('잘못된 형식의 핸드폰 번호입니다.');
				return;
			}
			$.ajax({
				url: '${contextPath}/member/sendAuthCodeSMS',
				type: 'get',
				data: 'memberPhone=' + $('#memberPhone').val(),
				dataType: 'json',
				success: function(obj){  
					alert('인증코드를 발송했습니다. 핸드폰을 확인하세요.');
					fnVerifyAuthCodeSMS(obj.authCodeSMS);  
				},
				error: function(){
					alert('인증코드 발송이 실패했습니다.');
				}
			})
		})
	}
	
	// 3. 입력을 무조건 대문자로 처리
	function fnToUpperCase(){
		$('#authCodeEmail').on('keyup', function(){
			$('#authCodeEmail').val($('#authCodeEmail').val().toUpperCase());
		})
		$('#authCodeSMS').on('keyup', function(){
			$('#authCodeSMS').val($('#authCodeSMS').val().toUpperCase());
		})
	}
	
	// 4. 인증코드 검증
	let authCodePassEmail = false;
	function fnVerifyAuthCodeEmail(authCodeEmail){  
		$('#btnVerifyAuthCodeEmail').on('click', function(){
			if($('#authCodeEmail').val() == authCodeEmail){
				alert('인증되었습니다.');
				authCodePassEmail = true;
			} else {
				alert('인증에 실패했습니다.');
				authCodePassEmail = false;
			}
		})
	}
	
	// 5. 이메일 중복체크
	function fnEmailCheck(){
		return new Promise(function(resolve, reject) {
			let regEmail = /^[a-zA-Z0-9-_]+@[a-zA-Z0-9]+(\.[a-zA-Z]{2,}){1,2}$/;  
			if(regEmail.test($('#memberEmail').val())==false){
				reject(1000);      
				return;
			}
			$.ajax({
				url: '${contextPath}/member/emailCheck',
				type: 'get',
				data: 'memberEmail=' + $('#memberEmail').val(),
				dataType: 'json',
				success: function(obj){
					if(obj.res == null){
						resolve();     
					} else {
						reject(2000);  
					}
				}
			})
		});
	}
	
	// 6. 이메일 인증
	function fnEmailAuth(){
		$('#btnGetAuthCodeEmail').on('click', function(){
			fnEmailCheck().then(
				function(){
					$.ajax({
						url: '${contextPath}/member/sendAuthCodeEmail',
						type: 'get',
						data: 'memberEmail=' + $('#memberEmail').val(),
						dataType: 'json',
						success: function(obj){  
							alert('인증코드를 발송했습니다. 이메일을 확인하세요.');
							fnVerifyAuthCodeEmail(obj.authCodeEmail); 
						},
						error: function(jqXHR){
							alert('인증코드 발송이 실패했습니다.');
						}
					})
				}
			).catch(
				function(code){
					if(code == 1000){
						$('#emailMsg').text('이메일 형식이 올바르지 않습니다.').addClass('dont').removeClass('ok');
						$('#authCodeEmail').prop('readonly', true);
					} else if(code == 2000){
						$('#emailMsg').text('이미 사용 중인 이메일입니다.').addClass('dont').removeClass('ok');
						$('#authCodeEmail').prop('readonly', true);
					}
				}
			)
		})
	}

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
		width: 50px;
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
				<li class="navItem nowPage"><a href="${contextPath}/mypage/myReserveList?memberNo=${loginMember.memberNo}&memberId=${loginMember.memberId}">수강내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myPayList?memberNo=${loginMember.memberNo}">결제내역</a></li>
				<li class="navItem">개인정보</li>
			</ul>	
		</nav>
		
		<div>
			<h1>개인정보</h1>
			<form id="f" action="${contextPath}/mypage/changeInfo" method="post">
				이름 ${loginMember.memberName} <br>
				생년월일 ${loginMember.memberBirth} 
				&nbsp;&nbsp;
				성별 
				<c:if test="${loginMember.memberGender eq 'F'}">여자</c:if>
				<c:if test="${loginMember.memberGender eq 'M'}">남자</c:if><br>
				아이디 ${loginMember.memberId} <br>
				<input type="hidden" name="memberNo" value="${loginMember.memberNo}">
				이메일
				<input type="text" name="memberEmail" id="memberEmail" value="${loginMember.memberEmail}" readonly>
				<input type="button" value="수정" id="btnEmailChange">
				<input type="button" value="인증번호받기" id="btnGetAuthCodeEmail"><br>
				<span id="emailMsg"></span><br>
				<div class="authCode">
					<input type="text" name="authCodeEmail" id="authCodeEmail" placeholder="인증번호 입력"> 
					<input type="button" value="인증하기" id="btnVerifyAuthCodeEmail"><br>
				</div>
				연락처
				<input type="text" name="memberPhone" id="memberPhone" value="${loginMember.memberPhone}" readonly>
				<input type="button" value="수정" id="btnPhoneChange">
				<input type="button" value="인증번호받기" id="btnGetAuthCodeSMS"><br>
				<span id="phoneMsg"></span><br>
				<div class="authCode">
					<input type="text" name="authCodeSMS" id="authCodeSMS" placeholder="인증번호 입력"> 
					<input type="button" value="인증하기" id="btnVerifyAuthCodeSMS"><br>
				</div>
				<button>수정하기</button><br>
			</form>
			<input type="button" value="비밀번호 수정" id="btnPwChange" onclick='location.href="${contextPath}/mypage/changePwPage?memberNo=${loginMember.memberNo}"'><br>
			<a href="${contextPath}/mypage/signOutPage?memberNo=${loginMember.memberNo}">회원탈퇴</a>
		</div>

		
	</section>
</body>
</html>