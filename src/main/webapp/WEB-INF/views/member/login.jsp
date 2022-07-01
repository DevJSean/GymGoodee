<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>GymGoodee : 로그인</title>

<script src="../resources/js/jquery-3.6.0.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js" integrity="sha512-3j3VU6WC5rPQB4Ld1jnLV7Kd5xr+cq9avvhwqzbH/taCRNURoeEpoPBK9pDyeukwSxwRPJ8fDgvYXd6SkaZ2TA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://momentjs.com/downloads/moment-with-locales.js"></script>

<script>
	
	$(function(){
		fnLogin();
		fnDisplayRememberId();
		fnFindId();
		fnPwCheck();
		fnPwConfirm();
		fnPhoneAuth();
		fnToUpperCase();
		fnChangePw();


		$('#remember_id').on('click', function(){
			$('.input_remember').prop('checked', true);
			if($('#remember_id').is(':checked')){
				$('.input_remember').addClass('check');
			} else {
				$('.input_remember').removeClass('check');
			}
		})
		
		$('.remember_text').on('click', function(){
			$(this).toggleClass('remember_check');
			
		})
		
		$('#findId').on('click', function(){
			$('.authAreaSMS').css('display', 'none');
			$('.authArea').css('display', 'block');
			$('.titlePw').css('display', 'none');
			$('.titleId').css('display', 'block');
			$('#modal.modal-overlay').css('display', 'flex');
		})
		
		$('#findPw').on('click', function(){
			$('.authArea').css('display', 'none');
			$('.authAreaSMS').css('display', 'block');
			$('.titleId').css('display', 'none');
			$('.titlePw').css('display', 'block');
			$('#modal.modal-overlay').css('display', 'flex');
		})
		
		$('#btnClose1').on('click', function(){
			$('#modal.modal-overlay').css('display', 'none');
		})
		
		$('#btnClose2').on('click', function(){
			$('#modal.modal-overlay').css('display', 'none');
		})
		
		$('#btnClose3').on('click', function(){
			$('#modal.modal-overlay').css('display', 'none');
		})
		
		$('#btnClose4').on('click', function(){
			$('#modal.modal-overlay').css('display', 'none');
		})
		
		$('#btnFindPw').on('click', function(){
			$('.changeArea').css('display', 'none');
			$('.authAreaSMS').css('display', 'block');
			$('.titleId').css('display', 'none');
			$('.titlePw').css('display', 'block');
		})
		
		$('#btnSignUp').on('click', function(){
			location.href="${contextPath}/member/agreePage";
		})
	})
	
	moment.locale('ko');
	
	// 1. 로그인
	function fnLogin(){
		$('#f').on('submit', function(event){
			if($('#memberId').val() == '' || $('#memberPw').val() == ''){
				alert('아이디와 비밀번호를 모두 입력하세요.');
				event.preventDefault();
				return false;
			}
			if($('#rememberId').is(':checked')){
				$.cookie('rememberId', $('#memberId').val());  
			} else {
				$.cookie('rememberId', '');
			}
			return true;
		})
	}
	
	// 2. 아이디 저장을 체크하면 쿠키에 저장된 아이디를 보여줌
	function fnDisplayRememberId(){
		let rememberId = $.cookie('rememberId');
		if(rememberId != ''){
			$('#memberId').val(rememberId);
			$('#rememberId').prop('checked', true);
		} else {
			$('#memberId').val('');
			$('#rememberId').prop('checked', false);
		}
	}
	
	// 3. 아이디 찾기
	function fnFindId(){
		$('#btnFindId').click(function(){
			let regEmail = /^[a-zA-Z0-9-_]+@[a-zA-Z0-9]+(\.[a-zA-Z]{2,}){1,2}$/;  // 실제 서비스에서 그대로 사용 가능.
			if (regEmail.test($('#memberEmail').val()) == false) {
				alert('이메일 형식을 확인하세요.');
				$('#findIdMsg').text('');
				return;

			}
			$.ajax({
				url: '${contextPath}/member/findId',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					memberName: $('#memberName').val(),
					memberEmail: $('#memberEmail').val()
				}),
				dataType: 'json',
				success: function(obj) {
					if (obj.findMember != null) {
						$('.authArea').css('display', 'none');
						$('.changeArea').css('display', 'block');
						$('#findIdMsg').html('회원님의 아이디는<br>' + obj.findMember.memberId + '입니다.<br>가입일<br>' + moment(obj.findMember.memberSignUp).format("YYYY년 MM월 DD일 a h:mm:ss"));
					} else {
						$('#findIdMsg').html('일치하는 회원이 없습니다. 입력 정보를 확인하세요.');
					}
				}
			});
		});
	}
	
	// 4. 비밀번호 정규식
	let pwPass = false;
	function fnPwCheck(){
		$('#changeMemberPw').on('keyup', function(){
			let regPw = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,16}$/;
			if(regPw.test($('#changeMemberPw').val())==false){
				$('#pwMsg').text('8~16자 영문, 숫자, 특수문자를 모두 사용하세요.').addClass('dont').removeClass('ok');
				pwPass = false;
			} else {
				$('#pwMsg').text('사용 가능한 비밀번호입니다.').addClass('ok').removeClass('dont');
				pwPass = true;
			}
		})
	}
	
	// 5. 비밀번호 입력확인
	let rePwPass = false;
	function fnPwConfirm(){
		$('#pwConfirm').on('keyup', function(){
			if($('#pwConfirm').val() != '' && $('#changeMemberPw').val() != $('#pwConfirm').val()){
				$('#rePwMsg').text('비밀번호를 확인하세요.').addClass('dont').removeClass('ok');
				rePwPass = false;
			} else {
				$('#rePwMsg').text('');
				rePwPass = true;
			}
		})
	}
	
	// 6. 아이디 + 연락처 일치하는 회원 확인
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
				data: 'memberId=' + $('#confirmMemberId').val() + '&memberPhone=' + $('#memberPhone').val(),
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
	
	// 7. SMS 인증
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
	
	// 8. 인증코드 검증
	let authCodePassSMS = false;
	function fnVerifyAuthCodeSMS(authCodeSMS){ 
		$('#btnVerifyAuthCodeSMS').on('click', function(){
			if($('#authCodeSMS').val() == authCodeSMS){
				alert('인증되었습니다.');
				$('.authAreaSMS').css('display', 'none');
				$('.changePw').css('display', 'block');
				authCodePassSMS = true;
			} else {
				alert('인증에 실패했습니다.');
				authCodePassSMS = false;
			}
		})
	}
	
	// 9. 입력을 무조건 대문자로 처리
	function fnToUpperCase(){
		$('#authCodeSMS').on('keyup', function(){
			$('#authCodeSMS').val($('#authCodeSMS').val().toUpperCase());
		})
	}
	
	// 10. 비밀번호 변경
	function fnChangePw(){
		$('#f2').on('submit', function(event){
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
      	.changeArea, .authAreaSMS, .changePw, #modal .titlePw h2 {
		display: none;
		}
		#modal.modal-overlay {
			
		    width: 100%;
		    height: 100%;
		    position: absolute;
		    left: 0;
		    top: 0;
		    display: flex;
		    flex-direction: column;
		    align-items: center;
		    justify-content: center;
		    background: rgba(255, 255, 255, 0.25);
		    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
		    backdrop-filter: blur(1.5px);
		    -webkit-backdrop-filter: blur(1.5px);
		    border-radius: 10px;
		    border: 1px solid rgba(255, 255, 255, 0.18);
		    display:none;
		    z-index: 2;
		}
	    #modal .modal-window {
	        background: rgba( 69, 139, 197, 0.70 );
	        box-shadow: 0 8px 32px 0 rgba( 31, 38, 135, 0.37 );
	        backdrop-filter: blur( 13.5px );
	        -webkit-backdrop-filter: blur( 13.5px );
	        border-radius: 10px;
	        border: 1px solid rgba( 255, 255, 255, 0.18 );
	        width: 400px;
	        height: 200px;
	        position: relative;
	        padding: 10px;
	    }
	    #modal .titleId, .titlePw {
	        padding-left: 10px;
	        display: inline;
	        text-shadow: 1px 1px 2px gray;
	        color: white;
	    }
	    #modal .titleId h2, .titlePw h2 {
	        display: inline;
	    }
	    #modal .close-area {
	        display: inline;
	        float: right;
	        padding-right: 10px;
	        cursor: pointer;
	        text-shadow: 1px 1px 2px gray;
	        color: white;
	    }
	    
	    #modal .authArea, .changeArea, .authAreaSMS, .changePw {
	        margin-top: 20px;
	        padding: 0px 10px;
	        text-shadow: 1px 1px 2px gray;
	        color: white;
	    }
	    #btnClose1, #btnFindId {
	    	position: relative;
	    	left: 220px;
	    	bottom: 120px;
	    	background-color: lightgrey;
			width: 120px;
			height: 40px;
			color: grey;
			border: none;
			border-radius: 5px;
	    }
	    
	    #btnClose2, #btnFindPw, #btnSignUp {
	    	position: relative;
	    	left: 250px;
	    	bottom: 145px;
	    	background-color: lightgrey;
			width: 120px;
			height: 40px;
			color: grey;
			border: none;
			border-radius: 5px;
	    }
	    #btnClose3, #btnGetAuthCodeSMS, #btnVerifyAuthCodeSMS {
	    	position: relative;
	    	left: 250px;
	    	bottom: 145px;
	    	background-color: lightgrey;
			width: 120px;
			height: 40px;
			color: grey;
			border: none;
			border-radius: 5px;
	    }
	    #btnClose4, #btnChangePw {
	    	position: relative;
	    	left: 125px;
	    	bottom: -10px;
	    	background-color: lightgrey;
			width: 120px;
			height: 40px;
			color: grey;
			border: none;
			border-radius: 5px;
	    }
	    
	    
        html, body, button, dd, dl, dt, fieldset, form,
        h1, h2, h3, h4, h5, h6, input, legend, 
        li, ol, p, select, table, td, textarea, th, ul,
        div, a, span, label {
            padding: 0;
            margin: 0;
            box-sizing: border-box;
        }
        html {
            font-size: 14px;
            height: 100%;
        }
        body {
            height: 100%;
            color: #222;
            background-color: #fff;
        }
        a {
            text-decoration: none;
        }
        input, button {
            border: none;
            outline: none;
            cursor: pointer;
        }
        ul {
            list-style-type: none;
        }
        .wrap {
            position: relative;
            height: 100%;
            letter-spacing: -0.5px;
        }
        .header {
            padding-bottom: 48px;
        } 
        .header .header_inner {
            margin: 0 auto;
            width: 743px;
            text-align: center;
            position: relative;
        }
        .header_inner .logo {
            display: inline-block;
            width: 300px;
            height: 150px;
            margin-top: 108px;
            background-image: url(../resources/images/linkedin_banner_image_1.png);
            background-size: 300px 150px;
            background-repeat: no-repeat;
        }
        .blind {
            position: absolute;
            width: 1px;
            height: 1px;
            overflow: hidden;
        }
        .login_wrap {
            width: 460px;
            margin: 0 auto;
        }
        .panel_wrap {
            margin-top: -8px;
            z-index: 1; 
            position: relative;
        }
        .panel_item {
            border: 1px solid #c6c6c6;
            border-radius: 6px;
            background-color: #fff;
        }
        .panel_inner {
            padding: 20px 28px;
        }
        .id_pw_wrap .input_row {
            display: table;
            table-layout: fixed;
            width: 100%;
            padding: 14px 17px 13px;
            border: 1px solid #dadada;
            position: relative;
        }
        .id_pw_wrap .input_row:first-of-type {
            border-radius: 6px 6px 0 0;
            border-bottom: 0;
        }
        .id_pw_wrap .input_row:last-of-type {
            border-radius: 0 0 6px 6px;
        }
        .id_pw_wrap .input_row .icon_cell {
            display: table-cell;
            width: 24px;
            vertical-align: middle;
        }
        .id_pw_wrap .input_row .icon_cell .icon_id,
        .id_pw_wrap .input_row .icon_cell .icon_pw {
            width: 16px;
            height: 16px;
            background-image: url(https://ssl.pstatic.net/static/nid/login/m_sp_01_login_008d5216.png);
            background-size: 266px 225px;
            position: absolute;
            top: 50%;
            left: 17px;
            margin-top: -8px;
        }
        .id_pw_wrap .input_row .icon_cell .icon_id {
            background-position: -93px -203px;
        }
        .id_pw_wrap .input_row .icon_cell .icon_pw {
            background-position: -129px -203px;
        }
        .id_pw_wrap .input_row .input_text {
            display: table-cell;
            padding-right: 30px;
            width: 100%;
            font-size: 16px;
            letter-spacing: -0.5px;
            color: #222;
            line-height: 19px;
            z-index: 4;  
            position: relative;
        }
       	.blindCheck {
			display: none;
		}
        .id_remember_wrap {
            margin-top: 13px;
            padding-right: 90px;
            position: relative;
        }
        .remember_text {
        	font-size: 14px;
        	font-weight: 500;
        	line-height: 17px;
        	color: #777;
 			padding-left: 25px;
			background-image: url(../resources/images/uncheck.png);
			background-size: 18px 18px;
			background-repeat: no-repeat;
        }
        .remember_check {
            background-image: url(../resources/images/check.png);
            background-color: #90c2ff;
        }
        .btn_login_wrap {
            margin-top: 38px;
        }
        .btn_login {
            display: block;
            width: 100%;
            padding: 13px 0;
            border: 1px solid rgba(0,0,0,0.15);
            border-radius: 6px;
            background-color: #90c2ff;
        }
        .btn_login .btn_text {
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            line-height: 24px;
        }
        .api_login {
            padding: 20px 0 35px;
            position: relative;
            display: inline-block;
            line-height: 17px;
        }
        .find_wrap {
            padding: 20px 0 35px;
            text-align: center;
        }
        .find_wrap li {
            display: inline-block;
            position: relative;
        }
        .find_wrap .find_text {
            display: inline-block;
            line-height: 17px;
            color: #888;
        }
        .find_wrap li+li {
            position: relative;
            padding-left: 13px;
        }
        .find_wrap li+li::before {
            content: '';
            width: 1px;
            height: 12px;
            background-color: #dadada;
            border-radius: 0.5px;
            position: absolute;
            top: 3px;
            left: 3px;
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
	
    <div id="modal" class="modal-overlay">
        <div class="modal-window">
            <div class="titleId">
                <h2>아이디 찾기</h2>
            </div>
            <div class="authArea">
           		이름<br>
           		<input type="text" name="memberName" id="memberName"><br><br>
            	이메일 주소<br>
				<input type="text" name="memberEmail" id="memberEmail"><br><br>
                <input type="button" value="아이디찾기" id="btnFindId"><br><br>
                <input type="button" value="나가기" id="btnClose1">
            </div>
		   	<div class="changeArea">
				<div id="findIdMsg"></div><br><br>
				
				<div>
					<input type="button" value="비밀번호찾기" id="btnFindPw"><br><br>
					<input type="button" value="회원가입" id="btnSignUp"><br><br>
					<input type="button" value="나가기" id="btnClose2">
				</div>
			</div>
            <div class="titlePw">
                <h2>비밀번호 찾기</h2>
            </div>
			<form id="f2" action="${contextPath}/member/changePw" method="post">
				<div class="authAreaSMS">
					아이디<br>
					<input type="text" name="memberId" id="confirmMemberId"><br><br>
					가입 당시 연락처<br>
					<input type="text" id="memberPhone" placeholder="-를 포함하여 입력"><br><br>
					<input type="text" id="authCodeSMS" placeholder="인증코드 입력"><br>
					<input type="button" value="인증번호받기" id="btnGetAuthCodeSMS"><br><br>
					<input type="button" value="인증하기" id="btnVerifyAuthCodeSMS"><br><br>
					<input type="button" value="나가기" id="btnClose3">
				</div>
				<div class="changePw">
					비밀번호<br>
					<input type="password" name="memberPw" id="changeMemberPw" placeholder="새 비밀번호"><br>
					<span id="pwMsg"></span><br>
					비밀번호 확인<br>
					<input type="password" id="pwConfirm" placeholder="새 비밀번호 확인"><br>
					<span id="rePwMsg"></span><br>
					<input type="button" value="나가기" id="btnClose4">
					<button id="btnChangePw">비밀번호 변경하기</button>
				</div>
			</form>
        </div>
    </div>
    
    
	
	<div id="wrap" class="wrap">

        <header class="header">
            <div class="header_inner">
                <a href="${contextPath}" class="logo">
                    <span class="blind">GymGoodee</span>
                </a>
            </div>
        </header>
	
		<div class="container">
	    	<div class="content">
				<div class="login_wrap">
					<form id="f" action="${contextPath}/member/login" method="post">
				        <ul class="panel_wrap">
				          <li class="panel_item">
				              <div class="panel_inner">
				                  <div class="id_pw_wrap">
				                      <div class="input_row" id="id_line">
				                          <div class="icon_cell" id="id_cell">
				                              <span class="icon_id">
				                                  <span class="blind">아이디</span>
				                              </span>
				                          </div>
											<input type="hidden" name="url" value="${url}">
											<input type="text" class="input_text" name="memberId" id="memberId" placeholder="아이디" title="아이디">
										</div>
										<div class="input_row" id="pw_line">
				                            <div class="icon_cell" id="pw_cell">
				                                <span class="icon_pw">
				                                    <span class="blind">비밀번호</span>
				                                </span>
				                            </div>
				                            <input type="password" class="input_text" name="memberPw" id="memberPw" placeholder="비밀번호" title="비밀번호">
				                        </div>
				                    </div>
				                    <div class="id_remember_wrap">
				                        <div class="remember">
			                            	<label for="rememberId" class="remember_text">아이디 저장</label>
			                            	<input type="checkbox" id="rememberId" class="input_remember blindCheck">
				                        </div>
			                        </div>
			                        <div class="btn_login_wrap">
			                            <button class="btn_login">
			                                <span class="btn_text">로그인</span>
			                            </button>
			                        </div>
				                    <div class="api_login" id="api_login">
				                    	<!-- 네이버 로그인 창으로 이동 -->	
					                   	<a href="${naver}">			
											<img width="200" height="45" src="../resources/images/btn_NaverLogin.png"/>
										</a>
										<!-- 카카오 로그인 창으로 이동 -->	
										<a href="${kakao}">			
											<img width="195" height="45" src="../resources/images/kakao_login_medium_narrow.png"/>
										</a>
									</div>
			                    </div>
			                </li>
			            </ul>
			        </form>
			    </div>
				<ul class="find_wrap" id="find_wrap">
			        <li><a href="${contextPath}/member/agreePage">회원가입</a></li>
			        <!-- <li><a href="${contextPath}/member/findIdPage">아이디 찾기</a></li> -->
			        <li><a id="findId">아이디 찾기</a></li>
			        <!-- <li><a href="${contextPath}/member/findPwPage">비밀번호 찾기</a></li>  -->
			        <li><a id="findPw">비밀번호 찾기</a></li>
			    </ul>
	    	</div>  <!-- content -->
	    </div>  <!-- container -->	
    </div>	
</body>
</html>