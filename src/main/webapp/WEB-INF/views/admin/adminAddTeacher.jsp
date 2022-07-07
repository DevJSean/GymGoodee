<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>관리자페이지 - 강사 등록</title>
<script src="../resources/js/jquery-3.6.0.js"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">

<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/reset.css">

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
				console.log(obj);
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
<style>

	
	/* 왼쪽 네비게이션 */
   .myPageNav {
      display: flex;
      width: 100px;
      flex-direction: column;
      list-style-type: none;
      
   }
    .navItem {
   	  text-align: center;
      background-color: white; 
      /* padding: 15px; */
      cursor: pointer;
      border-left: 2px solid  rgba(44, 62, 80, 0.65); 
	  border-right: 2px solid  rgba(44, 62, 80, 0.65);
	  width: 100px;
      height: 50px;
	  line-height: 50px;
   }
   .navItem a {
      text-decoration: none;
      color: rgb(70, 70, 70);
      display: inline-block;
      width: 100px;
      height: 50px;
   }
   .nowPage {
      background-color:  #2C3E50;
      opacity: 0.65;
      color: #F5F6F7;
   }
   .myPageNav .navItem:first-of-type { 
   		border-radius : 10px 10px 0 0; 
   		border-top: 2px solid  rgba(44, 62, 80, 0.65); 
   }
   .myPageNav .navItem:last-of-type { 
   		border-radius : 0 0 10px 10px; 
   		border-bottom: 2px solid  rgba(44, 62, 80, 0.65); 
   	}
   .navItem:hover {
      background-color:  #2C3E50;   
   }
   .navItem:hover > a {
      color: #F5F6F7;
   }
   #listNav {
        display: flex;
		margin-right: 20px;
		margin-left: 80px;
		margin-top: 50px;
   }
   
   
	/* wrapper 부분 css */
	
	section {
		display: flex;
	}
	
	#wrapper{
		background-color : white;
  		width : 70%;
  		margin : 50px auto;
  		border-radius : 50px;
  		padding: 30px;
  		text-align: left;
  		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
	}
	
	#wrapper1{
		line-height: 30px;
		margin-left: 45px;
	}

	
	table{
		border-collapse : collapse;
		width: 90%;
		text-align : center;
		margin : 0 auto;
		vertical-align : middle;
	}
	
	table caption{
		margin: 0 auto 10px auto;	
		text-align: left;	
	}
	
	table thead tr{
		border-top : 2px solid lightgrey;
		border-bottom : 2px solid lightgrey;
	}
	table tbody tr{
		border-bottom : 1px solid lightgrey;
	}
	
	td{
		padding: 5px;
		text-align: center;
	}
	
	input[type=button]{
		width: 80px;
		height: 30px;
		background-color : lightgrey;
		border : 1px solid lightgrey;
		border-radius : 3px;
		cursor: pointer;
		margin-top: 10px;
		
	}
	
	input[type=button]:hover{
		background-color :  #2C3E50; 
		opacity: 0.65;
		border : 1px solid #2C3E50;
		color:#F5F6F7;
	
	} 


	

</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<section>
		<nav id="listNav">
			<ul class="myPageNav">
				<li class="navItem"><a href="${contextPath}/admin/memberList">회원목록</a></li>
				<li class="navItem nowPage">강사등록</li>
				<li class="navItem"><a href="${contextPath}/admin/addClassPage">강좌개설</a></li>
				<li class="navItem"><a href="${contextPath}/admin/reserveList">예약내역</a></li>
				<li class="navItem"><a href="${contextPath}/admin/payList">결제내역</a></li>
			</ul>	
		</nav>
		
		<div id="wrapper">
			<div id="wrapper1">
				이름&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="teacherName" id="teacherName"><br>
				성별&nbsp;&nbsp;
				<label for="M">
					남자<input type="radio" name="teacherGender" value="M" id="M">
				</label>
				<label for="F">
					여자<input type="radio" name="teacherGender" value="F" id="F">
				</label>
				<br>
				종목&nbsp;&nbsp;
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
				<br>
				<input type="button" value="강사등록" id="btnTeacherAdd">
			</div>
			
			<hr>
			
			
			<table border="1">
				<caption>강사 목록</caption>
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
		
		</div>
	</section>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
	
</body>
</html>