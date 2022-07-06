<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>리뷰 상세보기</title>
<%
 String strReferer = request.getHeader("referer"); //이전 URL 가져오기
 
 if(strReferer == null){
%>
 <script type="text/javascript">
  	alert("url 입력을 통한 접근은 불가합니다.");
  	history.back();
 </script>
<%
  return;
 }
%>
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../resources/css/reset.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="../resources/js/jquery-3.6.0.js"></script>
<script>

	$(function(){
		
		$('body').on('click', '.reply_link', function(){ 
			$('.reply_form').addClass('blind');
	    	$(this).parent().parent().next().removeClass('blind');
		})
		
		$('#btnRemove').on('click', function(){
			if(confirm('삭제할까요?')){
				location.href="${contextPath}/board/reviewRemove?reviewNo=${review.reviewNo}";
			}
		})
		
		$('#btnListPage').on('click', function(){
			location.href="${contextPath}/board/reviewList";
		})
		// 댓글 개수 + 리스트
		fnList();
		// 페이징 링크 처리
		fnPagingLink();
		// 댓글 달기
		fnReplyAdd();
		// 댓글 삭제
		fnReplyRemove();
		// 댓글창 초기화
		fnInit();
		
	})
	
	// 년 월 일 시 분 초 요일 나타내기
	function getDate(a){
	    var date = new Date(a);
	    return date.getFullYear() + "년 " + (date.getMonth()+1) + "월 " + date.getDate() + "일 " + date.getHours() + "시 " + date.getMinutes() + "분 " + date.getSeconds() + "초 " +  '일월화수목금토'.charAt(date.getUTCDay())+'요일';
	}
	
	// 페이징 링크 처리(page 전역변수 값을 링크의 data-page 값으로 바꾸고 fnList() 호출)
	function fnPagingLink() {
		$(document).on('click', '.enable_link', function(){ // 동적 요소 클릭 이벤트
			page = $(this).data('page');
			fnList();
		})
	}
	// 회원목록 + page 전역변수
	var page = 1; // 최초 한 번 초기화
	function fnList(){
		$.ajax({
			url: '${contextPath}/board/replyList',
			type: 'GET',
			data: 'page=' + page + '&reviewNo=${review.reviewNo}',
			dataType: 'json',
			success: function(obj){ // obj = {"replyCount" : 개수, "replies" : [{댓글정보}, {댓글정보}, ...], "p" : ...}
				fnPrintReplyList(obj);
				if(obj.replyCount > 0){
					fnPrintPaging(obj.p);
				}
			}
		})
	}
	// 댓글 목록 출력
	function fnPrintReplyList(obj){
		$('#replies').empty();
		$('#replyCount').text(obj.replyCount); // 개수 달아주기
		
		let tr = '<tr><td colspan="4">'
			if('${loginMember.memberId}') {
				tr += '<form>';
				tr += '<input type="text" name="writer" value="${loginMember.memberId}" readonly>&nbsp;&nbsp;';
				tr += '<input type="text" name="content" class="replyContent" placeholder="내용" size="80">&nbsp;&nbsp';
				tr += '<input type="button" value="작성" class="btnReplySave">';
				<!-- 원글의 Depth, GroupNo, GroupOrd -->
				tr += '<input type="hidden" name="depth" value="${review.reviewDepth}">';
				tr += '<input type="hidden" name="groupNo" value="${review.reviewGroupNo}">';
				tr += '<input type="hidden" name="groupOrd" value="${review.reviewGroupOrd}">';
				tr += '</form>';
				tr += '</td></tr>';
			} else {
				tr += '댓글을 작성하시려면 로그인을 하셔야 합니다.</td></tr>';
			}
			$('#replies').append($(tr));
			
			$.each(obj.replies, function(i, reply){
				if(reply.reviewState == -1) {
					let tr = $('<tr>');
					$(tr).append('<td colspan="4">삭제된 게시글입니다.</td>');
					$('#replies').append($(tr));
				} else {
					let tr = '<tr>';
					if(reply.memberId == '${review.memberId}'){
						tr += '<td>글쓴이</td>';
					} else {
						tr += '<td>' + reply.memberId + '</td>';
					}
					if(reply.reviewDepth > 1) {
						tr += '<td>';
						for(let i = 0; i < reply.reviewDepth; i++){
							tr += '&nbsp;&nbsp;';
						}
						tr += '<i class="fa-brands fa-replyd"></i>' + decodeURIComponent(reply.reviewContent) + '<a class="reply_link"><i class="fa-solid fa-reply"></i></a><td>';
					} else {
						tr += '<td>' + decodeURIComponent(reply.reviewContent) + '<a class="reply_link"><i class="fa-solid fa-reply"></i></a><td>';
					}
					tr += '<td>' + getDate(reply.reviewCreated) + '</td>';
					if(reply.memberId == '${loginMember.memberId}' || '${loginMember.memberId}' == 'admin'){  // 댓글 작성자와 로그인한 사람이 같으면
						tr += '<td><a class="removeLink" data-review_no="' + reply.reviewNo + '"><i class="fa-solid fa-trash-can"></i></a></td>';
					}
					$('#replies').append($(tr));
					
					let tr2 = '<tr class="reply_form blind"><td colspan="4">';
					if('${loginMember.memberId}') {
						tr2 += '<form>';
						tr2 += '<input type="text" name="writer" value="${loginMember.memberId}" readonly>';
						tr2 += '<input type="text" name="content" class="replyContent" placeholder="내용" size="100">';
						tr2 += '<input type="button" value="작성" class="btnReplySave">';
						<!-- 누른 댓글의 depth, GroupNo, GroupOrd -->
							tr2 += '<input type="hidden" name="depth" value="' + reply.reviewDepth + '">';
						tr2 += '<input type="hidden" name="groupNo" value="' + reply.reviewGroupNo + '">';
						tr2 += '<input type="hidden" name="groupOrd" value="' + reply.reviewGroupOrd + '">';
						tr2 += '</form>';
						tr2 += '</td></tr>';
					} else {
						tr2 += '댓글을 작성하시려면 로그인을 하셔야 합니다.</td></tr>';
					}
					$('#replies').append($(tr2));
				}
			})
	}
	// 페이징 정보 출력
	function fnPrintPaging(p){
		$('#paging').empty();
		var paging = '';
		// ◀◀ : 이전 블록으로 이동
		if(page <= p.pagePerBlock){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-left"></i><i class="fa-solid fa-caret-left"></i></div>'
		} else {
			paging += '<div class="enable_link" data-page="' + (p.beginPage - 1) + '"><i class="fa-solid fa-caret-left"></i><i class="fa-solid fa-caret-left"></i></div>'
		}
		// ◀  : 이전 페이지로 이동
		if(page == 1){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-left"></i></div>'
		} else {
			paging += '<div class="enable_link" data-page="' + (p.page - 1) + '"><i class="fa-solid fa-caret-left"></i></div>'
		}
		// 1 2 3 4 5 : 페이지 번호
		for(let i = p.beginPage; i <= p.endPage; i++) {
			if(i == page){
				paging += '<div class="disable_link now_page nowUnlinkPage">' + i + '</div>'			
			} else {
				paging += '<div class="enable_link" data-page="' + i + '">' + i + '</div>'
			}
		}
		// ▶  : 다음 페이지로 이동
		if(page == p.totalPage){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-right"></i></div>'
		} else {
			paging += '<div class="enable_link" data-page="' + (p.page + 1) + '"><i class="fa-solid fa-caret-right"></i></div>'
		}
		// ▶▶ : 다음 블록으로 이동
		if(p.endPage == p.totalPage){
			paging += '<div class="disable_link"><i class="fa-solid fa-caret-right"></i><i class="fa-solid fa-caret-right"></i></div>'
		} else {
			paging += '<div class="enable_link" data-page="' + (p.endPage + 1) + '"><i class="fa-solid fa-caret-right"></i><i class="fa-solid fa-caret-right"></i></div>'
		}
			
		$('#paging').append(paging);
	}
	

	
	function fnReplyAdd() {
		$('body').on('click', '.btnReplySave', function(){
			
			if( $(this).prev().val() == ''){
				alert('내용은 필수입니다.');
				event.preventDefault();
				return false;
			}
		
			$.ajax({
				url: '${contextPath}/board/replyAdd',
				type: 'post',
				data: 'writer=' + $(this).prev().prev().val() + '&content=' + encodeURIComponent($(this).prev().val()) +
				      '&depth=' + $(this).next().val() + '&groupNo=' + $(this).next().next().val() + '&groupOrd=' + $(this).next().next().next().val(),
				
				dataType: 'json',
				success: function(obj) {
					if(obj.res > 0) {
						alert('댓글이 등록되었습니다.');
						fnList();
						fnInit();
					}
				},
				error: function(jqXHR) {
 					alert(jqXHR.status);
					alert(jqXHR.responseText);
				}
			})
		})
	}
	
	function fnReplyRemove() {
		$('body').on('click', '.removeLink', function(){ 
			if(confirm('삭제할까요?')){
				$.ajax({
					url: '${contextPath}/board/replyRemove',
					type: 'get',
					data: 'reviewNo=' + $(this).data('review_no'),
					dataType: 'json',
					success: function(obj){
						if(obj.res > 0){
							alert('댓글이 삭제되었습니다.');
							fnList();
							fnInit();
						}
					},
					error: function(jqXHR){
						alert(jqXHR.status);
						alert(jqXHR.responseText);
					}
				})
			}
		})
	}
	
	function fnInit(){
		$('.replyContent').val('');
	}
</script>
<style>
	* {
		box-sizing: border-box;
	}
	.blind {
		display: none;
	}
	
	article {
		text-align: center;
		background-color : white;
		width: 50%;
  		border-radius : 50px;
  		position : absolute;
  		top : 200px;
  		left: 50%;
  		transform: translate(-50%, 0%);
  		box-shadow: 0 5px 18px -7px rgba(0,0,0,1);
  		padding: 0 0 30px 0; 
	}	
	.pageName {
		margin: 30px auto;
		font-size: 30px;
		font-weight: 900;
	}	
	#divNo {
		margin: 30px auto 0 auto;
		width: 95%;
		text-align: left;
		font-size: 20px;
	}	
	#divClass, #divTitle, #divHit, #divCreated {
		margin: 5px auto 0 auto;
		width: 95%;
		text-align: left;	
		font-size: 20px;	
	}	
	#divContent {
		margin: 30px auto 0 auto;
	    width: 95%;
	    text-align: left;
	    font-size: 20px;
	}
	#divContent > textarea {
		margin-top : 10px;
		width: 100%;
		height: 400px;
		padding: 10px;
		border: solid 2px #2C3E50;
		border-radius: 30px;
		font-size: 16px;
		resize: none;
	}
	#divBtn {
		margin: 20px auto;
	}
	#btnRemove, #btnListPage{
		background-color: #2C3E50; 
 		padding: 10px;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		color: #F5F6F7;
		border: none;
		border-radius : 10px;
	}
	#btnRemove:hover, #btnListPage:hover {
		background-color: #2C3E50; opacity: 0.65;
	}
	#paging{
        display : flex;
        justify-content: center;
    }
    #paging div{
        height : 20px;
        text-align: center;
    }
    .disable_link, .enable_link {
        /* display: inline-block; */
        padding: 10px;
        margin: 5px;
        border: 1px solid white;
        text-align: center;
        text-decoration: none; 
        color: gray;
        font-size: 20px;
    }
    .enable_link:hover, .removeLink:hover, .reply_link:hover {
        color: #2C3E50; opacity: 0.65;
        cursor: pointer;
    }
	.nowUnlinkPage{
	    color: black;
	}
 	table {
		border-collapse: collapse;
		width: 90%;
		margin: 0 auto 30px auto;
	}
	td {
		padding: 5px;
		border-top: 1px solid silver;
		border-bottom: 1px solid silver;
	}
	tfoot td {
		border-left: 0;
		border-right: 0;
		border-bottom: 0;
		text-align: center;
	}
		
</style>
</head>
<body>

	<header>
		<jsp:include page="../layout/header.jsp"></jsp:include>
	</header>	
	
	<article>
	
		<div class="pageName">
			리뷰
		</div>
		<div id="divNo">
			번호 &nbsp;&nbsp;&nbsp;&nbsp;: ${review.reviewNo}
		</div>
		<div id="divClass">
			반정보 : ${review.classCode}
		</div>
		<div id="divTitle">
			제목 &nbsp;&nbsp;&nbsp;  : ${review.reviewTitle}
		</div>
		<div id="divHit">
			조회수 : ${review.reviewHit}
		</div>
		<div id="divCreated">
			작성일 : ${review.reviewCreated}
		</div>
		<div id="divContent">
			내용<textarea rows="30" cols="80" class="content" readonly>${review.reviewContent}</textarea>
		</div>
		
		<div id="divBtn">
			<c:if test="${loginMember.memberId eq review.memberId || loginMember.memberId eq 'admin'}">
				<input type="button" value="삭제" id="btnRemove">
			</c:if>
			<input type="button" value="목록" id="btnListPage">
		</div>

		<hr>
		
		<div class="pageName">
			<div>전체댓글 <span id="replyCount">0</span>개</div>
		</div>
		<table id="replyTable">
			<tbody id="replies">
			</tbody>
			<tfoot>
				<tr>
					<td colspan="4">
						<div id="paging"></div>
					</td>
				</tr>
			</tfoot>
		</table>
	</article>

	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	 
</body>
</html>