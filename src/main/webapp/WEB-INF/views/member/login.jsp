<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<!-- jquery -->
<script src="../resources/js/jquery-3.6.0.js"></script>
<!-- jquery-cookie -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js" integrity="sha512-3j3VU6WC5rPQB4Ld1jnLV7Kd5xr+cq9avvhwqzbH/taCRNURoeEpoPBK9pDyeukwSxwRPJ8fDgvYXd6SkaZ2TA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script>
	
	

	/* 페이지 로드 이벤트 */
	$(function(){
		fnLogin();
		fnDisplayRememberId();
		fnNaver();
		fnCallback();
	})
	
	/* 함수 */
	
	function fnNaver(){
		$('#btnNaver').on('click', function(){
			var naver_id_login = new naver_id_login("XYULZHj0e4wadrMeNhvI", "http://localhost");
			var state = naver_id_login.getUniqState();
			naver_id_login.setButton("white", 2,40);
			naver_id_login.setDomain("http://localhost");
			naver_id_login.setState(state);
			naver_id_login.setPopup();
			naver_id_login.init_naver_id_login();
		})
	}
	
	  var naver_id_login = new naver_id_login("XYULZHj0e4wadrMeNhvI", "http://localhost");
	  // 접근 토큰 값 출력
	  alert(naver_id_login.oauthParams.access_token);
	  // 네이버 사용자 프로필 조회
	  naver_id_login.get_naver_userprofile("naverSignInCallback()");
	  // 네이버 사용자 프로필 조회 이후 프로필 정보를 처리할 callback function
	  function naverSignInCallback() {
	    alert(naver_id_login.getProfileData('email'));
	    alert(naver_id_login.getProfileData('nickname'));
	    alert(naver_id_login.getProfileData('age'));
	  }
	
	// 1. 로그인
	function fnLogin(){
		$('#f').on('submit', function(event){
			// 아이디, 비밀번호 입력 확인
			if($('#memberId').val() == '' || $('#memberPw').val() == ''){
				alert('아이디와 비밀번호를 모두 입력하세요.');
				event.preventDefault();
				return false;
			}
			// 아이디 저장 체크 확인
			// 아이디 저장은 쿠키를 이용한다.
			if($('#rememberId').is(':checked')){
				$.cookie('rememberId', $('#memberId').val());  // 입력한 id를 쿠키에 rememberId로 저장한다.
			} else {
				$.cookie('rememberId', '');
			}
			// 서브밋 수행
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
	
	<a>카카오 로그인</a>
	<input type="button" value="Naver" id="btnNaver">
	<div id="naver_id_login" style="text-align:center"><a href="${url}">			
	<img width="223" src="https://developers.naver.com/doc/review_201802/CK_bEFnWMeEBjXpQ5o8N_20180202_7aot50.png"/></a></div>			<br>
	
	<form id="f" action="${contextPath}/member/login" method="post">
		
		<input type="hidden" name="url" value="${url}">
		
		아이디<br>
		<input type="text" name="memberId" id="memberId"><br><br>
		
		비밀번호<br>
		<input type="password" name="memberPw" id="memberPw"><br><br>
		
		<button>로그인</button><br><br>
		
		<label for="rememberId"><input type="checkbox" id="rememberId">아이디 저장</label>
	
	</form>
	
	<br>
	
	<div>
		<a href="${contextPath}/member/agreePage">회원가입페이지</a> | 
		<a href="${contextPath}/member/findIdPage">아이디 찾기</a> | 
		<a href="${contextPath}/member/findPwPage">비밀번호 찾기</a>
	</div>
	
</body>
</html>