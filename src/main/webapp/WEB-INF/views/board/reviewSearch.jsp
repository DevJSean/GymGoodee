<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<title>리뷰</title>
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
<script src="../resources/js/jquery-3.6.0.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script>

	$(function(){
		
		fnAreaChoice();
		fnSearchAll();	
		fnSearch();
		fnAutoComplete();
		$('#begin').datepicker({	
			'showOn' : 'focus',		
			'dateFormat': "yy-mm-dd",
			'showAnim' : 'slideDown'
		})
		$('#end').datepicker({	
			'showOn' : 'focus',		
			'dateFormat': "yy-mm-dd",
			'showAnim' : 'slideDown'
		})
	})

	function fnAreaChoice(){
		$('#rangeArea').css('display', 'none');
		$('#column').on('change', function(){
			if( $(this).val() == 'REVIEW_TITLE' || $(this).val() == 'MEMBER_ID' || $(this).val() == 'REVIEW_CONTENT' || $(this).val() == 'REVIEW_SUBJECT') {
				$('#equalArea').css('display', 'inline');
				$('#rangeArea').css('display', 'none');
			} else {
				$('#equalArea').css('display', 'none');
				$('#rangeArea').css('display', 'inline');
			}								  
		})
	}
	
	function fnSearchAll() {
		$('#btnSearchAll').on('click', function(){
			location.href='${contextPath}/board/reviewList';
		})
	}
	
	function fnSearch(){
		
		var column = $('#column');
		var query = $('#query');
		var begin = $('#begin');
		var end = $('#end');
		
		$('#btnSearch').on('click', function(){
			
 			var regTitle = /^[a-zA-Z가-힣0-9-_!@#$%^&*]{2,}$/;  
			if( column.val() == 'REVIEW_TITLE' && regTitle.test(query.val()) == false) {
				alert('제목은 2자 이상 입력해주세요.');
				query.focus();
				return;
			}
 			var regContent = /^[a-zA-Z가-힣0-9-_!@#$%^&*]{2,}$/;  
			if( column.val() == 'REVIEW_CONTENT' && regContent.test(query.val()) == false) {
				alert('내용은 2자 이상 입력해주세요.');
				query.focus();
				return;
			}
 			var regSubject = /^[가-힣]{1,5}$/;  
			if( column.val() == 'REVIEW_SUBJECT' && regSubject.test(query.val()) == false) {
				alert('종목은 한글 5자 이내로 입력해주세요.');
				query.focus();
				return;
			}
			var regCreated = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/;
			if( column.val() == 'REVIEW_CREATED' && ( !regCreated.test(begin.val()) || !regCreated.test(end.val()) ) ){
				alert('날짜 입력 형식은 YYYY-MM-DD 입니다.');
				return;
			}
			if(column.val() == 'REVIEW_TITLE' || column.val() == 'REVIEW_CONTENT' || column.val() == 'MEMBER_ID' || column.val() == 'REVIEW_SUBJECT' ) { 
				location.href="${contextPath}/board/reviewSearch?column=" + column.val() + "&query=" + query.val();
			} else {
				location.href="${contextPath}/board/reviewSearch?column=" + column.val() + "&begin=" + begin.val() + "&end=" + end.val();
			}
		})
	}
	
	function fnAutoComplete(){
		$('#query').on('keyup', function(){
			$('#autoComplete').empty();
			$.ajax({  
				url: '${contextPath}/board/reviewAutoComplete',
				type: 'get',
				data: 'column=' + $('#column').val() + '&query=' + $('#query').val(),
				dataType: 'json',
				success: function(result){
					if(result.status == 200){
						$.each(result.list, function(i, item){
							$('<option>')
							.val(item[result.column])
							.appendTo('#autoComplete');
						})
					}
				}
			})
		})
	}
</script>
</head>
<body>
	
<%@ include file="reviewList.jsp" %>

<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js" integrity="sha256-6XMVI0zB8cRzfZjqKcD01PBsAy3FlDASrlC8SxCpInY=" crossorigin="anonymous"></script>
 				<div id="searchForm">
					<form id="f" method="get">
						<select name="column" id="column">
							<option value="REVIEW_TITLE">제목</option>
							<option value="REVIEW_SUBJECT">종목</option>
							<option value="MEMBER_ID">작성자</option>
							<option value="REVIEW_CONTENT">내용</option>
							<option value="REVIEW_CREATED">작성일</option>
						</select>
						<span id="equalArea">
							<input type="text" name="query" id="query" list="autoComplete">
							<datalist id="autoComplete"></datalist>
						</span>
						<span id="rangeArea">
							<input type="text" name="begin" id="begin" autocomplete="off">
							~
							<input type="text" name="end" id="end" autocomplete="off">
						</span>
						&nbsp;&nbsp;&nbsp;<input type="button" value="검색" id="btnSearch">
						<input type="button" value="전체조회" id="btnSearchAll">
					</form>
				</div>
			</table>
		</div>
	</section>
	
	<footer>
		<jsp:include page="../layout/footer.jsp"></jsp:include>
	</footer>
	
</body>
</html>