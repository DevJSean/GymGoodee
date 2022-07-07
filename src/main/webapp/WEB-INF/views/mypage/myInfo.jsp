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
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
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
	
	// SMS 인증코드 검증
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
	
	// 연락처 정규식 확인
	function fnPhoneCheck() {
		let regPhone = /^01[0169]-[0-9]{3,4}-[0-9]{4}$/; 
		if(regPhone.test($('#memberPhone').val())==false){
			alert('잘못된 형식의 연락처입니다.');
			return false;
		} 
		if($('#memberPhone').val() == '${loginMember.memberPhone}') {
			alert('동일한 연락처입니다.');
			return false;
		}
		$('#authCodeSMS').prop('readonly', false);
		$('#authCodeSMS').css('display', 'inline');
		$('#btnVerifyAuthCodeSMS').css('display', 'inline');
		return true;
	}
	
	// SMS 인증
	function fnPhoneAuth(){
		$('#btnGetAuthCodeSMS').on('click', function(){
			if(fnPhoneCheck()) {
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
			}
		})
	}
	
	// 입력을 무조건 대문자로 처리
	function fnToUpperCase(){
		$('#authCodeEmail').on('keyup', function(){
			$('#authCodeEmail').val($('#authCodeEmail').val().toUpperCase());
		})
		$('#authCodeSMS').on('keyup', function(){
			$('#authCodeSMS').val($('#authCodeSMS').val().toUpperCase());
		})
	}
	
	// 인증코드 검증
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
	
	// 이메일 중복체크
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
						$('#authCodeEmail').prop('readonly', false);
						$('#authCodeEmail').css('display', 'inline');
						$('#btnVerifyAuthCodeEmail').css('display', 'inline');
						resolve();     
					} else {
						reject(2000);  
					}
				}
			})
		});
	}
	
	// 이메일 인증
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
						alert('이메일 형식이 올바르지 않습니다.');
						$('#authCodeEmail').prop('readonly', true);
					} else if(code == 2000){
						alert('이미 사용 중인 이메일입니다.');
						$('#authCodeEmail').prop('readonly', true);
					}
				}
			)
		})
	}

</script>
<style>
	 /* 왼쪽 네비게이션 */
    .myPageNav {
        display: flex;
        width: 100px;
        flex-direction: column;
        list-style-type: none;
    }
    .navItem {
    	text-align: center;
        background-color: white; 
        cursor: pointer;
        border-left: 2px solid  rgba(44, 62, 80, 0.65); 
        border-right: 2px solid  rgba(44, 62, 80, 0.65);
        width: 100px;
        height: 50px;
        line-height: 50px;
    }
    .navItem a {
        text-decoration: none;
        color: rgb(70, 70, 70);
        display: inline-block;
        width: 100px;
        height: 50px;
    }
    .nowPage {
        background-color: #2C3E50;
        opacity: 0.65;
        color: #F5F6F7;
    }
    .myPageNav .navItem:first-of-type { 
    	border-radius : 10px 10px 0 0; 
    	border-top: 2px solid  rgba(44, 62, 80, 0.65); 
    }
    .myPageNav .navItem:last-of-type { 
    	border-radius : 0 0 10px 10px; 
    	border-bottom: 2px solid  rgba(44, 62, 80, 0.65); 
    }
    .navItem:hover {
        background-color: #2C3E50;   
        opacity: 1;
    }
    .navItem:hover > a {
        color: #F5F6F7;
    }
    #listNav {
        display: flex;
        margin-right: 20px;
        margin-left: 80px;
        margin-top: 50px;
    }
   
   /* 개별 페이지 */
	section {
		display: flex;
	}
    #wrapper{
        background-color: white;
        width: 40%;
        margin: 50px auto;
        border-radius: 50px;
        padding: 30px;
        text-align: center;
        box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
    }
    #info_wrapper {
    	margin: 5px;
    	position: relative;
    	text-align: left;
    	line-height: 30px;
    }
    #info_wrapper #signOutArea {
    	position: inherit;
    	text-align: center;
    }
	#btnPwChange, button {
		width: 100%;
		padding: 16px 0px 15px;
		margin-top: 10px;
		background-color: lightgrey;
		border: 1px solid lightgrey;
		border-radius: 5px;
		font-size:16px;
	}
	#btnEmailChange, #btnPhoneChange {
		background-color: lightgrey;
		border: 1px solid lightgrey;
		width: 100px;
		height: 32px;
		border: none;
		border-radius: 3px;
		cursor: pointer;
	}
	#btnPwChange:hover, #btnEmailChange:hover, #btnPhoneChange:hover, button:hover                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	, #btnGetAuthCodeEmail:hover, #btnGetAuthCodeSMS:hover, #btnVerifyAuthCodeEmail:hover, #btnVerifyAuthCodeSMS:hover {
		background-color: #2C3E50; 
		opacity: 0.65;
		color: #F5F6F7;
        border: 1px solid #2C3E50;
        cursor: pointer;
	}
	#btnGetAuthCodeEmail, #btnGetAuthCodeSMS, #btnVerifyAuthCodeEmail, #btnVerifyAuthCodeSMS {
		background-color: lightgrey;
        border: 1px solid lightgrey;
        cursor: pointer;
		width: 100px;
		height: 32px;
		border: none;
		border-radius: 3px;
		display: none;
	}
	#memberPhone, #memberEmail {
	    width: 200px;
	    height: 32px;
	    border: 0;
	    border-radius: 3px;
	    outline: none;
	    background-color: rgb(233, 233, 233);
	    padding-left: 12px;
	}
	#authCodeSMS, #authCodeEmail {
		width: 200px;
	    height: 32px;
	    border: 0;
	    border-radius: 3px;
	    outline: none;
		background-color:rgb(240, 240, 240);
		padding-left: 12px;
	}
	#authCodeEmail, #authCodeSMS {
		display: none;
	}
	#linkText {
		text-decoration: none;
		display: inline-block;
        line-height: 17px;
        color: #888;
	}
	table{
        border-collapse: collapse;
        width: 90%;
        text-align: center;
        margin: 0 auto;
        vertical-align: middle;
    }
    td{
        padding: 5px;
        text-align: left;
    }

</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>	
		
	<section>
	
		<nav id="listNav">
			<ul class="myPageNav">
				<li class="navItem"><a href="${contextPath}/mypage/myReserveList">수강내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myPayList">결제내역</a></li>
				<li class="navItem nowPage">개인정보</li>
			</ul>	
		</nav>
		
		<div id="wrapper">
			<div id="info_wrapper">
				<form id="f" action="${contextPath}/mypage/changeInfo" method="post">
					<table>
						<thead>
							<tr>
								<td colspan="3"><i class="fa-solid fa-user"></i>&nbsp;&nbsp;개인정보</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>이름</td>
								<td colspan="2">${loginMember.memberName}</td>
							</tr>
							<tr>
								<td>생년월일</td>
								<td colspan="2">${loginMember.memberBirth}</td>
							</tr>
							<tr>
								<td>아이디</td>
								<td colspan="2">${loginMember.memberId}</td>
							</tr>
							<tr>
								<td>이메일</td>
								<td><input type="text" name="memberEmail" id="memberEmail" value="${loginMember.memberEmail}" readonly></td>
								<td>
									<input type="button" value="수정" id="btnEmailChange">
									<input type="button" value="인증번호받기" id="btnGetAuthCodeEmail">
								</td>
							</tr>
							<tr>
								<td></td>
								<td><input type="text" name="authCodeEmail" id="authCodeEmail" placeholder="인증번호 입력"></td>
								<td><input type="button" value="인증하기" id="btnVerifyAuthCodeEmail"></td>
							</tr>
							<tr>
								<td>연락처</td>
								<td><input type="text" name="memberPhone" id="memberPhone" value="${loginMember.memberPhone}" readonly></td>
								<td>
									<input type="button" value="수정" id="btnPhoneChange">
									<input type="button" value="인증번호받기" id="btnGetAuthCodeSMS">
								</td>
							</tr>
							<tr>
								<td></td>
								<td><input type="text" name="authCodeSMS" id="authCodeSMS" placeholder="인증번호 입력"></td>
								<td><input type="button" value="인증하기" id="btnVerifyAuthCodeSMS"></td>
							</tr>
							<tr>
								<td colspan="3"><button>수정하기</button></td>
							</tr>
							<tr>
								<td colspan="3"><input type="button" value="비밀번호 수정" id="btnPwChange" onclick='location.href="${contextPath}/mypage/changePwPage"'></td>
							</tr>
						</tbody>
					</table>	
				</form>
				<br><br>
			</div>
			<div id="signOutArea">
				<a id="linkText" href="${contextPath}/mypage/signOutPage">회원탈퇴</a>
			</div>
		</div>
		
	</section>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>