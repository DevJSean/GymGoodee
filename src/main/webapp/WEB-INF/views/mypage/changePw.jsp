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
		$('#btnPwChange').on('click', function(event) {
			if($('#pw').val() == '') {
				alert('비밀번호를 입력하세요.');
				event.preventDefault();
				return false;
			} else if($('#pw').val() != '${memberPw}') {
				alert('비밀번호가 일치하지 않습니다.');
				$('#pw').val('');
				event.preventDefault();
				return false;
			}
			return true;
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
	#btnCancle {
		width: 300px;
		padding: 16px 0px 15px;
		margin-top: 10px;
		background-color: lightgrey;
		color: white;
		border: none;
		border-radius: 15px;
	
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
				<li class="navItem"><a href="${contextPath}/mypage/myPayList?memberNo=101">결제내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myPwCheck?memberNo=101">개인정보</a></li>
			</ul>	
		</nav>
	
		<div>
			<h1>비밀번호 입력</h1>
			<label for="pw">
				현재 비밀번호
				<input type="password" name="pw" id="pw"><br><br>
			</label>
			<label for="newPW">
				새 비밀번호
				<input type="password" name="newPw" id="newPw"><br>
			</label>			
			<label for="newPwCheck">
				새 비밀번호 확인
				<input type="password" name="newPwCheck" id="newPwCheck"><br>
			</label>
			
			<input type="button" value="확인" id="btnPwChange"><br>
			<input type="button" value="취소" id="btnCancle" onclick='history.back()'>
		</div>
		
	</section>
	
</body>
</html>