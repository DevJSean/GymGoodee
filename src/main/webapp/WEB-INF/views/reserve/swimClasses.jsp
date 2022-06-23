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
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js" integrity="sha256-6XMVI0zB8cRzfZjqKcD01PBsAy3FlDASrlC8SxCpInY=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">
<script>

	// 페이지로드 이벤트
	$(function(){
		
		fnReserve();
		fngetClasses();
	})
	
	// 함수
	
	// 1. model에 담겨진 subject, classDate 정보를 읽어와서 ajax로 해당 종목, 날짜 개설 강좌 리스트로 불러오기
	function fngetClasses(){
		$.ajax({
			url : '${contextPath}/reserve/getClasses1',
			type: 'get',
			data : 'subject=SWIM&classDate=${classDate}',
			dataType:'json',
			success :function(obj){
				console.log(obj);
				$('#classList').empty();
				$.each(obj.classes, function(i,swimclass){
					var tr = $('<tr>');
					tr.append($('<td>').text(swimclass.teacherName));
					tr.append($('<td>').text(swimclass.classTime));
					tr.append($('<td>').text(swimclass.locationCode));
					tr.append($('<td>').text(swimclass.currentCount + "/" + swimclass.locationLimit));
					tr.append($('<td>').html('<input type="button" name="btnreserve" ???? value="예약">'));
					tr.appendTo($('#classList'));
				})
			}
		}) // ajax
	}
	
	// 2. 예약 버튼 눌러서 예약하기
	function fnReserve(){
		$('.btnreserve').on('click',function(){
			var a = $(this).data('vs');
			var children = $('#class' + a).children();
			console.log(children[0].value);
			// td에는 선생님 이름, 강의 시간, 장소코드, 현재신청인원 / 정원 정보가 들어있다.
			$.ajax({
				url : '${contextPath}/reserve/reserveSwim',
				type: 'post',
				data : 'subject=SWIM&memberNo=101&classCode=' + children[0].value,
				success : function(obj){
					if(obj.res == 1){
						if(confirm('예약이 완료되었습니다. 마이페이지로 이동하시겠습니까?')){
							location.href = '${contextPath}/mypage/myReserveList?memberNo=101';
						} else{
							window.close();
						}
					}
					else if(obj.res == 0){
						alert('강좌 예약에 실패했습니다.');
						window.close();
					}
				}
				
				
			}) // ajax
			
			
			
		}) // click
		
		
	} // fnReserve
	
	
	
</script>
<style>


</style>
</head>
<body>

	<h1>해당 날짜 강좌 목록</h1>
	
	
	<hr>
	
	<table border="1">
		<thead>
			<tr>
				<td>강사명</td>
				<td>시간</td>
				<td>장소</td>
				<td>수강인원</td>
				<td>버튼</td>
			</tr>
		</thead>
		<tbody id="classList">
			
		</tbody>
	
	</table>
	
	
	
	
	
</body>
</html>