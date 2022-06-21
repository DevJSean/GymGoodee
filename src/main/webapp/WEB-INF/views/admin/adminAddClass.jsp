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

	/* 페이지 로드 이벤트 */
	$(function(){
		
		// 개설 날짜 선택하기
		$('#classDate').datepicker({	// 달력 나타나서 날짜 선택하기!
			'showOn' : 'focus',		// both 쓰면 옆에 버튼 생길 수 있다! / focus, button, both
			'dateFormat': "yymmdd"
		})
		
		// radio 선택 시 어떤 것을 선택했는지 알 수 있다.
		$(":radio[name=subject]").on('change',function(){
			var subject = $(this).attr('id');
			//alert(subject);
			
			fnGetTeacher(subject);
			fnGetLocation(subject)
		}) // change
		
		fnRegistClass();
	})
	
	
	
	/* 함수 */
	
	// 1. subject 담당인 강사 목록 가져오기
	function fnGetTeacher(subject){
		
		$.ajax({
			url : '${contextPath}/admin/teachersBySubject',
			type: 'GET',
			data : 'subject=' + subject,
			dataType: 'json',
			success : function(obj){
				$('#teachers').html('');
				$.each(obj.teachers, function(i,teacher){
					var res = '<option value="'+ teacher.teacherNo +'">' + teacher.teacherName +'</option>';
					$('#teachers').append(res);
				})
			}, error : function(jqXHR){
				
			}
			
		}) // ajax
		
		
	} // fnGetTeacher
	
	// 2. subject에 해당 하는 장소 목록 가져오기
	function fnGetLocation(subject){
		
		$.ajax({
			url : '${contextPath}/admin/locationsBySubject',
			type: 'GET',
			data : 'subject=' + subject.substr(0,2),
			dataType: 'json',
			success : function(obj){
				$('#locations').html('');
				$.each(obj.locations, function(i,location){
					var res = '<option value="'+ location.locationCode +'">' + location.locationCode +'</option>';
					$('#locations').append(res);
				})
			}, error : function(jqXHR){
				
			}
			
		}) // ajax
		
	} // fnGetLocation
	
	
	// 3. 강좌 개설하기 (POST 방식으로 INSERT 하기) -- 다시하기
	function fnRegistClass(){
		$('#f').on('submit',function(ev){
			// 강좌 코드, 강사번호, 장소코드, 날짜, 시간 정보를 CLASS 테이블에 INSERT 해야한다.
			// 강좌 코드 (날짜_시간_장소 형태로 생성)
			// 강사번호는 teacherNo, 장소코드는 locadtionCode 으로, 날짜는 $('#classDate').val(), 시간은 classTime으로 파라미터로 넘겨주면 된다.
		
			$.ajax({
				url : '${contextPath}/admin/addClass',
				type: 'POST',
				data: $('#f').serialize(),
				dataTye:'json',
				success : function(obj){
					console.log(obj);
					alert(obj.res);
				}
			}) // ajax
			
			
		}) // click
		
	} // fnRegistClass
	
</script>

</head>
<body>

	<h1>강좌 개설 페이지</h1>
	
	<hr>
	
	<!-- 강좌 선택하면 해당 강좌 선생님과, 해당 강좌 장소 보여주기 -->
	<!-- CLASS 테이블의 PK 는 '날짜_시간_장소' -->
	
	<!-- radio 선택했을 때의 이벤트 처리.... -->
	<!-- 강좌를 선택 했을 시, ajax 처리 하여 해당 강좌 선생님 선택, 장소 선택하여
		등록 버튼 눌렀을 때 pk를 위의 형태로 만들어서 insert 하는데 실패할 경우 이미 개설된 수업이므로
		불가능!
	-->
	
	개설하고자 하는 종목을 선택하세요!<br>
	<label for="SWIN">
		수영<input type="radio" name="subject" id="SWIN">	
	</label>
	<label for="PILATES">
		필라테스<input type="radio" name="subject" id="PILATES">	
	</label>
	<label for="SPINNING">
		스피닝<input type="radio" name="subject" id="SPINNING">	
	</label>
	<label for="DANCE">
		스포츠댄스<input type="radio" name="subject" id="DANCE">	
	</label>
	
	<hr>

	<form id="f">
		강사 선택
		<select id="teachers" name="teacherNo">
		</select>
		<br>
		장소 선택
		<select id="locations" name="locationCode">
		</select>
		<br>
		
		날짜 선택
		<input type="text" name="classDate" id="classDate">
		<br>
		
		시간 선택
		<select name="classTime">
			<option value="A">A</option>
			<option value="B">B</option>
			<option value="C">C</option>
			<option value="D">D</option>
		</select>
		<br><br>
		<button>강좌 개설하기</button>
	</form>
	
	
	
	
	
	
</body>
</html>