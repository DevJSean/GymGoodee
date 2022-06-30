<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<jsp:include page="../layout/header.jsp"></jsp:include>
	
	<h1>운동정보</h1>	

	<table>
		<thead>
			<tr>
				<td colspan="2">강좌 개설 시간</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>A</td>
				<td>09:00 ~ 10:00</td>
			</tr>
			<tr>
				<td>B</td>
				<td>10:00 ~ 11:00</td>
			</tr>
			<tr>
				<td>C</td>
				<td>19:30 ~ 20:30</td>
			</tr>
			<tr>
				<td>D</td>
				<td>20:30 ~ 21:30</td>
			</tr>
		</tbody>
	</table>
	
	<div>※ 강좌는 종목마다 하루 4번의 고정된 시간에 해당 강사님의 스케줄에 따라 개설됩니다.</div>

	<br><br>


	<table border="1">
		<tbody>
			<tr>
				<td rowspan="4"><img id="swimImage" alt="수영" src="../resources/images/swim.png" width="300"></td>
				<td colspan="2">
					<h1>수영</h1>
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
				<td>수영 01반</td>
				<td rowspan="2">20명</td>
			</tr>
			<tr>
				<td>수영 02반</td>
			</tr>
		</tbody>
	</table>
	
	<br><br>
	
	<table border="1">
		<tbody>
			<tr>
				<td rowspan="4"><img id="spinningImage" alt="스피닝" src="../resources/images/spinning.png" width="300"></td>
				<td colspan="2">
					<h1>스피닝</h1>
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
				<td>스피닝 01반</td>
				<td>15명</td>
			</tr>
			<tr>
				<td>스피닝 02반</td>
				<td>18명</td>
			</tr>
		</tbody>
	</table>

	<br><br>
	
	<table border="1">
		<tbody>
			<tr>
				<td rowspan="4"><img id="pillatesImage" alt="필라테스" src="../resources/images/pillates.png" width="300"></td>
				<td colspan="2">
					<h1>필라테스</h1>
					<div>신체의 전반적인 균형과 협응력을 길러주는 필라테스</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					전신거울과 신체 안정화와 체형교정으로 균형적인 전신근육을 강화하며 <br>
					스트레스 완화와 통증 완화에 있어 효과적인 운동입니다.<br>
					※ 필라테스 칼로리 소모량 : 시간당 약 350kcal
				</td>
			</tr>
			<tr>
				<td>필라테스 01반</td>
				<td>8명</td>
			</tr>
			<tr>
				<td>필라테스 02반</td>
				<td>10명</td>
			</tr>
		</tbody>
	</table>

	<br><br>

	<table border="1">
		<tbody>
			<tr>
				<td rowspan="4"><img id="danceImage" alt="스포츠댄스" src="../resources/images/dance.png" width="300"></td>
				<td colspan="2">
					<h1>스포츠댄스</h1>
					<div>즐거운 음악과 함께 남녀노소 신나게 즐길 수 있는 스포츠댄스</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					커다란 스피커에서 나오는 음악으로 스트레스, 우울증 등을 떨쳐낼 수 있는<br>
					가장 재밌게 즐길 수 있는 운동입니다<br>
					※ 필라테스 칼로리 소모량 : 시간당 약 350kcal
				</td>
			</tr>
			<tr>
				<td>스포츠댄스 01반</td>
				<td>10명</td>
			</tr>
			<tr>
				<td>스포츠댄스 02반</td>
				<td>12명</td>
			</tr>
		</tbody>
	</table>

</body>
</html>


























