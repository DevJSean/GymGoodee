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
<title>관리자페이지 - 강좌 개설</title>
<script src="../resources/js/jquery-3.6.0.js"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">

<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/reset.css">
<script>

	/* 페이지 로드 이벤트 */
	$(function(){
		
		
		// 개설 날짜 선택하기
		$('#classDate').datepicker({	// 달력 나타나서 날짜 선택하기!
			'showOn' : 'focus',		// both 쓰면 옆에 버튼 생길 수 있다! / focus, button, both
			'dateFormat': "D, yymmdd",		// DD는 요일
			'minDate': 0, 
			'maxDate' : "+1M",
			'showAnim' : 'slideDown'
		})
		
		// radio 선택 시 어떤 것을 선택했는지 알 수 있다.
		$(":radio[name=subject]").on('change',function(){
			var subject = $(this).attr('id');
			
			fnGetTeacher(subject);
			fnGetLocation(subject)
		}) // change
		
		fnRegistClass();		
		fnPagingLink();
		fnList();
	})
	
	
	
	/* 함수 */
	
	
	// 0. 오늘 날짜 불러오기	(yyyyMMDD)
	function fnGetToday(){
		var date = new Date();
	    var year = date.getFullYear();              //yyyy
	    var month = (1 + date.getMonth());          //M
	    month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
	    var day = date.getDate();                   //d
	    day = day >= 10 ? day : '0' + day;          //day 두자리로 저장
	    
	    return  year + '' + month + '' + day;      
	}
	
	// 0. 시 분 가져오기
	function fnGetTime(){
	    var date = new Date();
	    var hour = date.getHours();
	    hour = hour >= 10? hour : '0' + hour;
	    var minute = date.getMinutes();
	    minute = minute >=10? minute : '0' + minute;
	    return hour+':'+ minute;
	}
	
	
	
	// 0. 선택 사항들 초기화하기
	function fnInit(){
		$('input[name="subject"]').prop('checked',false);
		$("select#teachers option").remove();
		$("select#locations option").remove();
		$("#classDate").val('');
		$('#classTime').val('A');
	}
	
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
	
	
	// 3. 강좌 개설하기 (POST 방식으로 INSERT 하기)
	function fnRegistClass(){
		
		$('#btnAdd').on('click',function(ev){
			// 강좌 코드, 강사번호, 장소코드, 날짜, 시간 정보를 CLASS 테이블에 INSERT 해야한다.
			// 강좌 코드 (날짜_시간_장소 형태로 생성)
			// 강사번호는 teacherNo, 장소코드는 locadtionCode 으로, 날짜는 $('#classDate').val(), 시간은 classTime으로 파라미터로 넘겨주면 된다.
			var subject = $(':radio[name=subject]:checked').val();
			if(typeof(subject) == 'undefined'){
				alert('종목을 선택하세요.');
				fnInit();
				ev.preventDefault();
				return false;
			}
			
			// $('#classDate').val() 에서 substring으로 indexOf(",") 앞부분만 잘라와서
			var pickerVal = $('#classDate').val();
			var dayOfWeek = pickerVal.substring(0,pickerVal.indexOf(","));			// 요일
			var classDate = pickerVal.substring(pickerVal.indexOf(",")+2);			// 날짜
			
			
			if($('#classDate').val() == ''){
				alert('날짜 선택은 필수 입니다.');
				fnInit();
				ev.preventDefault();
				return false;
			}
			
			if(classDate < fnGetToday()){
				alert('지난 날짜에는 강좌 개설을 할 수 없습니다.');
				fnInit();
				ev.preventDefault();
				return false;
			}
			
			var strTime = $('#classTime').val();
			var realTime;
			switch(strTime){
			case 'A':
				realTime = "09:00";
				break;
			case 'B':
				realTime = "10:00";
				break;
			case 'C':
				realTime = "19:30";
				break;
			case 'D':
				realTime = "20:30";
				break;
			}
			
			
			if(realTime < fnGetTime() && classDate == fnGetToday()){
				alert('시간이 지나 강좌를 개설할 수 없습니다.');
				fnInit();
				ev.preventDefault();
				return false;
			}
			
			
			// Sunday이면 개설 불가!
			if(dayOfWeek == 'Sun'){
				alert('일요일은 강좌를 개설할 수 없습니다.');
				fnInit();
				ev.preventDefault();
				return false;
			}

			// Saturday 일 때 C,D 시간대면 개설 불가!
			if(dayOfWeek == 'Sat' && (strTime == 'C' || strTime == 'D')){
				alert('토요일은 오전 시간대 강좌만 개설 가능합니다.');
				fnInit();
				ev.preventDefault();
				return false;
			}

			$.ajax({
				url : '${contextPath}/admin/addClass',
				data: JSON.stringify(
					{
						'teacherNo': $('#teachers option:selected').val(),
						'locationCode':$('#locations option:selected').val(),
						'classDate': classDate,
						'classTime': $('#classTime option:selected').val()
					}
				),
				type: 'POST',
				contentType: 'application/json',
				dataType:'json',
				success : function(obj){
					if(obj.state == 501){
						alert('해당 강사는 이미 해당 시간대 강좌가 있습니다.');
						fnInit();
					}
					else{
						if(obj.res == 1){
							alert('강좌 개설에 성공했습니다.');
							fnInit();
							fnList();
						}
						else{
							alert('강좌 개설에 실패했습니다.');
						}						
					}
				},
				error: function(jqXHR){
					alert('예외코드[' + jqXHR.status + '] : ' + jqXHR.responseText);
				}
			}) // ajax	
			
			
		}) // click
		
	} // fnRegistClass
	
	
	
	// 4. 페이징 링크 처리(page 전역변수 값을 링크의 data-page 값으로 바꾸고, fnList() 호출)
	function fnPagingLink(){
		$(document).on('click','.enable_link',function(){
			page = $(this).data('page');
			fnList();
		})
	} // fnPagingLink
	
	// 5. 개설강좌 목록 + page 전역변수
	var page = 1;
	function fnList(){
		$.ajax({
			/* 요청 */
			url : '${contextPath}/admin/ClassList?page=' + page,
			type : 'GET',
			/* 응답 */
			dataType : 'json',
			success : function(obj){
				//console.log(obj.classes);
				fnPrintClassList(obj.classes);
				fnPrintPaging(obj.p);
			},
			error : function(jqXHR){
				
			}
			
		}) // ajax
		
	} // fnList
	
	// 5-1) 강좌 목록 출력
	function fnPrintClassList(classes){
		$('#classes').empty();
		$.each(classes,function(i,registclass){
			var tr = $('<tr>');
			tr.append($('<td>').text(registclass.locationCode));
			tr.append($('<td>').text(registclass.teacherName));
			tr.append($('<td>').text(registclass.classDate));
			tr.append($('<td>').text(registclass.classTime));
			tr.append($('<td>').text(registclass.currentCount + '/' + registclass.locationLimit));
			tr.appendTo($('#classes'));
			
		}) // each
		
		
	} // fnPrintClassList
	
	// 5-2) 페이징 정보 출력
	function fnPrintPaging(p){
		
		$('#paging').empty();
		
		var paging ='';
		
		// ◀◀ : 이전 블록으로 이동
		if(page <= p.pagePerBlock){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-left"></i><i class="fa-solid fa-caret-left"></i></div>';
		} else{			
			paging += '<div class="enable_link" data-page="'+ (p.beginPage - 1) +'"><i class="fa-solid fa-caret-left"></i><i class="fa-solid fa-caret-left"></i></div>';
		}
		
		// ◀  : 이전 페이지로 이동
		if(page == 1){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-left"></i></div>';
		} else{			
			paging += '<div class="enable_link" data-page="'+ (page - 1) +'"><i class="fa-solid fa-caret-left"></i></div>';
		}
		
		// 1 2 3 4 5 : 페이지 번호
		for(let i = p.beginPage; i<=p.endPage; i++){
			if(i == page){
				paging += '<div class="disable_link nowUnlinkPage">'+ i +'</div>';
			} else{
				paging += '<div class="enable_link" data-page="'+ i +'">'+ i +'</div>';				
			}
		}
		
		
		// ▶  : 다음 페이지로 이동
		if(page == p.totalPage){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-right"></i></div>';
		} else{			
			paging += '<div class="enable_link" data-page="'+ (page + 1) +'"><i class="fa-solid fa-caret-right"></i></div>';
		}
		
		// ▶▶ : 다음 블록으로 이동
		if(p.endPage == p.totalPage){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-right"></i><i class="fa-solid fa-caret-right"></i></div>';
		} else{			
			paging += '<div class="enable_link" data-page="'+ (p.endPage + 1) +'"><i class="fa-solid fa-caret-right"></i><i class="fa-solid fa-caret-right"></i></div>';
		}
		
		$('#paging').append(paging);
		
	} // fnPrintPaging
	
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
      padding: 15px;
      cursor: pointer;
      border-left: 2px solid  rgba(44, 62, 80, 0.65); 
	  border-right: 2px solid  rgba(44, 62, 80, 0.65);
   }
   .navItem a {
   	  
      text-decoration: none;
      color: rgb(70, 70, 70);
   }
   .nowPage {
      background-color:  #2C3E50;
      opaity: 0.65;
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
		width: 100px;
		height: 30px;
		background-color : lightgrey;
		border : 1px solid lightgrey;
		border-radius : 3px;
		cursor: pointer;
		margin-top: 10px;
		
	}
	
	input[type=button]:hover{
		background-color : #2C3E50; 
		opacity: 0.65;
		border : 1px solid #2C3E50;
		color:#F5F6F7;
	
	} 
	
	#text{
		font-size: 30px;
		margin: 0px auto 5px auto;
	}
	
	/* 페이징 */
	#paging{
		display : flex;
		justify-content: center;
		
	}
	#paging div{
		width : 32px;
		height : 20px;
		text-align: center;
	}

	.disable_link, .enable_link {
      /* display: inline-block;  */
      padding: 10px;
      margin: 5px;
      border: 1px solid white;
      text-align: center;
      text-decoration: none; 
      color: gray;
      font-size: 20px;
   }
   .enable_link:hover {
      color: #8AAAE5;
      cursor: pointer;
   }
   
    .nowUnlinkPage{
   	  color: black;
   }

	#subjectImage{
		display: hidden;
	}
	
  
   

</style>
</head>
<body>

	
	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>
	
	<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js" integrity="sha256-6XMVI0zB8cRzfZjqKcD01PBsAy3FlDASrlC8SxCpInY=" crossorigin="anonymous"></script>
		

	<!-- 강좌 선택하면 해당 강좌 선생님과, 해당 강좌 장소 보여주기 -->
	<!-- CLASS 테이블의 PK 는 '날짜_시간_장소' -->
	
	<!-- radio 선택했을 때의 이벤트 처리.... -->
	<!-- 강좌를 선택 했을 시, ajax 처리 하여 해당 강좌 선생님 선택, 장소 선택하여
		등록 버튼 눌렀을 때 pk를 위의 형태로 만들어서 insert 하는데 실패할 경우 이미 개설된 수업이므로
		불가능!
	-->
		
	<section>
		<nav id="listNav">
			<ul class="myPageNav">
				<li class="navItem"><a href="${contextPath}/admin/memberList">회원목록</a></li>
				<li class="navItem"><a href="${contextPath}/admin/addTeacherPage">강사등록</a></li>
				<li class="navItem nowPage">강좌개설</li>
				<li class="navItem"><a href="${contextPath}/admin/reserveList">예약내역</a></li>
				<li class="navItem"><a href="${contextPath}/admin/payList">결제내역</a></li>
			</ul>	
		</nav>
		<div id="wrapper">
			<div id="wrapper1">
				
			
				<label for="SWIM">
					수영<input type="radio" name="subject" id="SWIM">	
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
				
		
				<form id="f">
					강사 선택&nbsp;&nbsp;
					<select id="teachers" name="teacherNo">
					</select>
					<br>
					장소 선택&nbsp;&nbsp;
					<select id="locations" name="locationCode">
					</select>
					<br>
					
					날짜 선택&nbsp;&nbsp;
					<input type="text" name="classDate" id="classDate" autocomplete="off">
					<br>
					
					시간 선택&nbsp;&nbsp;
					<select id="classTime" name="classTime">
						<option value="A">A(09:00)</option>
						<option value="B">B(10:00)</option>
						<option value="C">C(19:30)</option>
						<option value="D">D(20:30)</option>
					</select>
					<br>
					<input type="button" value="강좌 개설하기" id="btnAdd">
				</form>
			</div>
			
			<hr>
			
			<table>
				<caption>개설 강좌 목록</caption>
				<thead>
					<tr>
						<td>장소</td>
						<td>강사명</td>
						<td>날짜</td>
						<td>시간</td>
						<td>현재신청인원수</td>
					</tr>
				</thead>
				<tbody id="classes">
					
				</tbody>
				<tfoot>
					<tr>
						<td colspan="5">
							<div id="paging"></div>
						</td>
					</tr>
					
				</tfoot>
			</table>
		</div>
		
		
		
	
	</section>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
	
</body>
</html>