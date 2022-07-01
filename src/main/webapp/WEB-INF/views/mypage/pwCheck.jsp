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
	/* 	$('#f').on('submit', function(event){
			if($('#memberPw').val() == '') {
				alert('비밀번호를 입력하세요.');
				event.preventDefault();
				return false;
			}
			return true;
		} */
		// 개인정보페이지 들어오면 비밀번호 확인
		$('#btnCheck').on('click', function() {
			if($('#memberPw').val() == '') {
				alert('비밀번호를 입력하세요.');
				return;
			}
			$.ajax({
				url: '${contextPath}/mypage/pwCheck',
				data: 'memberPw=' + $('#memberPw').val(),
				type: 'post',
				dataType: 'json',
				success: function(obj) {
					if(obj.res){
						location.href='${contextPath}/mypage/myInfo';
					} else {
						alert('비밀번호가 일치하지 않습니다.');
					}
				}
			})
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

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>	
	
	<section>
	
		<nav>
			<ul class="myPageNav">
				<li class="navItem"><a href="${contextPath}/mypage/myReserveList">수강내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myPayList">결제내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/pwCheckPage">개인정보</a></li>
			</ul>	
		</nav>
	
		<label for="memberPw">
			비밀번호를 입력하세요.<br>
			<input type="password" name="memberPw" id="memberPw"><br><br>
		</label>
			<input type="button" value="확인" id="btnCheck"> 
			<input type="button" value="취소" id="btnCancle" onclick='history.back()'>
		
	</section>
	
</body>
</html>