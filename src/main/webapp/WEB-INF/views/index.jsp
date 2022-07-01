<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>GoodeeGym</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- 날씨 아이콘 가져오기 -->
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/weather-icons-master/css/weather-icons.min.css">
<script>
	$(function() {
		$.ajax({
			url: '${contextPath}/mypage/pwModifiedCheck',
			dataType: 'json',
			type: 'get',
			success: function(obj) {
				if(obj.postDays >=  3) {
					$('#modal.modal-overlay').css('display', 'flex');
				}
			}
		})
		
		// 현 위치를 알아내고 날씨 알아내기
		fnGetTodayWeather();
		// 시계 달기
		fnClock();
		setInterval(fnClock, 1000);
	})
	
	function fnModalClose() {
		$('#modal.modal-overlay').css('display', 'none');
	}
	
	// 시계 달기
	function fnClock() {
	    const date = new Date();
	    let hours = String(date.getHours()).padStart(2, "0");
	    let min = String(date.getMinutes()).padStart(2, "0");
	    let sec = String(date.getSeconds()).padStart(2, "0");
	    $('#clock').text(hours + ':' + min + ':' + sec);
	}

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
		  let fDate = today.getFullYear(); 
		  let month = today.getMonth() + 1;
		  if (month < 10) {
			  fDate += "0";
		  }
		  fDate += month;
		  let date = today.getDate();
		  if (date < 10) {
			  fDate += "0";
		  }
		  fDate += date;
		  let hours = String(today.getHours()).padStart(2, "0");
		  $.ajax({  
				url: '${contextPath}/forecastNow',
				type: 'get',
				data: 'fDate=' + fDate + '&fTime=' + (hours - 1) + '30' + '&x=' + location.x + '&y=' + location.y,
				dataType: 'json',
				success: function(obj){
					let item = obj.response.body.items.item;
					if(item[18].fcstValue == 1 && item[6].fcstValue == 0) {
						let i = '<i class="wi wi-day-sunny"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 1 && item[6].fcstValue == 1) {
						let i = '<i class="wi wi-day-rain"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 1 && item[6].fcstValue == 2) {
						let i = '<i class="wi wi-day-rain-mix"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 1 && item[6].fcstValue == 3) {
						let i = '<i class="wi wi-day-snow"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 1 && item[6].fcstValue == 5) {
						let i = '<i class="wi wi-day-sprinkle"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 1 && item[6].fcstValue == 6) {
						let i = '<i class="wi wi-day-rain-mix"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 1 && item[6].fcstValue == 7) {
						let i = '<i class="wi wi-day-snow-wind"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 3 && item[6].fcstValue == 0) {
						let i = '<i class="wi wi-cloud"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 3 && item[6].fcstValue == 1) {
						let i = '<i class="wi wi-rain"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 3 && item[6].fcstValue == 2) {
						let i = '<i class="wi wi-rain-mix"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 3 && item[6].fcstValue == 3) {
						let i = '<i class="wi wi-snow"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 3 && item[6].fcstValue == 5) {
						let i = '<i class="wi wi-sprinkle"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 3 && item[6].fcstValue == 6) {
						let i = '<i class="wi wi-rain-mix"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 3 && item[6].fcstValue == 7) {
						let i = '<i class="wi wi-snow-wind"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 4 && item[6].fcstValue == 0) {
						let i = '<i class="wi wi-fog"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 4 && item[6].fcstValue == 1) {
						let i = '<i class="wi wi-rain"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 4 && item[6].fcstValue == 2) {
						let i = '<i class="wi wi-rain-mix"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 4 && item[6].fcstValue == 3) {
						let i = '<i class="wi wi-snow"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 4 && item[6].fcstValue == 5) {
						let i = '<i class="wi wi-sprinkle"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 4 && item[6].fcstValue == 6) {
						let i = '<i class="wi wi-rain-mix"></i>';
						$('#todayWeather').append($(i));
					} else if(item[18].fcstValue == 4 && item[6].fcstValue == 7) {
						let i = '<i class="wi wi-snow-wind"></i>';
						$('#todayWeather').append($(i));
					}						
				}, error: function(){
					let i = '<i class="wi wi-refresh"></i>';
					$('#todayWeather').append($(i));
				}
		  })
		  $.ajax({  
				url: '${contextPath}/forecast',
				type: 'get',
				data: 'fDate=' + fDate + '&x=' + location.x + '&y=' + location.y,
				dataType: 'json',
				success: function(obj){
					let item = obj.response.body.items.item;
					if(item[331].fcstValue == 1 && item[332].fcstValue == 0) {
						let i = '<i class="wi wi-day-sunny"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 1 && item[332].fcstValue == 1) {
						let i = '<i class="wi wi-day-rain"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 1 && item[332].fcstValue == 2) {
						let i = '<i class="wi wi-day-rain-mix"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 1 && item[332].fcstValue == 3) {
						let i = '<i class="wi wi-day-snow"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 1 && item[332].fcstValue == 4) {
						let i = '<i class="wi wi-day-showers"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 0) {
						let i = '<i class="wi wi-cloudy"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 1) {
						let i = '<i class="wi wi-rain"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 2) {
						let i = '<i class="wi wi-rain-mix"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 3) {
						let i = '<i class="wi wi-snow"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 3 && item[332].fcstValue == 4) {
						let i = '<i class="wi wi-showers"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 0) {
						let i = '<i class="wi wi-fog"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 1) {
						let i = '<i class="wi wi-rain"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 2) {
						let i = '<i class="wi wi-rain-mix"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 3) {
						let i = '<i class="wi wi-snow"></i>';
						$('#tomorrowWeather').append($(i));
					} else if(item[331].fcstValue == 4 && item[332].fcstValue == 4) {
						let i = '<i class="wi wi-sleet"></i>';
						$('#tomorrowWeather').append($(i));
					}
				}, error: function(){
					let i = '<i class="wi wi-refresh"></i>';
					$('#tomorrowWeather').append($(i));
				}
			})
	}
	function onGeoError() {
		  // 위치 에러 발생시 아예 안 띄우기
		  $("#weatherTable").css("display", "none" );
	}
	function fnGetTodayWeather(){
		navigator.geolocation.getCurrentPosition(onGeoOkay, onGeoError, options);
	}

</script>
<style>
	#modal.modal-overlay {
	    width: 100%;
	    height: 100%;
	    position: absolute;
	    left: 0;
	    top: 0;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    background: rgba(255, 255, 255, 0.25);
	    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
	    backdrop-filter: blur(1.5px);
	    -webkit-backdrop-filter: blur(1.5px);
	    border-radius: 10px;
	    border: 1px solid rgba(255, 255, 255, 0.18);
	    display:none;
	}
    #modal .modal-window {
        background: rgba( 69, 139, 197, 0.70 );
        box-shadow: 0 8px 32px 0 rgba( 31, 38, 135, 0.37 );
        backdrop-filter: blur( 13.5px );
        -webkit-backdrop-filter: blur( 13.5px );
        border-radius: 10px;
        border: 1px solid rgba( 255, 255, 255, 0.18 );
        width: 400px;
        height: 200px;
        position: relative;
        padding: 10px;
    }
    #modal .title {
        padding-left: 10px;
        display: inline;
        text-shadow: 1px 1px 2px gray;
        color: white;
    }
    #modal .title h2 {
        display: inline;
    }
    #modal .close-area {
        display: inline;
        float: right;
        padding-right: 10px;
        cursor: pointer;
        text-shadow: 1px 1px 2px gray;
        color: white;
    }
    
    #modal .content {
        margin-top: 20px;
        padding: 0px 10px;
        text-shadow: 1px 1px 2px gray;
        color: white;
    }
    #btnClose, #btnChangePw {
    	position: relative;
    	left: 60px;
    	bottom: -15px;
    	background-color: lightgrey;
		width: 120px;
		height: 40px;
		color: grey;
		border: none;
		border-radius: 5px;
    }
    #weatherTable {
/*    	position: absolute;
   		top: 30px;
   		right: 30px;
   		border: 1px gray solid; */
   		width: 200px;
   		text-align: center;
   }
   .wi {
   		color:#8AAAE5;
   }
</style>
</head>
<body>
	
	<h1>메인 페이지</h1>
	
	<header>
		<jsp:include page="./layout/header.jsp"></jsp:include>
	</header>
	
	<!-- 날씨 -->
	<table id="weatherTable">
		<tbody>
			<tr style="font-size: 50px;">
				<td id="todayWeather"></td>
				<td id="tomorrowWeather"></td>
			</tr>
			<tr>
				<td><span id="clock"></span><br>Weather</td>
				<td>Tomorrow<br>Weather</td>
			</tr>
		</tbody>
	</table>
	
	<a href="${contextPath}/reserve/swimPage">수영 예약페이지</a><br>
	<a href="${contextPath}/reserve/pilatesPage">필라테스 예약페이지</a><br>
	<a href="${contextPath}/reserve/spinningPage">스피닝 예약페이지</a><br>
	<a href="${contextPath}/reserve/dancePage">스포츠댄스 예약페이지</a><br>

	<hr>
	
	<div id="modal" class="modal-overlay">
        <div class="modal-window">
            <div class="title">
                <h2>경고</h2>
            </div>
            <div class="content">
                <p>비밀번호를 변경하신지 90일이 경과하였습니다.</p>
                <p>안전을 위해 비밀번호를 변경해주세요.</p>
                
                <input type="button" value="다음에 변경하기" id="btnClose" onclick="fnModalClose()">
                <input type="button" value="비밀번호 변경" id="btnChangePw" onClick="location.href='${contextPath}/mypage/changePwPage'">
            </div>
        </div>
    </div>
    
    <hr>
    
	
</body>
</html>