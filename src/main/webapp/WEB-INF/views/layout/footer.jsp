<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
	.footer_wrap {
	    border-top: 1px solid #e6e7e8;
	    padding: 40px 0 40px 0;
	}
	.footer_box {
	    max-width: 1080px;
	    padding: 0 50px 0 50px;
	    margin: 0 auto;
	}
	.info_row {
		display: flex;
		flex-wrap: wrap;
	}
	.info_line {
		margin: 0;
		padding: 0;
	    flex: 0 0 33.333333%;
    	max-width: 33.333333%;
		font-size: 14px;
		text-align: center;
		color: #888;
	}
	.height {
		text-align: left;
	}
	.menu_row {
		margin: 20px 0;
	    padding-top: 20px;
	    padding-bottom: 10px;
	    border-top: 1px solid #e6e7e8;
	    border-bottom: 1px solid #e6e7e8;
   		display: flex;
		flex-wrap: wrap;
	}
	.menu_line {
		margin: 0;
		padding: 0;
		margin-bottom: 10px;
		flex-basis: 0;
	    flex-grow: 1;
	    max-width: 100%;
	    text-align: center;
	}
	.menu_text {
	    color: #888;
	    text-decoration: none;
	}
	.copyright_row {
   		display: flex;
		flex-wrap: wrap;
	}
	.copyright_line {
		margin: 0;
		padding: 0;
		margin-bottom: 10px;
		flex-basis: 0;
	    flex-grow: 1;
	    max-width: 100%;
	    text-align: center;
	}
    .copyright_text {
        color: #888;
        font-size: 12px;
        text-decoration: none;
    }
    .info_line .map {
    	display: inline-block;
    	width: 250px;
    	height: 150px;
    	background-image: url(${contextPath}/resources/images/location.png);
    	background-size: 250px 150px;
        background-repeat: no-repeat;
        background-position: center;
    }
	
</style>
</head>
<body>

	<div class="footer_wrap">
		<div class="footer_box">
			<div class="info_row">
				<div class="info_line">
					<h3>문의가능 연락처</h3><br>
					<h3>오가연 010-7134-4575</h3>
					<h3>이정민 010-3534-7849</h3>
					<h3>지시현 010-2588-7279</h3>
					<h3>박현규 010-9004-3058</h3>
					<h3>이상호 010-5646-6373</h3>
				</div>
				<div class="info_line height">
					<h3>GymGoodee</h3>
					<h3>서울시 금천구 가산디지털2로 115, 509호</h3>
					<h3>(가산동, 대륭테크노타운3차)</h3><br>
					<h3>서비스 이용문의</h3>
					<h3>AM 09:00 ~ PM 06:00</h3>
					<h3>일 공휴일 휴무</h3>
				</div>
				<div class="info_line">
					<a href="${contextPath}/about/center" class="map"></a>
				</div>
			</div>
			<div class="menu_row">
				<div class="menu_line">
					<a href="${contextPath}/policy/service" class="menu_text">이용약관</a>
				</div>
				<div class="menu_line">
					<a href="${contextPath}/policy/privacy" class="menu_text">개인정보처리방침</a>
				</div>
				<div class="menu_line">
					<a href="${contextPath}/policy/location" class="menu_text">위치정보이용약관</a>
				</div>
				<div class="menu_line">
					<a href="${contextPath}/board/questionList" class="menu_text">문의하기</a>
				</div>
			</div>
			<div class="copyright_row">
				<div class="copyright_line">
					<a href="https://www.flaticon.com/kr/" class="copyright_text">Freepik - Flaticon</a> 
				</div>
				<div class="copyright_line">
					<a href="https://fontawesome.com/license" class="copyright_text">fontawesome</a> 
				</div>
				<div class="copyright_line">
					<a href="https://erikflowers.github.io/weather-icons/" class="copyright_text">weather-icons-erikflowers</a> 
				</div>
			</div>
		</div>
	</div>

</body>
</html>