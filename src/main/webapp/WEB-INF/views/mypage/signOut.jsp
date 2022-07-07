<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원탈퇴</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
<script>

	$(function() {
		$('#btnSignOut').on('click', function() {
			if(confirm('모든 정보가 사라집니다. 정말로 탈퇴하시겠습니까 ?')) {
				if($('#agreeSignOut').val() == '탈퇴하겠습니다') {
					location.href='${contextPath}/mypage/signOut';
				} else {
					alert('잘못된 입력입니다.');
					$('#agreeSignOut').val('');
				}
			}
		})
	})
	
</script>
<style>
	/* 왼쪽 네비게이션 */
    .myPageNav {
        display: flex;
        width: 100px;
        flex-direction: column;
        list-style-type: none;
    }
    .navItem {
    	text-align: center;
        background-color: white; 
        cursor: pointer;
        border-left: 2px solid  rgba(44, 62, 80, 0.65); 
        border-right: 2px solid  rgba(44, 62, 80, 0.65);
        width: 100px;
        height: 50px;
        line-height: 50px;
    }
    .navItem a {
        text-decoration: none;
        color: rgb(70, 70, 70);
        display: inline-block;
        width: 100px;
        height: 50px;
    }
    .nowPage {
        background-color: #2C3E50;
        opacity: 0.65;
    }
    .nowPage a {
        color: #F5F6F7;
    }
    .myPageNav .navItem:first-of-type { 
    	border-radius : 10px 10px 0 0; 
    	border-top: 2px solid  rgba(44, 62, 80, 0.65); 
    }
    .myPageNav .navItem:last-of-type { 
    	border-radius : 0 0 10px 10px; 
    	border-bottom: 2px solid  rgba(44, 62, 80, 0.65); 
    }
    .navItem:hover {
        background-color: #2C3E50;   
        opacity: 1;
    }
    .navItem:hover > a {
        color: #F5F6F7;
    }
    #listNav {
        display: flex;
        margin-right: 20px;
        margin-left: 80px;
        margin-top: 50px;
    }
   
   /* 개별 페이지 */
	section {
		display: flex;
	}
	#wrapper{
        background-color: white;
        width: 70%;
        margin: 50px auto;
        border-radius: 50px;
        padding: 30px;
        text-align: center;
        box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
    }
	table{
        border-collapse: collapse;
        width: 70%;
        text-align: center;
        margin: 0 auto;
        vertical-align: middle;
    }
    td{
        padding: 5px;
        text-align: left;
    }
	#btnCancle, #btnSignOut {
        width: 300px;
		padding: 16px 0px 15px;
		margin-top: 10px;
		background-color: lightgrey;
		border: 1px solid lightgrey;
		border-radius: 5px;
		font-size:16px;
    }
    #btnCancle:hover, #btnSignOut:hover {
        background-color: #2C3E50; 
        opacity: 0.65;
        color: #F5F6F7;
        cursor: pointer;
    } 
	input[type=text] {
	    width: 585px;
	    height: 40px;
	    border: 0;
	    border-radius: 3px;
	    outline: none;
	    margin: 2px;
	    padding-left: 20px;
	    background-color: rgb(233, 233, 233);
	    font-size: 18px;
	}
</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>	
	
	<section>
	
		<nav id="listNav">
			<ul class="myPageNav">
				<li class="navItem"><a href="${contextPath}/mypage/myReserveList">수강내역</a></li>
				<li class="navItem"><a href="${contextPath}/mypage/myPayList">결제내역</a></li>
				<li class="navItem nowPage"><a href="${contextPath}/mypage/myInfo">개인정보</a></li>
			</ul>	
		</nav>
	
		<div id="wrapper">
			<table>
				<tr>
					<td colspan="3"><i class="fa-solid fa-user-xmark"></i>&nbsp;&nbsp;회원탈퇴</td>
				</tr>
				<tr>	
					<td colspan="3">만료일이 지나지 않은 보유 수강권 정보입니다.</td>
				</tr>
				<c:forEach items="${remainTickets}" var="remainTicket">
					<tr>
						<td></td>
						<c:if test="${remainTicket.remainTicketSubject eq 'SWIM'}">
							<td>- 수영
						</c:if>
						<c:if test="${remainTicket.remainTicketSubject eq 'PILATES'}">
							<td>- 필라테스
						</c:if>
						<c:if test="${remainTicket.remainTicketSubject eq 'DANCE'}">
							<td>- 스포츠댄스
						</c:if>
						<c:if test="${remainTicket.remainTicketSubject eq 'SPINNING'}">
							<td>- 스피닝
						</c:if>
						${remainTicket.remainTicketRemainCount}회</td>
						<td>~ ${remainTicket.remainTicketEndDate}</td>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="3">
						회원 탈퇴시 모든 정보가 사라지며, 복구할 수 없습니다.
					</td>
				</tr>
				<tr>
					<td colspan="3">
						탈퇴를 원하시면 "탈퇴하겠습니다"를 입력해주세요.
					</td>
				</tr>
				<tr>
					<td colspan="3"><input type="text" name="agreeSignOut" id="agreeSignOut"></td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="button" value="취소" id="btnCancle" onclick='history.back()'>
						<input type="button" value="회원탈퇴" id="btnSignOut">
					</td>
				</tr>
			</table>
		</div>
	</section>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>