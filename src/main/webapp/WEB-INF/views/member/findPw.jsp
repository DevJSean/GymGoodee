<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>

	$(function(){
		fnPwCheck();
		fnPwConfirm();
		fnPhoneAuth();
		fnToUpperCase();
		fnChangePw();
	})
	
	
	// 1. 비밀번호 정규식
	let pwPass = false;
	function fnPwCheck(){
		$('#memberPw').on('keyup', function(){
			let regPw = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,16}$/;
			if(regPw.test($('#memberPw').val())==false){
				$('#pwMsg').text('8~16자 영문, 숫자, 특수문자를 모두 사용하세요.').addClass('dont').removeClass('ok');
				pwPass = false;
			} else {
				$('#pwMsg').text('사용 가능한 비밀번호입니다.').addClass('ok').removeClass('dont');
				pwPass = true;
			}
		})
	}
	
	// 2. 비밀번호 입력확인
	let rePwPass = false;
	function fnPwConfirm(){
		$('#pwConfirm').on('keyup', function(){
			if($('#pwConfirm').val() != '' && $('#memberPw').val() != $('#pwConfirm').val()){
				$('#rePwMsg').text('비밀번호를 확인하세요.').addClass('dont').removeClass('ok');
				rePwPass = false;
			} else {
				$('#rePwMsg').text('');
				rePwPass = true;
			}
		})
	}
	
	// 3. 아이디 + 연락처 일치하는 회원 확인
	function fnIdPhoneCheck(){
		return new Promise(function(resolve, reject){
			let regPhone = /^01[0169]-[0-9]{3,4}-[0-9]{4}$/; 
			if(regPhone.test($('#memberPhone').val())==false){
				alert('잘못된 형식의 핸드폰 번호입니다.');
				return;
			}
			$.ajax({
				url: '${contextPath}/member/idPhoneCheck',
				type: 'get',
				data: 'memberId=' + $('#memberId').val() + '&memberPhone=' + $('#memberPhone').val(),
				dataType: 'json',
				success: function(obj){
					if(obj.findMember != null){  
						resolve();
					} else {
						reject(401);
					}
				}
			})
		})
	}
	
	// 4. SMS 인증
	function fnPhoneAuth(){
		$('#btnGetAuthCodeSMS').on('click', function(){
			fnIdPhoneCheck()
				.then(function(){
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
				}).catch(function(errorCode){
					alert('회원 정보를 찾을 수 없습니다.');
				})
		})
	}
	
	// 5. 인증코드 검증
	let authCodePassSMS = false;
	function fnVerifyAuthCodeSMS(authCodeSMS){ 
		$('#btnVerifyAuthCodeSMS').on('click', function(){
			if($('#authCodeSMS').val() == authCodeSMS){
				alert('인증되었습니다.');
				$('.authAreaSMS').css('display', 'none');
				$('.changeArea').css('display', 'block');
				authCodePassSMS = true;
			} else {
				alert('인증에 실패했습니다.');
				authCodePassSMS = false;
			}
		})
	}
	
	// 6. 입력을 무조건 대문자로 처리
	function fnToUpperCase(){
		$('#authCodeSMS').on('keyup', function(){
			$('#authCodeSMS').val($('#authCodeSMS').val().toUpperCase());
		})
	}
	
	// 7. 비밀번호 변경
	function fnChangePw(){
		$('#f').on('submit', function(event){
			if(pwPass == false || rePwPass == false){
				alert('비밀번호를 확인하세요.');
				event.preventDefault();
				return false;
			}
			else if(authCodePassSMS == false){
				alert('연락처 인증을 받아야 합니다.');
				event.preventDefault();
				return false;
			}
			return true;
		})
	}
	
</script>
<style>
	.changeArea {
		display: none;
	}
	.dont {
		color: red;
	}
	.ok {
		color: limegreen;
	}
</style>
</head>
<body>

	
	<form id="f" action="${contextPath}/member/changePw" method="post">
	
		<h3>비밀번호 찾기</h3>
	
		<div class="authAreaSMS">	
			아이디<br>
			<input type="text" name="memberId" id="memberId"><br><br>
			가입 당시 연락처<br>
			<input type="text" id="memberPhone" placeholder="-를 포함하여 입력">
			<input type="button" value="인증번호받기" id="btnGetAuthCodeSMS"><br>
			<span id="emailMsg"></span><br>
			<input type="text" id="authCodeSMS" placeholder="인증코드 입력">
			<input type="button" value="인증하기" id="btnVerifyAuthCodeSMS"><br><br>
		</div>
	
		<div class="changeArea">
			<h3>새로운 비밀번호를 설정하세요</h3>
			<input type="password" name="memberPw" id="memberPw" placeholder="새 비밀번호">
			<span id="pwMsg"></span><br><br>
			<input type="password" id="pwConfirm" placeholder="새 비밀번호 확인">
			<span id="pwConfirmMsg"></span><br><br>
			<button>비밀번호 변경하기</button>
		</div>
		
	</form>
	
</body>
</html>