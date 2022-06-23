<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

	.blind {
		display: none;
	}
	
	.items, .item {
		padding-left: 20px;
		background-image: url(../resources/images/uncheck.png);
		background-size: 18px 18px;
		background-repeat: no-repeat;
	}
	
	.check {
		background-image: url(../resources/images/check.png);
	}

</style>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>

	$(function(){
		$('#checkAll').on('click', function(){
			$('.checkOne').prop('checked', $('#checkAll').prop('checked'));
			if($('#checkAll').is(':checked')){
				$('.item, .items').addClass('check');
			} else {
				$('.item, .items').removeClass('check');
			}
		})

		
		
		$('.checkOne').on('click', function(){
			let checkAll = true;                         
			$.each($('.checkOne'), function(i, checkOne){
				if($(checkOne).is(':checked') == false){   
					$('#checkAll').prop('checked', false);
					$('.items').removeClass('check');
					checkAll = false;                      
					return false;
				}
			})
			if(checkAll){
				$('#checkAll').prop('checked', true);
				$('.items').addClass('check');
			}
		})
		
		$('.item, .items').on('click', function(){
			$(this).toggleClass('check');
		})
		
		$('#f').on('submit', function(event){
			if($('#service').is(':checked') == false || $('#privacy').is(':checked') == false) {
				alert('필수 약관에 모두 동의하세요.');
				event.preventDefault();
				return false;
			}
			return true;
		})
		
	})
	

</script>
</head>
<body>
	
	<h3>약관 동의하기</h3>
	
	<form id="f" action="${contextPath}/member/signUpPage">
	
		
		<label for="checkAll" class="items">모두 동의합니다.</label>
		<input type="checkbox" id="checkAll" class="blind checkAll">
		
		<hr>
		
		<label for="service" class="item">이용약관에 동의합니다.(필수)</label><br>
		<input type="checkbox" id="service" class="blind checkOne">
		<textarea>본 약관은 ...</textarea>
		<br><br>
		
		<label for="privacy" class="item">개인정보 수집에 동의합니다.(필수)</label><br>
		<input type="checkbox" id="privacy" class="blind checkOne">
		<textarea>개인정보보호법에 따라 ...</textarea>
		<br><br>
		
		<label for="location" class="item">위치정보 수집에 동의합니다.(선택)</label><br>
		<input type="checkbox" name="agreements" value="location" id="location" class="blind checkOne">  
		<textarea>위치정보 이용약관 ...</textarea>
		<br><br>
		
		<label for="promotion" class="item">프로모션 정보 수신에 동의합니다.(선택)</label><br>
		<input type="checkbox" name="agreements" value="promotion" id="promotion" class="blind checkOne">
		<textarea>각종 이벤트 ...</textarea>
		<br><br>
		
		<input type="button" value="취소" onclick="history.back()">
		<input type="submit" value="다음">
		
	</form>
	
</body>
</html>