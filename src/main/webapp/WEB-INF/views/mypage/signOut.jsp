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
		$('#f').on('submit', function(event){
			if(confirm('정말로 탈퇴하시겠습니까 ?')) {
				if($('#confirmPw').val() == '') {
					alert('비밀번호를 입력하세요.');
					event.preventDefault();
					return false;
				}
				return true;
			}
		})
	})
	
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
	  border-radius: 5px;
	  outline: none;
	  padding-left: 10px;
	  background-color: rgb(233, 233, 233);
	}
	button {
		width: 300px;
		padding: 16px 0px 15px;
		margin-top: 10px;
		background-color: #BADFC4;
		border: none;
		border-radius: 5px;
		font-size: 15px;
	}
	#btnCancle {
		width: 300px;
		padding: 16px 0px 15px;
		margin-top: 10px;
		background-color: lightgrey;
		border: none;
		border-radius: 5px;
		font-size: 15px;
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

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>	
	
	<section>
	
		<nav>
			<ul class="myPageNav">
				<li class="navItem"><a href="${contextPath}/mypage/myReserveList">수강내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myPayList">결제내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myInfo">개인정보</a></li>
			</ul>	
		</nav>
	
		<form id="f" action="${contextPath}/mypage/signOut" method="post">
			<input type="hidden" name="memberNo" value="${loginMember.memberNo}">
			<label for="confirmPw">
				비밀번호 확인
				<input type="password" name="confirmPw" id="confirmPw"><br><br>
			</label>
			
			<button>회원탈퇴</button><br>
			<input type="button" value="취소" id="btnCancle" onclick='history.back()'>
		</form>
		
	</section>
	
</body>
</html>