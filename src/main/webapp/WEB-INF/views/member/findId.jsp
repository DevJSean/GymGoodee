<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>GymGoodee : 아이디 찾기</title>

<script src="../resources/js/jquery-3.6.0.js"></script>

<script src="https://momentjs.com/downloads/moment-with-locales.js"></script>

<script>

	moment.locale('ko');


	$(document).ready(function(){
		fnFindId();
	});
	
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
						$('#findIdMsg').html('회원님의 아이디는 ' + obj.findMember.memberId + '입니다.<br>(가입일 : ' + moment(obj.findMember.memberSignUp).format("YYYY년 MM월 DD일 a h:mm:ss") + ')');
					} else {
						$('#findIdMsg').html('일치하는 회원이 없습니다. 입력 정보를 확인하세요.');
					}
				}
			});
		});
	}
	
</script>
<style>
	.changeArea {
		display: none;
	}
</style>
</head>
<body>

	<h3>아이디 찾기</h3>
	
	<div class="authArea">
		이름<br>
		<input type="text" name="memberName" id="memberName"><br><br>
		
		이메일 주소<br>
		<input type="text" name="memberEmail" id="memberEmail"><br><br>
		
		<input type="button" value="아이디찾기" id="btnFindId"><br><br>
	</div>
	
	<div class="changeArea">
		<div id="findIdMsg"></div><br><hr><br>
		
		<div>
			<a href="${contextPath}/member/findPwPage">비밀번호 찾기</a> /
			<a href="${contextPath}/member/agreePage">회원가입</a>
		</div>
	</div>
	
	
</body>
</html>