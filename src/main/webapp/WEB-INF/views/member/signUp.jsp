<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.ok {
		color: limegreen;
	}
	.dont {
		color: crimson;
	}
</style>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>

	$(function(){
		fnIdCheck();
		fnPwCheck();
		fnPwConfirm();
		fnEmailAuth();
		fnPhoneAuth();
		fnToUpperCase();
		fnSignUp();
	})
	
	// 11. 회원가입
	function fnSignUp(){
		$('#f').on('submit', function(event){
			if(idPass == false){
				alert('아이디를 확인하세요.');
				event.preventDefault();
				return false;
			}
			else if(pwPass == false || rePwPass == false){
				alert('비밀번호를 확인하세요.');
				event.preventDefault();
				return false;
			}
			else if(authCodePassSMS == false){
				alert('SMS 인증을 받아야 합니다.');
				event.preventDefault();
				return false;
			}
			else if(authCodePassEmail == false){
				alert('이메일 인증을 받아야 합니다.');
				event.preventDefault();
				return false;
			}
			return true;
		})
	}
	
	// 10. SMS 인증코드 검증
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
	
	// 9. 연락처 정규식 체크
	function fnPhoneCheck(){

	}
	
	// 8. SMS 인증
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
	
	// 7. 입력을 무조건 대문자로 처리
	function fnToUpperCase(){
		$('#authCodeEmail').on('keyup', function(){
			$('#authCodeEmail').val($('#authCodeEmail').val().toUpperCase());
		})
		$('#authCodeSMS').on('keyup', function(){
			$('#authCodeSMS').val($('#authCodeSMS').val().toUpperCase());
		})
	}
	
	// 6. 인증코드 검증
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
						$('#emailMsg').text('');
						resolve();     
					} else {
						reject(2000);  
					}
				}
			})
		});
	}
	
	// 4. 이메일 인증
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
					}
				}
			)
		})
	}
	
	// 3. 비밀번호 입력확인
	let rePwPass = false;
	function fnPwConfirm(){
		$('#pwConfirm').on('keyup', function(){
			if($('#pwConfirm').val() != '' && $('#memberPw').val() != $('#pwConfirm').val()){
				$('#pwConfirmMsg').text('비밀번호를 확인하세요.').addClass('dont').removeClass('ok');
				rePwPass = false;
			} else {
				$('#pwConfirmMsg').text('');
				rePwPass = true;
			}
		})
	}
	
	// 2. 비밀번호 정규식
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

	// 1. 아이디 정규식 & 중복체크
	let idPass = false;
	function fnIdCheck(){
		$('#memberId').on('keyup', function(){
			let regId = /^[a-z0-9-_]{5,20}$/;  
			if(regId.test($('#memberId').val())==false){
				$('#idMsg').text('아이디는 5~20자의 영문 소문자, 숫자와 특수기호 (-, _)만 사용이 가능합니다.').addClass('dont').removeClass('ok');
				idPass = false;
				return;
			}
			$.ajax({
				url: '${contextPath}/member/idCheck',
				type: 'get',
				data: 'memberId=' + $('#memberId').val(),
				dataType: 'json',
				success: function(obj){
					if(obj.res1 == null && obj.res2 == null){
						$('#idMsg').text('멋진 아이디네요!').addClass('ok').removeClass('dont');
						idPass = true;
					} else {
						$('#idMsg').text('이미 사용중이거나 탈퇴한 아이디입니다.').addClass('dont').removeClass('ok');
						idPass = false;
					}
				},
				error: function(jqXHR){
					$('#idMsg').text(jqXHR.responseText).addClass('dont').removeClass('ok');
					idPass = false;
				}
			})
		})
	}
	
</script>
</head>
<body>
	
	<h3>회원 가입</h3>
	
	<form id="f" action="${contextPath}/member/signUp" method="post">
	
		<input type="hidden" name="location" value="${agreements[0]}">
		<input type="hidden" name="promotion" value="${agreements[1]}">
		
		<label for="memberId">
			아이디<br>
			<input type="text" name="memberId" id="memberId"><br>
			<span id="idMsg"></span>
		</label><br><br>
		
		<label for="memberPw">
			비밀번호<br>
			<input type="password" name="memberPw" id="memberPw"><br>
			<span id="pwMsg"></span>
		</label><br><br>
		
		<label for="pwConfirm">
			비밀번호 재확인<br>
			<input type="password" id="pwConfirm"><br>
			<span id="pwConfirmMsg"></span>
		</label><br><br>
		
		<label for="memberName">
			이름<br>
			<input type="text" name="memberName" id="memberName"><br>
		</label><br><br>
		
		<label for="memberBirth">
			생년월일<br>
			<input type="text" name="memberBirth" id="memberBirth"><br>
		</label><br><br>
		
		성별
		<label for="male"><input type="radio" name="memberGender" value="M" id="male">남</label>
		<label for="female"><input type="radio" name="memberGender" value="F" id="female">여</label><br><br>
		
		<label for="memberPhone">
			연락처<br>
			<input type="text" name="memberPhone" id="memberPhone" placeholder="'-' 포함">
			<input type="button" value="인증코드받기" id="btnGetAuthCodeSMS"><br>
			<span id="phoneMsg"></span><br>
			<input type="text" name="authCodeSMS" id="authCodeSMS" placeholder="인증코드 입력">
			<input type="button" value="인증하기" id="btnVerifyAuthCodeSMS"><br><br>
		</label><br><br>
		
		<label for="email">
			이메일<br>
			<input type="text" name="memberEmail" id="memberEmail">
			<input type="button" value="인증코드받기" id="btnGetAuthCodeEmail"><br>
			<span id="emailMsg"></span><br>
			<input type="text" name="authCodeEmail" id="authCodeEmail" placeholder="인증코드 입력">
			<input type="button" value="인증하기" id="btnVerifyAuthCodeEmail"><br><br>
		</label><br><br>
		
		<button>가입하기</button>
		<input type="button" value="취소하기" onclick="location.href='${contextPath}/member/login'">
	
	</form>
	
</body>
</html>