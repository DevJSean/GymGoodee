<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>

	$(function() {
		fnNewPwCheck();
		fnNewPwConfirm();
		fnChangePw();
	})
	
	/* 함수 */
	
	// 1. 비밀번호 정규식
	let pwPass = false;
	function fnNewPwCheck(){
		// 비밀번호 정규식 검사
		$('#newPw').on('keyup', function(){
			let regPw = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,16}$/;
			if(regPw.test($('#newPw').val())==false){
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
	function fnNewPwConfirm(){
		$('#newPwConfirm').on('keyup', function(){
			if($('#newPwConfirm').val() != '' && $('#newPw').val() != $('#newPwConfirm').val()){
				$('#pwConfirmMsg').text('비밀번호를 확인하세요.').addClass('dont').removeClass('ok');
				rePwPass = false;
			} else {
				$('#pwConfirmMsg').text('');
				rePwPass = true;
			}
		})
	}
	
	// 3. 비밀번호 변경
	function fnChangePw(){
		$('#f').on('submit', function(event){
			if($('#currentPw').val() == '') {
				alert('현재 비밀번호를 입력하세요.');
				event.preventDefault();
				return false;
			} else if(pwPass == false || rePwPass == false){
				alert('비밀번호를 확인하세요.');
				fnInit();
				event.preventDefault();
				return false;
			}
			return true;
		})
	}
	
	function fnInit() {
		$('#currentPw').val('');
		$('#newPw').val('');
		$('#newPwConfirm').val('');
		$('#pwMsg').text('');
		$('#pwConfirmMsg').text('');
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
	}
	input[type=password] {
	  width: 200px;
	  height: 32px;
	  font-size: 15px;
	  border: 0;
	  border-radius: 15px;
	  outline: none;
	  padding-left: 10px;
	  background-color: rgb(233, 233, 233);
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
	button {
		width: 300px;
		padding: 16px 0px 15px;
		margin-top: 10px;
		background-color: lightgrey;
		color: white;
		border: none;
		border-radius: 15px;
	}
	.ok {
		color: limegreen;
	}
	.dont {
		color: crimson;
	}
</style>
</head>
<body>

	<h1>수강내역</h1>
	
	<jsp:include page="../layout/header.jsp"></jsp:include>
	
	<section>
	
		<nav>
			<ul class="myPageNav">
				<li class="navItem nowPage">수강내역</li>
				<li class="navItem"><a href="${contextPath}/mypage/myPayList?memberNo=${loginMember.memberNo}">결제내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myInfo?memberNo=${loginMember.memberNo}">개인정보</a></li>
			</ul>	
		</nav>
	
		<form id="f" action="${contextPath}/mypage/changePw" method="post">
			<h1>비밀번호 입력</h1>
			<input type="hidden" name="memberNo" value="${loginMember.memberNo}">
			<label for="pw">
				현재 비밀번호
				<input type="password" name="currentPw" id="currentPw"><br><br>
			</label>
			<label for="newPW">
				새 비밀번호
				<input type="password" name="newPw" id="newPw"><br>
				<span id="pwMsg"></span>
			</label><br>
			<label for="newPwConfirm">
				새 비밀번호 확인
				<input type="password" id="newPwConfirm"><br>
				<span id="pwConfirmMsg"></span>
			</label><br>
			
			<button>확인</button><br>
			<input type="button" value="취소" id="btnCancle" onclick='history.back()'>
		</form>
		
	</section>
	
</body>
</html>