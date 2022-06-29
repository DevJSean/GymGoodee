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

	$(function(){
		fnAreaChoice();
		fnSearchAll();	
		fnSearch();
		fnAutoComplete();
		
		// 현 위치 알아내기
		fnGetLocation();
	})
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
		  console.log(year + '0' + month + date);
			$.ajax({  
				url: '${contextPath}/forecast',
				type: 'get',
				data: 'fDate=' + year + '0' + month + date + '&x=' + location.x + '&y=' + location.y,
				dataType: 'json',
				success: function(obj){
					console.log(obj);
				}
			})
		  
		  console.log("You are in", DFStoXY(lat, lng));
	}
	function onGeoError() {
		// 에러 발생시 기본 위치 값 구디아카데미
		  const lat = 37.474125;
		  const lng = 126.89380833333334;
		  console.log("I'm not sure where you are, but GYMGoodee is", DFStoXY(lat, lng));
	}
	function fnGetLocation(){
		navigator.geolocation.getCurrentPosition(onGeoOkay, onGeoError, options);
	}
/*********************************************************************************************************/	
/*
	function fnForecast(){
		var xhr = new XMLHttpRequest();
		var url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst'; 
		var queryParams = '?' + encodeURIComponent('serviceKey') + '='+'lkYJjFhNdh0yOa1pzlWsCt6Bw%2FxTOpBVa6vuiQNOjpZUtlkXKYbTkAhL4KDaY97SmQucM4J42kl0cBNDthXb0A%3D%3D'; 
		queryParams += '&' + encodeURIComponent('pageNo') + '=' + encodeURIComponent('1'); 
		queryParams += '&' + encodeURIComponent('numOfRows') + '=' + encodeURIComponent('1000');
		queryParams += '&' + encodeURIComponent('dataType') + '=' + encodeURIComponent('JSON');
		queryParams += '&' + encodeURIComponent('base_date') + '=' + encodeURIComponent('20220629');
		queryParams += '&' + encodeURIComponent('base_time') + '=' + encodeURIComponent('0800');
		queryParams += '&' + encodeURIComponent('nx') + '=' + encodeURIComponent('58');
		queryParams += '&' + encodeURIComponent('ny') + '=' + encodeURIComponent('125');
		xhr.open('GET', url + queryParams);
		xhr.onreadystatechange = function () {
		    if (this.readyState == 4) {
		        alert('Status: '+this.status+'nHeaders: '+JSON.stringify(this.getAllResponseHeaders())+'nBody: '+this.responseText);
		    }
		};
		
		xhr.send();
	}
*/	
/*********************************************************************************************************/	
	
	function fnAreaChoice(){
		$('#rangeArea').css('display', 'none');
		$('#column').on('change', function(){
			if( $(this).val() == 'NOTICE_TITLE' || $(this).val() == 'NOTICE_CONTENT') {
				$('#equalArea').css('display', 'inline');
				$('#rangeArea').css('display', 'none');
			} else {
				$('#equalArea').css('display', 'none');
				$('#rangeArea').css('display', 'inline');
			}								  
		})
	}
	
	function fnSearchAll() {
		$('#btnSearchAll').on('click', function(){
			location.href='${contextPath}/board/noticeList';
		})
	}
	
	function fnSearch(){
		
		var column = $('#column');
		var query = $('#query');
		var begin = $('#begin');
		var end = $('#end');
		
		$('#btnSearch').on('click', function(){
			
 			var regTitle = /^[a-zA-Z가-힣0-9-_!@#$%^&*]{2,}$/;  
			if( column.val() == 'NOTICE_TITLE' && regTitle.test(query.val()) == false) {
				alert('제목은 2자 이상 입력해주세요.');
				query.focus();
				return;
			}
 			var regContent = /^[a-zA-Z가-힣0-9-_!@#$%^&*]{2,}$/;  
			if( column.val() == 'NOTICE_CONTENT' && regContent.test(query.val()) == false) {
				alert('내용은 2자 이상 입력해주세요.');
				query.focus();
				return;
			}
			var regCreated = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/;
			if( column.val() == 'NOTICE_CREATED' && ( !regCreated.test(begin.val()) || !regCreated.test(end.val()) ) ){
				alert('날짜 입력 형식은 YYYY-MM-DD 입니다.');
				return;
			}
			if(column.val() == 'NOTICE_TITLE' || column.val() == 'NOTICE_CONTENT' ) {
				location.href="${contextPath}/board/noticeSearch?column=" + column.val() + "&query=" + query.val();
			} else {
				location.href="${contextPath}/board/noticeSearch?column=" + column.val() + "&begin=" + begin.val() + "&end=" + end.val();
			}
		})
	}
	
	function fnAutoComplete(){
		$('#query').on('keyup', function(){
			$('#autoComplete').empty();
			$.ajax({  
				url: '${contextPath}/board/noticeAutoComplete',
				type: 'get',
				data: 'column=' + $('#column').val() + '&query=' + $('#query').val(),
				dataType: 'json',
				success: function(result){
					if(result.status == 200){
						$.each(result.list, function(i, item){
							$('<option>')
							.val(item[result.column])
							.appendTo('#autoComplete');
						})
					}
				}
			})
		})
	}
</script>
</head>
<body>
	
	<%@ include file="noticeList.jsp" %>

	<form id="f" method="get">
		<select name="column" id="column">
			<option value="NOTICE_TITLE">제목</option>
			<option value="NOTICE_CONTENT">내용</option>
			<option value="NOTICE_CREATED">작성일</option>
		</select>
		<span id="equalArea">
			<input type="text" name="query" id="query" list="autoComplete">
			<datalist id="autoComplete"></datalist>
		</span>
		<span id="rangeArea">
			<input type="text" name="begin" id="begin">
			~
			<input type="text" name="end" id="end">
		</span>
		<input type="button" value="검색" id="btnSearch">
		<input type="button" value="전체조회" id="btnSearchAll">
	</form>

</body>
</html>