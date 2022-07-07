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
<title>관리자페이지 - 강좌 목록</title>
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
	 	text-align: center;
	    background-color: white; 
	    padding: 15px;
	    cursor: pointer;
	 }
	 .navItem a {
	    text-decoration: none;
	    color: rgb(70, 70, 70);
	 }
	 .nowPage {
	    background-color: #BADFC4;
	    color: white;
	 }
	 .myPageNav .navItem:first-of-type { border-radius : 10px 10px 0 0; }
	 .myPageNav .navItem:last-of-type { border-radius : 0 0 10px 10px; }
	 .navItem:hover {
	    background-color: #63B47B;   
	 }
	 .navItem:hover > a {
	    color: white;
	 }
	 #listNav {
	    display: flex;
		margin-right: 30px;
		margin-left: 30px;
		margin-top: 50px;
	 }
	 
	/* 이정민 작성 */
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

	#tableTitle{
		text-align : center;
	}
	
	table{
		border-collapse : collapse;
		width: 90%;
		text-align : center;
		margin : 0 auto;
		vertical-align : middle;
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
      color: #63B47B;
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
				<li class="navItem"><a href="${contextPath}/admin/memberList">회원목록</a></li>
				<li class="navItem"><a href="${contextPath}/admin/addTeacherPage">강사등록</a></li>
				<li class="navItem"><a href="${contextPath}/admin/addClassPage">강좌개설</a></li>
				<li class="navItem nowPage">개설강좌</li>
				<li class="navItem"><a href="${contextPath}/admin/reserveList">예약내역</a></li>
				<li class="navItem"><a href="${contextPath}/admin/payList">결제내역</a></li>
			</ul>	
		</nav>
	
		<div id="wrapper">
			<table>
				<thead>
					<tr>
						<td>번호</td>
						<td>강좌코드</td>
						<td>강사이름</td>		
						<td>날짜</td>		
						<td>시간</td>		
						<td>현재신청인원</td>		
					</tr>
				</thead>
				<tbody>
					<c:forEach var="classList" items="${classes}">
						<tr>
							<td>${classList.rn}</td>
							<td>${classList.classCode}</td>
							<td>${classList.teacherName}</td>
							<td>${classList.classDate}</td>
							<td>${classList.classTime}</td>
							<td>${classList.currentCount} / ${classList.locationLimit}</td>
						</tr>
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