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
				tr += '<input type="text" name="writer" value="${loginMember.memberId}" readonly>';
				tr += '<input type="text" name="content" class="replyContent" placeholder="내용" size="100">';
				tr += '<input type="button" value="작성" class="btnReplySave">';
				<!-- 원글의  Depth, GroupNo, GroupOrd -->
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
					tr += '<td>' + reply.memberId + '</td>';
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
				paging += '<div class="disable_link now_page">' + i + '</div>'			
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

/* 			if( $(this).prev().val().startsWith('?') ){
				alert('댓글은 ?로 시작할 수 없습니다.');
				event.preventDefault();
				return false;
			} */
		
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
	.unlink, .link {
		display: inline-block;  /* 같은 줄에 둘 수 있고, width, height 등 크기 지정 속성을 지정할 수 있다. */
		padding: 10px;
		margin: 5px;
		border: 1px solid white;
		text-align: center;
		text-decoration: none;  /* 링크 밑줄 없애기 */
		color: gray;
	}
	.link:hover {
		border: 1px solid orange;
		color: limegreen;
	}
 	.removeLink:hover {
		cursor: pointer;
	}
	.reply_link:hover {
		cursor: pointer;
	}
	table {
		border-collapse: collapse;
	}
/* 	td:nth-of-type(1) { width: 200px; }
	td:nth-of-type(2) { width: 300px; }
	td:nth-of-type(3) { width: 100px; }
	td:nth-of-type(4) { width: 50px; } */
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
	.blind {
		display: none;
	}
	#paging {
		display: flex;
		justify-content: center;
	}
	#paging div {
		width: 32px;
		height: 20px;
		text-align: center;
		letter-spacing: -4px;
	}
	.disable_link {
		color: lightgray;
	}
	.enable_link {
		cursor: pointer;
	}
	.now_page {
		border: 1px solid gray;
		color: limegreen;
		font-weight: 900;
	}
</style>
</head>
<body>
	
	<jsp:include page="../layout/header.jsp"></jsp:include>
	
	<h1>게시글 구역</h1>
	번호 ${review.reviewNo}<br>
	반정보 ${review.classCode}<br>
	제목 ${review.reviewTitle}<br>
	조회수 ${review.reviewHit}<br>
	작성일 ${review.reviewCreated}<br>
	내용<br><textarea rows="30" cols="80" class="content" readonly>${review.reviewContent}</textarea><br>
	<c:if test="${loginMember.memberId eq review.memberId || loginMember.memberId eq 'admin'}">
		<input type="button" value="삭제" id="btnRemove">
	</c:if>
	<input type="button" value="목록" id="btnListPage">

	<hr>
	
	<h3>댓글</h3>
	<!-- 
		전체댓글 OO개  [  등록순 최신순 답글순  ]
		---------------------------------------------------
		작성자    작성내용                작성일 삭제버튼
		   └ 작성자  작성내용             작성일 삭제버튼
	
	 요런 식으로 구현
	 -->
	 <div>전체댓글 <span id="replyCount">0</span>개</div>
	 <table>
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
	 
</body>
</html>