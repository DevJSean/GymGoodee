<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약창</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js" integrity="sha256-6XMVI0zB8cRzfZjqKcD01PBsAy3FlDASrlC8SxCpInY=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">
<script>

	// 페이지로드 이벤트
	$(function(){
		
		fngetClasses();
		fnReserve();
		fnCancelReserve();
		fnBuyTicket();
	})
	
	// 함수
	
	// 1. model에 담겨진 subject, classDate 정보를 읽어와서 ajax로 
	// 해당 종목, 날짜 개설 강좌 리스트로 불러오기
	// 이때 각 강좌마다 1) 예약할 수 있는 상황, 2) 이미 예약하여 취소할 수 있는 상태 3) 정원 마감 에 따라 버튼을 다르게 구현한다.
	// 1)의 경우 처음 예약하는 경우에는 reserveState가 500이고, 취소 후 다시 예약하려는 경우 reserveState가 -1이다
	// 2)의 경우 이미 예약이 된 상태이므로 reserveState가 0이다
	// 3)은 현재 신청인원과 원래 정원을 비교하여 나타낸다.
	function fngetClasses(){
		$.ajax({
			url : '${contextPath}/reserve/getSwimClasses',
			type: 'get',
			data : 'subject=SWIM&classDate=${classDate}',
			dataType:'json',
			success :function(obj){
				//console.log('비회원회원 수강권 상태 : ',obj.state);	// -1(비회원) / 0(회원, 수강권 x), 1(회원, 수강권 0)
				//console.log(obj.classCount);
				$('#classList').empty();
				// 1) 비회원인 경우
				if(obj.state == -1){
					var tr = $('<tr>');
					tr.append($('<td rowspan="'+ obj.classCount +'"colspan="5">').append($('<a>').attr('id','btnLogin').text('로그인 후 이용해주세요.')));
					tr.appendTo($('#classList'));
					// <a> 링크 클릭 시 로그인 페이지로 이동하기
					$('body').on('click','#btnLogin',function(){
						window.opener.location.href='${contextPath}/member/loginPage';	// 부모창에서 새로운 경로로 이동
						window.close();						
					})
					return;
				}
				// 2) 로그인 된 경우 
				// 2-1) 수강권이 없는 경우
				// 2-2) 수강권이 있는 경우 아래와 같이
				else{
					if(obj.classCount == 0){
						var tr = $('<tr>');
						tr.append($('<td colspan="5">').text('개설된 강좌가 없습니다.'));
						tr.appendTo($('#classList'));
						return;
					}
					if(obj.state == 0){
						$('#table_caption').html('잔여 횟수가 0회입니다.<br><a id="btnPaySwim">수강권 구매하기</a>');	
						$('body').on('click','#btnPaySwim',function(){
							window.opener.location.href='${contextPath}/pay/paySwim';	// 부모창에서 새로운 경로로 이동
							window.close();
						})
					}
					$.each(obj.classes, function(i,swimclass){
						var tr = $('<tr>');
						tr.append($('<td>').text(swimclass.teacherName));
						tr.append($('<td>').text(swimclass.classTime));
						tr.append($('<td>').text(swimclass.locationCode));
						tr.append($('<td>').text(swimclass.currentCount + "/" + swimclass.locationLimit)); 
						// 수강권이 있고, 예약을 안한 강좌에 대해 [예약하기] 버튼
						if(swimclass.currentCount < swimclass.locationLimit && (swimclass.reservationState == 500 || swimclass.reservationState == -1) && obj.state==1){		
							tr.append($('<td>').html('<input type="button" class ="btnreserve" data-classcode="'+ swimclass.classCode + '" value="예약하기">'));			
						}
						// 수강권이 없고, 예약을 안한 강좌에 대해 [수강권 구매] 버튼
						else if(swimclass.currentCount < swimclass.locationLimit && (swimclass.reservationState == 500 || swimclass.reservationState == -1) && obj.state==0){	
							tr.append($('<td>').html('<input type="button" class ="btnBuyTicket" value="수강권 구매">'));			
						}
						// 수강권이 있든, 없든 사전에 예약을 한 강좌에 대해 [예약 취소] 버튼
						else if(swimclass.reservationState == 0){
							// if (1) 당일 수업아 아닌 경우 [예약 취소] 버튼
							tr.append($('<td>').html('<input type="button" class ="btnreserveCancel" data-classcode="'+ swimclass.classCode + '" value="예약취소">'));									
							// 당일 수업 취소는 불가능 하므로, 당일수업인데 아직 수업 시간이 안지난 수업에 대해서는 
							// [취소 불가] 버튼
							// 오늘 날짜와 해당 강좌의 날짜를 비교해서!
						}
						// 수강인원이 다 찬 예약에 대해 [예약마감] 버튼
						else if(swimclass.currentCount == swimclass.locationLimit){
							tr.append($('<td>').html('<input type="button" class ="btnreserveEnd" value="예약마감">'));												
						}
						// 수강을 완료한 강좌에 대해서
						else if(swimclass.reservationState == 1){
							tr.append($('<td>').html('<input type="button" class ="btnClassEnd" value="수강완료">'));
						}
						tr.appendTo($('#classList'));						
	
					}) // each
				} // else
			} // success
		}) // ajax
	}
	
	// 2. 예약 버튼 눌러서 예약하기
	// 1) 예약->취소-> 다시 예약하는 경우
	// 2) 처음 예약하는 경우
	// 두가지의 경우가 있고, 이는 ReseveServiceImpl에서 RESERVATION 테이블에서
	// MEMBER_NO, CLASS_CODE와 동일한 행이 있는지 확인하여
	// 1)의 경우 UPDATE하고, 2)의 경우 INSERT 한다.
	function fnReserve(){
		// .btnreserve가 동적요소이므로
		$('body').on('click','.btnreserve',function(){
			var classCode = $(this).data('classcode');
			//console.log(classCode);
			$.ajax({
				url : '${contextPath}/reserve/reserveSwim',
				type: 'post',
				data : 'subject=SWIM&memberNo=${loginMember.memberNo}&classCode='+ classCode,	// memberNo는 로그인 시 session에 들어있는 정보를 가져온다.
				success : function(obj){
					console.log('버튼 ',obj);
					if(obj.state == 501){
						alert('동일 날짜, 동일 시간대 강좌가 이미 예약되어 있습니다.');
						return false;
					}
					if(obj.res == 1){
						fngetClasses();		// 예약 완료 후 fngetClasses() 를 실행해야 현재 페이지에 바로 반영이 된다.
						if(confirm('예약이 완료되었습니다. 마이페이지로 이동하시겠습니까?')){
							window.opener.location.href='${contextPath}/mypage/myReserveList?memberNo=${loginMember.memberNo}';	// 부모창에서 새로운 경로로 이동
							window.close();
							return;
						} else { // 예약 성공후 마이페이지로 이동x
							window.opener.location.reload();		// 부모창 새로고침
							window.close();
						}
					}
					else if(obj.res == 0){
						alert('강좌 예약에 실패했습니다.');
						window.opener.location.reload();			// 부모창 새로고침
						window.close();
					}
				}, error : function(jqXHR){
					
				}
			}) // ajax
		}) // click
		
	
	} // fnReserve
	
	
	
	// 3. 예약 취소하기
	// 로그인되어 있는 회원의 MEMBER_NO 와 CLASS_CODE를 보내면 해당 정보를 일치하는 것을
	// RESERVATION 테이블에서 찾아 RESERVATION_STATE 을 -1로 UPDATE 한다.
	function fnCancelReserve(){
		$('body').on('click','.btnreserveCancel',function(){
			var classCode = $(this).data('classcode');
			
			$.ajax({
				url : '${contextPath}/reserve/cancelSwim',
				type: 'post',
				data : 'subject=SWIM&memberNo=${loginMember.memberNo}&classCode='+ classCode,	// memberNo는 로그인 시 session에 들어있는 정보를 가져온다.
				success : function(obj){
					console.log(obj);
					if(obj.res == 1){
						fngetClasses();
						if(confirm('강좌 취소가 완료되었습니다. 마이페이지로 이동하시겠습니까?')){
							window.opener.location.href='${contextPath}/mypage/myReserveList?memberNo=${loginMember.memberNo}';	// 부모창에서 새로운 경로로 이동
							window.close();
							return;
						} else{
							window.opener.location.reload();		// 부모창 새로고침
							window.close();
						}
					}
					else if(obj.res == 0){
						alert('강좌 취소에 실패했습니다.');
						window.opener.location.reload();		// 부모창 새로고침
						window.close();
					}
				},
				error : function(jqXHR){
					
				}
			}) // ajax	
			
		}) // click
	} // fnCancelReserve
	
	
	// 4. 수강권 구매 버튼 누르기
	function fnBuyTicket(){
		$('body').on('click','.btnBuyTicket',function(){
			window.opener.location.href='${contextPath}/pay/paySwim';	// 부모창에서 새로운 경로로 이동
			window.close();
			
		}) // click
	}
	
	
	
	
</script>
<style>

	h1{
		margin: auto;
		text-align : center;
	}
	
	table{
		margin : auto;
	}

</style>
</head>
<body>

	<h1>${classDate}</h1>
	
	<hr>	

	<table border="1">
		<caption id="table_caption"></caption>
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