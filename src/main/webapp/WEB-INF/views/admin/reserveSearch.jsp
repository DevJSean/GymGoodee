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
<title>관리자페이지 - 예약 내역</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/reset.css">


<script>

	$(function(){
		
		// 검색 기능
		fnSearchAll();	
		fnSearch();
		
		if($('#query').val() != ''){
			
			location.href="${contextPath}/admin/reserveSearch?column=" + $('#column').val() + "&query=" + $('#query').val();
			
		} // if
		
	})
	
	// 1. 전체 조회
	function fnSearchAll() {
		$('#btnSearchAll').on('click', function(){
			location.href='${contextPath}/admin/reserveList';
		})
	}
	
	// 2. 검색
	function fnSearch(){
		
		var column = $('#column');
		var query = $('#query');
		
		$('#btnSearch').on('click', function(){
			
 			var regClassCode = /^[a-zA-Z가-힣0-9-_!@#$%^&*]{2,}$/;  
			if( column.val() == 'CLASS_CODE' && regClassCode.test(query.val()) == false) {
				alert('강좌 코드는 2자 이상 입력해주세요.');
				query.focus();
				return;
			}
 			var regMemberName = /^[a-zA-Z가-힣0-9-_!@#$%^&*]{2,}$/;  
			if( column.val() == 'MEMBER_NAME' && regMemberName.test(query.val()) == false) {
				alert('이름은 2자 이상 입력해주세요.');
				query.focus();
				return;
			}
		
			// 검색 내용 보내주기
			if(column.val() == 'CLASS_CODE' || column.val() == 'MEMBER_NAME' ) {
				location.href="${contextPath}/admin/reserveSearch?column=" + column.val() + "&query=" + query.val();
			}
		}) // click
	} // fnSearch

	
	// 테스트
	$('#wrapper').append($('#f'));
										
</script>
<style>
	#f{
		display : flex;
		width : 100px;
		margin: 0 auto;
	}

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
	    background-color: #2C3E50; 
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

	#tableTitle{
		text-align : center;
	}
	
	table{
		border-collapse : collapse;
		/* width: 90%; */
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
		background-color : #2C3E50; 
		opacity: 0.65;
		border : 1px solid #2C3E50;
		color:#F5F6F7;
	
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
   
   	/* 검색창 */
	.equalArea{
		display: inline;
	}

	#f{
		display: flex;
		width: 90%;
	}
	#f > *{
		display: inline-block;
	}
	
	#column{
		margin: 0 30px 0 40px;
		width: 20%;
	}
	
	#equalArea{
		width: 40%;
		margin : 0 30px 0 0;
	}
	#query{
		width: 100%;
		margin : 0 30px 0 0;
	}
	
	#btnSearch{
		margin: 0 2px 0 0;
		width: 80px;	
	}
	#btnSearchAll{
		margin: 0 15px 0 2px;
		width: 80px;		
	}
	
</style>
</head>
<body>

	
	
	<!-- 강좌코드와 회원 이름으로 검색하는 것 만들기 -->
	
	<form id="f" method="get">
		<select name="column" id="column">
			<option value="CLASS_CODE">강좌코드</option>
			<option value="MEMBER_NAME">회원이름</option>
		</select>
		<span id="equalArea">
			<input type="text" name="query" id="query" value="${classCode}" autocomplete="off">
		</span>
		<input type="button" value="검색" id="btnSearch">
		<input type="button" value="전체조회" id="btnSearchAll">
	</form>
	
	
	
	

</body>
</html>