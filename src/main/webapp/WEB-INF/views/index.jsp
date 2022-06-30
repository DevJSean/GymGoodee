<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="./resources/js/jquery-3.6.0.js"></script>
<script>
	$(function() {
		$.ajax({
			url: '${contextPath}/mypage/pwModifiedCheck',
			dataType: 'json',
			type: 'get',
			success: function(obj) {
				if(obj.postDays >=  3) {
					$('#modal.modal-overlay').css('display', 'flex');
				}
			}
		})
	})
	
	function fnModalClose() {
		$('#modal.modal-overlay').css('display', 'none');
	}
</script>
<style>
	#modal.modal-overlay {
	    width: 100%;
	    height: 100%;
	    position: absolute;
	    left: 0;
	    top: 0;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    background: rgba(255, 255, 255, 0.25);
	    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
	    backdrop-filter: blur(1.5px);
	    -webkit-backdrop-filter: blur(1.5px);
	    border-radius: 10px;
	    border: 1px solid rgba(255, 255, 255, 0.18);
	    display:none;
	}
    #modal .modal-window {
        background: rgba( 69, 139, 197, 0.70 );
        box-shadow: 0 8px 32px 0 rgba( 31, 38, 135, 0.37 );
        backdrop-filter: blur( 13.5px );
        -webkit-backdrop-filter: blur( 13.5px );
        border-radius: 10px;
        border: 1px solid rgba( 255, 255, 255, 0.18 );
        width: 400px;
        height: 200px;
        position: relative;
        padding: 10px;
    }
    #modal .title {
        padding-left: 10px;
        display: inline;
        text-shadow: 1px 1px 2px gray;
        color: white;
    }
    #modal .title h2 {
        display: inline;
    }
    #modal .close-area {
        display: inline;
        float: right;
        padding-right: 10px;
        cursor: pointer;
        text-shadow: 1px 1px 2px gray;
        color: white;
    }
    
    #modal .content {
        margin-top: 20px;
        padding: 0px 10px;
        text-shadow: 1px 1px 2px gray;
        color: white;
    }
    #btnClose, #btnChangePw {
    	position: relative;
    	left: 60px;
    	bottom: -15px;
    	background-color: lightgrey;
		width: 120px;
		height: 40px;
		color: grey;
		border: none;
		border-radius: 5px;
    }
</style>
</head>
<body>
	
	<h1>메인 페이지</h1>
	
	<jsp:include page="./layout/header.jsp"></jsp:include>
	
	<a href="${contextPath}/reserve/swimPage">수영 예약페이지</a><br>
	<a href="${contextPath}/reserve/pilatesPage">필라테스 예약페이지</a><br>
	<a href="${contextPath}/reserve/spinningPage">스피닝 예약페이지</a><br>
	<a href="${contextPath}/reserve/dancePage">스포츠댄스 예약페이지</a><br>

	<hr>
	
	<div id="modal" class="modal-overlay">
        <div class="modal-window">
            <div class="title">
                <h2>경고</h2>
            </div>
            <div class="content">
                <p>비밀번호를 변경하신지 90일이 경과하였습니다.</p>
                <p>안전을 위해 비밀번호를 변경해주세요.</p>
                
                <input type="button" value="다음에 변경하기" id="btnClose" onclick="fnModalClose()">
                <input type="button" value="비밀번호 변경" id="btnChangePw" onClick="location.href='${contextPath}/mypage/changePwPage'">
            </div>
        </div>
    </div>
    
    <hr>
    
	
</body>
</html>