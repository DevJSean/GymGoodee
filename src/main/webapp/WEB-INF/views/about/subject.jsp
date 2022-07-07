<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>운동소개</title>
	<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
	
	
	
	
	<style>
	
	#subjectForm {
		background-color : white;
		width : 1000px;
		height: 2300px;
		margin : 0 auto 40px ;
		border-radius : 50px;
		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
	}
	
	#titleName{
        font-size: 2.75em;
        padding: 40px 0 0 0;
        margin: 40px;
     }
     	
    #sub{
        font-size: 1.5em;
        margin: 50px 0 10px 90px;
     }
	
	#timeTable{
		width: 800px;
		margin: 30px 0 0 90px;
		border: 1px;
		line-height: 35px;
		border-collapse: separate;
	}
	#box > img {
		width: 300px;
		height: 300px;
		float: left;
		margin: 0 35px 0 65px;
	}
	#subjectTable {
		width: 550px;
		margin-top: 30px;
		border: 1px;
		line-height: 35px;
		border-collapse: separate;
	}
	th {
		width: 30%;
		text-align: left;
		vertical-align: middle;
		padding: 5px 0 5px 20px;
		background-color: #2C3E50;
		opacity: 0.65;
		color: #F5F6F7;
		border-top: 1px solid lightgrey;
		border-right: 1px solid lightgrey;
	}
	td{
		padding: 5px 0 5px 10px;
		width: 70%;
		border-top: 1px solid grey;
	}
	#timeTable > tbody > tr > th {
		width: 20%;
		padding-left: 30px;
	}
	
	.last {
		border-bottom: 1px solid grey;
	}
	.tag1 {
		text-align: right;
		margin: 25px 110px 0 0;
		line-height: 0;
		font-size: 0.85em;
	}
	.tag2 {
		text-align: right;
		margin: 20px 349.5px 0 0;
		line-height: 0;
		font-size: 0.85em;
	}
	.tag3 {
		text-align: right;
		margin: 20px 288.5px 50px 0;
		line-height: 0;
		font-size: 0.85em;
	}

	.subjectTitle {
		line-height: 70px;
		font-size: 4em;
	}
	</style>
	
	
	
	
	
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>

	<form id="subjectForm">
		<div id="titleName">| 운동정보</div>
	
		<div id="sub">| 강좌개설 시간</div>
		<table id="timeTable">
			<tbody>
				<tr>
					<th>A</th>
					<td>09:00 ~ 10:00</td>
				</tr>
				<tr>
					<th>B</th>
					<td>10:00 ~ 11:00</td>
				</tr>
				<tr>
					<th>C</th>
					<td>19:30 ~ 20:30</td>
				</tr>
				<tr>
					<th class="last">D</th>
					<td class="last">20:30 ~ 21:30</td>
				</tr>
			</tbody>
		</table>
		
		<div class="tag1">※ 강좌는 종목마다 하루 4번의 고정된 시간에 해당 강사님의 스케줄에 따라 개설됩니다.</div>
		<div class="tag2">※ 토요일은 A, B 시간의 강좌만 운영합니다.</div>
		<div class="tag3">※ 강좌 예약 취소는 <span style="color: red"> 전날 자정 12시</span>까지만 가능합니다.</div>
	
		<br><br>
	
		<div id="box">
			<img id="swimImage" alt="수영" src="../resources/images/swim.png">
		
			<table id="subjectTable">
				<tbody>
					<tr>
						<td colspan="2">
							<div class="subjectTitle">수영</div>
							<div>쾌적하고 깨끗한 환경과 함께하는 수영</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							100미터 8개 레인과 초보자도 쉽게 접근이 가능한 낮은 수심을 보유한 수영장은<br>
							체계적인 수질관리 시스템으로 맑고 깨끗한 수영 환경을 제공합니다<br>
							※ 수영 칼로리 소모량 : 시간당 약 600kcal
						</td>
						
					</tr>
					<tr>
						<th>수영 01반</th>
						<td>20명</td>
					</tr>
					<tr>
						<th class="last">수영 02반</th>
						<td class="last">20명</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<br><br><br><br>
		
				<div id="box">
			<img id="pilatesImage" alt="필라테스" src="../resources/images/pilates.png">
			<table id="subjectTable">
				<tbody>
					<tr>
						<td colspan="2">
							<div class="subjectTitle">필라테스</div>
							<div>신체의 전반적인 균형과 협응력을 길러주는 필라테스</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							신체 안정화와 체형교정으로 균형적인 전신근육을 강화하며<br>
							스트레스 완화와 통증 완화에 있어 효과적인 운동입니다.<br>
							※ 필라테스 칼로리 소모량 : 시간당 약 350kcal
						</td>
					</tr>
					<tr>
						<th>필라테스 01반</th>
						<td>8명</td>
					</tr>
					<tr>
						<th class="last">필라테스 02반</th>
						<td class="last">10명</td>
					</tr>
				</tbody>
			</table>
		</div>
	
		<br><br><br><br>
		
		<div id="box">
			<img id="spinningImage" alt="스피닝" src="../resources/images/spinning.png">
			
			<table id="subjectTable">
				<tbody>
					<tr>
						<td colspan="2">
							<div class="subjectTitle">스피닝</div>
							<div>쉽고 즐거우며 확실한 운동효과를 볼 수 있는 스피닝</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							체지방 감소와 심폐지구력, 근지구력 향상에 큰 효과를 볼 수 있으며, <br>
							상.하체 근력의 균형적 발전에 효과적인 운동입니다<br>
							※ 스피닝 칼로리 소모량 : 시간당 약 500kcal
						</td>
					</tr>
					<tr>
						<th>스피닝 01반</th>
						<td>15명</td>
					</tr>
					<tr>
						<th class="last">스피닝 02반</th>
						<td class="last">18명</td>
					</tr>
				</tbody>
			</table>
		</div>
	
		<br><br><br><br>
		
		<div id="box">
			<img id="danceImage" alt="스포츠댄스" src="../resources/images/dance.png">
			<table id="subjectTable">
				<tbody>
					<tr>
						<td colspan="2">
							<div class="subjectTitle">스포츠댄스</div>
							<div>즐거운 음악과 함께 남녀노소 신나게 즐길 수 있는 스포츠댄스</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							음악과 함께 상대방과 호흡을 맞추며 스트레스, 우울증 등을 떨쳐낼 수 있는<br>
							저희 체육관에서 가장 쉽고 재밌게 즐길 수 있는 운동입니다<br>
							※ 스포츠댄스 칼로리 소모량 : 시간당 약 500kcal
						</td>
					</tr>
					<tr>
						<th>스포츠댄스 01반</th>
						<td>10명</td>
					</tr>
					<tr>
						<th class="last">스포츠댄스 02반</th>
						<td class="last">12명</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>

	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>

</body>
</html>


























