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

	/* 페이지 로드 이벤트 */
	$(function(){
		fnPwCheck();
		fnPwConfirm();
		fnEmailAuth();
		fnToUpperCase();
		fnChangePw();
	})
	
	/* 함수 */
	
	// 1. 비밀번호 정규식
	let pwPass = false;
	function fnPwCheck(){
		// 비밀번호 정규식 검사
		$('#memberPw').on('keyup', function(){
			let regPw = /^[0-9]{1,4}$/;  // 숫자 1~4자
			if(regPw.test($('#memberPw').val())==false){
				$('#pwMsg').text('8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.').addClass('dont').removeClass('ok');
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
		$('#memberRePw').on('keyup', function(){
			if($('#memberRePw').val() != '' && $('#memberPw').val() != $('#memberRePw').val()){
				$('#rePwMsg').text('비밀번호를 확인하세요.').addClass('dont').removeClass('ok');
				rePwPass = false;
			} else {
				$('#rePwMsg').text('');
				rePwPass = true;
			}
		})
	}
	
	// 3. 아이디 + 이메일 일치하는 회원 확인
	function fnIdEmailCheck(){
		return new Promise(function(resolve, reject){
			// 1) 이메일 정규식 체크
			let regEmail = /^[a-zA-Z0-9-_]+@[a-zA-Z0-9]+(\.[a-zA-Z]{2,}){1,2}$/;  // 실제 서비스에서 그대로 사용 가능.
			if(regEmail.test($('#memberEmail').val())==false){
				alert('잘못된 형식의 이메일입니다.');
				return;
			}
			// 2) 아이디와 이메일이 일치하는 회원 정보 확인
			$.ajax({
				url: '${contextPath}/member/idEmailCheck',
				type: 'get',
				data: 'memberId=' + $('#memberId').val() + '&memberEmail=' + $('#memberEmail').val(),
				dataType: 'json',
				success: function(obj){
					if(obj.findMember != null){  // 아이디와 이메일이 일치하는 회원이 있으면 정상 진행(resolve)
						resolve();
					} else {
						reject(401);  // 아이디와 이메일이 일치하는 회원이 없으면 401 반환
					}
				}
			})
		})
	}
	
	// 4. 이메일 인증
	function fnEmailAuth(){
		$('#btnGetAuthCode').on('click', function(){
			fnIdEmailCheck()
				.then(function(){
					$.ajax({
						url: '${contextPath}/member/sendAuthCode',
						type: 'get',
						data: 'memberEmail=' + $('#memberEmail').val(),
						dataType: 'json',
						success: function(obj){  // obj에는 발송한 인증코드(authCode)가 저장되어 있음.
							alert('인증코드를 발송했습니다. 이메일을 확인하세요.');
							fnVerifyAuthCode(obj.authCode);  // 발송한 인증코드와 사용자가 입력한 인증코드가 일치하는지 점검.
						},
						error: function(){
							alert('인증코드 발송이 실패했습니다.');
						}
					})
				}).catch(function(errorCode){
					alert('예외코드[' + errorCode + '] 회원 정보를 찾을 수 없습니다.');
				})
		})
	}
	
	// 6. 인증코드 검증
	let authCodePass = false;
	function fnVerifyAuthCode(authCode){  // 이메일로 전송한 인증코드
		$('#btnVerifyAuthCode').on('click', function(){
			if($('#authCode').val() == authCode){
				alert('인증되었습니다.');
				$('.authArea').css('display', 'none');
				$('.changeArea').css('display', 'block');
				authCodePass = true;
			} else {
				alert('인증에 실패했습니다.');
				authCodePass = false;
			}
		})
	}
	
	// 7. 입력을 무조건 대문자로 처리
	function fnToUpperCase(){
		$('#authCode').on('keyup', function(){
			$('#authCode').val($('#authCode').val().toUpperCase());
		})
	}
	
	// 8. 비밀번호 변경
	function fnChangePw(){
		$('#f').on('submit', function(event){
			if(pwPass == false || rePwPass == false){
				alert('비밀번호를 확인하세요.');
				event.preventDefault();
				return false;
			}
			else if(authCodePass == false){
				alert('이메일 인증을 받아야 합니다.');
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
	
		<div class="authArea">	
			아이디<br>
			<input type="text" name="memberId" id="memberId"><br><br>
			가입 당시 이메일<br>
			<input type="text" id="memberEmail">
			<input type="button" value="인증번호받기" id="btnGetAuthCode"><br>
			<span id="emailMsg"></span><br>
			<input type="text" id="authCode" placeholder="인증코드 입력">
			<input type="button" value="인증하기" id="btnVerifyAuthCode"><br><br>
		</div>
	
		<div class="changeArea">
			<h3>새로운 비밀번호를 설정하세요</h3>
			<input type="password" name="memberPw" id="memberPw" placeholder="새 비밀번호">
			<span id="pwMsg"></span><br><br>
			<input type="password" id="memberRePw" placeholder="새 비밀번호 확인">
			<span id="rePwMsg"></span><br><br>
			<button>비밀번호 변경하기</button>
		</div>
		
	</form>
	
</body>
</html>