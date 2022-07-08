<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>센터소개</title>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a2eaaee1257d5ccec0e423f47ffb938a"></script>
	<script src="../resources/js/jquery-3.6.0.js"></script>
	<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
	
	<script>
		$(document).ready(function(){
			var mapContainer = document.getElementById('map'),
		    mapOption = { 
		        center: new kakao.maps.LatLng(37.4778946468119, 126.87897099156314), // 지도 중심좌표
		        level: 3 // 지도 확대 레벨
		    };
		
			var map = new kakao.maps.Map(mapContainer, mapOption);
			
			// 마커 위치
			var markerPosition = new kakao.maps.LatLng(37.4778946468119, 126.87897099156314); 
			
			// 마커 생성
			var marker = new kakao.maps.Marker({
			    position: markerPosition
			});
	
			marker.setMap(map);
			
			var iwContent = '<div style="padding:5px;">GoodeeGym<br><a href="https://map.kakao.com/link/map/GoodeeGym,37.4778946468119,126.87897099156314" style="color:blue" target="_blank">큰지도보기</a> <a href="https://map.kakao.com/link/to/GoodeeGym,37.4778946468119,126.87897099156314" style="color:blue" target="_blank">길찾기</a></div>',
			    iwPosition = new kakao.maps.LatLng(37.4778946468119, 126.87897099156314); //인포윈도우 표시 위치
			
			var infowindow = new kakao.maps.InfoWindow({
			    position : iwPosition, 
			    content : iwContent 
			});
			  
			infowindow.open(map, marker); 
		})
	</script>
	
	
	
	<style>
	
	#centerForm {
		background-color : white;
		width : 1000px;
		height: 2500px;
		margin : 0 auto 40px;
		border-radius : 50px;
		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
	}
	
	#titleName{
        font-size: 2.75em;
        padding: 40px 0 0 0;
        margin: 40px;
     }
	#box > img {
		width: 400px;
		height: 700px;
		float: right;
		margin: 0 60px 0 0;
	}
	.boxTitle {
		font-size: 2em;
		margin: 50px 0 30px 50px;
		line-height: 50px;
	}
	.boxContent {
		font-size: 1.125em;
		font-weight: 300;
		margin: 50px 0 0 50px;
		width: 450px;
		line-height: 30px;
	}
	
	#centerTable {
		width: 800px;
		margin: 30px 30px 20px 80px ;
		border: 1px;
		line-height: 35px;
		border-collapse: separate;
	}
	
	th {
		width: 25%;
		text-align: left;
		padding: 5px 0 5px 20px;
		background-color: #78818C;
		color: #F5F6F7;
		border-top: 1px solid lightgrey;
		border-right: 1px solid lightgrey;
	}
	td {
		padding: 5px 0 5px 10px;
		width: 80%;
		border-top: 1px solid grey;
	}
	.last {
		border-bottom: 1px solid grey;
	}
	
	.tag {
		text-align: right;
		margin: 0 120px 50px 0;
		line-height: 0;
		font-size: 0.75em;
	}
	
	
	#map{
		width: 800px;
		height: 400px;
		margin: 30px 30px 20px 90px ;
	}
	#sub{
        font-size: 1.5em;
        margin: 50px 0 10px 90px;
     }
	#subContent{
        margin: 10px 0 0 90px;
     }


	</style>
	
	
	
	
	
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>

	
	<form id="centerForm">
		<div id="titleName">| 센터소개</div>
		<div id="box">
			<img src="../resources/images/picture.jpg" >
			<div class="boxTitle">저희 구디짐에 오신 것을<br>환영합니다!</div>
			<div class="boxContent">
				우리 센터는 시민의 생활체육과 건강증진을 위하여 수영장, 필라테스, 스피닝, 스포츠댄스
				등의 시설을 갖추고 2022년 7월 13일부터 운영하게 되었습니다.
				<br><br><br>
				우리 구디짐은 시민이 보다 깨끗한 환경속에서 즐길수 있도록 최신식 장비들과
				매일 깨끗한 수질관리, 각 시설별 청소시스템이 구성되어 있어 누구나 쾌적하고 자유롭게 이용이 가능합니다.
				앞으로 이용자 눈높이와 요구에 부응하는 다양한 프로그램을 개발하여 보다 많은 서비스를 제공하고자 합니다.
				<br><br><br>
				또한 홈페이지를 통해 시민 여러분께 여가선용과 시설 이용을 위한 다양한 정보를 신속하게 제공함은 물론
				체육시설에 대한 여러분의 애정 어린 관심과 좋은 의견을 주시면 적극 반영하도록 하겠습니다.
				앞으로 직원 모두는 고척체육센터를 이용하시는 시민 여러분을 보다 친절하게 모시겠으며,
				최적의 생활체육 공간 제공을 약속드립니다.
			</div>
		</div>
		<hr>
		
		<div id="titleName">| 운영시간</div>
		
		<table id="centerTable">
			<tbody>
				<tr>
					<th>평일</th>
					<td>08:30 ~ 22:00</td>
				</tr>
				<tr>
					<th class="last">토요일</th>
					<td class="last">08:30 ~ 12:00</td>
				</tr>
			</tbody>
		</table>
		<div class="tag">※ 일요일, 공휴일은 휴무입니다.</div>
		
		
		<hr>
		<div id="titleName">| 오시는 길</div>
		
		<div id="map"></div>
		<div id="sub">| 지하철</div>
		<div id="subContent">가산디지털단지역(1호선 / 7호선) 5번 출구</div>
		<div id="sub">| 버스</div>
		<div id="subContent"><span style="color:blue">간선버스</span> : 503번, 504번, 571번, 652번, 653번</div>
		<div id="subContent"><span style="color:#29CE58">지선버스</span> : 5012번, 5528번, 5536번, 5714번</div>
		<div id="subContent"><span style="color:#74D8D3">일반버스</span> : 21번</div>
		<div id="subContent"><span style="color:#07A93B">마을버스</span> : 금천 05번</div>
		<div id="sub">| 주차장 이용안내</div>
		<div id="subContent">구디짐 전용 주차장을 이용해 주세요</div>
		<div id="subContent">주차요금: 초반 30분 무료, 30분 당 천원</div>
		<div id="subContent">결제방법 : 카드결제</div>
	</form>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>































