<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.0.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/reset.css">
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<!-- 날씨 아이콘 가져오기 -->
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/weather-icons-master/css/weather-icons.min.css">
<script>
	$(function() {
		fnRemainTickets();
      	fnGetDate();
      
		// 현 위치를 알아내고 날씨 알아내기
		fnGetTodayWeather();
	})
   
   // 예약일시 타임스탬프 날짜 형태로 수정
    function fnGetDate(date){
       var date = new Date(date);
       return date.getFullYear() + "-" + ('0' + (date.getMonth() + 1)).slice(-2) + "-" + ('0' + date.getDate()).slice(-2);
    }

   //보유수강권 잔여횟수
   function fnRemainTickets() {
      $.ajax({
         // 요청
         url: '${contextPath}/remainTickets',
         type: 'get',
         // 응답
         dataType: 'json',
         success: function(obj) {
            $('#remainTickets').empty();
            $('#btn-mapper').empty();
            if(obj.remainTickets.length == 0) {
                $('#endDate')
                .append($('<div>').text('보유하고 있는 수강권이 없습니다.'));
             }
            $.each(obj.remainTickets, function(i, remainTicket) {
               let subject = null;
               switch(remainTicket.remainTicketSubject) {
               case 'SWIM': subject = '수영';
                  break;
               case 'DANCE': subject = '스포츠댄스';
                  break;
               case 'SPINNING': subject = '스피닝';
                  break;
               case 'PILATES': subject = '필라테스';
                  break;
               }
               $('#remainTickets')
               .append($('<div>').text(subject + '\t' + remainTicket.remainTicketRemainCount + '회'));
               $('#endDate')
               .append($('<div>').text(subject + '권 만료일 ' + fnGetDate(remainTicket.remainTicketEndDate)));
               
               // 보유한 수강권에 대한 예약리스트버튼 생성
               $('#btn-mapper')
               .append($('<input type="button" value="' + subject + '" class="btnSubjectList" data-subject="' + remainTicket.remainTicketSubject + '">'));
            })
         }
      })
   }
   
   function fnLogOut() {
      location.href='${contextPath}/member/logout';
   }

   function fnMyPage() {
      location.href='${contextPath}/mypage/myReserveList';
   }
   
   function fnAdminPage() {
      location.href='${contextPath}/admin/memberList';
   }
   
   function fnMainPage() {
      location.href='${contextPath}';
   }

   /*****************************************현위치 알아내기***************************************************/	
   // LCC DFS 좌표변환을 위한 기초 자료
   var RE = 6371.00877; // 지구 반경(km)
   var GRID = 5.0; // 격자 간격(km)
   var SLAT1 = 30.0; // 투영 위도1(degree)
   var SLAT2 = 60.0; // 투영 위도2(degree)
   var OLON = 126.0; // 기준점 경도(degree)
   var OLAT = 38.0; // 기준점 위도(degree)
   var XO = 43; // 기준점 X좌표(GRID)
   var YO = 136; // 기1준점 Y좌표(GRID)
   function DFStoXY(v1, v2) {
       var DEGRAD = Math.PI / 180.0;
       var RADDEG = 180.0 / Math.PI;

       var re = RE / GRID;
       var slat1 = SLAT1 * DEGRAD;
       var slat2 = SLAT2 * DEGRAD;
       var olon = OLON * DEGRAD;
       var olat = OLAT * DEGRAD;

       var sn = Math.tan(Math.PI * 0.25 + slat2 * 0.5) / Math.tan(Math.PI * 0.25 + slat1 * 0.5);
       sn = Math.log(Math.cos(slat1) / Math.cos(slat2)) / Math.log(sn);
       var sf = Math.tan(Math.PI * 0.25 + slat1 * 0.5);
       sf = Math.pow(sf, sn) * Math.cos(slat1) / sn;
       var ro = Math.tan(Math.PI * 0.25 + olat * 0.5);
       ro = re * sf / Math.pow(ro, sn);
       var rs = {};
           rs['lat'] = v1;
           rs['lng'] = v2;
           var ra = Math.tan(Math.PI * 0.25 + (v1) * DEGRAD * 0.5);
           ra = re * sf / Math.pow(ra, sn);
           var theta = v2 * DEGRAD - olon;
           if (theta > Math.PI) theta -= 2.0 * Math.PI;
           if (theta < -Math.PI) theta += 2.0 * Math.PI;
           theta *= sn;
           rs['x'] = Math.floor(ra * Math.sin(theta) + XO + 0.5);
           rs['y'] = Math.floor(ro - ra * Math.cos(theta) + YO + 0.5);
       return rs;
   }	
	// 위치 상세 검색을 위해 옵션 설정
	const options = {
 		enableHighAccuracy: true,
 		maximumAge: 30000,
 		timeout: 27000
	};
	function onGeoOkay(position) {
		  // 위도 경도 변수 선언
		  const lat = position.coords.latitude;
		  const lng = position.coords.longitude;
		  const location = DFStoXY(lat, lng);
		  let today = new Date();
		  let year = today.getFullYear(); 
		  let month = today.getMonth() + 1
		  let date = today.getDate();
		  $.ajax({  
				url: '${contextPath}/forecast',
				type: 'get',
				data: 'fDate=' + year + '0' + month + date + '&x=' + location.x + '&y=' + location.y,
				dataType: 'json',
				success: function(obj){
					let item = obj.response.body.items.item;
					if(item[41].fcstValue == 1 && item[42].fcstValue == 0) {
						let i = '<i class="wi wi-day-sunny" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 1 && item[42].fcstValue == 1) {
						let i = '<i class="wi wi-day-rain" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 1 && item[42].fcstValue == 2) {
						let i = '<i class="wi wi-day-rain-mix" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 1 && item[42].fcstValue == 3) {
						let i = '<i class="wi wi-day-snow" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 1 && item[42].fcstValue == 4) {
						let i = '<i class="wi wi-day-showers" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 3 && item[42].fcstValue == 0) {
						let i = '<i class="wi wi-cloudy" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 3 && item[42].fcstValue == 1) {
						let i = '<i class="wi wi-rain" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 3 && item[42].fcstValue == 2) {
						let i = '<i class="wi wi-rain-mix" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 3 && item[42].fcstValue == 3) {
						let i = '<i class="wi wi-snow" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 3 && item[42].fcstValue == 4) {
						let i = '<i class="wi wi-showers" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 4 && item[42].fcstValue == 0) {
						let i = '<i class="wi wi-fog" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 4 && item[42].fcstValue == 1) {
						let i = '<i class="wi wi-rain" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 4 && item[42].fcstValue == 2) {
						let i = '<i class="wi wi-rain-mix" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 4 && item[42].fcstValue == 3) {
						let i = '<i class="wi wi-snow" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} else if(item[41].fcstValue == 4 && item[42].fcstValue == 4) {
						let i = '<i class="wi wi-sleet" style="color:#8AAAE5;"></i>';
						$('#todayWeather').append($(i));
					} 
					if(item[331].fcstValue == 1 && item[332].fcstValue == 0) {
						let i = '<i class="wi wi-day-sunny" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 1 && item[332].fcstValue == 1) {
						let i = '<i class="wi wi-day-rain" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 1 && item[332].fcstValue == 2) {
						let i = '<i class="wi wi-day-rain-mix" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 1 && item[332].fcstValue == 3) {
						let i = '<i class="wi wi-day-snow" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 1 && item[332].fcstValue == 4) {
						let i = '<i class="wi wi-day-showers" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 0) {
						let i = '<i class="wi wi-cloudy" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 1) {
						let i = '<i class="wi wi-rain" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 2) {
						let i = '<i class="wi wi-rain-mix" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 3) {
						let i = '<i class="wi wi-snow" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 4) {
						let i = '<i class="wi wi-showers" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 0) {
						let i = '<i class="wi wi-fog" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 1) {
						let i = '<i class="wi wi-rain" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 2) {
						let i = '<i class="wi wi-rain-mix" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 3) {
						let i = '<i class="wi wi-snow" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 4) {
						let i = '<i class="wi wi-sleet" style="color:#8AAAE5;"></i>';
						$('#tomorrowWeather').append($(i));
					}
				}
			})
	}
	function onGeoError() {
		  // 에러 발생시 기본 위치 값 구디아카데미
		  const lat = 37.474125;
		  const lng = 126.89380833333334;
		  $("#weatherTable").css("display", "none" );
	}
	function fnGetTodayWeather(){
		navigator.geolocation.getCurrentPosition(onGeoOkay, onGeoError, options);
	}
/*********************************************************************************************************/	
   
</script>
<style>
	body {
		background-color: #F5F6F7;
	}
   .indexNav {
      display: flex;
      flex-direction: row;
      width: 100%;
      list-style-type: none;
   }
   .indexItem {
      background-color: #BADFC4; 
      padding: 15px;
      cursor: pointer;
   }
   .indexItem a {
      text-align: center;
      text-decoration: none;
      color: #343434;
      font-weight: 600;
   }
   .indexItem:hover {
      background-color: #63B47B;
   }
   #weatherTable {
   		position: absolute;
   		top: 30px;
   		right: 30px;
   		border: 1px gray solid;
   		width: 200px;
   		text-align: center;
   }
</style>
</head>
<body>
	<!-- 날씨 -->
	<table id="weatherTable">
		<tbody>
			<tr style="font-size: 50px;">
				<td id="todayWeather"></td>
				<td id="tomorrowWeather"></td>
			</tr>
			<tr>
				<td>오늘 날씨</td>
				<td>내일 날씨</td>
			</tr>
		</tbody>
	</table>

   <!-- 로그인 이전에 보여줄 링크 -->
   <c:if test="${loginMember eq null}">
      <a href="${contextPath}/member/loginPage">로그인</a>
      <a href="${contextPath}/member/agreePage">회원가입</a>
   </c:if>
   
   <!-- 로그인 이후에 보여줄 링크 -->
   <c:if test="${loginMember ne null}">
      ${loginMember.memberName}님 반갑습니다.&nbsp;&nbsp;&nbsp;
      <input type="button" value="로그아웃" id="btnLogOut" onclick="fnLogOut()">
      <input type="button" value="메인페이지" id="btnMainPage" onclick="fnMainPage()">
      <c:if test="${loginMember.memberId eq 'admin'}">
         <input type="button" value="관리자페이지" id="btnAdminPage" onclick="fnAdminPage()">
      </c:if>
      <c:if test="${loginMember.memberId ne 'admin'}">
         <input type="button" value="마이페이지" id="btnMyPage" onclick="fnMyPage()">
         <br>
         <div id="remainTickets"></div>
      </c:if>   
   </c:if>
   
   <nav>
      <ul class="indexNav">
         <li class="indexItem"><a href="${contextPath}/about/center">센터소개</a></li>
         <li class="indexItem"><a href="${contextPath}/about/subject">운동소개</a></li>
         <li class="indexItem">수강권구매</li>
         <li class="indexItem"><a href="${contextPath}/pay/paySwim">수영</a></li>
         <li class="indexItem"><a href="${contextPath}/pay/payPilates">필라테스</a></li>
         <li class="indexItem"><a href="${contextPath}/pay/paySpinning">스피닝</a></li>
         <li class="indexItem"><a href="${contextPath}/pay/payDance">스포츠댄스</a></li>
         <li class="indexItem">게시판</li>
         <li class="indexItem"><a href="${contextPath}/board/noticeList">공지사항</a></li>
         <li class="indexItem"><a href="${contextPath}/board/questionList">QNA</a></li>
         <li class="indexItem"><a href="${contextPath}/board/reviewList">리뷰</a></li>
         <li class="indexItem">예약</li>
         <li class="indexItem"><a href="${contextPath}/reserve/swimPage">수영</a></li>
         <li class="indexItem"><a href="${contextPath}/reserve/pilatesPage">필라테스</a></li>
         <li class="indexItem"><a href="${contextPath}/reserve/spinningPage">스피닝</a></li>
         <li class="indexItem"><a href="${contextPath}/reserve/dancePage">스포츠 댄스</a></li>
      </ul>
   </nav>

</body>
</html>