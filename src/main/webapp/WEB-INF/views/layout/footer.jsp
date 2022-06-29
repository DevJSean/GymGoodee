<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a2eaaee1257d5ccec0e423f47ffb938a"></script>
	<script src="../resources/js/jquery-3.6.0.js"></script>
	<script>
		$(document).ready(function(){
			var mapContainer = document.getElementById('map'),
		    mapOption = { 
		        center: new kakao.maps.LatLng(37.4778946468119, 126.87897099156314), // 지도 중심좌표
		        level: 3 // 지도 확대 레벨
		    };
		
			var map = new kakao.maps.Map(mapContainer, mapOption);
			
			// 마커 위치
			var markerPosition  = new kakao.maps.LatLng(37.4778946468119, 126.87897099156314); 
			
			// 마커 생성
			var marker = new kakao.maps.Marker({
			    position: markerPosition
			});
	
			marker.setMap(map);
			
			var iwContent = '<div style="padding:5px;">GoodeeGym<br><a href="https://map.kakao.com/link/map/GoodeeGym,37.4778946468119,126.87897099156314" style="color:blue" target="_blank">큰지도보기</a> <a href="https://map.kakao.com/link/to/GoodeeGym,37.4778946468119,126.87897099156314" style="color:blue" target="_blank">길찾기</a></div>',
			    iwPosition = new kakao.maps.LatLng(37.4778946468119, 126.87897099156314); //인포윈도우 표시 위치입니다
			
			var infowindow = new kakao.maps.InfoWindow({
			    position : iwPosition, 
			    content : iwContent 
			});
			  
			infowindow.open(map, marker); 
		})
	</script>
</head>
<body>
	<hr>
	<div id="map" style="width:600px;height:300px;"></div>
</body>
</html>