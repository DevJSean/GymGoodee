<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/reset.css">
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
            if(obj.remainTickets.length == 0) {
                $('#endDate')
                .append($('<div>').text('보유하고 있는 수강권이 없습니다.'));
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
               $('#endDate')
               .append($('<div>').text(subject + '권 만료일 ' + fnGetDate(remainTicket.remainTicketEndDate)));
               
               // 보유한 수강권에 대한 예약리스트버튼 생성
               $('#btn-mapper')
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
      location.href='${contextPath}/admin/memberList';
   }
   
   function fnMainPage() {
      location.href='${contextPath}';
   }
   
</script>
<style>
   header {
      padding-top: 30px;
   }
   .indexNav {
      display: flex;
      flex-direction: row;
      width: 100%;
      list-style-type: none;
   }
   .indexItem {
      background-color: #BADFC4; 
      padding: 15px;
      cursor: pointer;
   }
   .indexItem a {
      text-align: center;
      text-decoration: none;
      color: #343434;
      font-weight: 600;
   }
   .indexItem:hover {
      background-color: #63B47B;
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
         <li class="indexItem"><a href="${contextPath}/about/center">센터소개</a></li>
         <li class="indexItem"><a href="${contextPath}/about/subject">운동소개</a></li>
         <li class="indexItem">수강권구매</li>
         <li class="indexItem"><a href="${contextPath}/pay/paySwim">수영</a></li>
         <li class="indexItem"><a href="${contextPath}/pay/payPilates">필라테스</a></li>
         <li class="indexItem"><a href="${contextPath}/pay/paySpinning">스피닝</a></li>
         <li class="indexItem"><a href="${contextPath}/pay/payDance">스포츠댄스</a></li>
         <li class="indexItem">게시판</li>
         <li class="indexItem"><a href="${contextPath}/board/noticeList">공지사항</a></li>
         <li class="indexItem"><a href="${contextPath}/board/questionList">QNA</a></li>
         <li class="indexItem"><a href="${contextPath}/board/reviewList">리뷰</a></li>
         <li class="indexItem">예약</li>
         <li class="indexItem"><a href="${contextPath}/reserve/swimPage">수영</a></li>
         <li class="indexItem"><a href="${contextPath}/reserve/pilatesPage">필라테스</a></li>
         <li class="indexItem"><a href="${contextPath}/reserve/spinningPage">스피닝</a></li>
         <li class="indexItem"><a href="${contextPath}/reserve/dancePage">스포츠 댄스</a></li>
      </ul>
   </nav>

</body>
</html>