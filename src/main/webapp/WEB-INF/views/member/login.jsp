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
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js" integrity="sha512-3j3VU6WC5rPQB4Ld1jnLV7Kd5xr+cq9avvhwqzbH/taCRNURoeEpoPBK9pDyeukwSxwRPJ8fDgvYXd6SkaZ2TA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<script>
	
	$(function(){
		fnLogin();
		fnDisplayRememberId();
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
</head>
<body>
	
	
	<h3>로그인</h3>
	
	<form id="f" action="${contextPath}/member/login" method="post">
		
		<input type="hidden" name="url" value="${url}">
		
		아이디<br>
		<input type="text" name="memberId" id="memberId"><br><br>
		
		비밀번호<br>
		<input type="password" name="memberPw" id="memberPw"><br><br>
		
		<button>로그인</button><br><br>
		
		<label for="rememberId"><input type="checkbox" id="rememberId">아이디 저장</label>
	
	</form>
	
	<!-- 네이버 로그인 창으로 이동 -->			
	<div id="naver_id_login">
		<a href="${naver}">			
			<img width="200" src="https://developers.naver.com/doc/review_201802/CK_bEFnWMeEBjXpQ5o8N_20180202_7aot50.png"/>
		</a>
	</div>			
	<br>
	<!-- 카카오 로그인 창으로 이동 -->			
	<div id="kakao_id_login">
		<a href="${kakao}">			
			<img width="200" src="../resources/images/kakao_login_medium_narrow.png"/>
		</a>
	</div>			
	<br><br>
	
	<div>
		<a href="${contextPath}/member/agreePage">회원가입페이지</a> | 
		<a href="${contextPath}/member/findIdPage">아이디 찾기</a> | 
		<a href="${contextPath}/member/findPwPage">비밀번호 찾기</a>
	</div>
	
</body>
</html>