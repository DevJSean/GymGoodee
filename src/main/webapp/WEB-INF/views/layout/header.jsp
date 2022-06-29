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
	$(function() {
		fnRemainTickets();
		fnGetDate();
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
					.append($('<input type="hidden" value="' + remainTicket.remainTicketSubject + '" name="subject">'))
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
		location.href='${contextPath}/member/memberList';
	}
	
	function fnMainPage() {
		location.href='${contextPath}';
	}
	
</script>
<style>
	.indexNav {
		display: flex;
		flex-direction: row;
		width: 100%;
		list-style-type: none;
	}
	.indexItem {
		background-color: teal; 
		padding: 15px;
		cursor: pointer;
	}
	.indexItem a {
		text-align: center;
		text-decoration: none;
		color: white;
	}
	.indexItem:hover {
		background-color: navy;
	}
</style>
</head>
<body>

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
			<li class="indexItem"><a href="">센터소개</a></li>
			<li class="indexItem"><a href="">운동소개</a></li>
			<li class="indexItem"><a href="${contextPath}/pay/paySwim">수강권구매</a></li>
			<li class="indexItem"><a href="${contextPath}/board/noticeList">게시판</a></li>
			
		</ul>
	</nav>
	

</body>
</html>