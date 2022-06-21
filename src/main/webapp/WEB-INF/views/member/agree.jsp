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
	
		// 전체 선택
		$('#checkAll').on('click', function(){
		
			// 전체 선택이 checked -> 개별 선택 모두 checked
			// 전체 선택이 unchecked -> 개별 선택 모두 un-checked
			
			// 체크 여부 확인 방법
			//        Getter               Setter
			// 1) attr('checked'), attr('checked', 'checked')
			// 2) prop('checked'), prop('checked', true)
			
			// 체크 박스 체크 상태 변경
			$('.checkOne').prop('checked', $('#checkAll').prop('checked'));
			
			// 배경 이미지(체크 이미지) 변경
			if($('#checkAll').is(':checked')){
				$('.item, .items').addClass('check');
			} else {
				$('.item, .items').removeClass('check');
			}
		})
		
		// 개별 선택
		$('.checkOne').on('click', function(){
		
			let checkAll = true;                           // 전체 선택하는 거다.
			
			// 개별 선택이 하나라도 un-checked 상태이면, 전체 선택도 un-checked
			$.each($('.checkOne'), function(i, checkOne){
				if($(checkOne).is(':checked') == false){   // 개별 선택 하나라도 해제되어 있으면,
					$('#checkAll').prop('checked', false);
					$('.items').removeClass('check');
					checkAll = false;                      // 전체 선택이 아니다.
					return false;
				}
			})
			
			if(checkAll){
				$('#checkAll').prop('checked', true);
				$('.items').addClass('check');
			}
			
		})
		
		// 각 체크 박스는 클릭할때마다 check 클래스를 줬다 뺐었다 해야 함
		$('.item, .items').on('click', function(){
			$(this).toggleClass('check');
			
		})
		
		// 다음 버튼
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
	
		
		<input type="checkbox" id="checkAll" class="blind checkAll">
		<label for="checkAll" class="items">모두 동의합니다.</label>
		
		<hr>
		
		<input type="checkbox" id="service" class="blind checkOne">
		<label for="serivce" class="item">이용약관에 동의합니다.(필수)</label><br>
		<textarea>본 약관은 ...</textarea>
		<br><br>
		
		<input type="checkbox" id="privacy" class="blind checkOne">
		<label for="privacy" class="item">개인정보 수집에 동의합니다.(필수)</label><br>
		<textarea>개인정보보호법에 따라 ...</textarea>
		<br><br>
		
		<input type="checkbox" name="agreements" value="location" id="location" class="blind checkOne">  
		<!-- 
		checkbox 뿐만 아니라 하나로 받고 싶으면 name을 같게 주고 배열로 만들어 주면 된다.
		예를 들어 주소를 작성시킬 때 기본주소 + 상세주소를 작성시키고자 하면
		name을 address로 같게 주고 배열로 받으면 된다. email도 마찬가지.
		request.getParameterValues("agreements")
		String params = {"location", "promotion"} 
		-->
		<label for="location" class="item">위치정보 수집에 동의합니다.(선택)</label><br>
		<textarea>위치정보 이용약관 ...</textarea>
		<br><br>
		
		<input type="checkbox" name="agreements" value="promotion" id="promotion" class="blind checkOne">
		<label for="promotion" class="item">프로모션 정보 수신에 동의합니다.(선택)</label><br>
		<textarea>각종 이벤트 ...</textarea>
		<br><br>
		
		<input type="button" value="취소" onclick="history.back()">
		<input type="submit" value="다음">
		
	</form>
	
</body>
</html>