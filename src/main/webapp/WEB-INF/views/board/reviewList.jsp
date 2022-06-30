<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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
	td:nth-of-type(3) { width: 200px; }
	td:nth-of-type(4) { width: 200px; }
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

	<jsp:include page="../layout/header.jsp"></jsp:include>

	<h1>리뷰 목록</h1>
	<input type="button" value="메인으로 돌아가기" onclick="location.href='${contextPath}'">
	<input type="button" value="공지사항" onclick="location.href='${contextPath}/board/noticeList'">
	<input type="button" value="QnA" onclick="location.href='${contextPath}/board/questionList'">
	<input type="button" value="리뷰" onclick="location.href='${contextPath}/board/reviewList'">
	<br><br>
	<c:if test="${loginMember ne null && loginMember.memberId ne 'admin'}">
		<input type="button" value="글 작성" onclick="location.href='${contextPath}/board/reviewAddPage'">
	</c:if>
	
	<table>
		<thead>
			<tr>
				<td>글 번호</td>
				<td>제목</td>
				<td>반 정보</td>
				<td>작성자</td>
				<td>작성일</td>
				<td>조회수</td>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${reviews}" var="review" varStatus="vs">
				<tr>
					<td>${beginNo - vs.index}</td>
					<td>
						<a href="${contextPath}/board/reviewDetail?reviewNo=${review.reviewNo}">${review.reviewTitle}</a>
						<!-- (댓글 수 표시) -->
						(${review.replyCount})
						<!-- 올린지 하루 이내의 글이면 아이콘 표시 -->
						<fmt:parseDate var="startDate"  value="${review.reviewCreated}" pattern="yyyy-MM-dd"/>
						<fmt:parseDate var="endDate" value="${now}" pattern="yyyy-MM-dd"/>
						<fmt:parseNumber var="createdDate" value="${startDate.time / (1000*60*60*24)}" integerOnly="true" />
						<fmt:parseNumber var="todayDate" value="${endDate.time / (1000*60*60*24)}" integerOnly="true" /> 
						<c:if test="${todayDate - createdDate le 1}">
							<i class="fa-solid fa-circle-check"></i>
						</c:if>
					</td> 
					<td>
						<c:set var="classCode" value="${review.classCode}"/>
						<c:set var="classLength" value="${fn:length(classCode)}"/>
						<c:set var="classSubject" value="${fn:substring(classCode,11,classLength)}"/>
						<c:set var="classLocation" value="${fn:substring(classCode,classLength-2,classLength)}"/>
						${fn:substring(classCode,0,8)}
						${fn:substring(classCode,9,10)}
						<c:if test="${fn:startsWith(classSubject, 'SWIM')}">
							수영
						</c:if>
						<c:if test="${fn:startsWith(classSubject, 'DANCE')}">
							댄스
						</c:if>
						<c:if test="${fn:startsWith(classSubject, 'PILATES')}">
							필라테스
						</c:if>
						<c:if test="${fn:startsWith(classSubject, 'SPINNING')}">
							스피닝
						</c:if>
						${classLocation}
					</td>
					<td>${review.memberId}</td>
					<td>${review.reviewCreated}</td>
					<td>${review.reviewHit}</td>
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