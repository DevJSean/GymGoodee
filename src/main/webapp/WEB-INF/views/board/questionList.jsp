<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	* {
		box-sizing: border-box;
	}
	.unlink, .link {
		display: inline-block; 
		padding: 10px;
		margin: 5px;
		border: 1px solid white;
		text-align: center;
		text-decoration: none; 
		color: gray;
	}
	.link:hover {
		border: 1px solid orange;
		color: limegreen;
	}
	table {
		border-collapse: collapse;
	}
	td:nth-of-type(1) { width: 70px; }
	td:nth-of-type(2) { width: 300px; }
	td:nth-of-type(3) { width: 150px; }
	td:nth-of-type(4) { width: 100px; }
	td:nth-of-type(5) { width: 100px; }
	td:nth-of-type(6) { width: 100px; }
	td {
		padding: 5px;
		border: 1px solid silver;
		text-align: center;
	}
	tfoot td {
		border-left: 0;
		border-right: 0;
		border-bottom: 0;
		border-top: 0;
	}
</style>

</head>
<body>
	
	<h1>QnA 목록</h1>
	<a href="${contextPath}/jsh">메인으로 돌아가기</a>
	<a href="${contextPath}/board/noticeList">공지사항</a>
	<a href="${contextPath}/board/questionList">QnA</a>
	<a href="${contextPath}/board/reviewList">리뷰</a>
	<br><br>
	<a href="${contextPath}/board/questionAddPage">글 작성</a>
	<table>
		<thead>
			<tr>
				<td>글 번호</td>
				<td>제목</td>
				<td>작성자</td>
				<td>작성일</td>
				<td>조회수</td>
				<td>상태</td>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${questions}" var="question" varStatus="vs">
				<tr>
					<td>${beginNo - vs.index}</td>
					<td><a href="${contextPath}/board/questionDetail?questionNo=${question.questionNo}">${question.questionTitle}</a></td>
					<td>${question.memberId}</td>
					<td>${question.questionCreated}</td>
					<td>${question.questionHit}</td>
					<td>작성상태</td>
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


	
</body>
</html>