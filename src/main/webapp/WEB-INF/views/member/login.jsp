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

<script>
	
	$(function(){
		fnLogin();
		fnDisplayRememberId();
	})
	
	$(function(){
		$('.input_remember').on('click', function(){
			$(this).toggleClass('remember_check');
			
		})
	})
	
	
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
	
</script>
<style>
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
            z-index: 3; 
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
        .remember_check {
            padding-left: 23px;
            position: relative;
        }
        .remember_check .input_remember {
            position: absolute;
            top: 2px;
            left: 3px;
            width: 15px;
            height: 15px;
        }
        .remember_text {
        	display: inline_block;
        	font-size: 14px;
        	font-weight: 500;
        	line-height: 17px;
        	color: #777;
        }
        .remember_check .remember_text::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            background-image: url(https://ssl.pstatic.net/static/nid/login/m_sp_01_login_008d5216.png);
            background-size: 266px 225px;
            background-position: -244px -87px;
            background-color: #fff;
            width: 18px;
            height: 18px;
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
            background-color: #03c75a;
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
</style>
</head>
<body>
	
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
				                        <div class="remember_check">
			                            	<input type="checkbox" id="rememberId" class="input_remember blindCheck">
				                            	<label for="rememberId" class="remember_text">
				                            		로그인 상태 유지
				                            	</label>
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
											<img width="200" height="45" src="https://developers.naver.com/doc/review_201802/CK_bEFnWMeEBjXpQ5o8N_20180202_7aot50.png"/>
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
			        <li><a href="${contextPath}/member/findIdPage">아이디 찾기</a></li>
			        <li><a href="${contextPath}/member/findPwPage">비밀번호 찾기</a></li>
			    </ul>
	    	</div>  <!-- content -->
	    </div>  <!-- container -->	
    </div>	
</body>
</html>