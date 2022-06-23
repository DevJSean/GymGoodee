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
<script>

	/* 페이지 로드 이벤트 */
	$(function(){
		fnTeacherList();
		fnaddTeacher();		
	})
	
	/* 함수 */
	
	// 1. 강사 추가
	function fnaddTeacher(){
		$('#btnTeacherAdd').on('click',function(ev){
			var Gender =  $(':radio[name="teacherGender"]:checked').val();
			var Subject = $(':radio[name="teacherSubject"]:checked').val();
			
			if($('#teacherName').val() == ''){
				alert('강사명을 입력해주세요.');
				fnInit();
				ev.preventDefault();
				return false;
			}
			if(typeof(Gender) == 'undefined'|| typeof(Subject) == 'undefined'){
				alert('성별과 종목은 필수입니다.');
				ev.preventDefault();
				fnInit();
				return false;
			}
			
			let teacher = JSON.stringify(
				{
					teacherName: $('#teacherName').val(),
					teacherGender: Gender,
					teacherSubject: Subject
				}
					
			); // teacher
			
			// ajax 처리
			$.ajax({
				url: '${contextPath}/admin/addTeacher',
				type: 'POST',
				data: teacher,
				contentType: 'application/json',
				// 응답
				dataType: 'json',
				success: function(obj){
					//console.log(obj);
					if(obj.res > 0){
						alert('강사가 등록되었습니다.');
						fnTeacherList();
					} else {
						alert('강사 등록에 실패했습니다.');
					}
				},
				error: function(jqXHR){
					alert('예외코드[' + jqXHR.status + '] : ' + jqXHR.responseText);
				}
				
			}) // ajax

			fnInit();
		}) // click

	} // fnaddTeacher
	
	// 2. 강사 목록 가져오기 => paging 처리 x
	function fnTeacherList(){
		
		$.ajax({
			url : '${contextPath}/admin/TeacherList',
			type : 'GET',
			dataType : 'json',
			success: function(obj){
				$('#teachers').empty();
				// obj에 res 와 members 둘다 담자
				//console.log(obj);
				if(obj.res == 1){
					$.each(obj.teachers, function(i,teacher){
						//console.log(teacher);
						var tr = $('<tr>');
						tr.append($('<td>').text(teacher.teacherName));
						tr.append($('<td>').text(teacher.teacherGender));
						tr.append($('<td>').text(teacher.teacherSubject));
						tr.appendTo($('#teachers'));
					}) // each
				}
			},error : function(jqXHR){
				
			}
		
		}) // ajax
	} // fnTeacherList
	
	
	// 3. 강사 등록창 초기화
	function fnInit(){
		$('#teacherName').val('');
		$(':radio[name=teacherGender]').prop('checked',false);
		$(':radio[name=teacherSubject]').prop('checked',false);
	}
	
	
	
	
</script>
</head>
<body>

	<h1>강사 관리 페이지</h1>
	
	<hr>
	
	
	<h2>강사 등록하기</h2>
	<div>
		이름 <input type="text" name="teacherName" id="teacherName"><br>
		성별
		<label for="M">
			남자<input type="radio" name="teacherGender" value="M" id="M">
		</label>
		<label for="F">
			여자<input type="radio" name="teacherGender" value="F" id="F">
		</label>
		<br>
		종목
		<label for="SWIN">
			수영<input type="radio" name="teacherSubject" value="SWIM" id="SWIM">
		</label>
		<label for="PILATES">
			필라테스<input type="radio" name="teacherSubject" value="PILATES" id="PILATES">
		</label>
		<label for="SPINNING">
			스피닝<input type="radio" name="teacherSubject" value="SPINNING" id="SPINNING">
		</label>
		<label for="DANCE">
			스포츠댄스<input type="radio" name="teacherSubject" value="DANCE" id="DANCE">
		</label>
		<br><br>
		<input type="button" value="강사등록" id="btnTeacherAdd">
	</div>
	
	<hr>
	
	<h2>강사 목록</h2>
	<table border="1">
		<thead>
			<tr>
				<td>강사 이름</td>
				<td>강사 성별</td>
				<td>강사 종목</td>
			</tr>
		</thead>
		<tbody id="teachers">
			
		</tbody>
	</table>
	
	
	
	
	
	
</body>
</html>