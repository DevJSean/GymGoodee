<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>관리자페이지 - 회원목록</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/reset.css">


<script>
	
	$(function() {
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
	    background-color: white; 
	    padding: 15px;
	    cursor: pointer;
	    border-left: 2px solid  rgba(44, 62, 80, 0.65); 
	    border-right: 2px solid  rgba(44, 62, 80, 0.65);
	 }
	 .navItem a {
	 	text-align: center;
	    text-decoration: none;
	    color: rgb(70, 70, 70);
	 }
	 .nowPage {
	    background-color:  #2C3E50; 
	    opacity: 0.65;
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
	 
	/* wrapper 부분 css */
	section {
		display: flex;
	}
	#wrapper{
		background-color : white;
  		width : 70%;
  		margin : 50px auto;
  		border-radius : 50px;
  		padding: 30px;
  		text-align: left;
  		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
	}

	
	table{
		border-collapse : collapse;
		width: 90%;
		text-align : center;
		margin : 0 auto;
		vertical-align : middle;
	}

	
	table caption{
		margin: 0 auto 10px auto;	
		text-align: left;		
	}
	
	table thead tr{
		border-top : 2px solid lightgrey;
		border-bottom : 2px solid lightgrey;
	}
	table tbody tr{
		border-bottom : 1px solid lightgrey;
	}
	
	td{
		padding: 5px;
		text-align: center;
	}
	
	input[type=button]{
		background-color : lightgrey;
		border : 1px solid lightgrey;
		border-radius : 3px;
		cursor: pointer;
		
	}
	
	input[type=button]:hover{
		background-color : #BADFC4;
		border : 1px solid #BADFC4;
	
	} 
	
	/* 페이징 */
	.unlink, .link {
      display: inline-block; 
      padding: 10px;
      margin: 5px;
      border: 1px solid white;
      text-align: center;
      text-decoration: none; 
      color: gray;
      font-size: 20px;
   }
   .link:hover {
      color: #8AAAE5;
      cursor: pointer;
   }
   .nowUnlinkPage{
   	  color: black;
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
				<li class="navItem nowPage">회원목록</li>
				<li class="navItem"><a href="${contextPath}/admin/addTeacherPage">강사등록</a></li>
				<li class="navItem"><a href="${contextPath}/admin/addClassPage">강좌개설</a></li>
				<li class="navItem"><a href="${contextPath}/admin/reserveList">예약내역</a></li>
				<li class="navItem"><a href="${contextPath}/admin/payList">결제내역</a></li>
			</ul>	
		</nav>
	
		<div id="wrapper">
			<table>
				<caption>전체 회원 수 ${totalRecord - 1}명</caption>
				<thead>
					<tr>
						<td>번호</td>
						<td>회원번호</td>
						<td>아이디</td>		
						<td>이름</td>		
						<td>연락처</td>		
						<td>가입일시</td>		
					</tr>
				</thead>
				<tbody>
					<c:forEach var="member" items="${members}">
						<c:if test="${member.memberId ne 'admin'}">
							<tr>
								<td>${member.rn}</td>
								<td>${member.memberNo}</td>
								<td>${member.memberId}</td>
								<td>${member.memberName}</td>
								<td>${member.memberPhone}</td>
								<td>${member.memberSignUp}</td>
							</tr>
						</c:if>
					</c:forEach>
				</tbody>
				<tfoot>	
					<tr>
						<td colspan="6">
							${paging}
						</td>
					</tr>
				</tfoot>
			</table>
		
		</div>
	</section>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>


</body>
</html>