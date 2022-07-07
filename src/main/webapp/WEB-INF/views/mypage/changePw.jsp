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
			let regPw = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*~])[a-zA-Z0-9!@#$%^&*~]{8,16}$/;
			if($('#newPw').val() == '') {
				$('#pwMsg').text('');
				pwPass = false;
			} else if(regPw.test($('#newPw').val())==false){
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
			if(pwPass == false || rePwPass == false){
				alert('비밀번호를 확인하세요.');
				fnInit();
				event.preventDefault();
				return false;
			} 
			return true;
		})
	}
	
	function fnInit() {
		$('#newPw').val('');
		$('#newPwConfirm').val('');
		$('#pwMsg').text('');
		$('#pwConfirmMsg').text('');
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
        padding: 15px;
        cursor: pointer;
        border-left: 2px solid  rgba(44, 62, 80, 0.65); 
        border-right: 2px solid  rgba(44, 62, 80, 0.65);
    }
    .navItem a {
        text-decoration: none;
        color: rgb(70, 70, 70);
    }
    .nowPage {
        background-color: #2C3E50;
        opacity: 0.65;
    }
    .nowPage a {
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
	#btnCancle, button {
	  width: 235px;
	  padding: 16px 0px 15px;
	  margin-top: 10px;
      background-color: lightgrey;
      border: 1px solid lightgrey;
      border-radius: 3px;
      cursor: pointer;
      margin: 2px;
      font-size: 16px;
   }
   
   #btnCancle:hover, button:hover {
      background-color: #2C3E50; 
      opacity: 0.65;
      color: #F5F6F7;
   } 
   #wrapper{
      background-color: white;
      width: 70%;
      margin: 50px auto;
      border-radius: 50px;
      padding: 30px;
      text-align: center;
      box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
   }
	/* input[type=password] {
	  width: 200px;
	  height: 32px;
	  font-size: 15px;
	  border: 0;
	  border-radius: 5px;
	  outline: none;
	  padding-left: 10px;
	  background-color: rgb(233, 233, 233);
	} */
	.new_pw_wrap {
		text-align: center;
		margin: 10px;
	} 
	.new_pw_wrap .input_row {
        width: 50%;
        padding: 14px 17px 13px;
        border: 1px solid #dadada;
        position: relative;
        text-align: left;
        margin: 0 auto;
    }
    .new_pw_wrap .input_row:first-of-type {
        border-radius: 6px 6px 0 0;
        border-bottom: 0;
    }
    .new_pw_wrap .input_row:last-of-type {
        border-radius: 0 0 6px 6px;
    }
    .new_pw_wrap .input_row .input_text {
    	border: none;
        outline: none;
        cursor: pointer;
        padding-right: 30px;
        width: 90%;
        font-size: 16px;
        letter-spacing: -0.5px;
        color: #222;
        line-height: 19px;
        z-index: 4;  
        position: relative;
    }
	.blind {
        position: absolute;
        width: 1px;
        height: 1px;
        overflow: hidden;
    }
    .dont {
		color: red;
		font-size: 12px;
	}
	.ok {
		color: limegreen;
		font-size: 12px;
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
				<li class="navItem nowPage"><a href="${contextPath}/mypage/myInfo">개인정보</a></li>
			</ul>	
		</nav>
		
		<div id="wrapper">
			<h1><i class="fa-solid fa-user-pen"></i>&nbsp;&nbsp;변경하실 비밀번호를 입력해주세요</h1>
			<form id="f" action="${contextPath}/mypage/changePw" method="post">
				<div class="new_pw_wrap">
					<div class="input_row" id="pw_line">
						<span class="blind">
							새 비밀번호
						</span>
							<input type="password" class="input_text" name="newPw" id="newPw" placeholder="새 비밀번호"><br>
							<span id="pwMsg"></span>
					</div>
					<div class="input_row" id="pw_confirm_line">
						<span class="blind">
							새 비밀번호 확인
						</span>
						<input type="password" class="input_text" id="newPwConfirm" placeholder="새 비밀번호 확인"><br>
						<span id="pwConfirmMsg"></span>
					</div>
				</div>
				
				<input type="button" value="취소" id="btnCancle" onclick='history.back()'>
				<button>확인</button>
			</form>
		</div>
	</section>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>