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

	
	
										
</script>
<style>
	.myPageNav {
		display: flex;
		flex-direction: column;
		width: 100px;
		list-style-type: none;
	}
	.navItem {
		background-color: teal; 
		padding: 15px;
		cursor: pointer;
	}
	.navItem a {
		text-align: center;
		text-decoration: none;
		color: white;
	}
	.navItem:hover {
		background-color: navy;
	}
	nav {
		display: flex;
		margin-right: 30px;
	}
	section {
		display: flex;
	}
	td {
		text-align: center;
	}
	
	/* 검색창 */
	.equalArea{
		display: inline;
	}
	
</style>
</head>
<body>

	<%@ include file="reserveList.jsp" %>
	
	<!-- 강좌코드와 회원 이름으로 검색하는 것 만들기 -->
	<form id="f" method="get">
		<select name="column" id="column">
			<option value="CLASS_CODE">강좌코드</option>
			<option value="MEMBER_NAME">회원이름</option>
		</select>
		<span id="equalArea">
			<input type="text" name="query" id="query" list="autoComplete" value="${classCode}">
			<datalist id="autoComplete"></datalist>
		</span>
		<input type="button" value="검색" id="btnSearch">
		<input type="button" value="전체조회" id="btnSearchAll">
	</form>
	

</body>
</html>