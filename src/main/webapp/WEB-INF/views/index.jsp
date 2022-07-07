<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="./resources/images/favicon.png"/>
<title>GoodeeGym</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- 날씨 아이콘 가져오기 -->
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/weather-icons-master/css/weather-icons.min.css">
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/reset.css">
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
		
		
		$(".mySlideDiv").not(".active").hide(); //화면 로딩 후 첫번째 div를 제외한 나머지 숨김
		setInterval(nextSlide, 5000); //5초마다 다음 슬라이드로 넘어감
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
		  let hours = today.getHours();
		  let minutes = today.getMinutes();
 		  if (minutes < 30) {
			  hours = hours - 1
		  }
		  hours = hours >= 10 ? hours : '0' + hours;
		  minutes = minutes >= 10 ? minutes : '0' + minutes;
		  
		  $.ajax({  
				url: '${contextPath}/forecastNow',
				type: 'get',
				data: 'fDate=' + fDate + '&fTime=' + hours + minutes + '&x=' + location.x + '&y=' + location.y,
				dataType: 'json',
				success: function(obj){
					if(obj.response.header.resultCode == "01") {
						let i = '<i class="wi wi-refresh"></i>';
						$('#todayWeather').append($(i));
					}
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
					let span = '<span>' + item[24].fcstValue + '</span>';
					$('#nowTemperature').append(span + '°C');
					
				}, error: function(){
					let i = '<i class="wi wi-refresh"></i>';
					$('#todayWeather').append($(i));
					$('#nowTemperature').append($(i));
				}
		  })
		  $.ajax({  
				url: '${contextPath}/forecast',
				type: 'get',
				data: 'fDate=' + fDate + '&x=' + location.x + '&y=' + location.y,
				dataType: 'json',
				success: function(obj){
					if(obj.response.header.resultCode == "01") {
						let i = '<i class="wi wi-refresh"></i>';
						$('#tomorrowWeather').append($(i));
					}
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
			
			$.ajax({
				url : 'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=' + lng +'&y=' + lat,
			    type : 'GET',
			    headers : {
			        'Authorization' : 'KakaoAK ef00f5bff0c5db7716477c7e3c1d9b78'
			    },
			    success : function(data) {
					let p = '<p>' + data.documents[0].address.address_name + '</p>';
					$('#todayWeather').prepend(p);
					$('#nowTemperature').prepend(p);
					$('#tomorrowWeather').prepend(p);
			    },
			    error : function(e) {
			        console.log(e);
			    }
		  })
	}
	function onGeoError() {
		  // 위치 에러 발생시 아예 안 띄우기
		  $("#weather").css("display", "none" );
	}
	function fnGetTodayWeather(){
		navigator.geolocation.getCurrentPosition(onGeoOkay, onGeoError, options);
	}
	
	//이전 슬라이드
	function prevSlide() {
		$(".mySlideDiv").hide(); //모든 div 숨김
		var allSlide = $(".mySlideDiv"); //모든 div 객체를 변수에 저장
		var currentIndex = 0; //현재 나타난 슬라이드의 인덱스 변수
		
		//반복문으로 현재 active클래스를 가진 div를 찾아 index 저장
		$(".mySlideDiv").each(function(index,item){ 
			if($(this).hasClass("active")) {
				currentIndex = index;
			}
	        
		});
		
		//새롭게 나타낼 div의 index
		var newIndex = 0;
	    
		if(currentIndex <= 0) {
			//현재 슬라이드의 index가 0인 경우 마지막 슬라이드로 보냄(무한반복)
			newIndex = allSlide.length-1;
		} else {
			//현재 슬라이드의 index에서 한 칸 만큼 뒤로 간 index 지정
			newIndex = currentIndex-1;
		}

		//모든 div에서 active 클래스 제거
		$(".mySlideDiv").removeClass("active");
	    
		//새롭게 지정한 index번째 슬라이드에 active 클래스 부여 후 show()
		$(".mySlideDiv").eq(newIndex).addClass("active");
		$(".mySlideDiv").eq(newIndex).show();

	}

	//다음 슬라이드
	function nextSlide() {
		$(".mySlideDiv").hide();
		var allSlide = $(".mySlideDiv");
		var currentIndex = 0;
		
		$(".mySlideDiv").each(function(index,item){
			if($(this).hasClass("active")) {
				currentIndex = index;
			}
	        
		});
		
		var newIndex = 0;
		
		if(currentIndex >= allSlide.length-1) {
			//현재 슬라이드 index가 마지막 순서면 0번째로 보냄(무한반복)
			newIndex = 0;
		} else {
			//현재 슬라이드의 index에서 한 칸 만큼 앞으로 간 index 지정
			newIndex = currentIndex+1;
		}

		$(".mySlideDiv").removeClass("active");
		$(".mySlideDiv").eq(newIndex).addClass("active");
		$(".mySlideDiv").eq(newIndex).show();
		
	}

</script>
<style>
	/* 비밀번호 변경 경고창 */
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
	    border-radius: 10px;
	    border: 1px solid rgba(255, 255, 255, 0.18);
	    display:none;
	}
    #modal .modal-window {
        background: rgb(184, 184, 184);
        box-shadow: 0 8px 32px 0 rgba( 31, 38, 135, 0.37 );
        backdrop-filter: blur( 13.5px );
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
        color: rgb(70, 70, 70);
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
        color: rgb(70, 70, 70);
    }
    
    #modal .content {
        margin-top: 20px;
        padding: 0px 10px;
        text-shadow: 1px 1px 2px gray;
        color: rgb(70, 70, 70);
    }
    #btnClose, #btnChangePw {
    	position: relative;
    	left: 60px;
    	bottom: -15px;
    	background-color: lightgrey;
		width: 120px;
		height: 40px;
		border: none;
		border-radius: 5px;
    }
    #btnClose:hover, #btnChangePw:hover {
    	background-color: #2C3E50; 
        opacity: 0.65;
        color: #F5F6F7;
        cursor: pointer;
    }
    #cookie {
    	text-align: center;
	}	   
    #cookie a {
    	text-decoration: none;
    	position: relative;
    	color: rgb(70, 70, 70);
    	bottom: -50px;
    }
    #cookie a:hover {
    	color: #F5F6F7;
    	transition: ease 1s;
    }

	/* 날씨 CSS */
   /* Slideshow container */
	.slideshow-container {
		max-width: 50%;
		position: relative;
		top : 30px;
		left : 30px;
		height: 143.33px;
 		margin: 30px auto 70px auto;
 		z-index: -1;
	}
	.mySlideDiv {
		font-size: 50px;	
		text-align: center;
	}
	.mySlideDiv  > p{
		font-size: 20px;	
		text-align: center;
	}	
	.mySlideDiv > i, .mySlideDiv > span {
		font-size: 100px;
		color:#8AAAE5;
		margin-top: 20px;
	}
	/* effect */
	.fade {
		-webkit-animation-name: fade;
		-webkit-animation-duration: 1.5s;
		animation-name: fade;
		animation-duration: 1.5s;
	}
	@-webkit-keyframes fade {
		from {opacity: .4} 
		to {opacity: 1}
	}
	@keyframes fade {
		from {opacity: .4} 
		to {opacity: 1}
	}
	/* Next & previous buttons */
	.prev, .next {
		cursor: pointer;
		position: absolute;
		top: 50%;	
		width: auto;
		padding: 16px;
		margin-top: -22px;
		color: #2C3E50;
		font-weight: bold;
		font-size: 18px;
		transition: 0.6s ease;
		border-radius: 0 3px 3px 0;
	}
	/* Position the "next button" to the right */
	.next {
		right: 0;
		border-radius: 3px 0 0 3px;
	}
	/* On hover, add a black background color with a little bit see-through */
	.prev:hover, .next:hover {
		background-color: #2C3E50;
		opacity: 0.65;
		color: #F5F6F7;
	}
   
	/* wrapper */
   /* 이정민 구현 */
   #indexWrapper{
         display: flex;
         width: 90%;
         justify-content: space-between;
         margin: auto;
         padding: auto;
         flex-direction: row;
         margin-bottom: 30px;
   }
   #indexWrapper > div{
         display: inline-block;
         text-align: center;
         width: 18%;
         padding: 18px;
         margin: auto;
         border: 3px solid #F5F6F7;
         border-radius: 70%;
         
   }
 
   #swimImage, #PilatesImage, #SpinningImage, #DanceImage {
         width: 80%;   
         object-fit: cover;
   }
   #swimName, #pilatesName, #spinningName, #danceName {
         font-size: 18px;
   }   
   

   #swim_wrapper:hover{
        animation-name: my_animation1;          /* 애니메이션 이름 (마음대로 정한다.) */ 
        animation-duration: 1s;                 /* 애니메이션 동작시간(초) */
        animation-timing-function: ease;     /* 애니메이션 전환시간 배분 / ease-in : 시작은 천천히 끝은 빨리 */
        animation-iteration-count: infinite;    /* 애니메이션 반복 횟수 */
        animation-direction: alternate;
   }
   #pilates_wrapper:hover{
        animation-name: my_animation1;          /* 애니메이션 이름 (마음대로 정한다.) */ 
        animation-duration: 1s;                 /* 애니메이션 동작시간(초) */
        animation-timing-function: ease;     /* 애니메이션 전환시간 배분 / ease-in : 시작은 천천히 끝은 빨리 */
        animation-iteration-count: infinite;    /* 애니메이션 반복 횟수 */
        animation-direction: alternate;    /* 애니메이션 반복 횟수 */
   }
   #spinning_wrapper:hover{
        animation-name: my_animation1;          /* 애니메이션 이름 (마음대로 정한다.) */ 
        animation-duration: 1s;                 /* 애니메이션 동작시간(초) */
        animation-timing-function: ease;     /* 애니메이션 전환시간 배분 / ease-in : 시작은 천천히 끝은 빨리 */
        animation-iteration-count: infinite;    /* 애니메이션 반복 횟수 */
        animation-direction: alternate;    /* 애니메이션 반복 횟수 */
   }
   #dance_wrapper:hover{
        animation-name: my_animation1;          /* 애니메이션 이름 (마음대로 정한다.) */ 
        animation-duration: 1s;                 /* 애니메이션 동작시간(초) */
        animation-timing-function: ease;     /* 애니메이션 전환시간 배분 / ease-in : 시작은 천천히 끝은 빨리 */
        animation-iteration-count: infinite;    /* 애니메이션 반복 횟수 */
        animation-direction: alternate;    /* 애니메이션 반복 횟수 */
   }
   
   @keyframes my_animation1{
        from{
            /* 애니메이션 시작할 때, from 대신 0% 적는 것과 동일 */
          width:18%;
            
        }
        to{
            /* 애니메이션 끝날 때, to 대신 100% 적는 것과 동일 */
          width: 22%;
          color: rgba(44,62,80,0.65);
          border: 3px solid rgba(44,62,80,0.65);
          box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
        }
    }   
</style>
</head>
<body>
		
	<header>
		<jsp:include page="./layout/header.jsp"></jsp:include>
	</header>
	
	<!-- 날씨 -->
	<div class="slideshow-container weather">
	     <div class="mySlideDiv fade active" id="todayWeather">
	     	현재 날씨
	     </div>
	     <div class="mySlideDiv fade" id="nowTemperature">
	     	현재 기온
	     </div>       
	     <div class="mySlideDiv fade" id="tomorrowWeather">
	     	내일 날씨
	     </div>
	
	     <a class="prev" onclick="prevSlide()">&#10094;</a>
	     <a class="next" onclick="nextSlide()">&#10095;</a>
	</div>
	
	<!-- 이정민 구현 -->
   <div id="indexWrapper">
      <div id="swim_wrapper">
         <a href="${contextPath}/reserve/swimPage"><img id="swimImage" alt="수영" src="./resources/images/swim.png"></a><br>
         <span id="swimName">SWIM</span>   
      </div>
      <div id="pilates_wrapper">
         <a href="${contextPath}/reserve/pilatesPage"><img id="PilatesImage" alt="필라테스" src="./resources/images/pilates.png"></a><br>
         <span id="pilatesName">PILATES</span>      
      </div>
      <div id="spinning_wrapper">
         <a href="${contextPath}/reserve/spinningPage"><img id="SpinningImage" alt="스피닝" src="./resources/images/spinning.png"></a><br>
         <span id="spinningName">SPINNING</span>      
      </div>
      <div id="dance_wrapper">
         <a href="${contextPath}/reserve/dancePage"><img id="DanceImage" alt="스포츠댄스" src="./resources/images/dance.png"></a><br>
         <span id="danceName">SPORT DANCE</span>      
      </div>   
   </div>
	
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
                <div id="cookie">
                	<a href="">오늘 하루 보지 않기</a>
                </div>
            </div>
        </div>
    </div>
    
    <footer>
		<jsp:include page="./layout/footer.jsp"></jsp:include>    
    </footer>
    
	
</body>
</html>