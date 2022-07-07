<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
<script>

	$(function() {
		// 개인정보페이지 들어오면 비밀번호 확인
		$('#btnCheck').on('click', function() {
			if($('#memberPw').val() == '') {
				alert('비밀번호를 입력하세요.');
				return;
			}
			$.ajax({
				url: '${contextPath}/mypage/pwCheck',
				data: 'memberPw=' + $('#memberPw').val(),
				type: 'post',
				dataType: 'json',
				success: function(obj) {
					if(obj.res){
						location.href='${contextPath}/mypage/myInfo';
					} else {
						alert('비밀번호가 일치하지 않습니다.');
					}
				}
			})
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
	#btnCheck, #btnCancle {
	    width: 235px;
	    padding: 16px 0px 15px;
	    margin-top: 10px;
        background-color: lightgrey;
        border: 1px solid lightgrey;
        font-size: 16px;
        border-radius: 3px;
        cursor: pointer;
        margin: 2px;
        margin-top: 10px;
   }
   
   #btnCheck:hover, #btnCancle:hover{
        background-color: #2C3E50; 
        opacity: 0.65;
        color: #F5F6F7;
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
	.pw_wrap {
		text-align: center;
		margin: 10px;
	} 
	.pw_wrap .input_row {
		display: table;
        table-layout: fixed;
        width: 50%;
        padding: 14px 17px 13px;
        border: 1px solid #dadada;
        position: relative;
        text-align: left;
        margin: 0 auto;
        border-radius: 6px 6px 6px 6px;
    }
    .pw_wrap .input_row .input_text {
    	border: none;
        outline: none;
        cursor: pointer;
        padding-right: 30px;
        width: 90%;
        font-size: 16px;
        letter-spacing: -0.5px;
        color: #222;
        line-height: 19px;
        position: relative;
    }
	.blind {
        position: absolute;
        width: 1px;
        height: 1px;
        overflow: hidden;
    }
    .pw_wrap .input_row .icon_cell {
        display: table-cell;
        width: 24px;
        vertical-align: middle;
    }
    .pw_wrap .input_row .icon_cell .icon_pw {
        width: 16px;
        height: 16px;
        background-image: url(https://ssl.pstatic.net/static/nid/login/m_sp_01_login_008d5216.png);
        background-size: 266px 225px;
        position: absolute;
        top: 50%;
        left: 17px;
        margin-top: -8px;
    }
    .pw_wrap .input_row .icon_cell .icon_pw {
        background-position: -129px -203px;
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
				<li class="navItem nowPage">개인정보</li>
			</ul>	
		</nav>
	
		<div id="wrapper">
				<i class="fa-solid fa-user-lock"></i>&nbsp;&nbsp;비밀번호를 입력하세요.<br>
				<div class="pw_wrap">
					<div class="input_row" id="pw_line">
	                    <div class="icon_cell" id="pw_cell">
	                        <span class="icon_pw">
	                            <span class="blind">비밀번호</span>
	                        </span>
	                    </div>
	                    <input type="password" class="input_text" name="memberPw" id="memberPw">
	                </div>
					<input type="button" value="취소" id="btnCancle" onclick='history.back()'>
					<input type="button" value="확인" id="btnCheck"> 
				</div>
		</div>
		
	</section>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>