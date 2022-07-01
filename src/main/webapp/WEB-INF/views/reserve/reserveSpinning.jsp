<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>스피닝 예약창</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js" integrity="sha256-6XMVI0zB8cRzfZjqKcD01PBsAy3FlDASrlC8SxCpInY=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">
<script>

	// 페이지로드 이벤트
	$(function(){
		
		fnGetToday();
		fnGetTodayTime();
		fngetClasses();
		fnReserve();
		fnBuyTicket();
		fnCancelReserve();
		fnReserveConfirm();
		fnbtnReserveEnd();
		fnbtnClassEnd();
		
		fnAdminReservation();
	})
	
	/* 함수 */
	
	// 오늘 날짜 불러오기	(yyyyMMDD)
	function fnGetToday(){
		var date = new Date();
	    var year = date.getFullYear();              //yyyy
	    var month = (1 + date.getMonth());          //M
	    month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
	    var day = date.getDate();                   //d
	    day = day >= 10 ? day : '0' + day;          //day 두자리로 저장
	    
	    return  year + '' + month + '' + day;      
	}
	
	// 현재 날짜||시간 불러오기 (yyyyMMDDHHMM)
	function fnGetTodayTime(){
		var date = new Date();
	    var year = date.getFullYear();              //yyyy
	    var month = (1 + date.getMonth());          //M
	    month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
	    var day = date.getDate();                   //d
	    day = day >= 10 ? day : '0' + day;          //day 두자리로 저장
	    var hour = date.getHours();
	    hour = hour = hour >= 10? hour : '0' + hour;
	    var minute = date.getMinutes();
	    minute = minute >=10? minute : '0' + minute;
	    return  year + '' + month + '' + day +'' +hour+''+minute;      
	}
	
	// 1. model에 담겨진 subject, classDate 정보를 읽어와서 ajax로 
	// 해당 종목, 날짜 개설 강좌 리스트로 불러오기
	// 이때 각 강좌마다 1) 예약할 수 있는 상황, 2) 이미 예약하여 취소할 수 있는 상태 3) 정원 마감 에 따라 버튼을 다르게 구현한다.
	// 1)의 경우 처음 예약하는 경우에는 reserveState가 500이고, 취소 후 다시 예약하려는 경우 reserveState가 -1이다
	// 2)의 경우 이미 예약이 된 상태이므로 reserveState가 0이다
	// 3)은 현재 신청인원과 원래 정원을 비교하여 나타낸다.
	function fngetClasses(){
		$.ajax({
			url : '${contextPath}/reserve/getClasses',
			type: 'get',
			data : 'subject=SPINNING&classDate=${classDate}',
			dataType:'json',
			success :function(obj){
				//console.log('비회원회원 수강권 상태 : ',obj.state);	// -1(비회원) / 0(회원, 수강권 x), 1(회원, 수강권 0)
				//console.log(obj.classCount);
				console.log(obj);
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
				// 2-1) 관리자인 경우 => []
				// 2-2) 회원인 경우
				// 2-2-1) 수강권이 없는 경우
				// 2-2-2) 수강권이 있는 경우 아래와 같이
				else{
					var memberId = '${loginMember.memberId}';
					if(obj.classCount == 0){
						var tr = $('<tr>');
						if(memberId == 'admin'){
							// 강좌 개설 페이지로 이동하기
							tr.append($('<td colspan="5">').text('개설된 강좌가 없습니다. 강좌를 개설하세요!'));
						}
						else{
							tr.append($('<td colspan="5">').text('개설된 강좌가 없습니다.'));
							if(obj.state == 0){
								$('#table_caption').html('잔여 횟수가 0회입니다.<br><a id="btnPaySpinning">수강권 구매하기</a>');	
								$('body').on('click','#btnPaySpinning',function(){
									window.opener.location.href='${contextPath}/pay/paySpinning';	// 부모창에서 새로운 경로로 이동
									window.close();
								})
							} 
						}
						tr.appendTo($('#classList'));
						return;
					}
					
					// 강좌 목록 표시하기
					$.each(obj.classes, function(i,spinningclass){
						var tr = $('<tr>');
						tr.append($('<td>').text(spinningclass.teacherName));
						tr.append($('<td>').text(spinningclass.classTime));
						tr.append($('<td>').text(spinningclass.locationCode));
						tr.append($('<td>').text(spinningclass.currentCount + "/" + spinningclass.locationLimit));
						// 2-1) 관리자의 경우 => [예약 관리] 버튼
						if(memberId == 'admin'){
							tr.append($('<td>').html('<input type="button" class ="btnAdminReservation" data-classcode="'+ spinningclass.classCode + '" value="예약관리">'));
						}
						// 2-2) 고객의 경우
						else{
							// 수강권이 없는 회원의 경우 잔여 횟수에 대한 정보를 <caption>에 추가
							if(obj.state == 0){
								$('#table_caption').html('잔여 횟수가 0회입니다.<br><a id="btnPaySpinning">수강권 구매하기</a>');	
								$('body').on('click','#btnPaySpinning',function(){
									window.opener.location.href='${contextPath}/pay/paySpinning';	// 부모창에서 새로운 경로로 이동
									window.close();
								})
							} 
							var today = fnGetToday();
							
							if(today > spinningclass.classDate){
								if(spinningclass.reservationState == 1){
									tr.append($('<td>').html('<input type="button" class ="btnClassEnd" value="리뷰작성">'));
									
								}else{
									tr.append($('<td>').html('<input type="button" class ="btnEnd" value="종료">'));									
								}
							}
							// 당일
							else if(today == spinningclass.classDate){
								if(spinningclass.reservationState == 0){
									// (1) 내가 예약한 수업이 당일 수업인 경우 [예약 확정] 버튼
									tr.append($('<td>').html('<input type="button" class ="btnReserveConfirm" data-classcode="'+ spinningclass.classCode + '" value="예약확정">'));																		
								} 
								else if(spinningclass.reservationState == 1){
									// (2) 수강이 끝난 후
									tr.append($('<td>').html('<input type="button" class ="btnClassEnd" value="리뷰작성">'));
								}
								else if(spinningclass.reservationState == -1 || spinningclass.reservationState == 500){
									// (2) 당일 강좌 중 내가 예약하지 않은 경우
									var classDateTime = spinningclass.classDate + (spinningclass.classTime).replace(/:/gi, "");
									var nowDateTime = fnGetTodayTime();
									
									// (2-1) 아직 예약이 가능한 시간대인 수업 => 자리가 남아 있으면 [예약하기] / 자리가 다 차면 [예약마감] 
									if(nowDateTime < classDateTime){
										// (2-1-1) 자리가 남아 [예약하기]
										if(spinningclass.currentCount < spinningclass.locationLimit && obj.state==1){		
											tr.append($('<td>').html('<input type="button" class ="btnReserve" data-classcode="'+ spinningclass.classCode + '" value="예약하기">'));			
										}
										// (2-1-2) 인원이 다 차 마감된 경우 [예약마감]
										else if(spinningclass.currentCount == spinningclass.locationLimit){
											tr.append($('<td>').html('<input type="button" class ="btnReserveEnd" value="예약마감">'));												
										}
										// (2-1-3) 수강권이 없고, 예약을 안한 강좌에 대해 [수강권 구매] 버튼
										else if(spinningclass.currentCount < spinningclass.locationLimit && obj.state==0){	
											tr.append($('<td>').html('<input type="button" class ="btnBuyTicket" value="수강권 구매">'));			
										}
									}
									// (2-2) 시간대가 지나 예약이 불가능한 수업 => [종료]
									else if(nowDateTime >= classDateTime){
										tr.append($('<td>').html('<input type="button" class ="btnEnd" value="종료">'));																						
									}
									
								} // else
							} // if
							// 당일 수업이 아닌 경우 (미래 수업)
							else{
								if(spinningclass.reservationState == 0){
									// (1) 내가 예약한 수업인 경우 [예약 취소] 버튼
									tr.append($('<td>').html('<input type="button" class ="btnReserveCancel" data-classcode="'+ spinningclass.classCode + '" value="예약취소">'));
								}else if(spinningclass.reservationState == -1 || spinningclass.reservationState == 500){
									// (2-1) 수강권이 있고, 예약하지 않은 수업에 대해서 [예약하기] 버튼
									if(spinningclass.currentCount < spinningclass.locationLimit && obj.state==1){		
										tr.append($('<td>').html('<input type="button" class ="btnReserve" data-classcode="'+ spinningclass.classCode + '" value="예약하기">'));			
									}
									// (2-2) 수강권이 없고, 예약을 안한 강좌에 대해 [수강권 구매] 버튼
									else if(spinningclass.currentCount < spinningclass.locationLimit && obj.state==0){	
										tr.append($('<td>').html('<input type="button" class ="btnBuyTicket" value="수강권 구매">'));			
									}
									// (2-3) 내가 예약을 안했을 때 인원이 마감된 경우 [예약마감] 버튼
									else if(spinningclass.currentCount == spinningclass.locationLimit){
										tr.append($('<td>').html('<input type="button" class ="btnReserveEnd" value="예약마감">'));												
									}
								} // else
							} // else
						}
						tr.appendTo($('#classList'));						
					}) // each
				} // else
			} // success
		}) // ajax
	}
	
	// 2. [예약하기] 버튼
	// 1) 예약->취소-> 다시 예약하는 경우
	// 2) 처음 예약하는 경우
	// 두가지의 경우가 있고, 이는 ReseveServiceImpl에서 RESERVATION 테이블에서
	// MEMBER_NO, CLASS_CODE와 동일한 행이 있는지 확인하여
	// 1)의 경우 UPDATE하고, 2)의 경우 INSERT 한다.
	function fnReserve(){
		// .btnreserve가 동적요소이므로
		$('body').on('click','.btnReserve',function(){
			var classCode = $(this).data('classcode');
			//console.log(classCode);
			$.ajax({
				url : '${contextPath}/reserve/reserveClass',
				type: 'POST',
				data : 'subject=SPINNING&classCode=' + classCode,
				dataType: 'json',
				success : function(obj){
					//console.log('버튼 ',obj);
					if(obj.state == 501){
						alert('동일 날짜, 동일 시간대 강좌가 이미 예약되어 있습니다.');
						return false;
					}
					if(obj.res == 1){
						fngetClasses();		// 예약 완료 후 fngetClasses() 를 실행해야 현재 페이지에 바로 반영이 된다.
						if(confirm('예약이 완료되었습니다. 마이페이지로 이동하시겠습니까?')){
							window.opener.location.href='${contextPath}/mypage/myReserveList';	// 부모창에서 새로운 경로로 이동
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
	
	
	// 3. [수강권 구매] 버튼 누르기
	function fnBuyTicket(){
		$('body').on('click','.btnBuyTicket',function(){
			window.opener.location.href='${contextPath}/pay/paySpinning';	// 부모창에서 새로운 경로로 이동
			window.close();
			
		}) // click
	}
	
	
	// 4. [예약 취소] 버튼
	// 로그인되어 있는 회원의 MEMBER_NO 와 CLASS_CODE를 보내면 해당 정보를 일치하는 것을
	// RESERVATION 테이블에서 찾아 RESERVATION_STATE 을 -1로 UPDATE 한다.
	function fnCancelReserve(){
		$('body').on('click','.btnReserveCancel',function(){
			var classCode = $(this).data('classcode');
			
			if(confirm('예약을 취소하시겠습니까?')){
				$.ajax({
					url : '${contextPath}/reserve/cancelClass',
					type: 'POST',
					data : 'subject=SPINNING&classCode=' + classCode,
					success : function(obj){
						console.log(obj);
						if(obj.res == 1){
							fngetClasses();
							if(confirm('강좌 취소가 완료되었습니다. 마이페이지로 이동하시겠습니까?')){
								window.opener.location.href='${contextPath}/mypage/myReserveList';	// 부모창에서 새로운 경로로 이동
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
				
			} // if
		}) // click
	} // fnCancelReserve
	
	
	// 5. [예약 확정] 버튼
	function fnReserveConfirm(){
		$('body').on('click','.btnReserveConfirm',function(){
			alert('예약이 확정된 강좌는 취소할 수 없습니다!');
			if(confirm('예약내역으로 이동하겠습니까?')){
				window.opener.location.href='${contextPath}/mypage/myReserveList';	// 부모창에서 새로운 경로로 이동
				window.close();
				return;
			}
			window.opener.location.reload();		// 부모창 새로고침
			window.close();
		})
	}
	
	// 6. [예약 마감] 버튼
	function fnbtnReserveEnd(){
		$('body').on('click','.btnReserveEnd',function(){
			if(alert('예약이 마감됐습니다ㅠ.ㅠ')){
				window.close();
			}
		})
	}
	
	// 7. [수강완료] 버튼
	function fnbtnClassEnd(){
		$('body').on('click','.btnClassEnd',function(){
			if(confirm('리뷰를 작성하시겠습니까?')){
				window.opener.location.href='${contextPath}/board/reviewList';	// 부모창에서 새로운 경로로 이동
				window.close();
			}
		})
	}
	
	
	
	// 8. [관리자] 예약관리 버튼 
	function fnAdminReservation(){
		$('body').on('click','.btnAdminReservation',function(){
			window.opener.location.href='${contextPath}/admin/reserveList';	// 부모창에서 새로운 경로로 이동
			window.close();
		})
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

	<fmt:parseDate value="${classDate}" var="parseDateValue" pattern="yyyyMMdd"></fmt:parseDate>
	<fmt:formatDate value="${parseDateValue}" pattern="yyyy-MM-dd" var="Date"/>
	<h1>${Date}</h1>
	
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