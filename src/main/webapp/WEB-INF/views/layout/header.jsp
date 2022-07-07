<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
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
            $('#btn-mapper').empty();
            $('#endDate').empty();
            if(obj.remainTickets.length == 0) {
            	var tr = '<tr>';
                tr += '<td colspan="4"> 보유하고 있는 수강권이 없습니다. </td>'; 
                tr += '</tr>';
                $('#endDate').append(tr);
            }
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
               
               var tr = '<tr>';
               tr += '<th>' + subject + ' 만료일 </th>'; 
               tr += '<td>' + fnGetDate(remainTicket.remainTicketEndDate) + '</td>';
               tr += '</tr>';
               $('#endDate').append(tr);
               
               
               // 보유한 수강권에 대한 예약리스트버튼 생성
               $('#btn-wrapper')
               .append($('<div class="tab"><a class="subjectTab" data-subject="' + remainTicket.remainTicketSubject + '">' + subject + '</a></div>'));
            })
         }
      })
   }

</script>
<style>
	#header {
		background-color: #2C3E50;
		height: 150px;
		position: relative;
	}
	#headerLogo {
		text-align: center;
	}
	#logoArea .logo {
		display: inline-block;
		width: 400px;
        height: 150px;
        background-image: url(${contextPath}/resources/images/logo_tr1.png);
        background-size: 400px 150px;
        background-repeat: no-repeat;
		margin: 0 auto;
    }
    .indexBlind {
        position: absolute;
        width: 1px;
        height: 1px;
        overflow: hidden;
    }
	#indexMemberBtn {
		display: inline-block;
		color: #F5F6F7;
		position: absolute;
		top: 10px;
		right: 60px;
		line-height: 25px;
		text-align: right;
	}
	#memberInfo {
		display: inline-block;
		color: #F5F6F7;
		position: absolute;
		top: 50px;
		right: 60px;
		line-height: 25px;
		text-align: right;
	}
	ul, li { 
		list-style:none; 
		margin:0; 
		padding:0; 
	}
    #menu {
    	width: 100%;
    	text-align:center; 
    	background-color: #2C3E50; 
    }
    ul.myMenu {
    	display: flex;
    	width: 850px;
    	margin: 0 auto;
    }
    ul.myMenu > li { 
    	display: inline-block; 
    	width:150px; 
    	padding:25px 10px; 
    	background-color: #2C3E50; 
    	text-align:center; 
    	position:relative; 
    }
    ul.myMenu > li ul.submenu { 
    	display:none; 
    	position:absolute; 
    	top:73px; 
    	left:0; 
    }
    ul.myMenu > li:hover ul.submenu {
    	display:block; 
    }
    ul.myMenu > li:hover, ul.myMenu > li:hover > a {
    	color: #FFF4DB;
    	transition: ease 1s;
    }
    ul.myMenu > li ul.submenu > li { 
    	display:inline-block; 
    	width:150px; 
    	padding:15px 10px; 
    	background-color: #78818C; 
    	text-align:center; 
    }
    ul.myMenu > li ul.submenu > li:hover { 
    	background: #A0A7AF;
    	color: #F5F6F7;
    	transition: ease 1s;
    }
    .indexItem {
	    background-color: #2C3E50; 
	    padding: 15px;
	    cursor: pointer;
	    color: #F5F6F7;
	    font-weight: 600;
    }
	.indexItem a {
        text-align: center;
        text-decoration: none;
        color: #F5F6F7;
        font-weight: 600;
    }
    .font {
    	font-size: 20px;
    }
    .submenu {
    	font-size: 16px;
    }
	.indexIcon {
		text-decoration: none;
		color: #F5F6F7;
	}
</style>
</head>
<body>

	<div id="header">
		<div id="headerLogo">
			<div id="logoArea">
		        <a href="${contextPath}" class="logo">
		            <span class="indexBlind">GymGoodee</span>
		        </a>
			</div>		
		</div>
		<div id="indexMemberBtn">
			<%-- 로그인 이전에 보여줄 링크 --%>
		   <c:if test="${loginMember eq null}">
		      <a href="${contextPath}/member/loginPage" class="indexIcon"><i class="fa-solid fa-power-off"></i>&nbsp;&nbsp;로그인</a>
		      &nbsp;&nbsp;&nbsp;
		      <a href="${contextPath}/member/agreePage" class="indexIcon"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;회원가입</a>
		   </c:if>
		   
		   <%-- 로그인 이후에 보여줄 링크 --%>
		   <c:if test="${loginMember ne null}">
		      <c:if test="${loginMember.memberId eq 'admin'}">
		      	 <a href="${contextPath}/admin/memberList" class="indexIcon"><i class="fa-regular fa-circle-user"></i>&nbsp;&nbsp;관리자페이지</a>
			     &nbsp;&nbsp;&nbsp;
			     <a href="${contextPath}/member/logout" class="indexIcon"><i class="fa-solid fa-power-off"></i>&nbsp;&nbsp;로그아웃</a>
		      </c:if>
		      <c:if test="${loginMember.memberId ne 'admin'}">
		         <a href="${contextPath}/mypage/myReserveList" class="indexIcon"><i class="fa-regular fa-circle-user"></i>&nbsp;&nbsp;마이페이지</a>
		         &nbsp;&nbsp;&nbsp;
		         <a href="${contextPath}/member/logout" class="indexIcon"><i class="fa-solid fa-power-off"></i>&nbsp;&nbsp;로그아웃</a>
		      </c:if>   
		   </c:if>
		</div>
		<div id="memberInfo">
		   <%-- 로그인 이후에 보여줄 링크 --%>
		   <c:if test="${loginMember ne null}">
			  ${loginMember.memberName}님&nbsp;<i class="fa-regular fa-face-smile"></i><br>
		      <c:if test="${loginMember.memberId ne 'admin'}">
		         <div id="remainTickets"></div>
		      </c:if>   
		   </c:if>
		</div>
   </div>
   	<div id="menu">
      <ul class="myMenu">
         <li class="indexItem font"><a href="${contextPath}/about/center">센터소개</a></li>
         <li class="indexItem font"><a href="${contextPath}/about/subject">운동소개</a></li>
         <li class="indexItem font">수강권구매
         	<ul class="submenu">
		         <li class="indexItem"><a href="${contextPath}/pay/paySwim">수영</a></li>
		         <li class="indexItem"><a href="${contextPath}/pay/payPilates">필라테스</a></li>
		         <li class="indexItem"><a href="${contextPath}/pay/paySpinning">스피닝</a></li>
		         <li class="indexItem"><a href="${contextPath}/pay/payDance">스포츠댄스</a></li>
         	</ul>
         </li>
         <li class="indexItem font">게시판
         	<ul class="submenu">
		         <li class="indexItem"><a href="${contextPath}/board/noticeList">공지사항</a></li>
		         <li class="indexItem"><a href="${contextPath}/board/questionList">QNA</a></li>
		         <li class="indexItem"><a href="${contextPath}/board/reviewList">리뷰</a></li>
         	</ul>
         </li>
         <li class="indexItem font">예약
         	<ul class="submenu">
		         <li class="indexItem"><a href="${contextPath}/reserve/swimPage">수영</a></li>
		         <li class="indexItem"><a href="${contextPath}/reserve/pilatesPage">필라테스</a></li>
		         <li class="indexItem"><a href="${contextPath}/reserve/spinningPage">스피닝</a></li>
		         <li class="indexItem"><a href="${contextPath}/reserve/dancePage">스포츠 댄스</a></li>
         	</ul>
         </li>
      </ul>
   	</div>

</body>
</html>